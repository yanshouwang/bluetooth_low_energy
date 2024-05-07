import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'advertisement.dart';
import 'bluetooth_low_energy_manager.dart';
import 'event_args.dart';
import 'gatt.dart';
import 'peripheral.dart';
import 'uuid.dart';

/// The discovered event arguments.
final class DiscoveredEventArgs extends EventArgs {
  /// The disvered peripheral.
  final Peripheral peripheral;

  /// The rssi of the peripheral.
  final int rssi;

  /// The advertisement of the peripheral.
  final Advertisement advertisement;

  /// Constructs a [DiscoveredEventArgs].
  DiscoveredEventArgs(this.peripheral, this.rssi, this.advertisement);
}

/// The GATT characteristic notified event arguments.
final class GATTCharacteristicNotifiedEventArgs extends EventArgs {
  /// The GATT characteristic which notified.
  final GATTCharacteristic characteristic;

  /// The notified value.
  final Uint8List value;

  /// Constructs a [GATTCharacteristicNotifiedEventArgs].
  GATTCharacteristicNotifiedEventArgs(
    this.characteristic,
    this.value,
  );
}

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
  Stream<GATTCharacteristicNotifiedEventArgs> get characteristicNotified;

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
  /// This method is available on Android and iOS, throws [UnsupportedError] on other platforms.
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
  /// This method is available on Android, throws [UnsupportedError] on other platforms.
  Future<int> requestMTU(Peripheral peripheral, int mtu);

  /// Retrieves the current RSSI value for the peripheral while connected to the central manager.
  ///
  /// This method is available on Android, iOS, macOS and Linux, throws [UnsupportedError] on other platforms.
  Future<int> readRSSI(Peripheral peripheral);

  /// Discovers the GATT services, characteristics and descriptors of the peripheral.
  Future<List<GATTService>> discoverGATT(Peripheral peripheral);

  /// Retrieves the value of a specified characteristic.
  Future<Uint8List> readCharacteristic(GATTCharacteristic characteristic);

  /// Writes the value of a characteristic.
  ///
  /// The maximum size of the value is 512, all bytes that exceed this size will be discarded.
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

/// Platform-specific implementations should implement this class to support [BaseCentralManager].
abstract base class BaseCentralManager extends BaseBluetoothLowEnergyManager
    implements CentralManager {
  static final Object _token = Object();

  static BaseCentralManager? _instance;

  /// The default instance of [BaseCentralManager] to use.
  static BaseCentralManager get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'CentralManager is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BaseCentralManager] when
  /// they register themselves.
  static set instance(BaseCentralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [BaseCentralManager].
  BaseCentralManager() : super(token: _token);
}
