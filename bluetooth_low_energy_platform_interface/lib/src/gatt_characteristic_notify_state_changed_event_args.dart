import 'central.dart';
import 'gatt_characteristic.dart';

/// The GATT characteristic notify state changed event arguments.
class GattCharacteristicNotifyStateChangedEventArgs {
  /// The central which set this notify state.
  final Central central;

  /// The GATT characteristic which notify state changed.
  final GattCharacteristic characteristic;

  /// The notify state.
  final bool state;

  /// Constructs a [GattCharacteristicNotifyStateChangedEventArgs].
  GattCharacteristicNotifyStateChangedEventArgs(
    this.central,
    this.characteristic,
    this.state,
  );
}
