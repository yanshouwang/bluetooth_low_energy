import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_low_energy_manager.dart';

/// Platform-specific implementations should implement this class to support [CentralManagerImpl].
abstract base class CentralManagerImpl extends BluetoothLowEnergyManagerImpl
    implements CentralManager {
  static final Object _token = Object();

  static CentralManagerImpl? _instance;

  /// The default instance of [CentralManagerImpl] to use.
  static CentralManagerImpl get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'CentralManager is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CentralManagerImpl] when
  /// they register themselves.
  static set instance(CentralManagerImpl instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a [CentralManagerImpl].
  CentralManagerImpl() : super(token: _token);
}

/// An object that scans for, discovers, connects to, and manages peripherals.
abstract interface class CentralManager implements BluetoothLowEnergyManager {
  static CentralManager? _instance;

  /// Gets the instance of [CentralManager] to use.
  static CentralManager get instance {
    final instance = CentralManagerImpl.instance;
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

  /// Retrieves the current RSSI value for the peripheral while connected to the central manager.
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

/// A remote peripheral device.
abstract interface class Peripheral implements BluetoothLowEnergyPeer {}

base class PeripheralImpl extends BluetoothLowEnergyPeerImpl
    implements Peripheral {
  PeripheralImpl({
    required super.uuid,
  });

  @override
  int get hashCode => uuid.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Peripheral && other.uuid == uuid;
  }
}

/// The discovered event arguments.
base class DiscoveredEventArgs extends EventArgs {
  /// The disvered peripheral.
  final Peripheral peripheral;

  /// The rssi of the peripheral.
  final int rssi;

  /// The advertisement of the peripheral.
  final Advertisement advertisement;

  /// Constructs a [DiscoveredEventArgs].
  DiscoveredEventArgs(this.peripheral, this.rssi, this.advertisement);
}

/// The connection state cahnged event arguments.
base class ConnectionStateChangedEventArgs extends EventArgs {
  /// The peripheral which connection state changed.
  final Peripheral peripheral;

  /// The connection state.
  final bool connectionState;

  /// Constructs a [ConnectionStateChangedEventArgs].
  ConnectionStateChangedEventArgs(
    this.peripheral,
    this.connectionState,
  );
}

/// The GATT characteristic notified event arguments.
base class GattCharacteristicNotifiedEventArgs extends EventArgs {
  /// The GATT characteristic which notified.
  final GattCharacteristic characteristic;

  /// The notified value.
  final Uint8List value;

  /// Constructs a [GattCharacteristicNotifiedEventArgs].
  GattCharacteristicNotifiedEventArgs(
    this.characteristic,
    this.value,
  );
}
