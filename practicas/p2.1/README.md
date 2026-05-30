# P2.1 - Configuracion Flutter + Android Studio + Dispositivo

**Alumno:** Marco Antonio Gomez Olvera  
**No. de control:** 2023371124  
**Fecha:** 29 de mayo de 2026

## Descripcion de la practica

Instalacion y configuracion completa del entorno Flutter, creacion del primer proyecto (`climate_app`) y ejecucion en dispositivo Android (emulador) con hot reload funcionando.

## Requisitos verificados

- Flutter SDK instalado y configurado (`flutter doctor`).
- Android SDK con build-tools 36 y platform 36.
- Emulador Android creado: Pixel 5 API 33 (x86_64).
- Dispositivos disponibles: Chrome, Edge, Windows, Android Emulator.

## Como ejecutar

1. Abrir terminal en la carpeta `climate_app`.
2. Ejecutar: `flutter run`
3. Seleccionar el dispositivo deseado:
   - Opcion 1: Emulador Android (`emulator-5554`)
   - Opcion 2: Chrome (`chrome`)
   - Opcion 3: Edge (`edge`)
4. Para Hot Reload: guardar cambios en el codigo y presionar `r` en la terminal.
5. Para Hot Restart: presionar `R` en la terminal.

## Resultado esperado

- App con AppBar titulada **"Clima Actual"**.
- Pantalla principal con contador (0) y boton FAB (+).
- Despues de hot reload: titulo cambia a **"Mi Primera App"** sin perder el estado del contador.

## Estructura del proyecto

- `lib/main.dart` - Punto de entrada y pantalla principal.
- `android/app/build.gradle.kts` - Configuracion de compilacion Android (compileSdkVersion automatico >= 33).
- `.gitignore` - Configurado para ignorar build/, .dart_tool/, etc.

## Evidencias

- `flutter doctor` ejecutado sin errores criticos (unico warning: Visual Studio no instalado, no requerido para Android).
- App ejecutada exitosamente en emulador Android y Chrome.
- Hot reload verificado: cambio de titulo en AppBar sin reiniciar la app.

## Commits realizados

1. `P2.1: Setup Flutter inicial` - Proyecto creado con `flutter create`.
2. `P2.1: Hot reload test - cambio de titulo` - Modificacion de `title` en `MyHomePage`.
3. `P2.1: Documentacion final` - README con instrucciones y evidencias.
