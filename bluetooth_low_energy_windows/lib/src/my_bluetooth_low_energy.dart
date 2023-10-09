import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyBluetoothLowEnergy extends BluetoothLowEnergy {
  @override
  // TODO: implement centralManager
  CentralManager get centralManager => throw UnimplementedError();

  @override
  // TODO: implement peripheralManager
  PeripheralManager get peripheralManager => throw UnimplementedError();
}
