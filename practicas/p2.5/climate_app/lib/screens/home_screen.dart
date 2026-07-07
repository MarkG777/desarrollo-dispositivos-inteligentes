// Pantalla principal: busqueda de ciudad y visualizacion de datos reales via API
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/ble_provider.dart';
import 'ble_screen.dart';
import 'detail_screen.dart';
import '../widgets/temperature_chart.dart';
import '../models/forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar ciudad por defecto al abrir
    Future.microtask(() {
      if (mounted) {
        final wp = context.read<WeatherProvider>();
        wp.fetchWeather('Queretaro');
        wp.fetchForecast('Queretaro');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      final wp = context.read<WeatherProvider>();
      wp.fetchWeather(city);
      wp.fetchForecast(city);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate App'),
        centerTitle: true,
        actions: [
          // Toggle °C / °F
          Consumer<WeatherProvider>(
            builder: (context, wp, _) {
              return IconButton(
                icon: Text(
                  wp.isFahrenheit ? '°F' : '°C',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tooltip: 'Cambiar a ${wp.isFahrenheit ? 'Celsius' : 'Fahrenheit'}',
                onPressed: wp.toggleUnit,
              );
            },
          ),
          // Boton BLE heredado de P2.4
          Consumer<BLEProvider>(
            builder: (context, ble, _) {
              final wp = context.read<WeatherProvider>();
              final bleTemp = ble.bleTemperature != null
                  ? wp.formatTemp(ble.bleTemperature!)
                  : '?';
              return IconButton(
                icon: Icon(
                  Icons.bluetooth,
                  color: ble.isConnected ? Colors.blue : null,
                ),
                tooltip: ble.isConnected
                    ? 'BLE conectado ($bleTemp)'
                    : 'Buscar dispositivos BLE',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BleScreen()),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de busqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Buscar ciudad...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          // Contenido dinamico
          Expanded(
            child: Consumer<WeatherProvider>(
              builder: (context, wp, _) {
                if (wp.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (wp.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(wp.error!, textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => wp.fetchWeather('Queretaro'),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (wp.weather == null) {
                  return const Center(child: Text('Ingresa una ciudad'));
                }

                final w = wp.weather!;
                final todayItems = _getTodayItems(wp.forecast);
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        w.city,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        wp.formatTemp(w.temperature),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        w.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat('Humedad', '${w.humidity}%'),
                          _stat('Viento', '${w.windSpeed} m/s'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (todayItems.isNotEmpty) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Temperatura por hora (hoy)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: TemperatureChart(
                              items: todayItems,
                              formatTemp: wp.formatTemp,
                              isFahrenheit: wp.isFahrenheit,
                            ),
                          ),
                        ),
                      ] else if (wp.isLoadingForecast)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(city: w.city),
                          ),
                        ),
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Ver pronóstico 5 días'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) => Column(
    children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ],
  );

  List<ForecastItem> _getTodayItems(Forecast? forecast) {
    if (forecast == null || forecast.items.isEmpty) return [];
    final now = DateTime.now();
    return forecast.items.where((item) {
      return item.dateTime.day == now.day &&
          item.dateTime.month == now.month &&
          item.dateTime.year == now.year;
    }).toList();
  }
}
