// Servicio HTTP: realiza llamadas reales a la API de OpenWeatherMap
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';
import '../config/app_config.dart';

class WeatherService {
  static const Duration _timeout = Duration(seconds: 10);

  Future<Weather> getWeather(String city) async {
    // 1. Validar entrada
    if (city.trim().isEmpty) {
      throw ArgumentError('La ciudad no puede estar vacia');
    }

    // 2. Codificar para URL (preserva acentos: Querétaro -> Quer%C3%A9taro)
    final cleanCity = Uri.encodeComponent(city.trim());

    // 3. Verificar que la API key esta configurada
    if (!AppConfig.isConfigured()) {
      throw Exception('API key no configurada. Revisa el archivo .env');
    }

    // 4. Construir URL (la API key va como parametro, NUNCA en el body)
    final uri = Uri.parse(
      '${AppConfig.baseUrl}'
      '?q=$cleanCity'
      '&appid=${AppConfig.apiKey}'
      '&units=metric'
      '&lang=es',
    );

    try {
      // 5. Ejecutar GET con timeout
      final response = await http.get(uri).timeout(_timeout);

      // 6. Manejar codigos de respuesta
      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          return Weather.fromJson(json);
        case 401:
          throw Exception('API key invalida o no activada aun');
        case 404:
          throw Exception('Ciudad "$city" no encontrada');
        case 429:
          throw Exception('Limite de llamadas excedido. Espera un momento');
        default:
          throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Sin conexion a internet');
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado. Intenta de nuevo');
    } on FormatException catch (e) {
      throw Exception('Respuesta inesperada de la API: $e');
    }
  }

  // Pronostico de 5 dias con datos cada 3 horas
  Future<Forecast> getForecast(String city) async {
    if (city.trim().isEmpty) {
      throw ArgumentError('La ciudad no puede estar vacia');
    }

    final cleanCity = Uri.encodeComponent(city.trim());

    if (!AppConfig.isConfigured()) {
      throw Exception('API key no configurada. Revisa el archivo .env');
    }

    final baseUrl = AppConfig.baseUrl.replaceAll('/weather', '/forecast');
    final uri = Uri.parse(
      '$baseUrl'
      '?q=$cleanCity'
      '&appid=${AppConfig.apiKey}'
      '&units=metric'
      '&lang=es',
    );

    try {
      final response = await http.get(uri).timeout(_timeout);

      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          return Forecast.fromJson(json);
        case 401:
          throw Exception('API key invalida o no activada aun');
        case 404:
          throw Exception('Ciudad "$city" no encontrada');
        case 429:
          throw Exception('Limite de llamadas excedido. Espera un momento');
        default:
          throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Sin conexion a internet');
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado. Intenta de nuevo');
    } on FormatException catch (e) {
      throw Exception('Respuesta inesperada de la API: $e');
    }
  }

  // Consultar varias ciudades en paralelo
  Future<List<Weather>> getWeatherForCities(List<String> cities) async {
    final futures = cities.map((c) => getWeather(c));
    return Future.wait(futures);
  }
}
