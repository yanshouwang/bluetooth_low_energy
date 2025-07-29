import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class MyPeripheral extends Peripheral {
  final String addressArgs;

  MyPeripheral({required this.addressArgs})
    : super(uuid: UUID.fromAddress(addressArgs));
}
