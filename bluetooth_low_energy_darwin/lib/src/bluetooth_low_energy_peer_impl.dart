import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

abstract base class BluetoothLowEnergyPeerImpl
    implements BluetoothLowEnergyPeer {
  @override
  final UUID uuid;

  BluetoothLowEnergyPeerImpl({required this.uuid});

  // @override
  // String get address =>
  //     throw UnsupportedError('address is not supported on Darwin.');

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is BluetoothLowEnergyPeer && other.uuid == uuid;
  }
}
