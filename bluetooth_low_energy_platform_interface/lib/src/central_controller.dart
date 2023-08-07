import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_controller_state.dart';
import 'event_args.dart';
import 'gatt_characteristic.dart';
import 'gatt_characteristic_write_type.dart';
import 'gatt_descriptor.dart';
import 'gatt_service.dart';
import 'peripheral.dart';

abstract class CentralController extends PlatformInterface {
  /// Constructs a CentralController.
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

  Stream<CentralControllerStateChangedEventArgs> get stateChanged;
  Stream<CentralControllerDiscoveredEventArgs> get discovered;
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged;
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged;

  Future<void> initialize();
  Future<CentralControllerState> getState();
  Future<void> startDiscovery();
  Future<void> stopDiscovery();
  Future<void> connect(Peripheral peripheral);
  void disconnect(Peripheral peripheral);
  Future<List<GattService>> discoverServices(Peripheral peripheral);
  Future<List<GattCharacteristic>> discoverCharacteristics(GattService service);
  Future<List<GattDescriptor>> discoverDescriptors(
    GattCharacteristic characteristic,
  );
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic);
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  });
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  });
  Future<Uint8List> readDescriptor(GattDescriptor descriptor);
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  });
}
