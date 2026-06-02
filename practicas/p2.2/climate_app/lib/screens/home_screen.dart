import 'package:flutter/material.dart';
import 'search_screen.dart';
import '../widgets/weather_icon.dart';

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
      const Text(
        '24\u00B0C',
        style: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      const SizedBox(height: 16, width: 16),
      const Text(
        'Santiago de Queretaro',
        style: TextStyle(
          fontSize: 24,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 16, width: 16),
      const WeatherIcon(
        condition: 'sunny',
        size: 120,
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
    ];
  }
}
