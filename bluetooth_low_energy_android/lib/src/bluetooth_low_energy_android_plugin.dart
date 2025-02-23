import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class BluetoothLowEnergyAndroidPlugin extends BluetoothLowEnergyPlugin {
  BluetoothLowEnergyAndroidPlugin() : super.impl();

  static void registerWith() {
    BluetoothLowEnergyPlugin.instance = BluetoothLowEnergyAndroidPlugin();
  }

  @override
  CentralManager createCentralManager() {
    // TODO: implement createCentralManager
    throw UnimplementedError();
  }

  @override
  PeripheralManager createPeripheralManager() {
    // TODO: implement createPeripheralManager
    throw UnimplementedError();
  }
}
