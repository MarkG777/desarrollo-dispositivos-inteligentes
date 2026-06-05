# Práctica P2.3 – App de Clima (Flutter)

Implementación de lógica funcional, manejo de estado con Provider y separación de responsabilidades.

## Cómo ejecutar

```bash
cd practicas/p2.3/climate_app
flutter pub get
flutter emulators --launch <AVD_ID>
flutter run -d <device-id>
```

## Entregables incluidos

- `lib/screens/search_screen.dart` – búsqueda de ciudades en tiempo real con `StatefulWidget`.
- `lib/utils/weather_utils.dart` – funciones de conversión °C/°F, validación y utilidades.
- `lib/models/weather.dart` – modelo de datos con `fromJson`, `toJson` y `toString`.
- `lib/providers/weather_provider.dart` – estado centralizado con carga simulada y toggle de unidad.
- Conversión de temperaturas funcionando (°C ↔ °F).
- App ejecutable sin errores.

## Conclusión

La separación entre modelo, lógica pura, provider y UI facilita el mantenimiento y permite conectar una API real en prácticas futuras sin reescribir la interfaz.

## Tabla comparativa: guía vs entregado

| Requisito guía | Estado |
|---|---|
| StatefulWidget en search_screen.dart | Entregado |
| Funciones de conversión (2+) en weather_utils.dart | Entregado |
| Modelo Weather con fromJson/toJson/toString | Entregado |
| Provider implementado con loading, error y toggle | Entregado |
| Búsqueda funcionando en tiempo real | Entregado |
| Conversión temperaturas (°C ↔ °F) | Entregado |
| App ejecutable sin crashes | Entregado |
| GitHub commit estructurado | Pendiente de push |

## Capturas de la app

![Captura](climate_app/images/Captura%20de%20pantalla%202026-06-04%20213636.png)

![Captura](climate_app/images/Captura%20de%20pantalla%202026-06-04%20213651.png)

![Captura](climate_app/images/Captura%20de%20pantalla%202026-06-04%20213709.png)

![Captura](climate_app/images/Captura%20de%20pantalla%202026-06-04%20213717.png)

![Captura](climate_app/images/Captura%20de%20pantalla%202026-06-04%20213725.png)

![Captura](climate_app/images/Captura%20de%20pantalla%202026-06-04%20213732.png)


Las imágenes anteriores son capturas de pantalla tomadas directamente del emulador Android, utilizadas como evidencia visual del funcionamiento del código implementado en esta práctica.
