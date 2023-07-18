import 'dart:async';
import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_manager_state.dart';
import 'gatt_characteristic_write_type.dart';
import 'gatt_service.dart';
import 'peripheral.dart';
import 'peripheral_state.dart';

abstract class CentralManager extends PlatformInterface {
  /// Constructs a CentralManager.
  CentralManager() : super(token: _token);

  static final Object _token = Object();

  static CentralManager? _instance;

  /// The default instance of [CentralManager] to use.
  static CentralManager get instance {
    final instance = _instance;
    if (instance == null) {
      const message = '`CentralManager` is not implemented on this platform.';
      throw UnimplementedError(message);
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

  Stream<CentralManagerState> get stateChanged;
  Stream<Peripheral> get discovered;
  Stream<(String, PeripheralState)> get peripheralStateChanged;
  Stream<(String, String, String, Uint8List)> get characteristicValueChanged;

  Future<CentralManagerState> getState();
  Future<void> startDiscovery();
  Future<void> stopDiscovery();
  Future<void> connect(String id);
  void disconnect(String id);
  Future<List<GattService>> discoverServices(String id);
  Future<Uint8List> readCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
  });
  Future<void> writeCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required Uint8List value,
    required GattCharacteristicWriteType type,
  });
  Future<void> notifyCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required bool value,
  });
  Future<Uint8List> readDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
  });
  Future<void> writeDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
    required Uint8List value,
  });
}
