import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Map<String, dynamic>> _cities = [
    {'name': 'Santiago', 'temp': '24\u00B0C', 'condition': 'sunny'},
    {'name': 'Queretaro', 'temp': '28\u00B0C', 'condition': 'cloudy'},
    {'name': 'Mexico', 'temp': '22\u00B0C', 'condition': 'rainy'},
  ];

  List<Map<String, dynamic>> _filtered = [];

  void _filterCities(String query) {
    setState(() {
      _filtered = _cities
          .where((c) => c['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _filtered.isEmpty ? _cities : _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Ciudades'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterCities,
              decoration: const InputDecoration(
                hintText: 'Busca una ciudad...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final city = displayList[index];
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(city['name']),
                  subtitle: Text(city['temp']),
                  onTap: () {
                    // Devuelve la ciudad seleccionada a la pantalla anterior
                    Navigator.pop(context, city['name']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
