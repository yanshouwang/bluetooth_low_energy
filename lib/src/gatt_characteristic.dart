part of bluetooth_low_energy;

abstract class GattCharacteristic {
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
