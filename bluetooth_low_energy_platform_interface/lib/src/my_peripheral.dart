import 'my_bluetooth_low_energy_peer.dart';
import 'peripheral.dart';

class MyPeripheral extends MyBluetoothLowEnergyPeer implements Peripheral {
  MyPeripheral({
    required super.uuid,
  });

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Peripheral && other.uuid == uuid;
  }
}
