// Gestor de estado: centraliza los datos del clima y notifica a los widgets cuando cambian
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/weather.dart';
import '../services/ble_service.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  int _tempUnit = 0; // 0 = Celsius, 1 = Fahrenheit
  final BLEService _bleService = BLEService();

  // Estado BLE
  bool _isScanning = false;
  bool _isConnected = false;
  List<ScanResult> _scanResults = [];
  BluetoothDevice? _connectedDevice;

  // Getters para acceder al estado desde los widgets
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get temperatureUnit => _tempUnit == 0 ? '°C' : '°F';
  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  List<ScanResult> get scanResults => _scanResults;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  // Simula la carga de datos de una ciudad (en P2.5 será API real)
  Future<void> loadWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simula delay de red
      await Future.delayed(const Duration(seconds: 1));

      // Datos hardcodeados para la práctica
      _weather = Weather(
        city: city,
        temperature: 24,
        condition: 'cloudy',
        humidity: 65,
      );
    } catch (e) {
      _errorMessage = 'Error loading weather: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cambia entre Celsius y Fahrenheit
  void toggleTemperatureUnit() {
    _tempUnit = _tempUnit == 0 ? 1 : 0;
    notifyListeners();
  }

  // Actualiza la temperatura manualmente
  void updateTemperature(int newTemp) {
    if (_weather != null) {
      _weather = Weather(
        city: _weather!.city,
        temperature: newTemp,
        condition: _weather!.condition,
        humidity: _weather!.humidity,
      );
      notifyListeners();
    }
  }

  // Actualiza todo el objeto Weather y avisa a los Consumer para que se redibujen
  void updateWeather(Weather newWeather) {
    _weather = newWeather;
    notifyListeners();
  }

  // Inicia el escaneo de dispositivos BLE cercanos
  Future<void> startScan() async {
    // Verifica que el Bluetooth esté encendido
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
        // Evita duplicados por dirección MAC
        for (final result in results) {
          if (!_scanResults.any((r) => r.device.remoteId == result.device.remoteId)) {
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

  // Conecta al wearable BLE con reintentos de reconexión
  Future<void> connectToDevice(String deviceId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _bleService.connectWithRetry(deviceId, retries: 3);
      _connectedDevice = _bleService.connectedDevice;
      _isConnected = true;

      final temp = await _bleService.readTemperature();
      if (temp != null) {
        _weather = Weather(
          city: 'Wearable BLE',
          temperature: temp,
          condition: 'sunny',
          humidity: 50,
        );
      }
    } catch (e) {
      _errorMessage = 'Sin conexion BLE';
      _isConnected = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Maneja la desconexión del wearable
  Future<void> disconnectDevice() async {
    await _bleService.disconnect();
    _isConnected = false;
    _connectedDevice = null;
    _errorMessage = 'Sin conexion BLE';
    notifyListeners();
  }
}
