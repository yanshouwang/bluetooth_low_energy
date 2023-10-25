import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_manager.dart';
import 'event_args.dart';
import 'gatt_characteristic.dart';
import 'gatt_characteristic_write_type.dart';
import 'gatt_descriptor.dart';
import 'gatt_service.dart';
import 'peripheral.dart';

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract class CentralManager extends PlatformInterface
    implements BluetoothLowEnergyManager {
  /// Constructs a [CentralManager].
  CentralManager() : super(token: _token);

  static final Object _token = Object();

  static CentralManager? _instance;

  /// The default instance of [CentralManager] to use.
  static CentralManager get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
        'CentralManager is not implemented on this platform.',
      );
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CentralManager] when
  /// they register themselves.
  static set instance(CentralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Tells the central manager discovered a peripheral while scanning for devices.
  Stream<DiscoveredEventArgs> get discovered;

  /// Tells that retrieving the specified peripheral's state changed.
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged;

  /// Tells that retrieving the specified characteristic’s value changed.
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged;

  /// Scans for peripherals that are advertising services.
  Future<void> startDiscovery();

  /// Asks the central manager to stop scanning for peripherals.
  Future<void> stopDiscovery();

  /// Establishes a local connection to a peripheral.
  Future<void> connect(Peripheral peripheral);

  /// Cancels an active or pending local connection to a peripheral.
  Future<void> disconnect(Peripheral peripheral);

  /// Gets the maximum amount of data, in bytes, you can send to a characteristic in a single write type.
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GattCharacteristicWriteType type,
  });

  /// Retrieves the current RSSI value for the peripheral while connected to the central manager.
  Future<int> readRSSI(Peripheral peripheral);

  /// Discovers the GATT services, characteristics and descriptors of the peripheral.
  Future<List<GattService>> discoverGATT(Peripheral peripheral);

  /// Retrieves the value of a specified characteristic.
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic);

  /// Writes the value of a characteristic.
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  });

  /// Sets notifications or indications for the value of a specified characteristic.
  Future<void> notifyCharacteristic(
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
