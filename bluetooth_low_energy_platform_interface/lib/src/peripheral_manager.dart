import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'advertisement.dart';
import 'bluetooth_low_energy_manager.dart';
import 'central.dart';
import 'event_args.dart';
import 'gatt.dart';

/// The central connection state cahnged event arguments.
final class CentralConnectionStateChangedEventArgs
    extends ConnectionStateChangedEventArgs {
  /// The central which connection state changed.
  final Central central;

  /// Constructs a [CentralConnectionStateChangedEventArgs].
  CentralConnectionStateChangedEventArgs(
    this.central,
    super.state,
  );
}

/// The central MTU changed event arguments.
final class CentralMTUChangedEventArgs extends MTUChangedEventArgs {
  /// The central which MTU changed.
  final Central central;

  /// Constructs a [CentralMTUChangedEventArgs].
  CentralMTUChangedEventArgs(
    this.central,
    super.mtu,
  );
}

/// The GATT characteristic read requested event arguments.
final class GATTCharacteristicReadRequestedEventArgs extends EventArgs {
  /// The central which read this characteristic.
  final Central central;

  /// The read request.
  final GATTCharacteristicReadRequest request;

  /// Constructs a [GATTCharacteristicReadRequestedEventArgs].
  GATTCharacteristicReadRequestedEventArgs(
    this.central,
    this.request,
  );
}

/// The GATT characteristic write requested event arguments.
final class GATTCharacteristicWriteRequestedEventArgs extends EventArgs {
  /// The central which wrote this characteristic.
  final Central central;

  /// The write request.
  final GATTCharacteristicWriteRequest request;

  /// Constructs a [GATTCharacteristicWriteRequestedEventArgs].
  GATTCharacteristicWriteRequestedEventArgs(
    this.central,
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
  /// The central which read this characteristic.
  final Central central;

  /// The read request.
  final GATTDescriptorReadRequest request;

  /// Constructs a [GATTDescriptorReadRequestedEventArgs].
  GATTDescriptorReadRequestedEventArgs(
    this.central,
    this.request,
  );
}

/// The GATT descriptor write requested event arguments.
final class GATTDescriptorWriteRequestedEventArgs extends EventArgs {
  /// The central which wrote this characteristic.
  final Central central;

  /// The write request.
  final GATTDescriptorWriteRequest request;

  /// Constructs a [GATTDescriptorWriteRequestedEventArgs].
  GATTDescriptorWriteRequestedEventArgs(
    this.central,
    this.request,
  );
}

/// An object that manages and advertises peripheral services exposed by this app.
abstract interface class PeripheralManager
    implements BluetoothLowEnergyManager {
  static PeripheralManager? _instance;

  /// Gets the instance of [PeripheralManager] to use.
  factory PeripheralManager() {
    final instance = PlatformPeripheralManager.instance;
    if (instance != _instance) {
      instance.initialize();
      _instance = instance;
    }
    return instance;
  }

  /// Callback indicating when a remote device has been connected or disconnected.
  ///
  /// This event is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Stream<CentralConnectionStateChangedEventArgs> get connectionStateChanged;

  /// Callback indicating the MTU for a given device connection has changed.
  ///
  /// This callback will be invoked if a remote client has requested to change
  /// the MTU for a given connection.
  ///
  /// This event is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Stream<CentralMTUChangedEventArgs> get mtuChanged;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT)
  /// read request for a characteristic with a dynamic value.
  Stream<GATTCharacteristicReadRequestedEventArgs>
      get characteristicReadRequested;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT)
  /// write request for a characteristic with a dynamic value.
  Stream<GATTCharacteristicWriteRequestedEventArgs>
      get characteristicWriteRequested;

  /// Tells that the peripheral manager received a characteristic’s notify changed.
  Stream<GATTCharacteristicNotifyStateChangedEventArgs>
      get characteristicNotifyStateChanged;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT)
  /// read request for a descriptor with a dynamic value.
  Stream<GATTDescriptorReadRequestedEventArgs> get descriptorReadRequested;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT)
  /// write request for a descriptor with a dynamic value.
  Stream<GATTDescriptorWriteRequestedEventArgs> get descriptorWriteRequested;

  /// Publishes a service and any of its associated characteristics and characteristic
  /// descriptors to the local GATT database.
  Future<void> addService(GATTService service);

  /// Removes a specified published service from the local GATT database.
  Future<void> removeService(GATTService service);

  /// Removes all published services from the local GATT database.
  Future<void> removeAllServices();

  /// Advertises peripheral manager data.
  Future<void> startAdvertising(Advertisement advertisement);

  /// Stops advertising peripheral manager data.
  Future<void> stopAdvertising();

  /// The maximum amount of data, in bytes, that the central can receive in a
  /// single notification or indication.
  Future<void> getMaximumNotifyLength(Central central);

  /// Responds to a read request from a connected central.
  Future<void> respondCharacteristicReadRequestWithValue(
    GATTCharacteristicReadRequest request, {
    required Uint8List value,
  });

  /// Responds to a read request from a connected central.
  Future<void> respondCharacteristicReadRequestWithError(
    GATTCharacteristicReadRequest request, {
    required GATTError error,
  });

  /// Responds to a write request from a connected central.
  Future<void> respondCharacteristicWriteRequest(
    GATTCharacteristicWriteRequest request,
  );

  /// Responds to a write request from a connected central.
  Future<void> respondCharacteristicWriteRequestWithError(
    GATTCharacteristicWriteRequest request, {
    required GATTError error,
  });

  /// Send an updated characteristic value to one or more subscribed centrals,
  /// using a notification or indication.
  ///
  /// [characteristic] The characteristic whose value has changed.
  ///
  /// [value] The characteristic value you want to send via a notification or
  /// indication.
  ///
  /// [central] A list of centrals (represented by CBCentral objects) that have
  /// subscribed to receive updates of the characteristic’s value. If nil, the
  /// manager updates all subscribed centrals. The manager ignores any centrals
  /// that haven’t subscribed to the characteristic’s value.
  Future<void> notifyCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    Central? central,
  });

  /// Responds to a read request from a connected central.
  Future<void> respondDescriptorReadRequestWithValue(
    GATTDescriptorReadRequest request, {
    required Uint8List value,
  });

  /// Responds to a read request from a connected central.
  Future<void> respondDescriptorReadRequestWithError(
    GATTDescriptorReadRequest request, {
    required GATTError error,
  });

  /// Responds to a write request from a connected central.
  Future<void> respondDescriptorWriteRequest(
    GATTDescriptorWriteRequest request,
  );

  /// Responds to a write request from a connected central.
  Future<void> respondDescriptorWriteRequestWithError(
    GATTDescriptorWriteRequest request, {
    required GATTError error,
  });
}

/// Platform-specific implementations should implement this class to support
/// [PlatformPeripheralManager].
abstract base class PlatformPeripheralManager
    extends PlatformBluetoothLowEnergyManager implements PeripheralManager {
  static final Object _token = Object();

  static PlatformPeripheralManager? _instance;

  /// The default instance of [PlatformPeripheralManager] to use.
  static PlatformPeripheralManager get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'PeripheralManager is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PlatformPeripheralManager] when
  /// they register themselves.
  static set instance(PlatformPeripheralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [PlatformPeripheralManager].
  PlatformPeripheralManager() : super(token: _token);
}
