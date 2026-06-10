// Pantalla principal: gestiona estado de carga, errores y toggle de unidad
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_utils.dart';
import 'ble_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carga datos despues del primer frame para evitar crash en build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false)
          .loadWeather('Santiago');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
        centerTitle: true,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weather, _) {
          // Estado de carga
          if (weather.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado de error
          if (weather.errorMessage != null) {
            return Center(child: Text('Error: ${weather.errorMessage}'));
          }

          // Sin datos aún
          if (weather.weather == null) {
            return const Center(child: Text('No data'));
          }

          final w = weather.weather!;
          // Calcula temperatura según la unidad seleccionada
          final displayTemp = weather.temperatureUnit == '°C'
              ? w.temperature
              : WeatherUtils.celsiusToFahrenheit(w.temperature).toInt();

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  '$displayTemp${weather.temperatureUnit}',
                  style: const TextStyle(
                      fontSize: 72, fontWeight: FontWeight.bold),
                ),
                Text(
                  w.city,
                  style: const TextStyle(fontSize: 24),
                ),
                Icon(
                  WeatherUtils.getWeatherIcon(w.condition),
                  size: 120,
                  color: _getIconColor(w.condition),
                ),
                Text('Humedad: ${w.humidity}%'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => weather.toggleTemperatureUnit(),
                  child: const Text('Cambiar unidad'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()),
                    );
                    if (result != null && result is String) {
                      weather.loadWeather(result);
                    }
                  },
                  child: const Text('Buscar Ciudades'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BleScreen()),
                  ),
                  child: const Text('Buscar dispositivos BLE'),
                ),
                const SizedBox(height: 10),
                if (weather.isConnected)
                  ElevatedButton(
                    onPressed: () => weather.disconnectDevice(),
                    child: const Text('Desconectar BLE'),
                  )
                else if (weather.errorMessage != null && weather.errorMessage!.contains('Sin conexion'))
                  const Text('Sin conexion BLE', style: TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => _simulateWeatherChange(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Cambiar ciudad / clima'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
              ),
            ),
          );
        },
      ),
    );
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
    if (current == null) return;

    final cities = ['Monterrey', 'Guadalajara', 'Ciudad de Mexico', 'Cancun'];
    final conditions = ['sunny', 'cloudy', 'rainy'];

    final nextCity = cities[(cities.indexOf(current.city) + 1) % cities.length];
    final nextCondition =
        conditions[(conditions.indexOf(current.condition) + 1) % conditions.length];
    final nextTemp = current.temperature == 24 ? 32 : (current.temperature == 32 ? 18 : 24);

    provider.updateWeather(
      Weather(
        city: nextCity,
        temperature: nextTemp,
        condition: nextCondition,
        humidity: current.humidity,
      ),
    );
  }
}
