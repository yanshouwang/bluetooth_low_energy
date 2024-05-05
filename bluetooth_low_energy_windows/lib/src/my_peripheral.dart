import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';

base class MyPeripheral extends Peripheral {
  final int address;

  MyPeripheral({
    required this.address,
  }) : super(
          uuid: address.toUUID(),
        );
}
