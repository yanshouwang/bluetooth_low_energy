import 'dart:typed_data';

import 'package:log_service/log_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'advertisement.dart';
import 'bluetooth_low_energy_manager.dart';
import 'gatt_characteristic.dart';
import 'gatt_service.dart';
import 'peripheral_event_args.dart';

/// An object that manages and advertises peripheral services exposed by this app.
///
/// Platform-specific implementations should implement this class to support [PeripheralManager].
abstract class PeripheralManager extends PlatformInterface
    with LoggerProvider, LoggerController
    implements BluetoothLowEnergyManager {
  static final Object _token = Object();

  static PeripheralManager? _instance;

  /// The default instance of [PeripheralManager] to use.
  static PeripheralManager get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'PeripheralManager is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PeripheralManager] when
  /// they register themselves.
  static set instance(PeripheralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [PeripheralManager].
  PeripheralManager() : super(token: _token);

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
  ///
  /// The maximum size of the value is 512, all bytes that exceed this size will be discarded.
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
  });
}
