part of bluetooth_low_energy;

abstract class GattService {
  Future<List<GattCharacteristic>> get characteristics;
}
