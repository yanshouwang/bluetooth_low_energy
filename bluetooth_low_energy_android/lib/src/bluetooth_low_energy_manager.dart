import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'pigeon.g.dart';

extension BluetoothLowEnergyStateArgsX on BluetoothLowEnergyStateArgs {
  BluetoothLowEnergyState toState() {
    switch (this) {
      case BluetoothLowEnergyStateArgs.unknown:
        return BluetoothLowEnergyState.unknown;
      case BluetoothLowEnergyStateArgs.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case BluetoothLowEnergyStateArgs.unauthorized:
        return BluetoothLowEnergyState.unauthorized;
      case BluetoothLowEnergyStateArgs.off:
      case BluetoothLowEnergyStateArgs.turningOn:
        return BluetoothLowEnergyState.poweredOff;
      case BluetoothLowEnergyStateArgs.on:
      case BluetoothLowEnergyStateArgs.turningOff:
        return BluetoothLowEnergyState.poweredOn;
    }
  }
}

extension StringX on String {
  UUID toUUID() {
    return UUID.fromString(this);
  }
}

extension UuidX on UUID {
  String toArgs() {
    return toString();
  }
}
