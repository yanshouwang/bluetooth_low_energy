import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyPeripheral2 extends MyPeripheral {
  final String address;

  MyPeripheral2({
    required this.address,
  }) : super(
          uuid: UUID.fromAddress(address),
        );
}
