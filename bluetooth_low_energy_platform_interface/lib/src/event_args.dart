import 'dart:typed_data';

import 'advertisement.dart';
import 'bluetooth_low_energy_state.dart';
import 'central.dart';
import 'connection_state.dart';
import 'gatt.dart';
import 'peripheral.dart';

/// The base event arguments.
base class EventArgs {}

/// The bluetooth low energy state changed event arguments.
final class BluetoothLowEnergyStateChangedEventArgs extends EventArgs {
  /// The new state of the bluetooth low energy.
  final BluetoothLowEnergyState state;

  /// Constructs a [BluetoothLowEnergyStateChangedEventArgs].
  BluetoothLowEnergyStateChangedEventArgs(this.state);
}

/// The discovered event arguments.
final class DiscoveredEventArgs extends EventArgs {
  /// The disvered peripheral.
  final Peripheral peripheral;

  /// The rssi of the peripheral.
  final int rssi;

  /// The advertisement of the peripheral.
  final Advertisement advertisement;

  /// Constructs a [DiscoveredEventArgs].
  DiscoveredEventArgs(this.peripheral, this.rssi, this.advertisement);
}

/// The peripheral connection state cahnged event arguments.
final class PeripheralConnectionStateChangedEventArgs extends EventArgs {
  /// The peripheral which connection state changed.
  final Peripheral peripheral;

  /// The connection state.
  final ConnectionState state;

  /// Constructs a [PeripheralConnectionStateChangedEventArgs].
  PeripheralConnectionStateChangedEventArgs(this.peripheral, this.state);
}

/// The peripheral MTU changed event arguments.
final class PeripheralMTUChangedEventArgs extends EventArgs {
  /// The peripheral which MTU changed.
  final Peripheral peripheral;

  /// The MTU.
  final int mtu;

  /// Constructs a [PeripheralMTUChangedEventArgs].
  PeripheralMTUChangedEventArgs(this.peripheral, this.mtu);
}

/// The GATT characteristic notified event arguments.
final class GATTCharacteristicNotifiedEventArgs extends EventArgs {
  /// The peripheral which notified.
  final Peripheral peripheral;

  /// The GATT characteristic which notified.
  final GATTCharacteristic characteristic;

  /// The notified value.
  final Uint8List value;

  /// Constructs a [GATTCharacteristicNotifiedEventArgs].
  GATTCharacteristicNotifiedEventArgs(
    this.peripheral,
    this.characteristic,
    this.value,
  );
}

/// The central connection state cahnged event arguments.
final class CentralConnectionStateChangedEventArgs extends EventArgs {
  /// The central which connection state changed.
  final Central central;

  /// The connection state.
  final ConnectionState state;

  /// Constructs a [CentralConnectionStateChangedEventArgs].
  CentralConnectionStateChangedEventArgs(this.central, this.state);
}

/// The central MTU changed event arguments.
final class CentralMTUChangedEventArgs extends EventArgs {
  /// The central which MTU changed.
  final Central central;

  /// The MTU.
  final int mtu;

  /// Constructs a [CentralMTUChangedEventArgs].
  CentralMTUChangedEventArgs(this.central, this.mtu);
}

/// The GATT characteristic read requested event arguments.
final class GATTCharacteristicReadRequestedEventArgs extends EventArgs {
  /// The central which read this characteristic.
  final Central central;

  /// The characteristic to read the value of.
  final GATTCharacteristic characteristic;

  /// The read request.
  final GATTReadRequest request;

  /// Constructs a [GATTCharacteristicReadRequestedEventArgs].
  GATTCharacteristicReadRequestedEventArgs(
    this.central,
    this.characteristic,
    this.request,
  );
}

/// The GATT characteristic write requested event arguments.
final class GATTCharacteristicWriteRequestedEventArgs extends EventArgs {
  /// The central which wrote this characteristic.
  final Central central;

  /// The characteristic to write the value of.
  final GATTCharacteristic characteristic;

  /// The write request.
  final GATTWriteRequest request;

  /// Constructs a [GATTCharacteristicWriteRequestedEventArgs].
  GATTCharacteristicWriteRequestedEventArgs(
    this.central,
    this.characteristic,
    this.request,
  );
}

/// The GATT characteristic notify state changed event arguments.
final class GATTCharacteristicNotifyStateChangedEventArgs extends EventArgs {
  /// The central which set this notify state.
  final Central central;

  /// The GATT characteristic which notify state changed.
  final GATTCharacteristic characteristic;

  /// The notify state.
  final bool state;

  /// Constructs a [GATTCharacteristicNotifyStateChangedEventArgs].
  GATTCharacteristicNotifyStateChangedEventArgs(
    this.central,
    this.characteristic,
    this.state,
  );
}

/// The GATT descriptor read requested event arguments.
final class GATTDescriptorReadRequestedEventArgs extends EventArgs {
  /// The central which read this descriptor.
  final Central central;

  /// The descriptor to read the value of.
  final GATTDescriptor descriptor;

  /// The read request.
  final GATTReadRequest request;

  /// Constructs a [GATTDescriptorReadRequestedEventArgs].
  GATTDescriptorReadRequestedEventArgs(
    this.central,
    this.descriptor,
    this.request,
  );
}

/// The GATT descriptor write requested event arguments.
final class GATTDescriptorWriteRequestedEventArgs extends EventArgs {
  /// The central which wrote this descriptor.
  final Central central;

  /// The descriptor to write the value of.
  final GATTDescriptor descriptor;

  /// The write request.
  final GATTWriteRequest request;

  /// Constructs a [GATTDescriptorWriteRequestedEventArgs].
  GATTDescriptorWriteRequestedEventArgs(
    this.central,
    this.descriptor,
    this.request,
  );
}
