import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

class PigeonCentralManager extends CentralManager {
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
