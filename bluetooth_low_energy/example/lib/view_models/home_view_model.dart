import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';

import 'view_model.dart';

abstract class HomeViewModel extends ViewModel {
  ValueListenable<CentralManagerState> get state;
  ValueListenable<List<Peripheral>> get peripherals;

  void startScan();
  void stopScan();

  factory HomeViewModel() => _HomeViewModel();
}

class _HomeViewModel extends ViewModel implements HomeViewModel {
  @override
  ValueListenable<CentralManagerState> get state =>
      CentralManager.instance.state;
  @override
  final ValueNotifier<List<Peripheral>> peripherals;

  late final StreamSubscription<PeripheralEventArgs> scannedSubscription;

  _HomeViewModel() : peripherals = ValueNotifier([]) {
    scannedSubscription = CentralManager.instance.scanned.listen((eventArgs) {
      final peripheral = eventArgs.peripheral;
      // final exp = RegExp(r'.{2}')
      //     .allMatches(peripheral.id)
      //     .map((e) => e.group(0))
      //     .join(':');
      final peripherals = this.peripherals.value;
      final i = peripherals.indexWhere((device) => device.id == peripheral.id);
      if (i < 0) {
        this.peripherals.value = [
          ...peripherals,
          peripheral,
        ];
      } else {
        peripherals[i] = peripheral;
        this.peripherals.value = [
          ...peripherals,
        ];
      }
    });
  }

  @override
  void startScan() async {
    CentralManager.instance.startScan();
  }

  @override
  void stopScan() {
    CentralManager.instance.stopScan();
  }

  @override
  void dispose() {
    scannedSubscription.cancel();
    peripherals.dispose();
    super.dispose();
  }
}
