// Centraliza el acceso a variables de entorno del archivo .env
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Lee la API key del .env en tiempo de ejecucion (nunca hardcodeada)
  static String get apiKey =>
      dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  // Lee la URL base del .env con fallback a la URL oficial
  static String get baseUrl =>
      dotenv.env['OPENWEATHER_BASE_URL'] ??
      'https://api.openweathermap.org/data/2.5/weather';

  // Valida que las variables esten cargadas antes de hacer llamadas
  static bool isConfigured() {
    return apiKey.isNotEmpty && baseUrl.isNotEmpty;
  }
}
