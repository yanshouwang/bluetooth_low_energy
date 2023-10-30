import 'dart:typed_data';

import 'central.dart';
import 'gatt_characteristic.dart';

/// The read GATT characteristic command event arguments.
class ReadGattCharacteristicCommandEventArgs {
  /// The central which send this read command.
  final Central central;

  /// The GATT characteristic which value is to read.
  final GattCharacteristic characteristic;

  /// The id of this read command.
  final int id;

  /// The offset of this read command.
  final int offset;

  /// Constructs a [ReadGattCharacteristicCommandEventArgs].
  ReadGattCharacteristicCommandEventArgs(
    this.central,
    this.characteristic,
    this.id,
    this.offset,
  );
}

/// The write GATT characteristic command event arguments.
class WriteGattCharacteristicCommandEventArgs {
  /// The central which send this write command.
  final Central central;

  /// The GATT characteristic which value is to write.
  final GattCharacteristic characteristic;

  /// The id of this write command.
  final int id;

  /// The offset of this write command.
  final int offset;

  /// The value of this write command.
  final Uint8List value;

  /// Constructs a [WriteGattCharacteristicCommandEventArgs].
  WriteGattCharacteristicCommandEventArgs(
    this.central,
    this.characteristic,
    this.id,
    this.offset,
    this.value,
  );
}

/// The notify GATT characteristic command event arguments.
class NotifyGattCharacteristicCommandEventArgs {
  /// The central which send this notify command.
  final Central central;

  /// The GATT characteristic which value is to notify.
  final GattCharacteristic characteristic;

  /// The state of this notify command.
  final bool state;

  /// Constructs a [NotifyGattCharacteristicCommandEventArgs].
  NotifyGattCharacteristicCommandEventArgs(
    this.central,
    this.characteristic,
    this.state,
  );
}
