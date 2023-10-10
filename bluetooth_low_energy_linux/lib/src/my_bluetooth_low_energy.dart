import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_central_manager.dart';

class MyBluetoothLowEnergy extends BluetoothLowEnergy {
  @override
  final MyCentralManager centralManager;
  @override
  PeripheralManager get peripheralManager => throw UnimplementedError();

  MyBluetoothLowEnergy() : centralManager = MyCentralManager();
}
