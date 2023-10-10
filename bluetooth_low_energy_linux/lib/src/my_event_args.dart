import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

class BlueZDeviceServicesResolvedEventArgs extends EventArgs {
  final BlueZDevice device;

  BlueZDeviceServicesResolvedEventArgs(this.device);
}
