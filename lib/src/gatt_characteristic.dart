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
    this.device,
    this.service,
    this.uuid,
    this.descriptors,
    this.canRead,
    this.canWrite,
    this.canWriteWithoutResponse,
    this.canNotify,
  );

  final MAC device;
  final UUID service;
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
          message.characteristicValue.device.conversionOfMAC == device &&
          message.characteristicValue.service.conversionOfUUID == service &&
          message.characteristicValue.characteristic.conversionOfUUID == uuid)
      .map((message) => message.characteristicValue.value);

  @override
  Future<List<int>> read() {
    final name = proto.MessageCategory.GATT_CHARACTERISTIC_READ.name;
    final arguments = proto.GattCharacteristicReadArguments(
      device: device.name,
      service: service.name,
      characteristic: uuid.name,
    ).writeToBuffer();
    return method
        .invokeListMethod<int>(name, arguments)
        .then((value) => value!);
  }

  @override
  Future write(List<int> value, {bool withoutResponse = false}) {
    final name = proto.MessageCategory.GATT_CHARACTERISTIC_WRITE.name;
    final arguments = proto.GattCharacteristicWriteArguments(
      device: device.name,
      service: service.name,
      characteristic: uuid.name,
      value: value,
      withoutResponse: withoutResponse,
    ).writeToBuffer();
    return method.invokeMethod(name, arguments);
  }

  @override
  Future notify(bool state) {
    final name = proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY.name;
    final arguments = proto.GattCharacteristicNotifyArguments(
      device: device.name,
      service: service.name,
      characteristic: uuid.name,
      state: state,
    ).writeToBuffer();
    return method.invokeMethod(name, arguments);
  }
}
