import 'bluetooth_low_energy_peer.dart';
import 'uuid.dart';

abstract class MyBluetoothLowEnergyPeer implements BluetoothLowEnergyPeer {
  @override
  final UUID uuid;

  MyBluetoothLowEnergyPeer({
    required this.uuid,
  });
}
