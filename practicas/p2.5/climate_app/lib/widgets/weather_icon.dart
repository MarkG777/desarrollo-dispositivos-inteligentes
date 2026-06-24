import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String condition;
  final double size;

  const WeatherIcon({
    super.key,
    required this.condition,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (condition.toLowerCase()) {
      case 'soleado':
      case 'sunny':
        iconData = Icons.wb_sunny;
        iconColor = Colors.orange;
        break;
      case 'nublado':
      case 'cloudy':
        iconData = Icons.wb_cloudy;
        iconColor = Colors.grey;
        break;
      case 'lluvioso':
      case 'rainy':
        iconData = Icons.water_drop;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.wb_sunny;
        iconColor = Colors.orange;
    }

    return Icon(
      iconData,
      size: size,
      color: iconColor,
    );
  }
}
