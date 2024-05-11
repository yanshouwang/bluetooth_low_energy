import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class MyPeripheral extends Peripheral {
  final String address;

  MyPeripheral({
    required this.address,
  }) : super(
          uuid: UUID.fromAddress(address),
        );
}
