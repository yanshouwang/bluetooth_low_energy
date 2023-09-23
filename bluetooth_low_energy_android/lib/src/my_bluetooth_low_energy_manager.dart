import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyBluetoothLowEnergyManager extends BluetoothLowEnergyManager {
  MyBluetoothLowEnergyManager()
      : _state = BluetoothLowEnergyState.unknown,
        _stateChangedController = StreamController.broadcast();

  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;

  BluetoothLowEnergyState _state;
  @override
  BluetoothLowEnergyState get state => _state;
  set state(BluetoothLowEnergyState value) {
    if (_state == state) {
      return;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;

  Future<void> throwWithState(BluetoothLowEnergyState state) async {
    if (this.state == state) {
      throw BluetoothLowEnergyError('$state is unexpected.');
    }
  }

  Future<void> throwWithoutState(BluetoothLowEnergyState state) async {
    if (this.state != state) {
      throw BluetoothLowEnergyError(
        '$state is expected, but current state is ${this.state}.',
      );
    }
  }
}
