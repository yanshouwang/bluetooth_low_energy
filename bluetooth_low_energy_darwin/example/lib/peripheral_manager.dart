import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart'
    as inner;

import 'types.dart';

/// An object that manages and advertises peripheral services exposed by this app.
abstract class PeripheralManager {
  static inner.PeripheralManager get _manager =>
      inner.PeripheralManager.instance;

  /// The current state of the peripheral manager.
  static BluetoothLowEnergyState get state => _manager.state;

  /// Tells the peripheral manager’s state updated.
  static Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _manager.stateChanged;

  /// Sets up the peripheral manager.
  static Future<void> setUp() => _manager.setUp();

  /// Tells that the local peripheral received an Attribute Protocol (ATT) read request for a characteristic with a dynamic value.
  static Stream<ReadGattCharacteristicCommandEventArgs>
      get readCharacteristicCommandReceived =>
          _manager.readCharacteristicCommandReceived;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT) write request for a characteristic with a dynamic value.
  static Stream<WriteGattCharacteristicCommandEventArgs>
      get writeCharacteristicCommandReceived =>
          _manager.writeCharacteristicCommandReceived;

  /// Tells that the peripheral manager received a characteristic’s notify changed.
  static Stream<NotifyGattCharacteristicCommandEventArgs>
      get notifyCharacteristicCommandReceived =>
          _manager.notifyCharacteristicCommandReceived;

  /// Publishes a service and any of its associated characteristics and characteristic descriptors to the local GATT database.
  static Future<void> addService(GattService service) =>
      _manager.addService(service);

  /// Removes a specified published service from the local GATT database.
  static Future<void> removeService(GattService service) =>
      _manager.removeService(service);

  /// Removes all published services from the local GATT database.
  static Future<void> clearServices() => _manager.clearServices();

  /// Advertises peripheral manager data.
  static Future<void> startAdvertising(Advertisement advertisement) =>
      _manager.startAdvertising(advertisement);

  /// Stops advertising peripheral manager data.
  static Future<void> stopAdvertising() => _manager.stopAdvertising();

  /// Gets the maximum amount of data, in bytes, that the central can receive in a
  /// single notification or indication.
  static Future<int> getMaximumWriteLength(Central central) =>
      _manager.getMaximumWriteLength(central);

  /// Responds to a read request from a connected central.
  static Future<void> sendReadCharacteristicReply(
    Central central, {
    required GattCharacteristic characteristic,
    required int id,
    required int offset,
    required bool status,
    required Uint8List value,
  }) =>
      _manager.sendReadCharacteristicReply(
        central,
        characteristic: characteristic,
        id: id,
        offset: offset,
        status: status,
        value: value,
      );

  /// Responds to a write request from a connected central.
  static Future<void> sendWriteCharacteristicReply(
    Central central, {
    required GattCharacteristic characteristic,
    required int id,
    required int offset,
    required bool status,
  }) =>
      _manager.sendWriteCharacteristicReply(
        central,
        characteristic: characteristic,
        id: id,
        offset: offset,
        status: status,
      );

  /// Send an updated characteristic value to one or more subscribed centrals, using a notification or indication.
  static Future<void> notifyCharacteristicValueChanged(
    Central central, {
    required GattCharacteristic characteristic,
    required Uint8List value,
  }) =>
      _manager.notifyCharacteristicValueChanged(
        central,
        characteristic: characteristic,
        value: value,
      );
}
