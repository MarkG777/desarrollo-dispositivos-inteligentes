// Gestor de estado: maneja datos climaticos reales via API OpenWeatherMap
import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  Weather? _weather;
  Forecast? _forecast;
  bool _isLoading = false;
  bool _isLoadingForecast = false;
  String? _error;
  String? _forecastError;
  bool _isFahrenheit = false;

  Weather? get weather => _weather;
  Forecast? get forecast => _forecast;
  bool get isLoading => _isLoading;
  bool get isLoadingForecast => _isLoadingForecast;
  String? get error => _error;
  String? get forecastError => _forecastError;
  bool get isFahrenheit => _isFahrenheit;

  String get unitSymbol => _isFahrenheit ? '°F' : '°C';

  void toggleUnit() {
    _isFahrenheit = !_isFahrenheit;
    notifyListeners();
  }

  String formatTemp(num celsius) {
    if (_isFahrenheit) {
      return '${(celsius * 9 / 5 + 32).round()}°F';
    }
    return '${celsius.round()}°C';
  }

  // Obtiene datos reales de la ciudad via API OpenWeatherMap
  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _service.getWeather(city);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtiene el pronostico de 5 dias con datos cada 3 horas
  Future<void> fetchForecast(String city) async {
    _isLoadingForecast = true;
    _forecastError = null;
    notifyListeners();

    try {
      _forecast = await _service.getForecast(city);
    } catch (e) {
      _forecastError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingForecast = false;
      notifyListeners();
    }
  }
}
