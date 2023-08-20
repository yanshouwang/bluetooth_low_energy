import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_peripheral.dart';

class MyPeripheralDiscoveredEventArgs extends EventArgs {
  final MyPeripheral myPeripheral;

  MyPeripheralDiscoveredEventArgs(this.myPeripheral);
}
