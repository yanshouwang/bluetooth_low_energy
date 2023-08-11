import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';

void main() {
  runZonedGuarded(onStartUp, onCrashed);
}

void onStartUp() async {
  runApp(const MyApp());
}

void onCrashed(Object error, StackTrace stackTrace) {
  log(
    '$error',
    error: error,
    stackTrace: stackTrace,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final CentralController centralController;
  late final ValueNotifier<CentralState> state;
  late final ValueNotifier<bool> isDiscovering;
  late final StreamSubscription<CentralStateChangedEventArgs>
      stateChangedSubscription;
  late final StreamSubscription<CentralDiscoveredEventArgs>
      discoveredSubscription;

  @override
  void initState() {
    super.initState();
    centralController = CentralController.instance;
    state = ValueNotifier(centralController.state);
    isDiscovering = ValueNotifier(centralController.isDiscovering);
    stateChangedSubscription =
        centralController.stateChanged.listen(onStateChanged);
    discoveredSubscription = centralController.discovered.listen(onDiscovered);
    setUp();
  }

  Future<void> setUp() async {
    await centralController.setUp();
    state.value = centralController.state;
    await startDiscovery();
  }

  void onStateChanged(CentralStateChangedEventArgs eventArgs) {
    state.value = eventArgs.state;
  }

  void onDiscovered(CentralDiscoveredEventArgs eventArgs) {}

  Future<void> startDiscovery() async {
    await centralController.startDiscovery();
    isDiscovering.value = true;
  }

  Future<void> stopDiscovery() async {
    await centralController.stopDiscovery();
    isDiscovering.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BluetoothLowEnergy'),
        ),
        body: Center(
          child: Text('BluetoothLowEnergy'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    stateChangedSubscription.cancel();
    discoveredSubscription.cancel();
    state.dispose();
  }
}
