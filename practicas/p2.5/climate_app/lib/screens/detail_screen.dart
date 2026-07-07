import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_icon.dart';
import '../widgets/temperature_chart.dart';

class DetailScreen extends StatefulWidget {
  final String city;

  const DetailScreen({super.key, required this.city});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Set<int> _expandedDays = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<WeatherProvider>().fetchForecast(widget.city);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final wp = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.city} - Pronostico 5 dias'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (wp.isLoadingForecast)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (wp.forecastError != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(wp.forecastError!, textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () =>
                            wp.fetchForecast(widget.city),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              )
            else if (wp.forecast != null)
              Expanded(
                child: ListView(
                  children: _buildDayCards(wp),
                ),
              )
            else
              const Expanded(
                child: Center(child: Text('Sin datos de pronostico')),
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

  List<Widget> _buildDayCards(WeatherProvider wp) {
    final forecast = wp.forecast!;
    final grouped = forecast.groupedByDay;
    final dayKeys = grouped.keys.toList();
    final widgets = <Widget>[];

    for (var i = 0; i < dayKeys.length; i++) {
      final dayKey = dayKeys[i];
      final dayItems = grouped[dayKey]!;
      final isExpanded = _expandedDays.contains(i);
      final cond = forecast.mainCondition(dayItems);

      widgets.add(
        Card(
          child: Column(
            children: [
              ListTile(
                leading: WeatherIcon(condition: cond, size: 40),
                title: Text(
                  dayKey,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${wp.formatTemp(forecast.minTemp(dayItems))} / ${wp.formatTemp(forecast.maxTemp(dayItems))}',
                ),
                trailing: Icon(isExpanded
                    ? Icons.expand_less
                    : Icons.expand_more),
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedDays.remove(i);
                    } else {
                      _expandedDays.add(i);
                    }
                  });
                },
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TemperatureChart(
                    items: dayItems,
                    formatTemp: wp.formatTemp,
                    isFahrenheit: wp.isFahrenheit,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}
