import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyCentralManager extends CentralController {
  @override
  // TODO: implement characteristicValueChanged
  Stream<(String, String, String, Uint8List)> get characteristicValueChanged =>
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
  Future<List<GattService>> getServices(String id) {
    // TODO: implement discoverServices
    throw UnimplementedError();
  }

  @override
  // TODO: implement discovered
  Stream<Peripheral> get discovered => throw UnimplementedError();

  @override
  Future<BluetoothState> getState() {
    // TODO: implement getState
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
  Stream<(String, PeripheralState)> get peripheralStateChanged =>
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
  Future<void> startDiscovery() {
    // TODO: implement startDiscovery
    throw UnimplementedError();
  }

  @override
  // TODO: implement stateChanged
  Stream<BluetoothState> get stateChanged => throw UnimplementedError();

  @override
  Future<void> stopDiscovery() {
    // TODO: implement stopDiscovery
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
