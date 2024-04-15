import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'central_manager.dart';
import 'peripheral_manager.dart';

abstract class BluetoothLowEnergyAndroidPlugin {
  static void registerWith() {
    CentralManagerImpl.instance = AndroidCentralManagerImpl();
    PeripheralManagerImpl.instance = AndroidPeripheralManagerImpl();
  }
}
