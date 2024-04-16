import 'dart:typed_data';

import 'advertisement.dart';
import 'base_peripheral_manager.dart';
import 'bluetooth_low_energy_manager.dart';
import 'central.dart';
import 'gatt_characteristic.dart';
import 'gatt_characteristic_notify_state_changed_event_args.dart';
import 'gatt_characteristic_read_event_args.dart';
import 'gatt_characteristic_written_event_args.dart';
import 'gatt_service.dart';

/// An object that manages and advertises peripheral services exposed by this app.
abstract interface class PeripheralManager
    implements BluetoothLowEnergyManager {
  static PeripheralManager? _instance;

  /// Gets the instance of [PeripheralManager] to use.
  factory PeripheralManager() {
    final instance = BasePeripheralManager.instance;
    if (instance != _instance) {
      instance.initialize();
      _instance = instance;
    }
    return instance;
  }

  /// Tells that the local peripheral device received an Attribute Protocol (ATT) read request for a characteristic with a dynamic value.
  Stream<GattCharacteristicReadEventArgs> get characteristicRead;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT) write request for a characteristic with a dynamic value.
  Stream<GattCharacteristicWrittenEventArgs> get characteristicWritten;

  /// Tells that the peripheral manager received a characteristic’s notify changed.
  Stream<GattCharacteristicNotifyStateChangedEventArgs>
      get characteristicNotifyStateChanged;

  /// Publishes a service and any of its associated characteristics and characteristic descriptors to the local GATT database.
  Future<void> addService(GattService service);

  /// Removes a specified published service from the local GATT database.
  Future<void> removeService(GattService service);

  /// Removes all published services from the local GATT database.
  Future<void> clearServices();

  /// Advertises peripheral manager data.
  Future<void> startAdvertising(Advertisement advertisement);

  /// Stops advertising peripheral manager data.
  Future<void> stopAdvertising();

  /// Retrieves the value of a specified characteristic.
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic);

  /// Writes the value of a characteristic and sends an updated characteristic value to one or more subscribed centrals, using a notification or indication.
  ///
  /// The maximum size of the value is 512, all bytes that exceed this size will be discarded.
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    Central? central,
  });
}
