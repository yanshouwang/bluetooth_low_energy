import 'api.dart';
import 'bluetooth_adapter.dart';
import 'bluetooth_device.dart';
import 'bluetooth_gatt_server.dart';
import 'bluetooth_gatt_server_callback.dart';
import 'my_bluetooth_manager.dart';

abstract class BluetoothManager {
  Future<BluetoothAdapter> getAdapter();
  Future<int> getConnectionState(BluetoothDevice device, int profile);
  Future<List<BluetoothDevice>> getConnectedDevices(int profile);
  Future<List<BluetoothDevice>> getDevicesMatchingConnectionStates(
    int profile,
    List<int> states,
  );
  Future<BluetoothGattServer> openGattServer(
    BluetoothGattServerCallback callback,
  );

  static Future<BluetoothManager> getInstance() async {
    final hashCode = await bluetoothManagerApi.getInstance();
    return MyBluetoothManager(hashCode);
  }
}
