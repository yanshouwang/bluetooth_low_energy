import 'broadcast.dart';
import 'impl.dart';
import 'bluetooth_state.dart';
import 'uuid.dart';

abstract class CentralManager {
  Future<BluetoothState> get state;
  Stream<BluetoothState> get stateChanged;
  Stream<Broadcast> get scanned;

  Future<bool> authorize();
  Future<void> startScan({List<UUID>? uuids});
  Future<void> stopScan();

  static final _instance = MyCentralManager();
  static CentralManager get instance => _instance;
}
