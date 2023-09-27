import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

class MyBluetoothLowEnergyManager extends BluetoothLowEnergyManager {
  MyBluetoothLowEnergyManager()
      : _state = BluetoothLowEnergyState.unknown,
        _stateChangedController = StreamController.broadcast();

  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;

  BluetoothLowEnergyState _state;
  @override
  BluetoothLowEnergyState get state => _state;
  @protected
  set state(BluetoothLowEnergyState value) {
    if (_state == value) {
      return;
    }
    _state = value;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;

  @protected
  Future<void> throwWithoutState(BluetoothLowEnergyState state) async {
    if (this.state != state) {
      throw BluetoothLowEnergyError(
        '$state is expected, but current state is ${this.state}.',
      );
    }
  }
}
