import 'dart:typed_data';

import 'advertisement.dart';
import 'bluetooth_low_energy_manager.dart';
import 'bluetooth_low_energy_plugin.dart';
import 'connection_priority.dart';
import 'connection_state.dart';
import 'gatt.dart';
import 'peripheral.dart';
import 'uuid.dart';

/// The discovered event.
final class DiscoveredEvent {
  /// The disvered peripheral.
  final Peripheral peripheral;

  /// The rssi of the peripheral.
  final int rssi;

  /// The advertisement of the peripheral.
  final Advertisement advertisement;

  /// Constructs a [DiscoveredEvent].
  DiscoveredEvent(this.peripheral, this.rssi, this.advertisement);
}

/// The peripheral connection state cahnged event.
final class PeripheralConnectionStateChangedEvent {
  /// The peripheral which connection state changed.
  final Peripheral peripheral;

  /// The connection state.
  final ConnectionState state;

  /// Constructs a [PeripheralConnectionStateChangedEvent].
  PeripheralConnectionStateChangedEvent(this.peripheral, this.state);
}

/// The peripheral MTU changed event.
final class PeripheralMTUChangedEvent {
  /// The peripheral which MTU changed.
  final Peripheral peripheral;

  /// The MTU.
  final int mtu;

  /// Constructs a [PeripheralMTUChangedEvent].
  PeripheralMTUChangedEvent(this.peripheral, this.mtu);
}

/// The GATT characteristic notified event.
final class GATTCharacteristicNotifiedEvent {
  /// The GATT characteristic which notified.
  final GATTCharacteristic characteristic;

  /// The notified value.
  final Uint8List value;

  /// Constructs a [GATTCharacteristicNotifiedEvent].
  GATTCharacteristicNotifiedEvent(this.characteristic, this.value);
}

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract base class CentralManager extends BluetoothLowEnergyManager {
  CentralManager.impl() : super.impl();

  /// Gets the instance of [CentralManager] to use.
  factory CentralManager() {
    return BluetoothLowEnergyPlugin.instance.newCentralManager();
  }

  /// Tells the central manager discovered a peripheral while scanning for devices.
  Stream<DiscoveredEvent> get discovered;

  /// Tells that retrieving the specified peripheral's connection state changed.
  Stream<PeripheralConnectionStateChangedEvent> get connectionStateChanged;

  /// Callback indicating the MTU for a given device connection has changed.
  ///
  /// This callback is triggered in response to the BluetoothGatt#requestMtu
  /// function, or in response to a connection event.
  ///
  /// This event is available on Android and Windows, throws [UnsupportedError]
  /// on other platforms.
  Stream<PeripheralMTUChangedEvent> get mtuChanged;

  /// Tells that retrieving the specified characteristic’s value changed.
  Stream<GATTCharacteristicNotifiedEvent> get characteristicNotified;

  /// Scans for peripherals that are advertising services.
  ///
  /// The [serviceUUIDs] argument is an array of [UUID] objects that the app is
  /// interested in. Each [UUID] object represents the [UUID] of a service that
  /// a peripheral advertises.
  Future<void> startDiscovery({
    List<UUID>? serviceUUIDs,
  });

  /// Asks the central manager to stop scanning for peripherals.
  Future<void> stopDiscovery();

  /// Returns a list of the peripherals connected to the system.
  ///
  /// This method is available on Android, iOS, macOS and Linux, throws
  /// [UnsupportedError] on other platforms.
  Future<List<Peripheral>> retrieveConnectedPeripherals();

  /// Establishes a local connection to a peripheral.
  Future<void> connect(Peripheral peripheral);

  /// Cancels an active or pending local connection to a peripheral.
  Future<void> disconnect(Peripheral peripheral);

  /// Request an MTU size used for a given connection. Please note that starting
  /// from Android 14, the Android Bluetooth stack requests the BLE ATT MTU to
  /// 517 bytes when the first GATT client requests an MTU, and disregards all
  /// subsequent MTU requests. Check out [MTU is set to 517 for the first GATT
  /// client requesting an MTU](https://developer.android.com/about/versions/14/behavior-changes-all#mtu-set-to-517)
  /// for more information.
  ///
  /// This method is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Future<int> requestMTU(
    Peripheral peripheral, {
    required int mtu,
  });

  /// Request a connection parameter update.
  ///
  /// This function will send a connection parameter update request to the remote
  /// device.
  ///
  /// For apps targeting Build.VERSION_CODES#S or or higher, this requires the
  /// Manifest.permission#BLUETOOTH_CONNECT permission which can be gained with
  /// Activity.requestPermissions(String[], int).
  ///
  /// Requires Manifest.permission.BLUETOOTH_CONNECT
  ///
  /// This method is available on Android, throws [UnsupportedError] on other
  /// platforms.
  Future<void> requestConnectionPriority(
    Peripheral peripheral, {
    required ConnectionPriority priority,
  });

  /// The maximum amount of data, in bytes, you can send to a characteristic in
  /// a single write type.
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GATTCharacteristicWriteType type,
  });

  /// Retrieves the current RSSI value for the peripheral while connected to the
  /// central manager.
  ///
  /// This method is available on Android, iOS, macOS and Linux, throws
  /// [UnsupportedError] on other platforms.
  Future<int> readRSSI(Peripheral peripheral);

  /// Discovers the GATT services, characteristics and descriptors of the peripheral.
  Future<List<GATTService>> discoverServices(Peripheral peripheral);

  /// Retrieves the value of a specified characteristic.
  Future<Uint8List> readCharacteristic(GATTCharacteristic characteristic);

  /// Writes the value of a characteristic.
  Future<void> writeCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  });

  /// Sets notifications or indications for the value of a specified characteristic.
  Future<void> setCharacteristicNotifyState(
    GATTCharacteristic characteristic, {
    required bool state,
  });

  /// Retrieves the value of a specified characteristic descriptor.
  Future<Uint8List> readDescriptor(GATTDescriptor descriptor);

  /// Writes the value of a characteristic descriptor.
  Future<void> writeDescriptor(
    GATTDescriptor descriptor, {
    required Uint8List value,
  });
}
