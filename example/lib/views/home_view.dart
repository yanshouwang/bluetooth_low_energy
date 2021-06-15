import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Central manager;
  final Map<MAC, Discovery> discoveries;

  _HomeViewState()
      : manager = Central(),
        discoveries = {};

  @override
  void initState() {
    super.initState();
    manager.startDiscovery();
  }

  @override
  void dispose() {
    manager.stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: manager.discovered,
        builder: (context, AsyncSnapshot<Discovery> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            discoveries[data.address] = data;
          }
          return ListView.builder(
            itemCount: discoveries.length,
            itemBuilder: (context, i) {
              final discovery = discoveries[i]!;
              return Card(
                child: Column(
                  children: [
                    Text(discovery.address.toString()),
                    Text(discovery.rssi.toString()),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
