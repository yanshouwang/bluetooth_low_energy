import 'dart:typed_data';

import 'base_central_manager.dart';
import 'bluetooth_low_energy_manager.dart';
import 'connection_state_changed_event_args.dart';
import 'discovered_event_args.dart';
import 'gatt_characteristic.dart';
import 'gatt_characteristic_notified_event_args.dart';
import 'gatt_characteristic_write_type.dart';
import 'gatt_descriptor.dart';
import 'gatt_service.dart';
import 'peripheral.dart';
import 'uuid.dart';

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract interface class CentralManager implements BluetoothLowEnergyManager {
  static CentralManager? _instance;

  /// Gets the instance of [CentralManager] to use.
  factory CentralManager() {
    final instance = BaseCentralManager.instance;
    if (instance != _instance) {
      instance.initialize();
      _instance = instance;
    }
    return instance;
  }

  /// Tells the central manager discovered a peripheral while scanning for devices.
  Stream<DiscoveredEventArgs> get discovered;

  /// Tells that retrieving the specified peripheral's connection lost.
  Stream<ConnectionStateChangedEventArgs> get connectionStateChanged;

  /// Tells that retrieving the specified characteristic’s value changed.
  Stream<GattCharacteristicNotifiedEventArgs> get characteristicNotified;

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
  Future<List<Peripheral>> retrieveConnectedPeripherals();

  /// Establishes a local connection to a peripheral.
  Future<void> connect(Peripheral peripheral);

  /// Cancels an active or pending local connection to a peripheral.
  Future<void> disconnect(Peripheral peripheral);

  /// Request an MTU size used for a given connection. Please note that starting from Android 14,
  /// the Android Bluetooth stack requests the BLE ATT MTU to 517 bytes when the first GATT client
  /// requests an MTU, and disregards all subsequent MTU requests. Check out
  /// [MTU is set to 517 for the first GATT client requesting an MTU](https://developer.android.com/about/versions/14/behavior-changes-all#mtu-set-to-517)
  /// for more information.
  ///
  /// This method is only available on Android, throws [UnsupportedError] on other platforms.
  Future<int> requestMTU(Peripheral peripheral, int mtu);

  /// Retrieves the current RSSI value for the peripheral while connected to the central manager.
  ///
  /// Throws [UnsupportedError] on Windows.
  Future<int> readRSSI(Peripheral peripheral);

  /// Discovers the GATT services, characteristics and descriptors of the peripheral.
  Future<List<GattService>> discoverGATT(Peripheral peripheral);

  /// Retrieves the value of a specified characteristic.
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic);

  /// Writes the value of a characteristic.
  ///
  /// The maximum size of the value is 512, all bytes that exceed this size will be discarded.
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  });

  /// Sets notifications or indications for the value of a specified characteristic.
  Future<void> setCharacteristicNotifyState(
    GattCharacteristic characteristic, {
    required bool state,
  });

  /// Retrieves the value of a specified characteristic descriptor.
  Future<Uint8List> readDescriptor(GattDescriptor descriptor);

  /// Writes the value of a characteristic descriptor.
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  });
}
