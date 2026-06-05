// Modelo de datos: estructura del clima con soporte JSON para APIs futuras
class Weather {
  final String city;
  final int temperature;
  final String condition;
  final int humidity;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
  });

  // Construye un Weather desde un JSON (útil para consumir APIs)
  factory Weather.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('main')) {
      throw FormatException('Missing main field in weather data');
    }
    final temp = json['main']['temp'];
    if (temp is! num) {
      throw FormatException('Temperature must be number');
    }
    return Weather(
      city: json['name'] ?? 'Unknown',
      temperature: temp.toInt(),
      condition: (json['weather'] as List?)?.isNotEmpty == true
          ? json['weather'][0]['main'] ?? 'unknown'
          : 'unknown',
      humidity: json['main']['humidity'] ?? 0,
    );
  }

  // Convierte el objeto a Map para guardar o enviar
  Map<String, dynamic> toJson() => {
    'city': city,
    'temperature': temperature,
    'condition': condition,
    'humidity': humidity,
  };

  @override
  String toString() {
    return 'Weather(city: $city, temp: $temperature°C, condition: $condition, humidity: $humidity%)';
  }
}
