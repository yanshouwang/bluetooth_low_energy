import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

base mixin BluetoothLowEnergyManagerImpl on BluetoothLowEnergyManager {
  @override
  // TODO: implement stateChanged
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
      throw UnimplementedError();

  @override
  // TODO: implement nameChanged
  Stream<NameChangedEvent> get nameChanged => throw UnimplementedError();

  @override
  Future<BluetoothLowEnergyState> getState() {
    // TODO: implement getState
    throw UnimplementedError();
  }

  @override
  Future<bool> authorize() {
    // TODO: implement authorize
    throw UnimplementedError();
  }

  @override
  Future<void> showAppSettings() {
    // TODO: implement showAppSettings
    throw UnimplementedError();
  }

  @override
  Future<String> getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  Future<void> setName(String name) {
    // TODO: implement setName
    throw UnimplementedError();
  }

  @override
  Future<void> turnOn() {
    // TODO: implement turnOn
    throw UnimplementedError();
  }

  @override
  Future<void> turnOff() {
    // TODO: implement turnOff
    throw UnimplementedError();
  }
}
