import 'dart:typed_data';

import 'advertise_data.dart';
import 'bluetooth_low_energy_state.dart';
import 'central.dart';
import 'gatt_characteristic.dart';
import 'peripheral.dart';

/// The base event arguments.
abstract class EventArgs {}

/// The bluetooth low energy state changed event arguments.
class BluetoothLowEnergyStateChangedEventArgs extends EventArgs {
  /// The new state of the bluetooth low energy.
  final BluetoothLowEnergyState state;

  /// Constructs a [BluetoothLowEnergyStateChangedEventArgs].
  BluetoothLowEnergyStateChangedEventArgs(this.state);
}

/// The discovered event arguments.
class DiscoveredEventArgs extends EventArgs {
  /// The disvered peripheral.
  final Peripheral peripheral;

  /// The rssi of the peripheral.
  final int rssi;

  /// The advertise data of the peripheral.
  final AdvertiseData advertiseData;

  /// Constructs a [DiscoveredEventArgs].
  DiscoveredEventArgs(this.peripheral, this.rssi, this.advertiseData);
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

class ReadGattCharacteristicCommandEventArgs {
  final Central central;
  final GattCharacteristic characteristic;
  final int id;
  final int offset;

  ReadGattCharacteristicCommandEventArgs(
    this.central,
    this.characteristic,
    this.id,
    this.offset,
  );
}

class WriteGattCharacteristicCommandEventArgs {
  final Central central;
  final GattCharacteristic characteristic;
  final int id;
  final int offset;
  final Uint8List value;

  WriteGattCharacteristicCommandEventArgs(
    this.central,
    this.characteristic,
    this.id,
    this.offset,
    this.value,
  );
}

class NotifyGattCharacteristicCommandEventArgs {
  final Central central;
  final GattCharacteristic characteristic;
  final bool state;

  NotifyGattCharacteristicCommandEventArgs(
    this.central,
    this.characteristic,
    this.state,
  );
}
