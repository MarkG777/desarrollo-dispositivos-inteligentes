// Pantalla BLE: escanea, lista y conecta dispositivos Bluetooth Low Energy
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ble_provider.dart';
import '../providers/weather_provider.dart';

class BleScreen extends StatelessWidget {
  const BleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar dispositivos BLE'),
        centerTitle: true,
      ),
      body: Consumer2<BLEProvider, WeatherProvider>(
        builder: (context, provider, wp, _) {
          if (provider.isScanning && provider.scanResults.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.scanResults.isEmpty) {
            return Center(child: Text(provider.errorMessage!));
          }

          if (provider.scanResults.isEmpty) {
            return const Center(
              child: Text('Presiona el botón para buscar dispositivos'),
            );
          }

          return ListView.builder(
            itemCount: provider.scanResults.length,
            itemBuilder: (context, index) {
              final result = provider.scanResults[index];
              final name = result.device.advName.isNotEmpty
                  ? result.device.advName
                  : 'Dispositivo desconocido';
              return ListTile(
                leading: const Icon(Icons.bluetooth),
                title: Text(name),
                subtitle: Text(result.device.remoteId.toString()),
                trailing: Text('${result.rssi} dBm'),
                onTap: () async {
                  await provider.connectToDevice(
                    result.device.remoteId.toString(),
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer2<BLEProvider, WeatherProvider>(
        builder: (context, provider, wp, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (provider.isConnected && provider.bleTemperature != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Temp BLE: ${wp.formatTemp(provider.bleTemperature!)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              FloatingActionButton(
                onPressed: provider.isScanning ? null : provider.startScan,
                child: provider.isScanning
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.search),
              ),
            ],
          );
        },
      ),
    );
  }
}
