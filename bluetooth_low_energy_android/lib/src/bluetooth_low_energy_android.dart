import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'api.dart' as api;

class BluetoothLowEnergyAndroid extends BluetoothLowEnergy {
  static void registerWith() {
    BluetoothLowEnergy.instance = BluetoothLowEnergyAndroid();
  }

  @override
  void initialize() {
    api.setup();
  }

  @override
  Future<CentralManager> getCenrtalManager() {
    // TODO: implement getCenrtalManager
    throw UnimplementedError();
  }
}
