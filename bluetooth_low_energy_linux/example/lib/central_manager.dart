import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart'
    as inner;

import 'types.dart';

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract class CentralManager {
  static inner.CentralManager get _manager => inner.CentralManager.instance;

  /// The current state of the central manager.
  static BluetoothLowEnergyState get state => _manager.state;

  /// Tells the central manager’s state updated.
  static Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _manager.stateChanged;

  /// Sets up the central manager.
  static Future<void> setUp() => _manager.setUp();

  /// Tells the central manager discovered a peripheral while scanning for devices.
  static Stream<DiscoveredEventArgs> get discovered => _manager.discovered;

  /// Tells that retrieving the specified peripheral's state changed.
  static Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      _manager.peripheralStateChanged;

  /// Tells that retrieving the specified characteristic’s value changed.
  static Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged => _manager.characteristicValueChanged;

  /// Scans for peripherals that are advertising services.
  static Future<void> startDiscovery() => _manager.startDiscovery();

  /// Asks the central manager to stop scanning for peripherals.
  static Future<void> stopDiscovery() => _manager.stopDiscovery();

  /// Establishes a local connection to a peripheral.
  static Future<void> connect(Peripheral peripheral) =>
      _manager.connect(peripheral);

  /// Cancels an active or pending local connection to a peripheral.
  static Future<void> disconnect(Peripheral peripheral) =>
      _manager.disconnect(peripheral);

  /// Gets the maximum amount of data, in bytes, you can send to a characteristic in a single write type.
  static Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GattCharacteristicWriteType type,
  }) =>
      _manager.getMaximumWriteLength(
        peripheral,
        type: type,
      );

  /// Retrieves the current RSSI value for the peripheral while connected to the central manager.
  static Future<int> readRSSI(Peripheral peripheral) =>
      _manager.readRSSI(peripheral);

  /// Discovers the GATT services, characteristics and descriptors of the peripheral.
  static Future<List<GattService>> discoverGATT(Peripheral peripheral) =>
      _manager.discoverGATT(peripheral);

  /// Retrieves the value of a specified characteristic.
  static Future<Uint8List> readCharacteristic(
          GattCharacteristic characteristic) =>
      _manager.readCharacteristic(characteristic);

  /// Writes the value of a characteristic.
  static Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) =>
      _manager.writeCharacteristic(
        characteristic,
        value: value,
        type: type,
      );

  /// Sets notifications or indications for the value of a specified characteristic.
  static Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) =>
      _manager.notifyCharacteristic(
        characteristic,
        state: state,
      );

  /// Retrieves the value of a specified characteristic descriptor.
  static Future<Uint8List> readDescriptor(GattDescriptor descriptor) =>
      _manager.readDescriptor(descriptor);

  /// Writes the value of a characteristic descriptor.
  static Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) =>
      _manager.writeDescriptor(
        descriptor,
        value: value,
      );
}
