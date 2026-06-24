// Pantalla BLE: escanea, lista y conecta dispositivos Bluetooth Low Energy
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ble_provider.dart';

class BleScreen extends StatelessWidget {
  const BleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar dispositivos BLE'),
        centerTitle: true,
      ),
      body: Consumer<BLEProvider>(
        builder: (context, provider, _) {
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
      floatingActionButton: Consumer<BLEProvider>(
        builder: (context, provider, _) {
          return FloatingActionButton(
            onPressed: provider.isScanning ? null : provider.startScan,
            child: provider.isScanning
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.search),
          );
        },
      ),
    );
  }
}
