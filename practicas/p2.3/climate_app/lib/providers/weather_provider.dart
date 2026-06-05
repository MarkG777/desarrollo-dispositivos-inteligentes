// Gestor de estado: centraliza los datos del clima y notifica a los widgets cuando cambian
import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  int _tempUnit = 0; // 0 = Celsius, 1 = Fahrenheit

  // Getters para acceder al estado desde los widgets
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get temperatureUnit => _tempUnit == 0 ? '°C' : '°F';

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
}
