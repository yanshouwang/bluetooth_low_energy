import 'advertisement.dart';
import 'impl.dart';
import 'bluetooth_state.dart';
import 'peripheral.dart';
import 'uuid.dart';

abstract class CentralManager {
  Stream<BluetoothState> get stateStream;

  Future<bool> authorize();
  Future<BluetoothState> getState();
  Stream<Advertisement> getAdvertisementStream({List<UUID>? uuids});
  Future<Peripheral> connect(
    UUID uuid, {
    Function(Exception)? onConnectionLost,
  });

  static CentralManager instance = MyCentralManager();
}
