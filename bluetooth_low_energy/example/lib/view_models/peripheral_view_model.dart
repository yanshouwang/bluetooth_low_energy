import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/foundation.dart';

import 'view_model.dart';

const communicationServiceId = 'af661820-d14a-4b21-90f8-54d58f8614f0';
const notifyCharacteristicId = '1b6b9415-ff0d-47c2-9444-a5032f727b2d';
const writeCharacteristicId = '1b6b9415-ff0d-47c2-9444-a5032f727b2d';

abstract class PeripheralViewModel {
  String get name;

  Stream<PeripheralState> get stateChanged;

  void connect();
  void disconnect();

  factory PeripheralViewModel(Peripheral peripheral) =>
      _DeviceViewModel(peripheral);
}

class _DeviceViewModel extends ViewModel implements PeripheralViewModel {
  final Peripheral peripheral;

  _DeviceViewModel(this.peripheral);

  @override
  String get name => peripheral.name;

  @override
  Stream<PeripheralState> get stateChanged =>
      CentralManager.instance.peripheralStateChanged
          .where((eventArgs) => eventArgs.id == peripheral.id)
          .map((eventArgs) => eventArgs.state);

  @override
  void connect() {
    CentralManager.instance.connect(peripheral.id);
  }

  @override
  void disconnect() {
    CentralManager.instance.disconnect(peripheral.id);
  }

  final _maximumWriteLength = 20;

  Future<void> write(Uint8List value) async {
    var start = 0;
    while (start < value.length) {
      final end = start + _maximumWriteLength;
      final trimmedValue =
          end < value.length ? value.sublist(start, end) : value.sublist(start);
      await CentralManager.instance.write(
        peripheral.id,
        communicationServiceId,
        writeCharacteristicId,
        trimmedValue,
        // withoutResponse: true,
      );
      start = end;
    }
  }
}
