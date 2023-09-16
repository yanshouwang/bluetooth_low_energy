import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';

class MyBluetoothLowEnergyManager extends BluetoothLowEnergyManager
    implements MyBluetoothLowEnergyManagerFlutterApi {
  final MyBluetoothLowEnergyManagerHostApi _myApi;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  BluetoothLowEnergyState _state;

  MyBluetoothLowEnergyManager()
      : _myApi = MyBluetoothLowEnergyManagerHostApi(),
        _state = BluetoothLowEnergyState.unknown,
        _stateChangedController = StreamController.broadcast();

  @override
  BluetoothLowEnergyState get state => _state;
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

  Future<void> setUp() async {
    await throwWithoutState(BluetoothLowEnergyState.unknown);
    final args = await _myApi.setUp();
    final myStateArgs = MyCentralStateArgs.values[args.myStateNumber];
    _state = myStateArgs.toState();
  }

  @override
  void onStateChanged(int myStateNumber) {
    final myStateArgs = MyCentralStateArgs.values[myStateNumber];
    final state = myStateArgs.toState();
    if (_state == state) {
      return;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }
}

extension on MyBluetoothLowEnergyStateArgs {
  CentralState toState() {
    return CentralState.values[index];
  }
}
