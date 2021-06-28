part of bluetooth_low_energy;

abstract class GattDescriptor {
  UUID get uuid;

  Future<List<int>> read();
  Future write(List<int> value);
}

class _GattDescriptor implements GattDescriptor {
  _GattDescriptor(this.device, this.service, this.characteristic, this.uuid);

  final MAC device;
  final UUID service;
  final UUID characteristic;
  @override
  final UUID uuid;

  @override
  Future<List<int>> read() {
    final name = proto.MessageCategory.GATT_DESCRIPTOR_READ.name;
    final arguments = proto.GattDescriptorReadArguments(
      device: device.name,
      service: service.name,
      characteristic: characteristic.name,
      uuid: uuid.name,
    ).writeToBuffer();
    return method
        .invokeListMethod<int>(name, arguments)
        .then((value) => value!);
  }

  @override
  Future write(List<int> value) {
    final name = proto.MessageCategory.GATT_DESCRIPTOR_WRITE.name;
    final arguments = proto.GattDescriptorWriteArguments(
      device: device.name,
      service: service.name,
      characteristic: characteristic.name,
      uuid: uuid.name,
      value: value,
    ).writeToBuffer();
    return method.invokeMethod(name, arguments);
  }
}
