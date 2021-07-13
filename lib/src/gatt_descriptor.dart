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
  _GattDescriptor(this.id, this.uuid);

  final int id;
  @override
  final UUID uuid;

  @override
  Future<List<int>> read() {
    final message = proto.Message(
      category: proto.MessageCategory.GATT_DESCRIPTOR_READ,
      descriptorReadArguments: proto.GattDescriptorReadArguments(id: id),
    ).writeToBuffer();
    return method.invokeListMethod<int>('', message).then((value) => value!);
  }

  @override
  Future write(List<int> value) {
    final message = proto.Message(
      category: proto.MessageCategory.GATT_DESCRIPTOR_WRITE,
      descriptorWriteArguments: proto.GattDescriptorWriteArguments(
        id: id,
        value: value,
      ),
    ).writeToBuffer();
    return method.invokeMethod('', message);
  }
}
