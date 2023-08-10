import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';

void main() {
  runZonedGuarded(onStartUp, onCrashed);
}

void onStartUp() async {
  await initialize();
  runApp(const MyApp());
}

void onCrashed(Object error, StackTrace stackTrace) {
  log(
    '$error',
    error: error,
    stackTrace: stackTrace,
  );
}

Future<void> initialize() async {
  await CentralController.instance.initialize();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final CentralController centralController;
  late final ValueNotifier<CentralControllerState> state;
  late final StreamSubscription<CentralControllerStateChangedEventArgs>
      stateChangedSubscription;
  late final StreamSubscription<CentralControllerDiscoveredEventArgs>
      discoveredSubscription;

  @override
  void initState() {
    super.initState();
    centralController = CentralController.instance;
    state = ValueNotifier(centralController.state);
    stateChangedSubscription =
        centralController.stateChanged.listen(onStateChanged);
    discoveredSubscription = centralController.discovered.listen(onDiscovered);
  }

  void onStateChanged(CentralControllerStateChangedEventArgs eventArgs) {
    state.value = eventArgs.state;
  }

  void onDiscovered(CentralControllerDiscoveredEventArgs eventArgs) {}

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
