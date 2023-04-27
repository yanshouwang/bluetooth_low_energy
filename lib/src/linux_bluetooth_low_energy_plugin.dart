import 'bluez_central_manager.dart';
import 'central_manager.dart';

abstract class LinuxBluetoothLowEnergyPlugin {
  static void registerWith() {
    CentralManager.instance = BluezCentralManager();
  }
}
