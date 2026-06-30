import 'package:flutter/material.dart';
import 'sensor_simulator.dart';
import 'ble_server.dart';

void main() => runApp(const WearableApp());

class WearableApp extends StatefulWidget {
  const WearableApp({super.key});

  @override
  State<WearableApp> createState() => _WearableAppState();
}

class _WearableAppState extends State<WearableApp> {
  late final SensorSimulator _sim;
  late final BleServer _server;
  int _steps = 0;
  int _heartRate = 72;
  int _calories = 0;
  String _status = 'reposo';
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _sim = SensorSimulator();
    _server = BleServer(_sim);
    _subscribeStreams();
  }

  void _subscribeStreams() {
    _sim.stepsStream.listen((v) => setState(() => _steps = v));
    _sim.heartRateStream.listen((v) => setState(() => _heartRate = v));
    _sim.caloriesStream.listen((v) => setState(() => _calories = v));
    _sim.statusStream.listen((v) => setState(() => _status = v));
  }

  void _toggleActivity() {
    setState(() => _active = !_active);
    if (_active) {
      _sim.start();
      _server.startAdvertising();
    } else {
      _server.stop();
    }
  }

  @override
  void dispose() {
    _server.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ritmo cardiaco (dato principal en wearable)
              Text(
                '$_heartRate',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: _heartRate > 120 ? Colors.red : Colors.white,
                  height: 1.0,
                ),
              ),
              const Text('bpm',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text('$_steps pasos',
                  style:
                      const TextStyle(fontSize: 14, color: Colors.green)),
              Text('$_calories kcal',
                  style:
                      const TextStyle(fontSize: 12, color: Colors.amber)),
              Text(_status,
                  style:
                      const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _toggleActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _active ? Colors.red : Colors.green,
                  minimumSize: const Size(90, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(_active ? 'Detener' : 'Iniciar',
                    style: const TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
