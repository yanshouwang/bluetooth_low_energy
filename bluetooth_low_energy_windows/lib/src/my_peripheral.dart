import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class MyPeripheral extends Peripheral {
  final int addressArgs;

  MyPeripheral({required this.addressArgs, required super.uuid});
}
