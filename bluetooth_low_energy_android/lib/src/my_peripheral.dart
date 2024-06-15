import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';

final class MyPeripheral extends Peripheral {
  final String addressArgs;

  MyPeripheral({
    required this.addressArgs,
  }) : super(
          uuid: UUID.fromAddress(addressArgs),
        );

  factory MyPeripheral.fromArgs(MyPeripheralArgs peripheralArgs) {
    return MyPeripheral(
      addressArgs: peripheralArgs.addressArgs,
    );
  }
}
