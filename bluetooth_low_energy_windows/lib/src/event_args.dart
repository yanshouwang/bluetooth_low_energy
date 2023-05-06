import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class GattServiceEventArgs extends EventArgs {
  final String id;
  final GattService service;

  GattServiceEventArgs(this.id, this.service);
}
