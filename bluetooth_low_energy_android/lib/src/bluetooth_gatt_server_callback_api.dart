import 'dart:typed_data';

import 'api.g.dart';

class BluetoothGattServerCallbackApi extends BluetoothGattServerCallbackHostApi
    implements BluetoothGattServerCallbackFlutterApi {
  @override
  void onCharacteristicReadRequest(int hashCode, int deviceHashCode,
      int requestId, int offset, int characteristicHashCode) {
    // TODO: implement onCharacteristicReadRequest
  }

  @override
  void onCharacteristicWriteRequest(
      int hashCode,
      int deviceHashCode,
      int requestId,
      int characteristicHashCode,
      bool preparedWrite,
      bool responseNeeded,
      int offset,
      Uint8List value) {
    // TODO: implement onCharacteristicWriteRequest
  }

  @override
  void onConnectionStateChange(
      int hashCode, int deviceHashCode, int status, int newState) {
    // TODO: implement onConnectionStateChange
  }

  @override
  void onDescriptorReadRequest(int hashCode, int deviceHashCode, int requestId,
      int offset, int descriptorHashCode) {
    // TODO: implement onDescriptorReadRequest
  }

  @override
  void onDescriptorWriteRequest(
      int hashCode,
      int deviceHashCode,
      int requestId,
      int descriptorHashCode,
      bool preparedWrite,
      bool responseNeeded,
      int offset,
      Uint8List value) {
    // TODO: implement onDescriptorWriteRequest
  }

  @override
  void onExecuteWrite(
      int hashCode, int deviceHashCode, int requestId, bool execute) {
    // TODO: implement onExecuteWrite
  }

  @override
  void onMtuChanged(int hashCode, int deviceHashCode, int mtu) {
    // TODO: implement onMtuChanged
  }

  @override
  void onNotificationSent(int hashCode, int deviceHashCode, int status) {
    // TODO: implement onNotificationSent
  }

  @override
  void onPhyRead(
      int hashCode, int deviceHashCode, int txPhy, int rxPhy, int status) {
    // TODO: implement onPhyRead
  }

  @override
  void onPhyUpdate(
      int hashCode, int deviceHashCode, int txPhy, int rxPhy, int status) {
    // TODO: implement onPhyUpdate
  }

  @override
  void onServiceAdded(int hashCode, int status, int serviceHashCode) {
    // TODO: implement onServiceAdded
  }
}
