import 'advertisement.dart';
import 'bluetooth_state.dart';
import 'uuid.dart';

abstract class CentralController {
  Stream<BluetoothState> get stateStream;

  Future<BluetoothState> getState();
  Stream<Advertisement> buildAdvertisementStream({List<UUID>? uuids});
  void dispose();
}
