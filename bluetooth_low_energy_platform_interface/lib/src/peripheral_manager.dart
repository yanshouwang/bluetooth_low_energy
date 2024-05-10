import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'advertisement.dart';
import 'bluetooth_low_energy_manager.dart';
import 'central.dart';
import 'event_args.dart';
import 'gatt.dart';

/// The central MTU changed event arguments.
final class CentralMTUChangedEventArgs extends EventArgs {
  /// The central which MTU changed.
  final Central central;

  /// The MTU.
  final int mtu;

  CentralMTUChangedEventArgs(this.central, this.mtu);
}

/// The GATT characteristic read event arguments.
final class GATTCharacteristicReadEventArgs extends EventArgs {
  /// The central which read this characteristic.
  final Central central;

  /// The GATT characteristic which value is read.
  final GATTCharacteristic characteristic;

  /// The value.
  final Uint8List value;

  /// Constructs a [GATTCharacteristicReadEventArgs].
  GATTCharacteristicReadEventArgs(
    this.central,
    this.characteristic,
    this.value,
  );
}

/// The GATT characteristic written event arguments.
final class GATTCharacteristicWrittenEventArgs extends EventArgs {
  /// The central which wrote this characteristic.
  final Central central;

  /// The GATT characteristic which value is written.
  final GATTCharacteristic characteristic;

  /// The value.
  final Uint8List value;

  /// Constructs a [GATTCharacteristicWrittenEventArgs].
  GATTCharacteristicWrittenEventArgs(
    this.central,
    this.characteristic,
    this.value,
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

  /// Callback indicating the MTU for a given device connection has changed.
  ///
  /// This callback will be invoked if a remote client has requested to change the
  /// MTU for a given connection.
  ///
  /// This event is available on Android, throws [UnsupportedError] on other platforms.
  Stream<CentralMTUChangedEventArgs> get mtuChanged;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT) read request for a characteristic with a dynamic value.
  Stream<GATTCharacteristicReadEventArgs> get characteristicRead;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT) write request for a characteristic with a dynamic value.
  Stream<GATTCharacteristicWrittenEventArgs> get characteristicWritten;

  /// Tells that the peripheral manager received a characteristic’s notify changed.
  Stream<GATTCharacteristicNotifyStateChangedEventArgs>
      get characteristicNotifyStateChanged;

  /// Publishes a service and any of its associated characteristics and characteristic descriptors to the local GATT database.
  Future<void> addService(GATTService service);

  /// Removes a specified published service from the local GATT database.
  Future<void> removeService(GATTService service);

  /// Removes all published services from the local GATT database.
  Future<void> clearServices();

  /// Advertises peripheral manager data.
  Future<void> startAdvertising(Advertisement advertisement);

  /// Stops advertising peripheral manager data.
  Future<void> stopAdvertising();

  /// Retrieves the value of a specified characteristic.
  Future<Uint8List> readCharacteristic(GATTCharacteristic characteristic);

  /// Writes the value of a characteristic and sends an updated characteristic value to one or more subscribed centrals, using a notification or indication.
  ///
  /// The maximum size of the value is 512, all bytes that exceed this size will be discarded.
  Future<void> writeCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
  });

  /// Notifies an updated characteristic value to one or more subscribed centrals, using a notification or indication.
  ///
  /// The maximum size of the value is 512, all bytes that exceed this size will be discarded.
  Future<void> notifyCharacteristic(
    GATTCharacteristic characteristic, {
    List<Central>? centrals,
  });
}

/// Platform-specific implementations should implement this class to support [BasePeripheralManager].
abstract base class BasePeripheralManager extends BaseBluetoothLowEnergyManager
    implements PeripheralManager {
  static final Object _token = Object();

  static BasePeripheralManager? _instance;

  /// The default instance of [BasePeripheralManager] to use.
  static BasePeripheralManager get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'PeripheralManager is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BasePeripheralManager] when
  /// they register themselves.
  static set instance(BasePeripheralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [BasePeripheralManager].
  BasePeripheralManager() : super(token: _token);
}
