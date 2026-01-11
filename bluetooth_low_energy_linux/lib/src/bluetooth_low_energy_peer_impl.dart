import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

abstract base class BluetoothLowEnergyPeerImpl
    implements BluetoothLowEnergyPeer {
  final BlueZDevice blueZDevice;

  BluetoothLowEnergyPeerImpl(this.blueZDevice);

  @override
  UUID get uuid => UUID.fromAddress(blueZDevice.address);

  @override
  int get hashCode => blueZDevice.hashCode;

  @override
  bool operator ==(Object other) {
    return other is BluetoothLowEnergyPeerImpl &&
        other.blueZDevice == blueZDevice;
  }
}
