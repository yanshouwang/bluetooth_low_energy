import 'api.g.dart';

class BluetoothGattCallbackApi extends BluetoothGattCallbackHostApi
    implements BluetoothGattCallbackFlutterApi {
  @override
  void onCharacteristicChanged(int gattHashCode, int characteristicHashCode) {
    // TODO: implement onCharacteristicChanged
  }

  @override
  void onCharacteristicRead(
      int gattHashCode, int characteristicHashCode, int status) {
    // TODO: implement onCharacteristicRead
  }

  @override
  void onCharacteristicWrite(
      int gattHashCode, int characteristicHashCode, int status) {
    // TODO: implement onCharacteristicWrite
  }

  @override
  void onConnectionStateChange(int gattHashCode, int status, int newState) {
    // TODO: implement onConnectionStateChange
  }

  @override
  void onConnectionUpdated(
      int gattHashCode, int interval, int latency, int timeout, int status) {
    // TODO: implement onConnectionUpdated
  }

  @override
  void onDescriptorRead(int gattHashCode, int descriptorHashCode, int status) {
    // TODO: implement onDescriptorRead
  }

  @override
  void onDescriptorWrite(int gattHashCode, int descriptorHashCode, int status) {
    // TODO: implement onDescriptorWrite
  }

  @override
  void onMtuChanged(int gattHashCode, int mtu, int status) {
    // TODO: implement onMtuChanged
  }

  @override
  void onPhyRead(int gattHashCode, int txPhy, int rxPhy, int status) {
    // TODO: implement onPhyRead
  }

  @override
  void onPhyUpdate(int gattHashCode, int txPhy, int rxPhy, int status) {
    // TODO: implement onPhyUpdate
  }

  @override
  void onReadRemoteRssi(int gattHashCode, int rssi, int status) {
    // TODO: implement onReadRemoteRssi
  }

  @override
  void onReliableWriteCompleted(int gattHashCode, int status) {
    // TODO: implement onReliableWriteCompleted
  }

  @override
  void onServiceChanged(int gattHashCode) {
    // TODO: implement onServiceChanged
  }

  @override
  void onServicesDiscovered(int gattHashCode, int status) {
    // TODO: implement onServicesDiscovered
  }
}
