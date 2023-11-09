import 'central.dart';
import 'my_bluetooth_low_energy_peer.dart';

class MyCentral extends MyBluetoothLowEnergyPeer implements Central {
  MyCentral({
    required super.uuid,
  });
}
