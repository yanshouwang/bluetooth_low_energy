import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'central_manager_impl.dart';
import 'peripheral_manager_impl.dart';

final class BluetoothLowEnergyDarwinPlugin extends BluetoothLowEnergyPlugin {
  static void registerWith() {
    BluetoothLowEnergyPlugin.instance = BluetoothLowEnergyDarwinPlugin();
  }

  @override
  CentralManager createCentralManager() {
    return CentralManagerImpl();
  }

  @override
  PeripheralManager createPeripheralManager() {
    return PeripheralManagerImpl();
  }
}
