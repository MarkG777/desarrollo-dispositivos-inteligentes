// Funciones puras: solo transforman datos, sin estado ni side-effects
import 'package:flutter/material.dart';

class WeatherUtils {
  // Convierte Celsius a Fahrenheit
  static double celsiusToFahrenheit(int celsius) {
    return (celsius * 9 / 5) + 32;
  }

  // Convierte Fahrenheit a Celsius
  static int fahrenheitToCelsius(double fahrenheit) {
    return ((fahrenheit - 32) * 5 / 9).toInt();
  }

  // Devuelve el ícono correspondiente a la condición climática
  static IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'soleado':
      case 'sunny':
        return Icons.wb_sunny;
      case 'nublado':
      case 'cloudy':
        return Icons.wb_cloudy;
      case 'lluvioso':
      case 'rainy':
        return Icons.water_drop;
      default:
        return Icons.wb_sunny;
    }
  }

  // Valida que la temperatura esté dentro de rangos reales
  static bool isValidTemperature(int temp) {
    return temp >= -50 && temp <= 60;
  }
}
