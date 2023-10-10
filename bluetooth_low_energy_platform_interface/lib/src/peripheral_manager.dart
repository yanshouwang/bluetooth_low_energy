import 'dart:typed_data';

import 'advertise_data.dart';
import 'bluetooth_low_energy.dart';
import 'bluetooth_low_energy_manager.dart';
import 'central.dart';
import 'event_args.dart';
import 'gatt_characteristic.dart';
import 'gatt_service.dart';

/// An object that manages and advertises peripheral services exposed by this app.
abstract class PeripheralManager extends BluetoothLowEnergyManager {
  /// Gets the instance of [PeripheralManager].
  static PeripheralManager get instance =>
      BluetoothLowEnergy.instance.peripheralManager;

  /// Tells that the local peripheral received an Attribute Protocol (ATT) read request for a characteristic with a dynamic value.
  Stream<ReadGattCharacteristicCommandEventArgs>
      get readCharacteristicCommandReceived;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT) write request for a characteristic with a dynamic value.
  Stream<WriteGattCharacteristicCommandEventArgs>
      get writeCharacteristicCommandReceived;

  /// Tells that the peripheral manager received a characteristic’s notify changed.
  Stream<NotifyGattCharacteristicCommandEventArgs>
      get notifyCharacteristicCommandReceived;

  /// Publishes a service and any of its associated characteristics and characteristic descriptors to the local GATT database.
  Future<void> addService(GattService service);

  /// Removes a specified published service from the local GATT database.
  Future<void> removeService(GattService service);

  /// Removes all published services from the local GATT database.
  Future<void> clearServices();

  /// Advertises peripheral manager data.
  Future<void> startAdvertising(AdvertiseData advertiseData);

  /// Stops advertising peripheral manager data.
  Future<void> stopAdvertising();

  /// Gets the maximum amount of data, in bytes, that the central can receive in a
  /// single notification or indication.
  Future<int> getMaximumWriteLength(Central central);

  /// Responds to a read request from a connected central.
  Future<void> sendReadCharacteristicReply(
    Central central,
    GattCharacteristic characteristic,
    int id,
    int offset,
    bool status,
    Uint8List value,
  );

  /// Responds to a write request from a connected central.
  Future<void> sendWriteCharacteristicReply(
    Central central,
    GattCharacteristic characteristic,
    int id,
    int offset,
    bool status,
  );

  /// Send an updated characteristic value to one or more subscribed centrals, using a notification or indication.
  Future<void> notifyCharacteristicValueChanged(
    Central central,
    GattCharacteristic characteristic,
    Uint8List value,
  );
}
