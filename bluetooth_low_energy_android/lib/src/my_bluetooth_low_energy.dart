import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyBluetoothLowEnergy extends BluetoothLowEnergy {
  @override
  // TODO: implement centralController
  CentralManager get centralController => throw UnimplementedError();

  @override
  // TODO: implement peripheralController
  PeripheralManager get peripheralController => throw UnimplementedError();

  @override
  Future<void> setUp() {
    // TODO: implement setUp
    throw UnimplementedError();
  }
}
