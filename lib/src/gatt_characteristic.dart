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
    this.address,
    this.serviceUUID,
    this.id,
    this.uuid,
    this.descriptors,
    this.canRead,
    this.canWrite,
    this.canWriteWithoutResponse,
    this.canNotify,
  );

  final MAC address;
  final UUID serviceUUID;
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
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category ==
              proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY &&
          message.characteristicValue.id == id)
      .map((message) => message.characteristicValue.value);

  @override
  Future<List<int>> read() {
    final name = proto.MessageCategory.GATT_CHARACTERISTIC_READ.name;
    final arguments = proto.GattCharacteristicReadArguments(
      address: address.name,
      serviceUuid: serviceUUID.name,
      uuid: uuid.name,
      id: id,
    ).writeToBuffer();
    return method
        .invokeListMethod<int>(name, arguments)
        .then((value) => value!);
  }

  @override
  Future write(List<int> value, {bool withoutResponse = false}) {
    final name = proto.MessageCategory.GATT_CHARACTERISTIC_WRITE.name;
    final arguments = proto.GattCharacteristicWriteArguments(
      address: address.name,
      serviceUuid: serviceUUID.name,
      uuid: uuid.name,
      id: id,
      value: value,
      withoutResponse: withoutResponse,
    ).writeToBuffer();
    return method.invokeMethod(name, arguments);
  }

  @override
  Future notify(bool state) {
    final name = proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY.name;
    final arguments = proto.GattCharacteristicNotifyArguments(
      address: address.name,
      serviceUuid: serviceUUID.name,
      uuid: uuid.name,
      id: id,
      state: state,
    ).writeToBuffer();
    return method.invokeMethod(name, arguments);
  }
}
