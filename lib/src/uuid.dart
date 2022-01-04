import 'dart:typed_data';

import 'bluetooth_implementation.dart';

/// A universally unique identifier, as defined by bluetooth standards.
abstract class UUID {
  /// The value of this [UUID].
  Uint8List get value;

  /// The name of this [UUID].
  String get name;

  /// Create an [UUID] from a [String].
  factory UUID(String uuidString) => $UUID(uuidString);
}
