import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'advertisement.dart';
import 'bluetooth_low_energy_manager.dart';
import 'central.dart';
import 'event_args.dart';
import 'gatt.dart';

/// An object that manages and advertises peripheral services exposed by this app.
abstract interface class PeripheralManager
    implements BluetoothLowEnergyManager {
  static PeripheralManager? _instance;

  /// Gets the instance of [PeripheralManager] to use.
  factory PeripheralManager() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = PeripheralManagerChannel.instance.create();
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
  /// This event is available on Android and Windows, throws [UnsupportedError]
  /// on other platforms.
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
  ///
  /// This event is available on Android and Windows, throws [UnsupportedError]
  /// on other platforms.
  Stream<GATTDescriptorReadRequestedEventArgs> get descriptorReadRequested;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT)
  /// write request for a descriptor with a dynamic value.
  ///
  /// This event is available on Android and Windows, throws [UnsupportedError]
  /// on other platforms.
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

  /// Get a central object for the given bluetooth hardware address.
  ///
  /// This method is available on Android, throws [UnsupportedError] on other platforms.
  Future<Central> getCentral(String address);

  /// Returns a list of the centrals connected to the system.
  ///
  /// This method is available on Android, throws [UnsupportedError] on other platforms.
  Future<List<Central>> retrieveConnectedCentrals();

  /// Disconnects a connected central.
  ///
  /// This method is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Future<void> disconnect(Central central);

  /// The maximum amount of data, in bytes, that the central can receive in a
  /// single notification or indication.
  Future<int> getMaximumNotifyLength(Central central);

  /// Responds to a read request from a connected central.
  Future<void> respondReadRequestWithValue(
    GATTReadRequest request, {
    required Uint8List value,
  });

  /// Responds to a read request from a connected central.
  Future<void> respondReadRequestWithError(
    GATTReadRequest request, {
    required GATTError error,
  });

  /// Responds to a write request from a connected central.
  Future<void> respondWriteRequest(GATTWriteRequest request);

  /// Responds to a write request from a connected central.
  Future<void> respondWriteRequestWithError(
    GATTWriteRequest request, {
    required GATTError error,
  });

  /// Send an updated characteristic value to one or more subscribed centrals,
  /// using a notification or indication.
  ///
  /// [central] A central (represented by CBCentral objects) that have subscribed
  /// to receive updates of the characteristic’s value. The manager ignores any
  /// centrals that haven’t subscribed to the characteristic’s value.
  ///
  /// [characteristic] The characteristic whose value has changed.
  ///
  /// [value] The characteristic value you want to send via a notification or
  /// indication.
  Future<void> notifyCharacteristic(
    Central central,
    GATTCharacteristic characteristic, {
    required Uint8List value,
  });
}

/// Platform-specific implementations should implement this class to support
/// [PeripheralManagerChannel].
abstract base class PeripheralManagerChannel extends PlatformInterface {
  static final Object _token = Object();

  static PeripheralManagerChannel? _instance;

  /// The default instance of [PeripheralManagerChannel] to use.
  static PeripheralManagerChannel get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
        'PeripheralManager is not implemented on this platform.',
      );
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PeripheralManagerChannel] when
  /// they register themselves.
  static set instance(PeripheralManagerChannel instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [PeripheralManagerChannel].
  PeripheralManagerChannel() : super(token: _token);

  PeripheralManager create();
}
