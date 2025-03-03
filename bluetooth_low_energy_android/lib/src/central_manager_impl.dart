import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:hybrid_logging/hybrid_logging.dart';

import 'bluetooth_low_energy_manager_impl.dart';

final class CentralManagerImpl extends CentralManager
    with BluetoothLowEnergyManagerImpl, TypeLogger, LoggerController {
  CentralManagerImpl() : super.impl();

  @override
  // TODO: implement characteristicNotified
  Stream<GATTCharacteristicNotifiedEvent> get characteristicNotified =>
      throw UnimplementedError();

  @override
  Future<void> connect(Peripheral peripheral) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  // TODO: implement connectionStateChanged
  Stream<PeripheralConnectionStateChangedEvent> get connectionStateChanged =>
      throw UnimplementedError();

  @override
  Future<void> disconnect(Peripheral peripheral) {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<List<GATTService>> discoverServices(Peripheral peripheral) {
    // TODO: implement discoverServices
    throw UnimplementedError();
  }

  @override
  // TODO: implement discovered
  Stream<DiscoveredEvent> get discovered => throw UnimplementedError();

  @override
  Future<int> getMaximumWriteLength(Peripheral peripheral,
      {required GATTCharacteristicWriteType type}) {
    // TODO: implement getMaximumWriteLength
    throw UnimplementedError();
  }

  @override
  // TODO: implement mtuChanged
  Stream<PeripheralMTUChangedEvent> get mtuChanged =>
      throw UnimplementedError();

  @override
  Future<Uint8List> readCharacteristic(GATTCharacteristic characteristic) {
    // TODO: implement readCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readDescriptor(GATTDescriptor descriptor) {
    // TODO: implement readDescriptor
    throw UnimplementedError();
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) {
    // TODO: implement readRSSI
    throw UnimplementedError();
  }

  @override
  Future<void> requestConnectionPriority(Peripheral peripheral,
      {required ConnectionPriority priority}) {
    // TODO: implement requestConnectionPriority
    throw UnimplementedError();
  }

  @override
  Future<int> requestMTU(Peripheral peripheral, {required int mtu}) {
    // TODO: implement requestMTU
    throw UnimplementedError();
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() {
    // TODO: implement retrieveConnectedPeripherals
    throw UnimplementedError();
  }

  @override
  Future<void> setCharacteristicNotifyState(GATTCharacteristic characteristic,
      {required bool state}) {
    // TODO: implement setCharacteristicNotifyState
    throw UnimplementedError();
  }

  @override
  Future<void> startDiscovery({List<UUID>? serviceUUIDs}) {
    // TODO: implement startDiscovery
    throw UnimplementedError();
  }

  @override
  Future<void> stopDiscovery() {
    // TODO: implement stopDiscovery
    throw UnimplementedError();
  }

  @override
  Future<void> writeCharacteristic(GATTCharacteristic characteristic,
      {required Uint8List value, required GATTCharacteristicWriteType type}) {
    // TODO: implement writeCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> writeDescriptor(GATTDescriptor descriptor,
      {required Uint8List value}) {
    // TODO: implement writeDescriptor
    throw UnimplementedError();
  }
}
