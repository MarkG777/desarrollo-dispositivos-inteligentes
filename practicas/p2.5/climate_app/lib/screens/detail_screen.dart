import 'package:flutter/material.dart';
import '../widgets/weather_icon.dart';

class DetailScreen extends StatelessWidget {
  final String city;

  const DetailScreen({super.key, required this.city});

  final List<Map<String, String>> _forecast = const [
    {'day': 'Lun', 'temp': '24\u00B0C', 'condition': 'cloudy'},
    {'day': 'Mar', 'temp': '26\u00B0C', 'condition': 'sunny'},
    {'day': 'Mie', 'temp': '28\u00B0C', 'condition': 'sunny'},
    {'day': 'Jue', 'temp': '25\u00B0C', 'condition': 'rainy'},
    {'day': 'Vie', 'temp': '28\u00B0C', 'condition': 'sunny'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$city - 5 Dias'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _forecast.length,
                itemBuilder: (context, index) {
                  final day = _forecast[index];
                  return Card(
                    child: ListTile(
                      leading: WeatherIcon(
                        condition: day['condition']!,
                        size: 40,
                      ),
                      title: Text(day['day']!),
                      trailing: Text(
                        day['temp']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
