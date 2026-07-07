import 'package:flutter/material.dart';

String formatTemperature(double temp, String unit) {
  return '${temp.toStringAsFixed(1)}\u00B0$unit';
}

IconData getWeatherIcon(String condition) {
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
