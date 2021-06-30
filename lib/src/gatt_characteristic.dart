part of bluetooth_low_energy;

abstract class GattCharacteristic {
  UUID get uuid;
  Map<UUID, GattDescriptor> get descriptors;
  bool get canRead;
  bool get canWrite;
  bool get canWriteWithoutResponse;
  bool get canNotify;

  Stream<List<int>> get valueChanged;

  Future<List<int>> read();
  Future write(List<int> value, {bool withoutResponse = false});
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
