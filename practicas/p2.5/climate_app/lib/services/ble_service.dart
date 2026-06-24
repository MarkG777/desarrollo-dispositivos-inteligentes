// Servicio BLE: escanea, conecta y lee datos de dispositivos Bluetooth Low Energy
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEService {
  // UUID de característica de temperatura estándar BLE
  static final Guid _tempCharacteristicUuid =
      Guid('00002a6e-0000-1000-8000-00805f9b34fb');

  BluetoothDevice? _connectedDevice;

  // Devuelve un stream de listas de dispositivos BLE encontrados
  Stream<List<ScanResult>> scanForDevices() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    return FlutterBluePlus.scanResults;
  }

  // Conecta al dispositivo especificado con reintentos
  Future<void> connect(String deviceId) async {
    final device = BluetoothDevice(remoteId: DeviceIdentifier(deviceId));
    await device.connect(autoConnect: false);
    _connectedDevice = device;
  }

  // Intenta conectar hasta N veces con delay entre intentos
  Future<void> connectWithRetry(String deviceId,
      {int retries = 3, Duration delay = const Duration(seconds: 2)}) async {
    for (int i = 0; i < retries; i++) {
      try {
        await connect(deviceId);
        return;
      } catch (e) {
        if (i == retries - 1) rethrow;
        await Future.delayed(delay);
      }
    }
  }

  // Descubre servicios y lee la característica de temperatura
  Future<int?> readTemperature() async {
    if (_connectedDevice == null) return null;

    final services = await _connectedDevice!.discoverServices();
    for (final service in services) {
      for (final characteristic in service.characteristics) {
        if (characteristic.uuid == _tempCharacteristicUuid) {
          final data = await characteristic.read();
          return _parseTemperature(data);
        }
      }
    }
    return null;
  }

  // Desconecta del dispositivo actual
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
    }
  }

  // Valida y convierte los bytes crudos a temperatura entera
  // Criterio de seguridad: rango (-60 a 60) y longitud de datos
  int? _parseTemperature(List<int> data) {
    if (data.isEmpty) return null;
    final raw = data[0];
    final temp = raw - 50; // Offset para permitir negativos
    if (temp < -60 || temp > 60) return null; // Validación de rango
    return temp;
  }

  BluetoothDevice? get connectedDevice => _connectedDevice;
}
