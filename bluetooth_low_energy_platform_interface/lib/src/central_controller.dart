import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_state.dart';
import 'event_args.dart';
import 'gatt_characteristic.dart';
import 'gatt_characteristic_write_type.dart';
import 'gatt_descriptor.dart';
import 'gatt_service.dart';
import 'peripheral.dart';

/// The central controller used to communicate with peripherals.
/// Call `setUp` before use any api, and call `tearDown` when it is no longer needed.
abstract class CentralController extends PlatformInterface {
  /// Constructs a [CentralController].
  CentralController() : super(token: _token);

  static final Object _token = Object();

  static CentralController? _instance;

  /// The default instance of [CentralController] to use.
  static CentralController get instance {
    final instance = _instance;
    if (instance == null) {
      const message =
          '`BluetoothLowEnergy` is not implemented on this platform.';
      throw UnimplementedError(message);
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CentralController] when
  /// they register themselves.
  static set instance(CentralController instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Gets the state of the central.
  CentralState get state;

  /// Used to listen the central state changed event.
  Stream<CentralStateChangedEventArgs> get stateChanged;

  /// Used to listen the central discovered event.
  Stream<CentralDiscoveredEventArgs> get discovered;

  /// Used to listen peripherals state changed event.
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged;

  /// Used to listen GATT characteristics value changed event.
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged;

  /// Sets up the central controller, call this before use any api.
  Future<void> setUp();

  /// Tears down the central controller, call this when it is no longer needed.
  Future<void> tearDown();

  /// Starts to discover peripherals.
  Future<void> startDiscovery();

  /// Stops to discover peripherals.
  Future<void> stopDiscovery();

  /// Connects to the peripheral.
  Future<void> connect(Peripheral peripheral);

  /// Disconnects form the peripheral.
  Future<void> disconnect(Peripheral peripheral);

  /// Discovers GATT of the peripheral.
  Future<void> discoverGATT(Peripheral peripheral);

  /// Gets GATT services of the peripheral.
  Future<List<GattService>> getServices(Peripheral peripheral);

  /// Gets GATT characteristics of the GATT service.
  Future<List<GattCharacteristic>> getCharacteristics(GattService service);

  /// Gets GATT descriptors of the GATT characteristic.
  Future<List<GattDescriptor>> getDescriptors(
    GattCharacteristic characteristic,
  );

  /// Reads value of the GATT characteristic.
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic);

  /// Writes value of the GATT characteristic.
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  });

  /// Notifies value of the GATT characteristic.
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  });

  /// Reads value of the GATT descriptor.
  Future<Uint8List> readDescriptor(GattDescriptor descriptor);

  /// Writes value of the GATT descriptor.
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  });
}
