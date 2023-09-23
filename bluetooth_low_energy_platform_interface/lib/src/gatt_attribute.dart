import 'uuid.dart';

/// A representation of common aspects of services offered by a peripheral.
abstract class GattAttribute {
  /// The Bluetooth-specific UUID of the attribute.
  UUID get uuid;
}
