import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyCentralManager2 extends MyCentralManager {
  @override
  // TODO: implement state
  BluetoothLowEnergyState get state => throw UnimplementedError();

  @override
  // TODO: implement stateChanged
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      throw UnimplementedError();

  @override
  // TODO: implement discovered
  Stream<DiscoveredEventArgs> get discovered => throw UnimplementedError();

  @override
  // TODO: implement peripheralStateChanged
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      throw UnimplementedError();

  @override
  // TODO: implement characteristicValueChanged
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged => throw UnimplementedError();

  @override
  Future<void> setUp() {
    // TODO: implement setUp
    throw UnimplementedError();
  }

  @override
  Future<void> startDiscovery() {
    // TODO: implement startDiscovery
    throw UnimplementedError();
  }

  @override
  Future<void> stopDiscovery() {
    // TODO: implement stopDiscovery
    throw UnimplementedError();
  }

  @override
  Future<void> connect(Peripheral peripheral) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect(Peripheral peripheral) {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<int> getMaximumWriteLength(Peripheral peripheral,
      {required GattCharacteristicWriteType type}) {
    // TODO: implement getMaximumWriteLength
    throw UnimplementedError();
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) {
    // TODO: implement readRSSI
    throw UnimplementedError();
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) {
    // TODO: implement discoverGATT
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic) {
    // TODO: implement readCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> writeCharacteristic(GattCharacteristic characteristic,
      {required Uint8List value, required GattCharacteristicWriteType type}) {
    // TODO: implement writeCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> notifyCharacteristic(GattCharacteristic characteristic,
      {required bool state}) {
    // TODO: implement notifyCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) {
    // TODO: implement readDescriptor
    throw UnimplementedError();
  }

  @override
  Future<void> writeDescriptor(GattDescriptor descriptor,
      {required Uint8List value}) {
    // TODO: implement writeDescriptor
    throw UnimplementedError();
  }
}
