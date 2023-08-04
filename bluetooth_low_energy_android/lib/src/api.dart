import 'api.g.dart';
import 'bluetooth_gatt_callback_api.dart';
import 'bluetooth_gatt_server_callback_api.dart';
import 'bluetooth_profile_service_listener_api.dart';
import 'broadcast_receiver_api.dart';
import 'scan_call_back_api.dart';

final instanceManagerApi = InstanceManagerHostApi();
final intentApi = IntentHostApi();
final pendingIntentAPi = PendingIntentHostApi();
final uuidApi = UuidHostApi();
final parcelUuidApi = ParcelUuidHostApi();
final broadcastReceiverApi = BroadcastReceiverApi();
final bluetoothManagerApi = BluetoothManagerHostApi();
final bluetoothGattServerCallbackApi = BluetoothGattServerCallbackApi();
final bluetoothAdapterApi = BluetoothAdapterHostApi();
final bluetoothProfileServiceListenerApi = BluetoothProfileServiceListenerApi();
final bluetoothLeScanner = BluetoothLeScannerHostApi();
final scanCallbackApi = ScanCallbackApi();
final scanResultApi = ScanResultHostApi();
final scanRecordApi = ScanRecordHostApi();
final bluetoothDeviceApi = BluetoothDeviceHostApi();
final bluetoothGattApi = BluetoothGattHostApi();
final bluetoothGattCallbackApi = BluetoothGattCallbackApi();
final bluetoothGattServiceApi = BluetoothGattServiceHostApi();
final bluetoothGattCharacteristicApi = BluetoothGattCharacteristicHostApi();
final bluetoothGattDescriptorApi = BluetoothGattDescriptorHostApi();

void setup() {
  BroadcastReceiverFlutterApi.setup(broadcastReceiverApi);
  BluetoothGattServerCallbackFlutterApi.setup(bluetoothGattServerCallbackApi);
  BluetoothProfileServiceListenerFlutterApi.setup(
    bluetoothProfileServiceListenerApi,
  );
  ScanCallbackFlutterApi.setup(scanCallbackApi);
  BluetoothGattCallbackFlutterApi.setup(bluetoothGattCallbackApi);
}
