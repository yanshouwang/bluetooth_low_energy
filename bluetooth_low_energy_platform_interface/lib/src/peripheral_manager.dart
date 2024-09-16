import 'dart:typed_data';

import 'advertisement.dart';
import 'bluetooth_low_energy_manager.dart';
import 'bluetooth_low_energy_plugin.dart';
import 'central.dart';
import 'connection_state.dart';
import 'event_args.dart';
import 'gatt.dart';

/// The central connection state cahnged event arguments.
final class CentralConnectionStateChangedEventArgs extends EventArgs {
  /// The central which connection state changed.
  final Central central;

  /// The connection state.
  final ConnectionState state;

  /// Constructs a [CentralConnectionStateChangedEventArgs].
  CentralConnectionStateChangedEventArgs(this.central, this.state);
}

/// The central MTU changed event arguments.
final class CentralMTUChangedEventArgs extends EventArgs {
  /// The central which MTU changed.
  final Central central;

  /// The MTU.
  final int mtu;

  /// Constructs a [CentralMTUChangedEventArgs].
  CentralMTUChangedEventArgs(this.central, this.mtu);
}

/// The GATT characteristic read requested event arguments.
final class GATTCharacteristicReadRequestedEventArgs extends EventArgs {
  /// The characteristic to read the value of.
  final GATTCharacteristic characteristic;

  /// The remote central device that originated the request.
  final Central central;

  /// The read request.
  final GATTReadRequest request;

  /// Constructs a [GATTCharacteristicReadRequestedEventArgs].
  GATTCharacteristicReadRequestedEventArgs(
      this.characteristic, this.central, this.request);
}

/// The GATT characteristic write requested event arguments.
final class GATTCharacteristicWriteRequestedEventArgs extends EventArgs {
  /// The characteristic to write the value of.
  final GATTCharacteristic characteristic;

  /// The remote central device that originated the request.
  final Central central;

  /// The write request.
  final GATTWriteRequest request;

  /// Constructs a [GATTCharacteristicWriteRequestedEventArgs].
  GATTCharacteristicWriteRequestedEventArgs(
      this.characteristic, this.central, this.request);
}

/// The GATT characteristic notify state changed event arguments.
final class GATTCharacteristicNotifyStateChangedEventArgs extends EventArgs {
  /// The GATT characteristic which notify state changed.
  final GATTCharacteristic characteristic;

  /// The remote central device that subscribed to the characteristic’s value.
  final Central central;

  /// The notify state.
  final bool state;

  /// Constructs a [GATTCharacteristicNotifyStateChangedEventArgs].
  GATTCharacteristicNotifyStateChangedEventArgs(
      this.characteristic, this.central, this.state);
}

/// The GATT descriptor read requested event arguments.
final class GATTDescriptorReadRequestedEventArgs extends EventArgs {
  /// The descriptor to read the value of.
  final GATTDescriptor descriptor;

  /// The remote central device that originated the request.
  final Central central;

  /// The read request.
  final GATTReadRequest request;

  /// Constructs a [GATTDescriptorReadRequestedEventArgs].
  GATTDescriptorReadRequestedEventArgs(
      this.descriptor, this.central, this.request);
}

/// The GATT descriptor write requested event arguments.
final class GATTDescriptorWriteRequestedEventArgs extends EventArgs {
  /// The descriptor to write the value of.
  final GATTDescriptor descriptor;

  /// The remote central device that originated the request.
  final Central central;

  /// The write request.
  final GATTWriteRequest request;

  /// Constructs a [GATTDescriptorWriteRequestedEventArgs].
  GATTDescriptorWriteRequestedEventArgs(
      this.descriptor, this.central, this.request);
}

/// An object that manages and advertises peripheral services exposed by this app.
abstract interface class PeripheralManager
    implements BluetoothLowEnergyManager {
  /// Gets the instance of [PeripheralManager] to use.
  factory PeripheralManager() {
    return BluetoothLowEnergyPlugin.instance.createPeripheralManager();
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
  ///
  /// [includeDeviceName] Set whether the device name should be included in advertise
  /// packet. this argument is available on Android, throws [UnsupportedError] on
  /// other platforms.
  ///
  /// [includeTXPowerLevel] Whether the transmission power level should be included
  /// in the advertise packet. TX power level field takes 3 bytes in advertise
  /// packet. This argument is available on Android, throws [UnsupportedError] on
  /// other platforms.
  Future<void> startAdvertising(
    Advertisement advertisement, {
    bool? includeDeviceName,
    bool? includeTXPowerLevel,
  });

  /// Stops advertising peripheral manager data.
  Future<void> stopAdvertising();

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
  /// [characteristic] The characteristic whose value has changed.
  ///
  /// [value] The characteristic value you want to send via a notification or
  /// indication.
  ///
  /// [centrals] A central (represented by CBCentral objects) that have subscribed
  /// to receive updates of the characteristic’s value. The manager ignores any
  /// centrals that haven’t subscribed to the characteristic’s value.
  Future<void> notifyCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    List<Central>? centrals,
  });
}
