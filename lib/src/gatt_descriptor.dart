part of bluetooth_low_energy;

/// TO BE DONE.
abstract class GattDescriptor {
  /// TO BE DONE.
  UUID get uuid;

  /// TO BE DONE.
  Future<List<int>> read();

  /// TO BE DONE.
  Future write(List<int> value);
}

class _GattDescriptor implements GattDescriptor {
  _GattDescriptor(
    this.address,
    this.serviceUUID,
    this.characteristicUUID,
    this.id,
    this.uuid,
  );

  final MAC address;
  final UUID serviceUUID;
  final UUID characteristicUUID;
  final int id;
  @override
  final UUID uuid;

  @override
  Future<List<int>> read() {
    final name = proto.MessageCategory.GATT_DESCRIPTOR_READ.name;
    final arguments = proto.GattDescriptorReadArguments(
      address: address.name,
      serviceUuid: serviceUUID.name,
      characteristicUuid: characteristicUUID.name,
      uuid: uuid.name,
      id: id,
    ).writeToBuffer();
    return method
        .invokeListMethod<int>(name, arguments)
        .then((value) => value!);
  }

  @override
  Future write(List<int> value) {
    final name = proto.MessageCategory.GATT_DESCRIPTOR_WRITE.name;
    final arguments = proto.GattDescriptorWriteArguments(
      address: address.name,
      serviceUuid: serviceUUID.name,
      characteristicUuid: characteristicUUID.name,
      uuid: uuid.name,
      id: id,
      value: value,
    ).writeToBuffer();
    return method.invokeMethod(name, arguments);
  }
}
