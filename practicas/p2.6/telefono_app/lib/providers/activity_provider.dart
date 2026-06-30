import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/activity_data.dart';
import '../services/ble_client.dart';

enum ConnectionStatus { disconnected, scanning, connected, error }

class ActivityProvider extends ChangeNotifier {
  final BleClient _client = BleClient();

  ActivityData _data = ActivityData(
    steps: 0,
    heartRate: 0,
    calories: 0,
    status: 'sin datos',
    timestamp: DateTime.now(),
  );
  ConnectionStatus _status = ConnectionStatus.disconnected;
  String? _errorMessage;
  StreamSubscription? _dataSub;
  Timer? _demoTimer;
  bool _demoMode = false;
  final Random _rng = Random();

  ActivityData get data => _data;
  ConnectionStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isConnected => _status == ConnectionStatus.connected;
  bool get isDemoMode => _demoMode;

  Future<void> connect() async {
    _status = ConnectionStatus.scanning;
    _errorMessage = null;
    notifyListeners();

    try {
      await _client.scanAndConnect();
      _status = ConnectionStatus.connected;
      notifyListeners();

      // Escuchar datos del wearable
      _dataSub = _client.dataStream.listen((data) {
        _data = data;
        notifyListeners();
      });
    } catch (e) {
      _status = ConnectionStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    await _dataSub?.cancel();
    await _client.disconnect();
    _demoTimer?.cancel();
    _demoMode = false;
    _status = ConnectionStatus.disconnected;
    notifyListeners();
  }

  /// Inicia un modo demo que genera datos simulados localmente.
  /// Util cuando no hay un wearable real disponible (p.ej. entre emuladores).
  void startDemo() {
    _demoTimer?.cancel();
    _demoMode = true;
    _status = ConnectionStatus.connected;
    _errorMessage = null;
    var steps = 0;
    var calories = 0;
    var hr = 75;
    final states = ['caminando', 'corriendo', 'reposo'];
    var stateIdx = 0;
    var tick = 0;
    notifyListeners();

    _demoTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      tick++;
      // Cambia de estado cada 12 segundos para mostrar variedad
      if (tick % 12 == 0) {
        stateIdx = (stateIdx + 1) % states.length;
      }
      final state = states[stateIdx];
      switch (state) {
        case 'caminando':
          steps += 2 + _rng.nextInt(2);
          hr = 90 + _rng.nextInt(15);
          calories += 1;
          break;
        case 'corriendo':
          steps += 4 + _rng.nextInt(3);
          hr = 130 + _rng.nextInt(20); // dispara alerta bpm > 120
          calories += 2;
          break;
        default: // reposo
          hr = 68 + _rng.nextInt(8);
      }
      _data = ActivityData(
        steps: steps,
        heartRate: hr,
        calories: calories,
        status: state,
        timestamp: DateTime.now(),
      );
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _dataSub?.cancel();
    _demoTimer?.cancel();
    _client.dispose();
    super.dispose();
  }
}
