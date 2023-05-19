import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'bluetooth_low_energy_android_api.dart';
import 'pigeon_central_manager.dart';

class BluetoothLowEnergyAndroidPlugin {
  void registerWith() {
    final api = PigeonCentralManager();
    CentralManagerFlutterApi.setup(api);
    CentralManager.instance = api;
  }
}
