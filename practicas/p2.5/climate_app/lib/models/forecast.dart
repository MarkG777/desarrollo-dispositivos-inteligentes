// Modelo de pronostico: mapea la respuesta de /data/2.5/forecast de OpenWeatherMap
// La API devuelve 5 dias con datos cada 3 horas (40 puntos aprox.)

class ForecastItem {
  final DateTime dateTime;
  final int temperature;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    final temp = json['main']?['temp'];
    if (temp is! num) {
      throw const FormatException('Temperatura invalida en forecast');
    }

    final weatherList = json['weather'] as List?;
    if (weatherList == null || weatherList.isEmpty) {
      throw const FormatException('Sin datos de clima en forecast');
    }

    return ForecastItem(
      dateTime:    DateTime.parse(json['dt_txt'] ?? ''),
      temperature: temp.toInt(),
      condition:   weatherList[0]['main'] ?? 'Desconocido',
      description: weatherList[0]['description'] ?? '',
      humidity:    (json['main']?['humidity'] ?? 0) as int,
      windSpeed:   ((json['wind']?['speed']) ?? 0).toDouble(),
    );
  }

  String get hourLabel {
    final h = dateTime.hour.toString().padLeft(2, '0');
    return '$h:00';
  }

  String get dayLabel {
    const days = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
    return days[dateTime.weekday - 1];
  }

  String get dateLabel {
    final d = dateTime.day.toString().padLeft(2, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    return '$dayLabel $d/$m';
  }
}

class Forecast {
  final String city;
  final List<ForecastItem> items;

  Forecast({required this.city, required this.items});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List?;
    if (list == null || list.isEmpty) {
      throw const FormatException('Respuesta de forecast incompleta');
    }

    final items = list
        .map((e) => ForecastItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return Forecast(
      city:  json['city']?['name'] ?? 'Desconocido',
      items: items,
    );
  }

  // Agrupa los items por dia y devuelve min/max por dia
  Map<String, List<ForecastItem>> get groupedByDay {
    final map = <String, List<ForecastItem>>{};
    for (final item in items) {
      final key = item.dateLabel;
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  // Temperatura minima de un grupo de items
  int minTemp(List<ForecastItem> dayItems) {
    return dayItems.map((e) => e.temperature).reduce((a, b) => a < b ? a : b);
  }

  // Temperatura maxima de un grupo de items
  int maxTemp(List<ForecastItem> dayItems) {
    return dayItems.map((e) => e.temperature).reduce((a, b) => a > b ? a : b);
  }

  // Condicion mas frecuente del dia (para el icono)
  String mainCondition(List<ForecastItem> dayItems) {
    final counts = <String, int>{};
    for (final item in dayItems) {
      counts[item.condition] = (counts[item.condition] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
