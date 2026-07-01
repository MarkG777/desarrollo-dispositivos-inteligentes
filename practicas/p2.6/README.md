# P2.6 — Monitor de Actividad Física Wearable (Wear OS → Teléfono)

**Unidad 2 — Flutter + Wear OS | 100 pts**

Sistema de monitoreo de actividad física con dos apps Flutter:
- **wearable_app**: corre en Wear OS, simula sensores (pasos, bpm, calorías, estado) y envía datos vía BLE NOTIFY
- **telefono_app**: corre en el teléfono, escanea y se conecta al wearable, muestra dashboard en tiempo real

---

## Flujo de datos

```
[SensorSimulator] → [BleServer NOTIFY] → BLE → [BleClient] → [ActivityProvider] → [MonitorScreen]
     Wearable                                              Teléfono
```

| Origen | Dato | Destino | Transporte |
|---|---|---|---|
| Wearable | Pasos acumulados | Teléfono | BLE NOTIFY (int32 LE) |
| Wearable | Ritmo cardiaco (bpm) | Teléfono | BLE NOTIFY (uint8) |
| Wearable | Calorías quemadas | Teléfono | BLE NOTIFY (int16 LE) |
| Wearable | Estado actividad | Teléfono | BLE NOTIFY (UTF-8 string) |

---

## Estructura del proyecto

```
practicas/p2.6/
├── P2.6_Contexto.md          # Instrucciones completas de la práctica
├── IA.md                     # Uso de IA en el desarrollo
├── README.md                 # Este archivo
├── .gitignore                # Protege secrets, build, keystore
├── captures/                 # Capturas de pantalla
│   ├── wear_idle.png         # Wearable en reposo (72 bpm, 0 pasos)
│   ├── wear_active.png       # Wearable iniciado y anunciando vía BLE (botón Detener)
│   ├── wear_data.png         # Wearable caminando (95 bpm, 51 pasos) vía BLE
│   ├── phone_disconnected.png # Teléfono — pantalla inicial
│   ├── phone_scanning.png    # Teléfono escaneando ("Buscando wearable...")
│   ├── phone_error.png       # Teléfono — wearable no encontrado tras 15s
│   ├── phone_dashboard.png   # Dashboard real con datos BLE del wearable (caminando)
│   └── phone_alert.png       # Dashboard con alerta bpm > 120 (corriendo, Modo Demo)
├── wearable_app/             # App Wear OS
│   └── lib/
│       ├── ble_constants.dart     # UUIDs de servicio y características
│       ├── sensor_simulator.dart  # Simulador de pasos, bpm, calorías, estado
│       ├── ble_server.dart        # Servidor BLE con NOTIFY
│       └── main.dart              # Pantalla circular del wearable
└── telefono_app/             # App Teléfono
    └── lib/
        ├── ble_constants.dart          # UUIDs idénticos al wearable
        ├── models/activity_data.dart   # Modelo con zonas de frecuencia cardiaca
        ├── services/ble_client.dart    # Cliente BLE (scan + NOTIFY)
        ├── providers/activity_provider.dart  # Estado con Provider
        ├── widgets/metric_card.dart    # Tarjeta reutilizable con gradiente
        ├── screens/monitor_screen.dart # Dashboard 2x2 + alerta bpm
        └── main.dart                   # Entry point con ChangeNotifierProvider
```

---

## Requisitos

- Flutter SDK ^3.12.0
- Android Studio con emuladores:
  - **Wear OS Large Round** (API 33+) — para el wearable
  - **Pixel 5 API 33** (o superior) — para el teléfono
- Dependencias: `flutter_blue_plus`, `provider`

---

## Ejecución

### 1. Iniciar emuladores

En Android Studio → Device Manager, iniciar:
1. Wear OS Large Round
2. Pixel 5 API 33

Verificar:
```bash
flutter devices
# Deben aparecer ambos emuladores
```

### 2. Compilar y correr el wearable

```bash
cd practicas/p2.6/wearable_app
flutter pub get
flutter run -d emulator-5556
```

Presionar **INICIAR** en la pantalla del wearable para activar los sensores.

### 3. Compilar y correr el teléfono

```bash
cd practicas/p2.6/telefono_app
flutter pub get
flutter run -d emulator-5554
```

Presionar **BUSCAR WEARABLE** para escanear y conectar.

---

## Capturas

### Wearable — Estado inicial (reposo)

<img src="captures/wear_idle.png" width="240" alt="Wearable Idle">

Wearable en reposo: 72 bpm, 0 pasos, botón **Iniciar**.

### Wearable — Recién iniciado

<img src="captures/wear_active.png" width="240" alt="Wearable Active">

Wearable activo: botón **Detener** (rojo), 78 bpm, estado reposo, indicador **Anunciando (visible)**. El servidor BLE (`ble_peripheral`) ya publica el serviceUUID y las 4 características NOTIFY.

### Wearable — Datos en actividad (caminando)

<img src="captures/wear_data.png" width="240" alt="Wearable Data">

Wearable caminando: **95 bpm**, **51 pasos**, estado caminando. Los datos se envían vía BLE NOTIFY usando `ble_peripheral`.

### Teléfono — Pantalla inicial (desconectado)

<img src="captures/phone_disconnected.png" width="280" alt="Phone Disconnected">

Pantalla inicial: **Conecta tu wearable** + botón **Buscar wearable**.

### Teléfono — Escaneando

<img src="captures/phone_scanning.png" width="280" alt="Phone Scanning">

Escaneando: spinner **Buscando wearable...**.

### Teléfono — Wearable no encontrado

<img src="captures/phone_error.png" width="280" alt="Phone Error">

Error tras timeout: **Wearable no encontrado en 15 segundos**.

### Teléfono — Dashboard con datos BLE reales

<img src="captures/phone_dashboard.png" width="280" alt="Phone Dashboard">

Dashboard **real con BLE**: 4 tarjetas con estado **CAMINANDO**, 94 bpm, zona FC Moderada. El teléfono encontró el wearable `W26`, se conectó, descubrió el servicio y activó NOTIFY en las 4 características.

> ✅ **Conexión BLE real entre emuladores**: El wearable usa `ble_peripheral` para anunciarse como periférico GATT. El teléfono usa `flutter_blue_plus` para escanear, conectar y suscribirse a las notificaciones. El flujo completo `Wearable → Teléfono` funciona en los AVDs.

### Teléfono — Alerta de ritmo cardiaco alto (vista previa)

<img src="captures/phone_alert.png" width="280" alt="Phone Alert">

Alerta: banner rojo **Ritmo cardiaco alto: 142 bpm**, zona FC Alta.

> Captura tomada con el **Modo Demo** para mostrar rápidamente la UI de alerta, pero el mismo componente `if (d.heartRate > 120)` en `MonitorScreen` se activa idénticamente cuando el wearable envía bpm > 120 vía BLE.

> **Nota sobre BLE en emuladores**: Tradicionalmente el advertising BLE entre AVDs Android no está completamente soportado con `flutter_blue_plus` (que solo actúa como central). Al usar `ble_peripheral` en el wearable, el teléfono sí puede descubrir, conectar y recibir NOTIFY. Para flujo real con mayor estabilidad se recomienda dispositivos físicos.

---

## Características implementadas

- [x] App Wear OS con simulador de sensores (pasos, bpm, calorías, estado)
- [x] Servidor BLE con 4 características NOTIFY (UUIDs personalizados)
- [x] Pantalla circular del wearable con tema oscuro
- [x] App teléfono con escaneo BLE automático por serviceUUID
- [x] Cliente BLE con suscripción a notificaciones
- [x] ActivityProvider con ChangeNotifier para estado
- [x] Dashboard 2x2 con MetricCard (pasos, bpm, calorías, zona FC)
- [x] Alerta visual roja cuando bpm > 120
- [x] Banner de estado de actividad (reposo/caminando/corriendo)
- [x] Timestamp de última actualización
- [x] Desconexión limpia con cancelación de suscripciones
- [x] Permisos BLE configurados en ambos AndroidManifest.xml
- [x] .gitignore protegiendo secrets y archivos sensibles

---

## Diferencia con P2.4 y P2.5

| Aspecto | P2.4 | P2.5 | P2.6 |
|---|---|---|---|
| Dirección BLE | Teléfono → Wearable | Teléfono → Wearable | **Wearable → Teléfono** |
| Operación BLE | WRITE | WRITE + READ | **NOTIFY** |
| Datos | Temperatura API | Temperatura + pronóstico | **Pasos, bpm, calorías, estado** |
| UI Teléfono | Lista dispositivos | Weather + forecast | **Dashboard 2x2 + alertas** |
| Provider | WeatherProvider | WeatherProvider + BLEProvider | **ActivityProvider** |

---

## Seriación

- **P2.4**: Se reutiliza `flutter_blue_plus` y el patrón de escaneo/conexión BLE
- **P2.5**: Se reutiliza `provider` para estado, permisos BLE en AndroidManifest, y el patrón Service → Provider → Screen
