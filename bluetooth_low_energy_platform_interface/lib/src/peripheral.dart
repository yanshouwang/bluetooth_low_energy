import 'uuid.dart';

/// The peripheral.
abstract class Peripheral {
  /// The [UUID] of this peripheral.
  UUID get uuid;
}
