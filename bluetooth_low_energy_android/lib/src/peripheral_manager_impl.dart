import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:hybrid_logging/hybrid_logging.dart';

import 'bluetooth_low_energy_manager_impl.dart';

final class PeripheralManagerImpl extends PeripheralManager
    with BluetoothLowEnergyManagerImpl, TypeLogger, LoggerController {
  PeripheralManagerImpl() : super.impl();

  @override
  Future<void> addService(GATTService service) {
    // TODO: implement addService
    throw UnimplementedError();
  }

  @override
  // TODO: implement characteristicNotifyStateChanged
  Stream<GATTCharacteristicNotifyStateChangedEvent>
      get characteristicNotifyStateChanged => throw UnimplementedError();

  @override
  // TODO: implement characteristicReadRequested
  Stream<GATTCharacteristicReadRequestedEvent>
      get characteristicReadRequested => throw UnimplementedError();

  @override
  // TODO: implement characteristicWriteRequested
  Stream<GATTCharacteristicWriteRequestedEvent>
      get characteristicWriteRequested => throw UnimplementedError();

  @override
  // TODO: implement connectionStateChanged
  Stream<CentralConnectionStateChangedEvent> get connectionStateChanged =>
      throw UnimplementedError();

  @override
  // TODO: implement descriptorReadRequested
  Stream<GATTDescriptorReadRequestedEvent> get descriptorReadRequested =>
      throw UnimplementedError();

  @override
  // TODO: implement descriptorWriteRequested
  Stream<GATTDescriptorWriteRequestedEvent> get descriptorWriteRequested =>
      throw UnimplementedError();

  @override
  Future<int> getMaximumNotifyLength(Central central) {
    // TODO: implement getMaximumNotifyLength
    throw UnimplementedError();
  }

  @override
  // TODO: implement mtuChanged
  Stream<CentralMTUChangedEvent> get mtuChanged => throw UnimplementedError();

  @override
  Future<void> notifyCharacteristic(GATTCharacteristic characteristic,
      {required Uint8List value, List<Central>? centrals}) {
    // TODO: implement notifyCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> removeAllServices() {
    // TODO: implement removeAllServices
    throw UnimplementedError();
  }

  @override
  Future<void> removeService(GATTService service) {
    // TODO: implement removeService
    throw UnimplementedError();
  }

  @override
  Future<void> respondReadRequestWithError(GATTReadRequest request,
      {required GATTError error}) {
    // TODO: implement respondReadRequestWithError
    throw UnimplementedError();
  }

  @override
  Future<void> respondReadRequestWithValue(GATTReadRequest request,
      {required Uint8List value}) {
    // TODO: implement respondReadRequestWithValue
    throw UnimplementedError();
  }

  @override
  Future<void> respondWriteRequest(GATTWriteRequest request) {
    // TODO: implement respondWriteRequest
    throw UnimplementedError();
  }

  @override
  Future<void> respondWriteRequestWithError(GATTWriteRequest request,
      {required GATTError error}) {
    // TODO: implement respondWriteRequestWithError
    throw UnimplementedError();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement,
      {bool? includeDeviceName, bool? includeTXPowerLevel}) {
    // TODO: implement startAdvertising
    throw UnimplementedError();
  }

  @override
  Future<void> stopAdvertising() {
    // TODO: implement stopAdvertising
    throw UnimplementedError();
  }
}
