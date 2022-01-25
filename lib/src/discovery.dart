import 'dart:convert';
import 'dart:typed_data';

import 'uuid.dart';

/// Peripheral discovery.
abstract class Discovery {
  /// The [UUID] of the discovered peripheral.
  UUID get uuid;

  /// The RSSI of the discovered peripheral.
  int get rssi;

  /// The advertisements of the discovered peripheral.
  Map<int, Uint8List> get advertisements;

  /// Indicate whether the discovered peripheral is connectable.
  bool get connectable;
}

/// [Discovery] extensions.
extension DiscoveryX on Discovery {
  /// The name extract form the [advertisements].
  String? get name {
    if (advertisements.containsKey(0x08)) {
      return utf8.decode(advertisements[0x08]!);
    } else if (advertisements.containsKey(0x09)) {
      return utf8.decode(advertisements[0x09]!);
    } else {
      return null;
    }
  }
}
