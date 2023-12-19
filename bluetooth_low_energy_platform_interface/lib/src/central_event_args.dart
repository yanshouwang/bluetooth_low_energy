import 'dart:typed_data';

import 'advertisement.dart';
import 'event_args.dart';
import 'gatt_characteristic.dart';
import 'peripheral.dart';

/// The discovered event arguments.
class DiscoveredEventArgs extends EventArgs {
  /// The disvered peripheral.
  final Peripheral peripheral;

  /// The rssi of the peripheral.
  final int rssi;

  /// The advertisement of the peripheral.
  final Advertisement advertisement;

  /// Constructs a [DiscoveredEventArgs].
  DiscoveredEventArgs(this.peripheral, this.rssi, this.advertisement);
}

/// The connection state cahnged event arguments.
class ConnectionStateChangedEventArgs extends EventArgs {
  /// The peripheral which connection state changed.
  final Peripheral peripheral;

  /// The connection state.
  final bool connectionState;

  /// Constructs a [ConnectionStateChangedEventArgs].
  ConnectionStateChangedEventArgs(
    this.peripheral,
    this.connectionState,
  );
}

/// The GATT characteristic notified event arguments.
class GattCharacteristicNotifiedEventArgs extends EventArgs {
  /// The GATT characteristic which notified.
  final GattCharacteristic characteristic;

  /// The notified value.
  final Uint8List value;

  /// Constructs a [GattCharacteristicNotifiedEventArgs].
  GattCharacteristicNotifiedEventArgs(
    this.characteristic,
    this.value,
  );
}
