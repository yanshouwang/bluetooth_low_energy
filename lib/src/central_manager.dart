import 'advertisement.dart';
import 'bluetooth_low_energy_impl.dart';
import 'bluetooth_state.dart';
import 'peripheral.dart';
import 'uuid.dart';

abstract class CentralManager {
  Stream<BluetoothState> get stateStream;

  Future<BluetoothState> getState();
  Stream<Advertisement> createAdvertisementStream({List<UUID>? uuids});
  Future<Peripheral> connect(
    UUID uuid, {
    Function(Exception)? onConnectionLost,
  });

  static CentralManager instance = MyCentralManager();
}
