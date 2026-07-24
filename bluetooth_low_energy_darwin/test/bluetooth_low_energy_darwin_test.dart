import 'package:bluetooth_low_energy_darwin/src/api.g.dart';
import 'package:bluetooth_low_energy_darwin/src/central_manager_impl.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'CentralManagerImpl#onConnectionStateChanged forwards the native '
    'NSError code into PeripheralConnectionStateChangedEventArgs.status.',
    () async {
      final manager = CentralManagerImpl();
      final peripheralArgs = PeripheralArgs(
        uuidArgs: '00000000-0000-0000-0000-AABBCCDDEEFF',
      );

      final future = manager.connectionStateChanged.first;
      manager.onConnectionStateChanged(
        peripheralArgs,
        6, // CBErrorPeripheralDisconnected
        ConnectionStateArgs.disconnected,
      );
      final eventArgs = await future;

      expect(eventArgs.status, 6);
      expect(eventArgs.state, ConnectionState.disconnected);
    },
  );
}
