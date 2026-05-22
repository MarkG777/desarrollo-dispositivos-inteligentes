import 'package:flutter/material.dart';

// Punto de entrada de la aplicacion.
// runApp() recibe el widget raiz y lo pinta en pantalla.
void main() {
  runApp(const MyApp());
}

// Widget raiz de la app.
// StatelessWidget = no cambia su estado interno despues de construirse.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp define la estructura basica de una app con estilo Material Design.
    return MaterialApp(
      title: 'Climate App',                 // Titulo que aparece en multitarea
      theme: ThemeData(
        primarySwatch: Colors.blue,        // Paleta de color principal (azul)
        useMaterial3: true,                // Activa Material Design 3
      ),
      home: const MyHomePage(),             // Pantalla inicial que se muestra
    );
  }
}

// Pantalla principal.
// Scaffold = layout basico con AppBar arriba y cuerpo debajo.
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'), // Texto de la barra superior
        centerTitle: true,                   // Centra el titulo
      ),
      body: Center(
        // Center: coloca a su hijo en el centro de la pantalla
        child: Column(
          // Column: apila widgets verticalmente
          mainAxisAlignment: MainAxisAlignment.center, // Centra hijos verticalmente
          children: [
            // Texto grande con la temperatura
            const Text(
              '28\u00B0C',
              style: TextStyle(
                fontSize: 96,                   // Tamano de letra grande
                fontWeight: FontWeight.bold,   // Negrita
                color: Colors.red,             // Color rojo
              ),
            ),
            // Espacio vertical de 16 pixeles logicos (dp)
            const SizedBox(height: 16),
            // Texto con el nombre de la ciudad
            const Text(
              'Queretaro',
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
            // Espacio vertical de 32 pixeles logicos
            const SizedBox(height: 32),
            // Icono de sol (Material Design icon)
            const Icon(
              Icons.sunny,
              size: 120,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
