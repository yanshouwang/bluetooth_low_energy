import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'pigeon.dart';

final class CentralImpl extends Central {
  final String uuidArgs;

  CentralImpl({
    required this.uuidArgs,
  }) : super(
          uuid: UUID.fromString(uuidArgs),
        );

  factory CentralImpl.fromArgs(CentralArgs args) {
    return CentralImpl(
      uuidArgs: args.uuidArgs,
    );
  }

  @override
  int get hashCode => uuidArgs.hashCode;

  @override
  bool operator ==(Object other) {
    return other is CentralImpl && other.uuidArgs == uuidArgs;
  }
}
