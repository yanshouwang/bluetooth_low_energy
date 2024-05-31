import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class MyCentral extends Central {
  final int addressArgs;

  MyCentral({
    required this.addressArgs,
    required super.uuid,
  });
}
