import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherProvider extends ChangeNotifier {
  Weather _weather = Weather(
    city: 'Santiago de Queretaro',
    temp: 24.0,
    condition: 'sunny',
    unit: 'C',
  );

  Weather get weather => _weather;

  void updateWeather(Weather newWeather) {
    _weather = newWeather;
    notifyListeners();
  }

  void updateCity(String city) {
    _weather = _weather.copyWith(city: city);
    notifyListeners();
  }

  void updateTemp(double temp) {
    _weather = _weather.copyWith(temp: temp);
    notifyListeners();
  }

  void updateCondition(String condition) {
    _weather = _weather.copyWith(condition: condition);
    notifyListeners();
  }
}
