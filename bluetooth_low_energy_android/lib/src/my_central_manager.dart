import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';

class MyCentralManager extends CentralManager
    implements MyCentralManagerFlutterApi {
  final MyCentralManagerHostApi _api;
  final StreamController<CentralManagerState> _stateChangedController;
  final StreamController<Peripheral> _discoveredController;
  final StreamController<(String, PeripheralState)>
      _peripheralStateChangedController;
  final StreamController<(String, String, String, Uint8List)>
      _characteristicValueChangedController;

  MyCentralManager()
      : _api = MyCentralManagerHostApi(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast();

  @override
  Stream<CentralManagerState> get stateChanged =>
      _stateChangedController.stream;

  @override
  Stream<Peripheral> get discovered => _discoveredController.stream;

  @override
  Stream<(String, PeripheralState)> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;

  @override
  Stream<(String, String, String, Uint8List)> get characteristicValueChanged =>
      _characteristicValueChangedController.stream;

  @override
  Future<CentralManagerState> getState() {
    return _api.getState().then((i) => CentralManagerState.values[i]);
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
    _api.disconnect(id);
  }

  @override
  Future<List<GattService>> discoverServices(String id) {
    return _api.discoverServices(id).then((services) {
      return services
          .cast<MyGattService>()
          .map((service) => service.nativeService)
          .toList();
    });
  }

  @override
  Future<Uint8List> readCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
  }) {
    return _api.readCharacteristic(id, serviceId, characteristicId);
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

  @override
  void onStateChanged(int state) {
    final myState = MyCentralManagerState.values[state];
    _stateChangedController.add(myState.nativeState);
  }

  @override
  void onDiscovered(MyPeripheral peripheral) {
    _discoveredController.add(peripheral.nativePeripheral);
  }

  @override
  void onPeripheralStateChanged(String id, int state) {
    final myState = MyPeripheralState.values[state];
    final event = (id, myState.nativeState);
    _peripheralStateChangedController.add(event);
  }

  @override
  void onCharacteristicValueChanged(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value,
  ) {
    final event = (id, serviceId, characteristicId, value);
    _characteristicValueChangedController.add(event);
  }
}

extension on MyPeripheral {
  Peripheral get nativePeripheral {
    return Peripheral(
      id: id,
      name: name,
      rssi: rssi,
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
