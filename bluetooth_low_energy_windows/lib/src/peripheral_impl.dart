import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'bluetooth_low_energy_peer_impl.dart';

final class PeripheralImpl extends BluetoothLowEnergyPeerImpl
    implements Peripheral {
  PeripheralImpl({required super.address});

  @override
  int get hashCode => address.hashCode;

  @override
  bool operator ==(Object other) {
    return other is PeripheralImpl && other.address == address;
  }
}
