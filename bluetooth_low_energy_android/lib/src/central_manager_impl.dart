import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'bluetooth_low_energy_manager_impl.dart';

final class CentralManagerImpl extends CentralManager
    with BluetoothLowEnergyManagerImpl {
  CentralManagerImpl() : super.impl();
}
