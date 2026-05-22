# P1.2 - Mi primer Hello World en Flutter

**Alumno:** Marco Antonio Gomez Olvera  
**No. de control:** 2023371124  
**Fecha:** 22 de mayo de 2026

## Descripcion de la practica

Primera aplicacion en Flutter que muestra informacion de clima: temperatura, ciudad e icono. Se trabajo con widgets basicos de Material Design.

## Lo que hace la app

- Muestra la temperatura (28C) en rojo y tamaño grande.
- Muestra la ciudad (Queretaro).
- Muestra un icono de sol.
- Todo centrado en pantalla con AppBar arriba.

## Estructura del codigo

El codigo esta en `climate_app/lib/main.dart` y esta comentado para entender cada parte:

- `void main()` - Punto de entrada de la app.
- `MyApp` - Widget raiz que configura el tema y la pantalla inicial.
- `MyHomePage` - Pantalla principal con Scaffold (AppBar + body).
- Dentro del body se usan: Center, Column, Text, SizedBox e Icon.

## Uso de IA en esta practica

Se utilizo una herramienta de IA conversacional como apoyo en:

1. Creacion del proyecto Flutter (`flutter create climate_app`).
2. Escritura del codigo inicial de `main.dart` basado en la guia del curso.
3. Correccion de un error de codificacion (encoding UTF-8) que provoco que los simbolos especiales no se vieran bien en el navegador.
4. Agregado de comentarios explicativos en el codigo para entender los widgets.
5. Comandos de Git para subir el proyecto al repositorio.

## Lo que se hizo manualmente

- Revision visual de la app en Chrome para verificar que se ve correctamente.
- Modificaciones solicitadas por la guia: cambio de color a rojo, tamano de fuente a 96, cambio de icono a sol.
- Ajustes menores de texto y verificacion del resultado final.

## Como ejecutar

1. Abrir terminal en la carpeta `climate_app`.
2. Ejecutar: `flutter run`
3. Seleccionar Chrome (opcion 2) o el dispositivo deseado.
4. Para Hot Reload: guardar cambios en el codigo, presionar `r` en la terminal.
