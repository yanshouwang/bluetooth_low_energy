import 'central.dart';
import 'my_bluetooth_low_energy_peer.dart';

class MyCentral extends MyBluetoothLowEnergyPeer implements Central {
  MyCentral({
    required super.uuid,
  });

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Central && other.uuid == uuid;
  }
}
