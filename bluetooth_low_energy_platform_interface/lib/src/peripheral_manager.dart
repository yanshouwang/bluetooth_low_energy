import 'dart:typed_data';

import 'package:hybrid_core/hybrid_core.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'common.dart';

/// Platform-specific implementations should implement this class to support [PeripheralManagerImpl].
abstract base class PeripheralManagerImpl extends PlatformInterface
    with LoggerProvider, LoggerController
    implements PeripheralManager {
  static final Object _token = Object();

  static PeripheralManagerImpl? _instance;

  /// The default instance of [PeripheralManagerImpl] to use.
  static PeripheralManagerImpl get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'PeripheralManager is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PeripheralManagerImpl] when
  /// they register themselves.
  static set instance(PeripheralManagerImpl instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [PeripheralManagerImpl].
  PeripheralManagerImpl() : super(token: _token);
}

/// An object that manages and advertises peripheral services exposed by this app.
abstract interface class PeripheralManager
    implements BluetoothLowEnergyManager {
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

/// A remote device connected to a local app, which is acting as a peripheral.
abstract interface class Central implements BluetoothLowEnergyPeer {}

base class CentralImpl extends BluetoothLowEnergyPeerImpl implements Central {
  CentralImpl({
    required super.uuid,
  });

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Central && other.uuid == uuid;
  }
}

/// The GATT characteristic written event arguments.
class GattCharacteristicReadEventArgs {
  /// The central which read this characteristic.
  final Central central;

  /// The GATT characteristic which value is read.
  final GattCharacteristic characteristic;

  /// The value.
  final Uint8List value;

  /// Constructs a [GattCharacteristicReadEventArgs].
  GattCharacteristicReadEventArgs(
    this.central,
    this.characteristic,
    this.value,
  );
}

/// The GATT characteristic written event arguments.
class GattCharacteristicWrittenEventArgs {
  /// The central which wrote this characteristic.
  final Central central;

  /// The GATT characteristic which value is written.
  final GattCharacteristic characteristic;

  /// The value.
  final Uint8List value;

  /// Constructs a [GattCharacteristicWrittenEventArgs].
  GattCharacteristicWrittenEventArgs(
    this.central,
    this.characteristic,
    this.value,
  );
}

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
