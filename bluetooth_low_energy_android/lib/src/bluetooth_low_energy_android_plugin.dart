import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'impl.dart';

final class BluetoothLowEnergyAndroidPlugin extends BluetoothLowEnergyPlugin {
  BluetoothLowEnergyAndroidPlugin() : super.impl();

  static void registerWith() {
    BluetoothLowEnergyPlugin.instance = BluetoothLowEnergyAndroidPlugin();
  }

  @override
  CentralManager newCentralManager() {
    return CentralManagerImpl();
  }

  @override
  PeripheralManager newPeripheralManager() {
    // TODO: implement createPeripheralManager
    throw UnimplementedError();
  }
}
