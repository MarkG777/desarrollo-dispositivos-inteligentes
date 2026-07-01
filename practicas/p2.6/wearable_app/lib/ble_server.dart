import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:ble_peripheral/ble_peripheral.dart';
import 'ble_constants.dart';
import 'sensor_simulator.dart';

/// Servidor BLE real usando ble_peripheral (GATT server + advertising).
/// El wearable se anuncia como periferico BLE con serviceUUID y 4
/// caracteristicas NOTIFY. El telefono lo escanea con flutter_blue_plus.
class BleServer {
  final SensorSimulator simulator;
  bool _advertising = false;
  bool _initialized = false;
  String? _error;

  final _statusCtrl = StreamController<String>.broadcast();
  Stream<String> get statusStream => _statusCtrl.stream;

  bool get isAdvertising => _advertising;
  String? get error => _error;

  final List<StreamSubscription> _subs = [];

  BleServer(this.simulator);

  Future<void> _initOnce() async {
    if (_initialized) return;
    try {
      await BlePeripheral.initialize();

      BlePeripheral.setAdvertisingStatusUpdateCallback((advertising, error) {
        _advertising = advertising;
        _error = error;
        _statusCtrl.add(advertising
            ? 'Anunciando (visible)'
            : (error ?? 'Detenido'));
        print('[BleServer] AdvertisingStatus=$advertising error=$error');
      });

      BlePeripheral.setBleStateChangeCallback((state) {
        print('[BleServer] BleState=$state');
      });

      BlePeripheral.setConnectionStateChangeCallback((deviceId, connected) {
        print('[BleServer] $deviceId connected=$connected');
      });

      BlePeripheral.setCharacteristicSubscriptionChangeCallback((
        deviceId,
        characteristicId,
        subscribed,
      ) {
        print('[BleServer] $deviceId subscription $characteristicId=$subscribed');
      });

      BlePeripheral.setReadRequestCallback((characteristicId, offset, value) {
        print('[BleServer] ReadRequest $characteristicId');
        return value;
      });

      _initialized = true;
    } catch (e) {
      _error = 'init: $e';
      _statusCtrl.add('Error: $e');
      print('[BleServer] init error: $e');
      rethrow;
    }
  }

  Future<void> _addService() async {
    // Cada caracteristica: NOTIFY + READ, permiso readable.
    BleCharacteristic char(String uuid) => BleCharacteristic(
          uuid: uuid,
          properties: [
            CharacteristicProperties.read.index,
            CharacteristicProperties.notify.index,
          ],
          value: null,
          permissions: [AttributePermissions.readable.index],
        );

    await BlePeripheral.addService(
      BleService(
        uuid: BleConstants.serviceUUID,
        primary: true,
        characteristics: [
          char(BleConstants.stepsUUID),
          char(BleConstants.heartRateUUID),
          char(BleConstants.caloriesUUID),
          char(BleConstants.statusUUID),
        ],
      ),
    );
    print('[BleServer] Servicio agregado: ${BleConstants.serviceUUID}');
  }

  Uint8List _intToBytes(int value) {
    final data = ByteData(4);
    data.setInt32(0, value, Endian.little);
    return data.buffer.asUint8List();
  }

  Uint8List _int16ToBytes(int value) {
    final data = ByteData(2);
    data.setInt16(0, value, Endian.little);
    return data.buffer.asUint8List();
  }

  Future<void> startAdvertising() async {
    try {
      await _initOnce();
      await _addService();

      // Suscribir streams del simulador para emitir NOTIFY reales
      _subs.add(simulator.stepsStream.listen((steps) {
        _notify(BleConstants.stepsUUID, _intToBytes(steps));
      }));
      _subs.add(simulator.heartRateStream.listen((bpm) {
        _notify(BleConstants.heartRateUUID, Uint8List.fromList([bpm & 0xFF]));
      }));
      _subs.add(simulator.caloriesStream.listen((cal) {
        _notify(BleConstants.caloriesUUID, _int16ToBytes(cal));
      }));
      _subs.add(simulator.statusStream.listen((status) {
        _notify(BleConstants.statusUUID,
            Uint8List.fromList(utf8.encode(status)));
      }));

      // localName corto para caber en 31 bytes junto al UUID 128-bit
      await BlePeripheral.startAdvertising(
        services: [BleConstants.serviceUUID],
        localName: 'W26',
      );
      _statusCtrl.add('Anunciando (visible)');
      print('[BleServer] Advertising iniciado');
    } catch (e) {
      _error = '$e';
      _statusCtrl.add('Error: $e');
      print('[BleServer] startAdvertising error: $e');
      rethrow;
    }
  }

  void _notify(String uuid, Uint8List value) {
    try {
      BlePeripheral.updateCharacteristic(
        characteristicId: uuid,
        value: value,
      );
    } catch (e) {
      print('[BleServer] updateCharacteristic $uuid error: $e');
    }
  }

  Future<void> stop() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
    try {
      if (_initialized) {
        await BlePeripheral.stopAdvertising();
      }
    } catch (e) {
      print('[BleServer] stopAdvertising error: $e');
    }
    simulator.stop();
    _advertising = false;
    _statusCtrl.add('Detenido');
  }

  void dispose() {
    _statusCtrl.close();
  }
}
