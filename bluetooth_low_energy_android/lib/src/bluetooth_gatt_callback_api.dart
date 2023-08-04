import 'api.g.dart';

class BluetoothGattCallbackApi extends BluetoothGattCallbackHostApi
    implements BluetoothGattCallbackFlutterApi {
  @override
  void onCharacteristicChanged(
      int hashCode, int gattHashCode, int characteristicHashCode) {
    // TODO: implement onCharacteristicChanged
  }

  @override
  void onCharacteristicRead(
      int hashCode, int gattHashCode, int characteristicHashCode, int status) {
    // TODO: implement onCharacteristicRead
  }

  @override
  void onCharacteristicWrite(
      int hashCode, int gattHashCode, int characteristicHashCode, int status) {
    // TODO: implement onCharacteristicWrite
  }

  @override
  void onConnectionStateChange(
      int hashCode, int gattHashCode, int status, int newState) {
    // TODO: implement onConnectionStateChange
  }

  @override
  void onConnectionUpdated(int hashCode, int gattHashCode, int interval,
      int latency, int timeout, int status) {
    // TODO: implement onConnectionUpdated
  }

  @override
  void onDescriptorRead(
      int hashCode, int gattHashCode, int descriptorHashCode, int status) {
    // TODO: implement onDescriptorRead
  }

  @override
  void onDescriptorWrite(
      int hashCode, int gattHashCode, int descriptorHashCode, int status) {
    // TODO: implement onDescriptorWrite
  }

  @override
  void onMtuChanged(int hashCode, int gattHashCode, int mtu, int status) {
    // TODO: implement onMtuChanged
  }

  @override
  void onPhyRead(
      int hashCode, int gattHashCode, int txPhy, int rxPhy, int status) {
    // TODO: implement onPhyRead
  }

  @override
  void onPhyUpdate(
      int hashCode, int gattHashCode, int txPhy, int rxPhy, int status) {
    // TODO: implement onPhyUpdate
  }

  @override
  void onReadRemoteRssi(int hashCode, int gattHashCode, int rssi, int status) {
    // TODO: implement onReadRemoteRssi
  }

  @override
  void onReliableWriteCompleted(int hashCode, int gattHashCode, int status) {
    // TODO: implement onReliableWriteCompleted
  }

  @override
  void onServiceChanged(int hashCode, int gattHashCode) {
    // TODO: implement onServiceChanged
  }

  @override
  void onServicesDiscovered(int hashCode, int gattHashCode, int status) {
    // TODO: implement onServicesDiscovered
  }
}
