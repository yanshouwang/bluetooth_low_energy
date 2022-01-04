import 'gatt_characteristic.dart';
import 'uuid.dart';

/// The GATT service.
abstract class GattService {
  /// The uuid of this [GattService].
  UUID get uuid;

  /// The characteristics of this [GattService].
  Map<UUID, GattCharacteristic> get characteristics;
}
