import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'src/central_manager_impl.dart';
import 'src/peripheral_manager_impl.dart';

abstract class BluetoothLowEnergyWindowsPlugin {
  static void registerWith() {
    CentralManagerChannel.instance = CentralManagerChannelImpl();
    PeripheralManagerChannel.instance = PeripheralManagerChannelImpl();
  }
}
