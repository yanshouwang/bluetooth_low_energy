import 'package:bluetooth_low_energy/src/pigeon.dart';

import 'bluetooth_low_energy_impl.dart';
import 'central_controller_api.dart';

class BluetoothLowEnergyPlugin {
  static void registerWith() {
    final centralControllerApi = MyCentralControllerApi();
    CentralControllerFlutterApi.setup(centralControllerApi);
    CentralControllerApi.instance = centralControllerApi;
  }
}

class BluetoothLowEnergyPluginAndroid {
  static void registerWith() {
    BluetoothLowEnergyPlugin.registerWith();
  }
}

class BluetoothLowEnergyPluginIOS {
  static void registerWith() {
    BluetoothLowEnergyPlugin.registerWith();
  }
}
