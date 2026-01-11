import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_manager.dart';
import 'event_args.dart';
import 'gatt.dart';
import 'peripheral.dart';
import 'uuid.dart';

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract interface class CentralManager implements BluetoothLowEnergyManager {
  static CentralManager? _instance;

  /// Gets the instance of [CentralManager] to use.
  factory CentralManager() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = CentralManagerChannel.instance.create();
    }
    return instance;
  }

  /// Tells the central manager discovered a peripheral while scanning for devices.
  Stream<DiscoveredEventArgs> get discovered;

  /// Tells that retrieving the specified peripheral's connection state changed.
  Stream<PeripheralConnectionStateChangedEventArgs> get connectionStateChanged;

  /// Callback indicating the MTU for a given device connection has changed.
  ///
  /// This callback is triggered in response to the BluetoothGatt#requestMtu
  /// function, or in response to a connection event.
  ///
  /// This event is available on Android and Windows, throws [UnsupportedError]
  /// on other platforms.
  Stream<PeripheralMTUChangedEventArgs> get mtuChanged;

  /// Tells that retrieving the specified characteristic’s value changed.
  Stream<GATTCharacteristicNotifiedEventArgs> get characteristicNotified;

  /// Scans for peripherals that are advertising services.
  ///
  /// The [serviceUUIDs] argument is an array of [UUID] objects that the app is
  /// interested in. Each [UUID] object represents the [UUID] of a service that
  /// a peripheral advertises.
  Future<void> startDiscovery({List<UUID>? serviceUUIDs});

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
  Future<int> requestMTU(Peripheral peripheral, {required int mtu});

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
  Future<List<GATTService>> discoverGATT(Peripheral peripheral);

  /// Retrieves the value of a specified characteristic.
  Future<Uint8List> readCharacteristic(
    Peripheral peripheral,
    GATTCharacteristic characteristic,
  );

  /// Writes the value of a characteristic.
  Future<void> writeCharacteristic(
    Peripheral peripheral,
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  });

  /// Sets notifications or indications for the value of a specified characteristic.
  Future<void> setCharacteristicNotifyState(
    Peripheral peripheral,
    GATTCharacteristic characteristic, {
    required bool state,
  });

  /// Retrieves the value of a specified characteristic descriptor.
  Future<Uint8List> readDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor,
  );

  /// Writes the value of a characteristic descriptor.
  Future<void> writeDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor, {
    required Uint8List value,
  });
}

/// Platform-specific implementations should implement this class to support
/// [CentralManagerChannel].
abstract base class CentralManagerChannel extends PlatformInterface {
  static final Object _token = Object();

  static CentralManagerChannel? _instance;

  /// The default instance of [CentralManagerChannel] to use.
  static CentralManagerChannel get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
        'CentralManager is not implemented on this platform.',
      );
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CentralManagerChannel] when
  /// they register themselves.
  static set instance(CentralManagerChannel instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [CentralManagerChannel].
  CentralManagerChannel() : super(token: _token);

  CentralManager create();
}
