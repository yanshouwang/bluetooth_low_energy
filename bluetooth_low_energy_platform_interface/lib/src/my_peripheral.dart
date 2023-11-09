import 'my_bluetooth_low_energy_peer.dart';
import 'peripheral.dart';

class MyPeripheral extends MyBluetoothLowEnergyPeer implements Peripheral {
  MyPeripheral({
    required super.uuid,
  });
}
