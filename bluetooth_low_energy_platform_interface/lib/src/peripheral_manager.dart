import 'dart:typed_data';

import 'advertisement.dart';
import 'bluetooth_low_energy_manager.dart';
import 'gatt_characteristic.dart';
import 'gatt_service.dart';
import 'my_peripheral_manager.dart';
import 'peripheral_event_args.dart';

/// An object that manages and advertises peripheral services exposed by this app.
abstract class PeripheralManager extends BluetoothLowEnergyManager {
  /// The instance of [PeripheralManger] to use.
  static PeripheralManager get instance => MyPeripheralManager.instance;

  /// Tells that the local peripheral received an Attribute Protocol (ATT) read request for a characteristic with a dynamic value.
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

  /// Sends an updated characteristic value to one or more subscribed centrals, using a notification or indication.
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
  });
}
