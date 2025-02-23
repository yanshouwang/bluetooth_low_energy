import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'bluetooth_low_energy_manager_impl.dart';

final class PeripheralManagerImpl extends PeripheralManager
    with BluetoothLowEnergyManagerImpl {
  PeripheralManagerImpl() : super.impl();
}
