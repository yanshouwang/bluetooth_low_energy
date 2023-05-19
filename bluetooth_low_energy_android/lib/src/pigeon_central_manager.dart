import 'dart:async';

import 'package:bluetooth_low_energy_android/src/bluetooth_low_energy_android_api.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

class PigeonCentralManager extends CentralManager
    implements CentralManagerFlutterApi {
  final CentralManagerHostApi _hostApi;
  final ValueNotifier<CentralManagerState> _state;
  final StreamController<PeripheralEvent> _scannedController;
  final StreamController<PeripheralStateEvent>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueEvent>
      _characteristicValueChangedController;

  PigeonCentralManager()
      : _hostApi = CentralManagerHostApi(),
        _state = ValueNotifier(CentralManagerState.unknown),
        _scannedController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast();

  @override
  ValueListenable<CentralManagerState> get state => _state;

  @override
  Stream<PeripheralEvent> get scanned => _scannedController.stream;

  @override
  Stream<PeripheralStateEvent> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;

  @override
  Stream<GattCharacteristicValueEvent> get characteristicValueChanged =>
      _characteristicValueChangedController.stream;

  @override
  Future<void> initialize() {
    return _hostApi.initialize();
  }

  @override
  Future<void> startScan() {
    return _hostApi.startScan();
  }

  @override
  Future<void> stopScan() {
    return _hostApi.stopScan();
  }

  @override
  Future<void> connect(String id) {
    return _hostApi.connect(id);
  }

  @override
  void disconnect(String id) {
    _hostApi.disconnect(id);
  }

  @override
  Future<GattService> discoverService({
    required String id,
    required String serviceId,
  }) {
    return _hostApi
        .discoverService(id, serviceId)
        .then((service) => service.toGattService());
  }

  @override
  Future<Uint8List> readCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
  }) {
    return _hostApi.read(id, serviceId, characteristicId);
  }

  @override
  Future<void> writeCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) {
    return _hostApi.write(
      id,
      serviceId,
      characteristicId,
      value,
      type.toGattCharacteristicWriteTypeArgs(),
    );
  }

  @override
  Future<void> notifyCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required bool value,
  }) {
    return _hostApi.notify(id, serviceId, characteristicId, value);
  }

  @override
  Future<List<GattService>> discoverServices(String id) {
    // TODO: implement discoverServices
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
  }) {
    // TODO: implement readDescriptor
    throw UnimplementedError();
  }

  @override
  Future<void> writeDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
    required Uint8List value,
  }) {
    // TODO: implement writeDescriptor
    throw UnimplementedError();
  }

  @override
  void onStateChanged(CentralManagerStateEventArgs eventArgs) {
    _state.value = eventArgs.stateArgs.toCentralManagerState();
  }

  @override
  void onScanned(PeripheralEventArgs eventArgs) {
    _scannedController.add(eventArgs.toPeripheralEvent());
  }

  @override
  void onPeripheralStateChanged(PeripheralStateEventArgs eventArgs) {
    _peripheralStateChangedController.add(eventArgs.toPeripheralStateEvent());
  }

  @override
  void onCharacteristicValueChanged(
    GattCharacteristicValueEventArgs eventArgs,
  ) {
    _characteristicValueChangedController
        .add(eventArgs.toGattCharacteristicValueEvent());
  }
}

extension on GattCharacteristicWriteType {
  GattCharacteristicWriteTypeArgs toGattCharacteristicWriteTypeArgs() {
    return GattCharacteristicWriteTypeArgs.values[index];
  }
}

extension on PeripheralArgs {
  Peripheral toPeripheral() {
    return Peripheral(
      id: id,
      name: name,
      rssi: rssi,
      manufacturerSpecificData: manufacturerSpecificData,
    );
  }
}

extension on GattServiceArgs {
  GattService toGattService() {
    final characteristics = characteristicArgs
        .map((characteristicArgs) => characteristicArgs!.toGattCharacteristic())
        .toList();
    return GattService(
      id: id,
      characteristics: characteristics,
    );
  }
}

extension on GattCharacteristicArgs {
  GattCharacteristic toGattCharacteristic() {
    final descriptors = descriptorArgs
        .map((descriptorArgs) => descriptorArgs!.toGattDescriptor())
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

extension on GattDescriptorArgs {
  GattDescriptor toGattDescriptor() {
    return GattDescriptor(
      id: id,
    );
  }
}

extension on PeripheralEventArgs {
  PeripheralEvent toPeripheralEvent() {
    return PeripheralEvent(peripheralArgs.toPeripheral());
  }
}

extension on PeripheralStateEventArgs {
  PeripheralStateEvent toPeripheralStateEvent() {
    return PeripheralStateEvent(
      id,
      stateArgs.toPeripheralState(),
    );
  }
}

extension on GattCharacteristicValueEventArgs {
  GattCharacteristicValueEvent toGattCharacteristicValueEvent() {
    return GattCharacteristicValueEvent(
      id,
      serviceId,
      characteristicId,
      value,
    );
  }
}

extension on CentralManagerStateArgs {
  CentralManagerState toCentralManagerState() {
    return CentralManagerState.values[index];
  }
}

extension on PeripheralStateArgs {
  PeripheralState toPeripheralState() {
    return PeripheralState.values[index];
  }
}
