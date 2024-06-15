import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';

final class MyCentral extends Central {
  final String address;

  MyCentral({
    required this.address,
  }) : super(
          uuid: UUID.fromAddress(address),
        );

  factory MyCentral.fromArgs(MyCentralArgs centralArgs) {
    return MyCentral(
      address: centralArgs.addressArgs,
    );
  }
}
