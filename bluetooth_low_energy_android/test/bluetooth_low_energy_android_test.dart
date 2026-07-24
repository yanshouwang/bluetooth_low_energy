import 'package:bluetooth_low_energy_android/src/api.g.dart';
import 'package:bluetooth_low_energy_android/src/central_manager_impl.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'CentralManagerImpl#onConnectionStateChanged forwards the native GATT '
    'status code into PeripheralConnectionStateChangedEventArgs.status.',
    () async {
      final manager = CentralManagerImpl();
      final peripheralArgs = PeripheralArgs(
        addressArgs: 'AA:BB:CC:DD:EE:FF',
      );

      final future = manager.connectionStateChanged.first;
      manager.onConnectionStateChanged(
        peripheralArgs,
        8, // GATT_CONN_TIMEOUT
        ConnectionStateArgs.disconnected,
      );
      final eventArgs = await future;

      expect(eventArgs.status, 8);
      expect(eventArgs.state, ConnectionState.disconnected);
    },
  );
}
