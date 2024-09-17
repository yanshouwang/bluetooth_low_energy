import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'pigeon.dart';

final class PeripheralImpl extends Peripheral {
  final String uuidArgs;

  PeripheralImpl({
    required this.uuidArgs,
  }) : super(
          uuid: UUID.fromString(uuidArgs),
        );

  factory PeripheralImpl.fromArgs(PeripheralArgs args) {
    return PeripheralImpl(
      uuidArgs: args.uuidArgs,
    );
  }

  @override
  int get hashCode => uuidArgs.hashCode;

  @override
  bool operator ==(Object other) {
    return other is PeripheralImpl && other.uuidArgs == uuidArgs;
  }
}
