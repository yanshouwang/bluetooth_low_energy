import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'central_manager_state.dart';
import 'gatt_characteristic_write_type.dart';
import 'events.dart';
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

  Stream<PeripheralEvent> get scanned;
  Stream<PeripheralStateEvent> get peripheralStateChanged;
  Stream<GattCharacteristicValueEvent> get characteristicValueChanged;

  Future<void> initialize();
  Future<void> startScan();
  Future<void> stopScan();
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

class _CentralManager extends CentralManager {
  @override
  // TODO: implement characteristicValueChanged
  Stream<GattCharacteristicValueEvent> get characteristicValueChanged =>
      throw UnimplementedError();

  @override
  Future<void> connect(String id) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  void disconnect(String id) {
    // TODO: implement disconnect
  }

  @override
  Future<List<GattService>> discoverServices(String id) {
    // TODO: implement discoverServices
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<void> notifyCharacteristic(
      {required String id,
      required String serviceId,
      required String characteristicId,
      required bool value}) {
    // TODO: implement notifyCharacteristic
    throw UnimplementedError();
  }

  @override
  // TODO: implement peripheralStateChanged
  Stream<PeripheralStateEvent> get peripheralStateChanged =>
      throw UnimplementedError();

  @override
  Future<Uint8List> readCharacteristic(
      {required String id,
      required String serviceId,
      required String characteristicId}) {
    // TODO: implement readCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readDescriptor(
      {required String id,
      required String serviceId,
      required String characteristicId,
      required String descriptorId}) {
    // TODO: implement readDescriptor
    throw UnimplementedError();
  }

  @override
  // TODO: implement scanned
  Stream<PeripheralEvent> get scanned => throw UnimplementedError();

  @override
  Future<void> startScan() {
    // TODO: implement startScan
    throw UnimplementedError();
  }

  @override
  // TODO: implement state
  ValueListenable<CentralManagerState> get state => throw UnimplementedError();

  @override
  Future<void> stopScan() {
    // TODO: implement stopScan
    throw UnimplementedError();
  }

  @override
  Future<void> writeCharacteristic(
      {required String id,
      required String serviceId,
      required String characteristicId,
      required Uint8List value,
      required GattCharacteristicWriteType type}) {
    // TODO: implement writeCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> writeDescriptor(
      {required String id,
      required String serviceId,
      required String characteristicId,
      required String descriptorId,
      required Uint8List value}) {
    // TODO: implement writeDescriptor
    throw UnimplementedError();
  }
}