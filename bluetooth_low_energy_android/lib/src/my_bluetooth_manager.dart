import 'api.dart';
import 'bluetooth_adapter.dart';
import 'bluetooth_device.dart';
import 'bluetooth_gatt_server.dart';
import 'bluetooth_gatt_server_callback.dart';
import 'bluetooth_manager.dart';
import 'my_bluetooth_adapter.dart';
import 'my_bluetooth_device.dart';
import 'my_bluetooth_gatt_server.dart';
import 'my_object.dart';

class MyBluetoothManager extends MyObject implements BluetoothManager {
  MyBluetoothManager(super.hashCode);

  @override
  Future<BluetoothAdapter> getAdapter() async {
    final adapterHashCode = await bluetoothManagerApi.getAdapter(hashCode);
    return MyBluetoothAdapter(adapterHashCode);
  }

  @override
  Future<List<BluetoothDevice>> getConnectedDevices(int profile) async {
    final deviceHashCodes = await bluetoothManagerApi.getConnectedDevices(
      hashCode,
      profile,
    );
    return deviceHashCodes
        .whereType<int>()
        .map((deviceHashCode) => MyBluetoothDevice(deviceHashCode))
        .toList();
  }

  @override
  Future<int> getConnectionState(BluetoothDevice device, int profile) {
    return bluetoothManagerApi.getConnectionState(
      hashCode,
      device.hashCode,
      profile,
    );
  }

  @override
  Future<List<BluetoothDevice>> getDevicesMatchingConnectionStates(
      int profile, List<int> states) async {
    final deviceHashCodes =
        await bluetoothManagerApi.getDevicesMatchingConnectionStates(
      hashCode,
      profile,
      states,
    );
    return deviceHashCodes
        .whereType<int>()
        .map((deviceHashCode) => MyBluetoothDevice(deviceHashCode))
        .toList();
  }

  @override
  Future<BluetoothGattServer> openGattServer(
    BluetoothGattServerCallback callback,
  ) async {
    final serverHashCode = await bluetoothManagerApi.openGattServer(
      hashCode,
      callback.hashCode,
    );
    return MyBluetoothGattServer(serverHashCode);
  }
}
