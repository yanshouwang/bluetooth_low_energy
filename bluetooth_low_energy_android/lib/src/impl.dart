import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:hybrid_logging/hybrid_logging.dart';

import 'api.g.dart';
import 'api.x.dart';

final class CentralManagerImpl extends CentralManager
    with TypeLogger, LoggerController
    implements CentralManagerFlutterApi {
  final CentralManagerHostApi _api;

  late final StreamController<BluetoothLowEnergyStateChangedEvent>
      _stateChangedController;
  late final StreamController<NameChangedEvent> _nameChangedController;
  late final StreamController<DiscoveredEvent> _discoveredController;
  late final StreamController<PeripheralConnectionStateChangedEvent>
      _connectionStateChangedController;
  late final StreamController<PeripheralMTUChangedEvent> _mtuChangedController;
  late final StreamController<GATTCharacteristicNotifiedEvent>
      _characteristicNotifiedController;

  CentralManagerImpl()
      : _api = CentralManagerHostApi(),
        super.impl() {
    _stateChangedController = StreamController.broadcast(
      onListen: () => _api.addStateChangedListener(),
      onCancel: () => _api.removeStateChangedListener(),
    );
    _nameChangedController = StreamController.broadcast(
      onListen: () => _api.addNameChangedListener(),
      onCancel: () => _api.removeNameChangedListener(),
    );
    _discoveredController = StreamController.broadcast(
      onListen: () => _api.addDiscoveredListener(),
      onCancel: () => _api.removeDiscoveredListener(),
    );
    _connectionStateChangedController = StreamController.broadcast(
      onListen: () => _api.addConnectionStateChangedListener(),
      onCancel: () => _api.removeConnectionStateChangedListener(),
    );
    _mtuChangedController = StreamController.broadcast(
      onListen: () => _api.addMTUChanagedListener(),
      onCancel: () => _api.removeMTUChangedListener(),
    );
    _characteristicNotifiedController = StreamController.broadcast(
      onListen: () => _api.addCharacteristicNotifiedListener(),
      onCancel: () => _api.removeCharacteristicNotifiedListener(),
    );
    CentralManagerFlutterApi.setUp(this);
  }

  @override
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<NameChangedEvent> get nameChanged => _nameChangedController.stream;
  @override
  Stream<DiscoveredEvent> get discovered => _discoveredController.stream;
  @override
  Stream<PeripheralConnectionStateChangedEvent> get connectionStateChanged =>
      _connectionStateChangedController.stream;
  @override
  Stream<PeripheralMTUChangedEvent> get mtuChanged =>
      _mtuChangedController.stream;
  @override
  Stream<GATTCharacteristicNotifiedEvent> get characteristicNotified =>
      _characteristicNotifiedController.stream;

  @override
  Future<BluetoothLowEnergyState> getState() async {
    final stateApi = await _api.getState();
    final state = stateApi.impl;
    return state;
  }

  @override
  Future<bool> shouldShowAuthorizeRationale() async {
    final shouldShowRationale = await _api.shouldShowAuthorizeRationale();
    return shouldShowRationale;
  }

  @override
  Future<bool> authorize() async {
    final isAuthorized = await _api.authorize();
    return isAuthorized;
  }

  @override
  Future<void> showAppSettings() async {
    await _api.showAppSettings();
  }

  @override
  Future<void> turnOn() async {
    await _api.turnOn();
  }

  @override
  Future<void> turnOff() async {
    await _api.turnOff();
  }

  @override
  Future<String?> getName() async {
    final name = await _api.getName();
    return name;
  }

  @override
  Future<void> setName(String? name) async {
    await _api.setName(name);
  }

  @override
  Future<void> startDiscovery({
    List<UUID> serviceUUIDs = const [],
  }) async {
    final serviceUUIDApis = serviceUUIDs.map((e) => e.toString()).toList();
    await _api.startDiscovery(serviceUUIDApis);
  }

  @override
  Future<void> stopDiscovery() async {
    await _api.stopDiscovery();
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() async {
    final peripheralApis = await _api.retrieveConnectedPeripherals();
    final peripherals = peripheralApis.map((e) => e.impl).toList();
    return peripherals;
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    await _api.connect(peripheral.address);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    await _api.disconnect(peripheral.address);
  }

  @override
  Future<int> requestMTU(
    Peripheral peripheral, {
    required int mtu,
  }) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final mtu1 = await _api.requestMTU(peripheral.address, mtu);
    return mtu1;
  }

  @override
  Future<void> requestConnectionPriority(
    Peripheral peripheral, {
    required ConnectionPriority priority,
  }) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    await _api.requestConnectionPriority(peripheral.address, priority.api);
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GATTCharacteristicWriteType type,
  }) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final maximumWriteLength =
        await _api.getMaximumWriteLength(peripheral.address, type.api);
    return maximumWriteLength;
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final rssi = await _api.readRSSI(peripheral.address);
    return rssi;
  }

  @override
  Future<List<GATTService>> discoverServices(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final serviceApis = await _api.discoverServices(peripheral.address);
    final services = serviceApis.map((e) => e.impl).toList();
    return services;
  }

  @override
  Future<List<GATTCharacteristic>> discoverCharacteristics(
      GATTService service) async {
    return service.characteristics;
  }

  @override
  Future<List<GATTDescriptor>> discoverDescriptors(
      GATTCharacteristic characteristic) async {
    return characteristic.descriptors;
  }

  @override
  Future<Uint8List> readCharacteristic(
      GATTCharacteristic characteristic) async {
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final value = await _api.readCharacteristic(characteristic.id);
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  }) async {
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    await _api.writeCharacteristic(characteristic.id, value, type.api);
  }

  @override
  Future<void> setCharacteristicNotifyState(
    GATTCharacteristic characteristic, {
    required bool state,
  }) async {
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    await _api.setCharacteristicNotifyState(characteristic.id, state);
  }

  @override
  Future<Uint8List> readDescriptor(GATTDescriptor descriptor) async {
    if (descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    final value = await _api.readDescriptor(descriptor.id);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    await _api.writeDescriptor(descriptor.id, value);
  }

  @override
  void onStateChanged(BluetoothLowEnergyStateApi state) {
    final event = BluetoothLowEnergyStateChangedEvent(state.impl);
    _stateChangedController.add(event);
  }

  @override
  void onNameChanged(String? name) {
    final event = NameChangedEvent(name);
    _nameChangedController.add(event);
  }

  @override
  void onDiscovered(
      PeripheralApi peripheral, int rssi, AdvertisementApi advertisement) {
    final event = DiscoveredEvent(peripheral.impl, rssi, advertisement.impl);
    _discoveredController.add(event);
  }

  @override
  void onConnectionStateChanged(
      PeripheralApi peripheral, ConnectionStateApi state) {
    final event =
        PeripheralConnectionStateChangedEvent(peripheral.impl, state.impl);
    _connectionStateChangedController.add(event);
  }

  @override
  void onMTUChanged(PeripheralApi peripheral, int mtu) {
    final event = PeripheralMTUChangedEvent(peripheral.impl, mtu);
    _mtuChangedController.add(event);
  }

  @override
  void onCharacteristicNotified(
      GATTCharacteristicApi characteristic, Uint8List value) {
    final event = GATTCharacteristicNotifiedEvent(characteristic.impl, value);
    _characteristicNotifiedController.add(event);
  }
}

final class PeripheralImpl extends Peripheral {
  final String address;

  PeripheralImpl({
    required this.address,
  }) : super.impl(
          uuid: UUID.fromAddress(address),
        );
}

base mixin GATTAttributeImpl on GATTAttribute {
  int get id;

  @override
  bool operator ==(Object other) {
    return other is GATTAttributeImpl && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

final class GATTDescriptorImpl extends GATTDescriptor with GATTAttributeImpl {
  @override
  final int id;

  GATTDescriptorImpl({
    required this.id,
    required super.uuid,
  }) : super.impl();
}

final class GATTCharacteristicImpl extends GATTCharacteristic
    with GATTAttributeImpl {
  @override
  final int id;

  GATTCharacteristicImpl({
    required this.id,
    required super.uuid,
    required super.properties,
    required super.descriptors,
  }) : super.impl();
}

final class GATTServiceImpl extends GATTService with GATTAttributeImpl {
  @override
  final int id;

  GATTServiceImpl({
    required this.id,
    required super.uuid,
    required super.isPrimary,
    required super.includedServices,
    required super.characteristics,
  });
}
