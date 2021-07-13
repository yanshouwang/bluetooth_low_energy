part of bluetooth_low_energy;

/// TO BE DONE.
abstract class GattCharacteristic {
  /// TO BE DONE.
  UUID get uuid;

  /// TO BE DONE.
  Map<UUID, GattDescriptor> get descriptors;

  /// TO BE DONE.
  bool get canRead;

  /// TO BE DONE.
  bool get canWrite;

  /// TO BE DONE.
  bool get canWriteWithoutResponse;

  /// TO BE DONE.
  bool get canNotify;

  /// TO BE DONE.
  Stream<List<int>> get valueChanged;

  /// TO BE DONE.
  Future<List<int>> read();

  /// TO BE DONE.
  Future write(List<int> value, {bool withoutResponse = false});

  /// TO BE DONE.
  Future notify(bool state);
}

class _GattCharacteristic implements GattCharacteristic {
  _GattCharacteristic(
    this.id,
    this.uuid,
    this.descriptors,
    this.canRead,
    this.canWrite,
    this.canWriteWithoutResponse,
    this.canNotify,
  );

  final int id;
  @override
  final UUID uuid;
  @override
  final Map<UUID, GattDescriptor> descriptors;
  @override
  final bool canRead;
  @override
  final bool canWrite;
  @override
  final bool canWriteWithoutResponse;
  @override
  final bool canNotify;

  @override
  Stream<List<int>> get valueChanged => stream
      .where((message) =>
          message.category ==
              proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY &&
          message.characteristicValue.id == id)
      .map((message) => message.characteristicValue.value);

  @override
  Future<List<int>> read() {
    final message = proto.Message(
      category: proto.MessageCategory.GATT_CHARACTERISTIC_READ,
      characteristicReadArguments:
          proto.GattCharacteristicReadArguments(id: id),
    ).writeToBuffer();
    return method.invokeListMethod<int>('', message).then((value) => value!);
  }

  @override
  Future write(List<int> value, {bool withoutResponse = false}) {
    final message = proto.Message(
      category: proto.MessageCategory.GATT_CHARACTERISTIC_WRITE,
      characteristicWriteArguments: proto.GattCharacteristicWriteArguments(
        id: id,
        value: value,
        withoutResponse: withoutResponse,
      ),
    ).writeToBuffer();
    return method.invokeMethod('', message);
  }

  @override
  Future notify(bool state) {
    final message = proto.Message(
      category: proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY,
      characteristicNotifyArguments: proto.GattCharacteristicNotifyArguments(
        id: id,
        state: state,
      ),
    ).writeToBuffer();
    return method.invokeMethod('', message);
  }
}
