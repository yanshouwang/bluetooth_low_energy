import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

abstract base class BluetoothLowEnergyPeerImpl
    implements BluetoothLowEnergyPeer {
  final String address;

  BluetoothLowEnergyPeerImpl({required this.address});

  @override
  UUID get uuid => UUID.fromAddress(address);

  @override
  int get hashCode => address.hashCode;

  @override
  bool operator ==(Object other) {
    return other is BluetoothLowEnergyPeerImpl && other.address == address;
  }
}
