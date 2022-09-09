import 'bluetooth_low_energy_impl.dart';

abstract class UUID {
  factory UUID(String value) => MyUUID(value);
}
