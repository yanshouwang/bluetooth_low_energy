import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

base class MyCentral extends Central {
  final String address;

  MyCentral({
    required this.address,
  }) : super(
          uuid: UUID.fromAddress(address),
        );
}
