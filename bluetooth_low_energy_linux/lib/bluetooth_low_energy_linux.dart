import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'src/central_manager_impl.dart';

abstract class BluetoothLowEnergyLinuxPlugin {
  static void registerWith() {
    CentralManagerChannel.instance = CentralManagerChannelImpl();
  }
}
