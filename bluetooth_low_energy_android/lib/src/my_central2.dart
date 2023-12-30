import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyCentral2 extends MyCentral {
  final String address;

  MyCentral2({
    required this.address,
  }) : super(
          uuid: UUID.fromAddress(address),
        );
}
