import 'dart:typed_data';

import 'advertisement.dart';
import 'central_state.dart';
import 'gatt_characteristic.dart';
import 'peripheral.dart';

/// The base event arguments.
abstract class EventArgs {}

/// The central state changed event arguments.
class CentralStateChangedEventArgs extends EventArgs {
  /// The new state of the central.
  final CentralState state;

  /// Constructs a [CentralStateChangedEventArgs].
  CentralStateChangedEventArgs(this.state);
}

/// The central discovered event arguments.
class CentralDiscoveredEventArgs extends EventArgs {
  /// The disvered peripheral.
  final Peripheral peripheral;

  /// The rssi of the peripheral.
  final int rssi;

  /// The advertisement of the peripheral.
  final Advertisement advertisement;

  /// Constructs a [CentralDiscoveredEventArgs].
  CentralDiscoveredEventArgs(this.peripheral, this.rssi, this.advertisement);
}

/// The peripheral state changed event arguments.
class PeripheralStateChangedEventArgs extends EventArgs {
  /// The peripheral which state is changed.
  final Peripheral peripheral;

  /// The new state of the peripheral.
  final bool state;

  /// Constructs a [PeripheralStateChangedEventArgs].
  PeripheralStateChangedEventArgs(this.peripheral, this.state);
}

/// The GATT characteristic value changed event arguments.
class GattCharacteristicValueChangedEventArgs extends EventArgs {
  /// The GATT characteristic which value is changed.
  final GattCharacteristic characteristic;

  /// The changed value of the characteristic.
  final Uint8List value;

  /// Constructs a [GattCharacteristicValueChangedEventArgs].
  GattCharacteristicValueChangedEventArgs(this.characteristic, this.value);
}
