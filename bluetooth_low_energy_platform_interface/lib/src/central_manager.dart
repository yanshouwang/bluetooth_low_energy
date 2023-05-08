import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_manager_state.dart';
import 'gatt_characteristic_write_type.dart';
import 'event_args.dart';
import 'gatt_service.dart';

abstract class CentralManager extends PlatformInterface {
  /// Constructs a CentralManager.
  CentralManager() : super(token: _token);

  static final Object _token = Object();

  static CentralManager _instance = _CentralManager();

  /// The default instance of [CentralManager] to use.
  static CentralManager get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CentralManager] when
  /// they register themselves.
  static set instance(CentralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ValueListenable<CentralManagerState> get state;

  Stream<PeripheralEventArgs> get scanned;
  Stream<PeripheralStateEventArgs> get peripheralStateChanged;
  Stream<GattCharacteristicValueEventArgs> get characteristicValueChanged;

  Future<void> startScan();
  Future<void> stopScan();
  Future<void> connect(String id);
  void disconnect(String id);
  Future<GattService> discoverService(String id, String serviceId);
  Future<Uint8List> read(
    String id,
    String serviceId,
    String characteristicId,
  );
  Future<void> write(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value, {
    GattCharacteristicWriteType? type,
  });
  Future<void> notify(
    String id,
    String serviceId,
    String characteristicId,
    bool value,
  );
}

class _CentralManager extends CentralManager {
  @override
  Stream<GattCharacteristicValueEventArgs> get characteristicValueChanged =>
      throw UnimplementedError();

  @override
  Future<void> connect(String id) {
    throw UnimplementedError();
  }

  @override
  void disconnect(String id) {
    throw UnimplementedError();
  }

  @override
  Future<GattService> discoverService(String id, String serviceId) {
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    throw UnimplementedError();
  }

  @override
  Future<void> notify(
    String id,
    String serviceId,
    String characteristicId,
    bool value,
  ) {
    throw UnimplementedError();
  }

  @override
  Stream<PeripheralStateEventArgs> get peripheralStateChanged =>
      throw UnimplementedError();

  @override
  Future<Uint8List> read(String id, String serviceId, String characteristicId) {
    throw UnimplementedError();
  }

  @override
  Stream<PeripheralEventArgs> get scanned => throw UnimplementedError();

  @override
  Future<void> startScan() {
    throw UnimplementedError();
  }

  @override
  ValueListenable<CentralManagerState> get state => throw UnimplementedError();

  @override
  Future<void> stopScan() {
    throw UnimplementedError();
  }

  @override
  Future<void> write(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value, {
    GattCharacteristicWriteType? type,
  }) {
    throw UnimplementedError();
  }
}
