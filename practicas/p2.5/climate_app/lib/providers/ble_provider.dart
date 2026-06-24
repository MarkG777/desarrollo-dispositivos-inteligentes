// Proveedor BLE: gestiona escaneo, conexion y lectura de wearables (extraido de P2.4)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/ble_service.dart';

class BLEProvider extends ChangeNotifier {
  final BLEService _bleService = BLEService();

  bool _isScanning = false;
  bool _isConnected = false;
  List<ScanResult> _scanResults = [];
  BluetoothDevice? _connectedDevice;
  String? _errorMessage;
  int? _bleTemperature;

  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  List<ScanResult> get scanResults => _scanResults;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  String? get errorMessage => _errorMessage;
  int? get bleTemperature => _bleTemperature;

  // Inicia el escaneo de dispositivos BLE cercanos
  Future<void> startScan() async {
    // Verifica que el Bluetooth este encendido
    final adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      _errorMessage = 'Activa el Bluetooth para buscar dispositivos';
      notifyListeners();
      return;
    }

    _isScanning = true;
    _scanResults = [];
    _errorMessage = null;
    notifyListeners();

    _bleService.scanForDevices().listen(
      (results) {
        // Evita duplicados por direccion MAC
        for (final result in results) {
          if (!_scanResults.any(
              (r) => r.device.remoteId == result.device.remoteId)) {
            _scanResults.add(result);
          }
        }
        notifyListeners();
      },
      onDone: () {
        _isScanning = false;
        notifyListeners();
      },
      onError: (e) {
        _errorMessage = 'Error escaneando: $e';
        _isScanning = false;
        notifyListeners();
      },
    );
  }

  // Conecta al wearable BLE con reintentos de reconexion
  Future<void> connectToDevice(String deviceId) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _bleService.connectWithRetry(deviceId, retries: 3);
      _connectedDevice = _bleService.connectedDevice;
      _isConnected = true;

      final temp = await _bleService.readTemperature();
      if (temp != null) {
        _bleTemperature = temp;
      }
    } catch (e) {
      _errorMessage = 'Sin conexion BLE';
      _isConnected = false;
    } finally {
      notifyListeners();
    }
  }

  // Maneja la desconexion del wearable
  Future<void> disconnectDevice() async {
    await _bleService.disconnect();
    _isConnected = false;
    _connectedDevice = null;
    _bleTemperature = null;
    _errorMessage = 'Sin conexion BLE';
    notifyListeners();
  }
}
