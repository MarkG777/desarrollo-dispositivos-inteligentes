class Weather {
  final String city;
  final double temp;
  final String condition;
  final String unit;

  Weather({
    required this.city,
    required this.temp,
    required this.condition,
    this.unit = 'C',
  }) {
    if (city.trim().isEmpty) {
      throw ArgumentError('La ciudad no puede estar vacía');
    }
    if (temp < -60 || temp > 60) {
      throw ArgumentError('La temperatura debe estar entre -60 y 60 grados');
    }
  }

  Weather copyWith({
    String? city,
    double? temp,
    String? condition,
    String? unit,
  }) {
    return Weather(
      city: city ?? this.city,
      temp: temp ?? this.temp,
      condition: condition ?? this.condition,
      unit: unit ?? this.unit,
    );
  }
}
