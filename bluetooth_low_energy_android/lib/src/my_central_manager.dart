import 'dart:typed_data';

import 'package:bluetooth_low_energy_android/src/my_api.dart';
import 'package:bluetooth_low_energy_android/src/my_central_manager_api.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyCentralManager extends CentralManager {
  late final _api = MyCentralManagerApi()..setup();

  @override
  Stream<CentralManagerState> get stateChanged =>
      _api.stateChanged.map((i) => MyCentralManagerState.values[i].nativeState);
  @override
  Stream<Peripheral> get discovered =>
      _api.discovered.map((peripheral) => peripheral.nativePeripheral);
  @override
  Stream<(String, PeripheralState)> get peripheralStateChanged => _api
      .peripheralStateChanged
      .map((item) => (item.$1, MyPeripheralState.values[item.$2].nativeState));
  @override
  Stream<(String, String, String, Uint8List)> get characteristicValueChanged =>
      _api.characteristicValueChanged;

  @override
  Future<CentralManagerState> getState() async {
    final state = await _api.getState();
    final myState = MyCentralManagerState.values[state];
    return myState.nativeState;
  }

  @override
  Future<void> startDiscovery() {
    return _api.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() {
    return _api.stopDiscovery();
  }

  @override
  Future<void> connect(String id) {
    return _api.connect(id);
  }

  @override
  void disconnect(String id) {
    _api.disconnect(id).ignore();
  }

  @override
  Future<List<GattService>> discoverServices(String id) async {
    final myServices = await _api.discoverServices(id);
    return myServices
        .cast<MyGattService>()
        .map((myService) => myService.nativeService)
        .toList();
  }

  @override
  Future<Uint8List> readCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
  }) {
    return _api.readCharacteristic(
      id,
      serviceId,
      characteristicId,
    );
  }

  @override
  Future<void> writeCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) {
    return _api.writeCharacteristic(
      id,
      serviceId,
      characteristicId,
      value,
      type.myType.index,
    );
  }

  @override
  Future<void> notifyCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required bool value,
  }) {
    return _api.notifyCharacteristic(
      id,
      serviceId,
      characteristicId,
      value,
    );
  }

  @override
  Future<Uint8List> readDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
  }) {
    return _api.readDescriptor(
      id,
      serviceId,
      characteristicId,
      descriptorId,
    );
  }

  @override
  Future<void> writeDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
    required Uint8List value,
  }) {
    return _api.writeDescriptor(
      id,
      serviceId,
      characteristicId,
      descriptorId,
      value,
    );
  }
}

extension on MyPeripheral {
  Peripheral get nativePeripheral {
    return Peripheral(
      id: id,
      rssi: rssi,
      name: name,
      manufacturerSpecificData: manufacturerSpecificData,
    );
  }
}

extension on MyGattService {
  GattService get nativeService {
    final characteristics = this
        .characteristics
        .cast<MyGattCharacteristic>()
        .map((characteristic) => characteristic.nativeCharacteristic)
        .toList();
    return GattService(
      id: id,
      characteristics: characteristics,
    );
  }
}

extension on MyGattCharacteristic {
  GattCharacteristic get nativeCharacteristic {
    final descriptors = this
        .descriptors
        .cast<MyGattDescriptor>()
        .map((descriptor) => descriptor.nativeDescriptor)
        .toList();
    return GattCharacteristic(
      id: id,
      canRead: canRead,
      canWrite: canWrite,
      canWriteWithoutResponse: canWriteWithoutResponse,
      canNotify: canNotify,
      descriptors: descriptors,
    );
  }
}

extension on MyGattDescriptor {
  GattDescriptor get nativeDescriptor {
    return GattDescriptor(
      id: id,
    );
  }
}

extension on MyCentralManagerState {
  CentralManagerState get nativeState {
    return CentralManagerState.values[index];
  }
}

extension on MyPeripheralState {
  PeripheralState get nativeState {
    return PeripheralState.values[index];
  }
}

extension on GattCharacteristicWriteType {
  MyGattCharacteristicWriteType get myType {
    return MyGattCharacteristicWriteType.values[index];
  }
}
