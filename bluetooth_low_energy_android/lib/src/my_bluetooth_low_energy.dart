import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_central_manager.dart';
import 'my_peripheral_manager.dart';

class MyBluetoothLowEnergy extends BluetoothLowEnergy {
  @override
  final MyCentralManager centralManager;
  @override
  final MyPeripheralManager peripheralManager;

  MyBluetoothLowEnergy()
      : centralManager = MyCentralManager(),
        peripheralManager = MyPeripheralManager();

  @override
  Future<void> setUp() async {
    await centralManager.setUp();
    await peripheralManager.setUp();
  }
}
