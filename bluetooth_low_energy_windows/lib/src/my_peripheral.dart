import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';

final class MyPeripheral extends Peripheral {
  final int addressArgs;

  MyPeripheral({
    required this.addressArgs,
  }) : super(
          uuid: addressArgs.toUUID(),
        );
}
