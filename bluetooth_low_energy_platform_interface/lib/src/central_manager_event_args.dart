import 'dart:typed_data';

import 'advertise_data.dart';
import 'event_args.dart';
import 'gatt_characteristic.dart';
import 'peripheral.dart';

/// The discovered event arguments.
class DiscoveredEventArgs extends EventArgs {
  /// The disvered peripheral.
  final Peripheral peripheral;

  /// The rssi of the peripheral.
  final int rssi;

  /// The advertise data of the peripheral.
  final AdvertiseData data;

  /// Constructs a [DiscoveredEventArgs].
  DiscoveredEventArgs(this.peripheral, this.rssi, this.data);
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
