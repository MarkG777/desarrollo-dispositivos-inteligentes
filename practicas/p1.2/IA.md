# Declaracion de uso de IA - P1.2

**Practica:** P1.2 - Mi primer Hello World en Flutter  
**Alumno:** Marco Antonio Gomez Olvera  
**Fecha:** 22 de mayo de 2026

## Herramienta utilizada

Asistente de IA conversacional integrado en el IDE Windsurf.

## En que me ayudo la IA

La IA se utilizo como apoyo en dos areas especificas, **no en la creacion del proyecto** (`flutter create climate_app`), ya que ese paso es sencillo y se realizo sin problemas.

### 1. Correccion de errores cometidos manualmente

Al editar el archivo `lib/main.dart` directamente en el editor, los caracteres especiales (simbolo de grados °, acentos) se corrompieron por un problema de codificacion (encoding). En el navegador aparecian como simbolos extranos en lugar del texto correcto.

La IA detecto el problema, reescribio el archivo con codificacion UTF-8 limpia y verifico que los simbolos se vieran correctamente en Chrome.

**Error del alumno:** edicion manual con caracteres especiales que corrompieron el archivo.  
**Correccion con apoyo de IA:** reescritura del archivo garantizando encoding correcto.

### 2. Comprension del codigo

La IA agrego comentarios explicativos en `lib/main.dart` para entender que hace cada parte del codigo a primera instancia:

- `void main()` y `runApp()`
- `StatelessWidget`
- `MaterialApp` y `ThemeData`
- `Scaffold`, `AppBar`, `Center`, `Column`
- `Text`, `SizedBox`, `Icon`

Estos comentarios sirven como referencia rapida para entender los widgets basicos de Flutter usados en esta practica.

### 3. utilización de herramientas para plantillas figma
Se le solicito ayuda a la ia para comprender como se usabana las herramientas tipo widgets y plugins como spark entre otras así como para la mejora del diseño y sugerencias para un diseño profesional.

## Lo que se hizo sin IA

- Creacion del proyecto Flutter (`flutter create`).
- Ejecucion de `flutter run` y seleccion del dispositivo (Chrome).
- Modificaciones visuales solicitadas por la guia: cambio de color a rojo, tamano de fuente a 96, cambio de icono a sol, cambio de temperatura a 28C.
- Revision visual de la app en el navegador.
- Comandos de Git para subir los cambios al repositorio.
