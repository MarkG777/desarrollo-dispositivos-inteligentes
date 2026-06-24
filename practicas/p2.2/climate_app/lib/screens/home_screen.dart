import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_utils.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLandscape = width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
        centerTitle: true,
      ),
      body: Center(
        child: isLandscape
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(context),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(context),
              ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context) {
    return [
      Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          final weather = weatherProvider.weather;
          return Text(
            formatTemperature(weather.temp, weather.unit),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          );
        },
      ),
      const SizedBox(height: 16, width: 16),
      Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          final weather = weatherProvider.weather;
          return Text(
            weather.city,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black87,
            ),
          );
        },
      ),
      const SizedBox(height: 16, width: 16),
      Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          final weather = weatherProvider.weather;
          return Icon(
            getWeatherIcon(weather.condition),
            size: 120,
            color: _getIconColor(weather.condition),
          );
        },
      ),
      const SizedBox(height: 16, width: 16),
      const Text(
        'Humedad: 65%  |  Viento: 12 km/h',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 40, width: 40),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
        child: const Text('Buscar Ciudades'),
      ),
      const SizedBox(height: 16, width: 16),
      ElevatedButton.icon(
        onPressed: () => _simulateWeatherChange(context),
        icon: const Icon(Icons.refresh),
        label: const Text('Cambiar ciudad / clima'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
    ];
  }

  Color _getIconColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'soleado':
      case 'sunny':
        return Colors.orange;
      case 'nublado':
      case 'cloudy':
        return Colors.grey;
      case 'lluvioso':
      case 'rainy':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  void _simulateWeatherChange(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    final current = provider.weather;

    final cities = ['Monterrey', 'Guadalajara', 'Ciudad de Mexico', 'Cancun'];
    final conditions = ['sunny', 'cloudy', 'rainy'];

    final nextCity = cities[cities.indexOf(current.city) + 1 < cities.length
        ? cities.indexOf(current.city) + 1
        : 0];
    final nextCondition = conditions[conditions.indexOf(current.condition) + 1 < conditions.length
        ? conditions.indexOf(current.condition) + 1
        : 0];
    final nextTemp = current.temp == 24.0 ? 32.0 : (current.temp == 32.0 ? 18.0 : 24.0);

    try {
      provider.updateWeather(
        Weather(
          city: nextCity,
          temp: nextTemp,
          condition: nextCondition,
          unit: current.unit,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
