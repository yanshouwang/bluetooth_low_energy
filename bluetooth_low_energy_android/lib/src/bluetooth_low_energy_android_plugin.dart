import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_central_manager.dart';

class BluetoothLowEnergyAndroidPlugin {
  void registerWith() {
    final myCentralManagerApi = MyCentralManager();
    MyCentralManagerFlutterApi.setup(myCentralManagerApi);
    CentralManager.instance = myCentralManagerApi;
  }
}
