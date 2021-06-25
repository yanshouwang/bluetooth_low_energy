part of bluetooth_low_energy;

abstract class GattCharacteristic {
  UUID get uuid;
  List<GattDescriptor> get descriptors;
  bool get canRead;
  bool get canWrite;
  bool get canWriteWithoutResponse;
  bool get canNotify;

  Stream<List<int>> get valueChanged;

  Future<List<int>> read();
  Future write(List<int> value);
  Future writeWithoutResponse(List<int> value);
  Future startNotify();
  Future stopNotify();
}

class _GattCharacteristic implements GattCharacteristic {
  _GattCharacteristic(
    this.uuid,
    this.descriptors,
    this.canRead,
    this.canWrite,
    this.canWriteWithoutResponse,
    this.canNotify,
  );

  @override
  final UUID uuid;
  @override
  final List<GattDescriptor> descriptors;
  @override
  final bool canRead;
  @override
  final bool canWrite;
  @override
  final bool canWriteWithoutResponse;
  @override
  final bool canNotify;

  @override
  // TODO: implement valueChanged
  Stream<List<int>> get valueChanged => throw UnimplementedError();

  @override
  Future<List<int>> read() {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future write(List<int> value) {
    // TODO: implement write
    throw UnimplementedError();
  }

  @override
  Future writeWithoutResponse(List<int> value) {
    // TODO: implement writeWithoutResponse
    throw UnimplementedError();
  }

  @override
  Future startNotify() {
    // TODO: implement startNotify
    throw UnimplementedError();
  }

  @override
  Future stopNotify() {
    // TODO: implement stopNotify
    throw UnimplementedError();
  }
}
