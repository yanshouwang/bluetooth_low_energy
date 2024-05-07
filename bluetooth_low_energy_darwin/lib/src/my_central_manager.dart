import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_api.g.dart';
import 'my_gatt.dart';

base class MyCentralManager extends BaseCentralManager
    implements MyCentralManagerFlutterAPI {
  final MyCentralManagerHostAPI _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<ConnectionStateChangedEventArgs>
      _connectionStateChangedController;
  final StreamController<GATTCharacteristicNotifiedEventArgs>
      _characteristicNotifiedController;
  final Map<String, Peripheral> _peripherals;
  final Map<String, Map<int, MyGATTCharacteristic>> _characteristics;

  BluetoothLowEnergyState _state;

  MyCentralManager()
      : _api = MyCentralManagerHostAPI(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _characteristicNotifiedController = StreamController.broadcast(),
        _peripherals = {},
        _characteristics = {},
        _state = BluetoothLowEnergyState.unknown;

  @override
  BluetoothLowEnergyState get state => _state;
  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<DiscoveredEventArgs> get discovered => _discoveredController.stream;
  @override
  Stream<ConnectionStateChangedEventArgs> get connectionStateChanged =>
      _connectionStateChangedController.stream;
  @override
  Stream<MTUChangedEventArgs> get mtuChanged =>
      throw UnsupportedError('`mtuChanged` is not supported on Darwin.');
  @override
  Stream<GATTCharacteristicNotifiedEventArgs> get characteristicNotified =>
      _characteristicNotifiedController.stream;

  @override
  Future<void> initialize() async {
    MyCentralManagerFlutterAPI.setUp(this);
    logger.info('initialize');
    await _api.initialize();
  }

  @override
  Future<void> startDiscovery({
    List<UUID>? serviceUUIDs,
  }) async {
    final serviceUUIDsArgs =
        serviceUUIDs?.map((uuid) => uuid.toArgs()).toList() ?? [];
    logger.info('startDiscovery: $serviceUUIDsArgs');
    await _api.startDiscovery(serviceUUIDsArgs);
  }

  @override
  Future<void> stopDiscovery() async {
    logger.info('stopDiscovery');
    await _api.stopDiscovery();
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() async {
    logger.info('retrieveConnectedPeripherals');
    final peripheralsArgs = await _api.retrieveConnectedPeripherals();
    final peripherals = peripheralsArgs.cast<MyPeripheralArgs>().map((args) {
      final peripheral = _peripherals.putIfAbsent(
        args.uuidArgs,
        () => args.toPeripheral(),
      );
      return peripheral;
    }).toList();
    return peripherals;
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    final uuidArgs = peripheral.uuid.toArgs();
    logger.info('connect: $uuidArgs');
    await _api.connect(uuidArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    final uuidArgs = peripheral.uuid.toArgs();
    logger.info('disconnect: $uuidArgs');
    await _api.disconnect(uuidArgs);
  }

  @override
  Future<int> requestMTU(Peripheral peripheral, int mtu) {
    throw UnsupportedError("Darwin doesn't support request MTU.");
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    final uuidArgs = peripheral.uuid.toArgs();
    logger.info('readRSSI: $uuidArgs');
    final rssi = await _api.readRSSI(uuidArgs);
    return rssi;
  }

  @override
  Future<List<GATTService>> discoverGATT(Peripheral peripheral) async {
    // 发现 GATT 服务
    final uuidArgs = peripheral.uuid.toArgs();
    logger.info('discoverServices: $uuidArgs');
    final servicesArgs = await _api
        .discoverServices(uuidArgs)
        .then((args) => args.cast<MyGATTServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      // 发现 GATT 特征值
      final hashCodeArgs = serviceArgs.hashCodeArgs;
      logger.info('discoverCharacteristics: $uuidArgs.$hashCodeArgs');
      final characteristicsArgs = await _api
          .discoverCharacteristics(uuidArgs, hashCodeArgs)
          .then((args) => args.cast<MyGATTCharacteristicArgs>());
      for (var characteristicArgs in characteristicsArgs) {
        // 发现 GATT 描述值
        final hashCodeArgs = characteristicArgs.hashCodeArgs;
        logger.info('discoverDescriptors: $uuidArgs.$hashCodeArgs');
        final descriptorsArgs = await _api
            .discoverDescriptors(uuidArgs, hashCodeArgs)
            .then((args) => args.cast<MyGATTDescriptorArgs>());
        characteristicArgs.descriptorsArgs = descriptorsArgs;
      }
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    final services =
        servicesArgs.map((args) => args.toService(peripheral)).toList();
    final characteristics =
        services.expand((service) => service.characteristics).toList();
    _characteristics[uuidArgs] = {
      for (var characteristic in characteristics)
        characteristic.hashCode: characteristic
    };
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
    GATTCharacteristic characteristic,
  ) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    logger.info('readCharacteristic: $uuidArgs.$hashCodeArgs');
    final value = await _api.readCharacteristic(uuidArgs, hashCodeArgs);
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  }) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final trimmedValueArgs = value.trimGATT();
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    final fragmentSize = await _api.maximumWriteValueLength(
      uuidArgs,
      typeNumberArgs,
    );
    var start = 0;
    while (start < trimmedValueArgs.length) {
      final end = start + fragmentSize;
      final fragmentedValueArgs = end < trimmedValueArgs.length
          ? trimmedValueArgs.sublist(start, end)
          : trimmedValueArgs.sublist(start);
      logger.info(
          'writeCharacteristic: $uuidArgs.$hashCodeArgs - $fragmentedValueArgs, $typeArgs');
      await _api.writeCharacteristic(
        uuidArgs,
        hashCodeArgs,
        fragmentedValueArgs,
        typeNumberArgs,
      );
      start = end;
    }
  }

  @override
  Future<void> setCharacteristicNotifyState(
    GATTCharacteristic characteristic, {
    required bool state,
  }) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final stateArgs = state;
    logger.info(
        'setCharacteristicNotifyState: $uuidArgs.$hashCodeArgs - $stateArgs');
    await _api.setCharacteristicNotifyState(
      uuidArgs,
      hashCodeArgs,
      stateArgs,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GATTDescriptor descriptor) async {
    if (descriptor is! MyGATTDescriptor) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = descriptor.hashCode;
    logger.info('readDescriptor: $uuidArgs.$hashCodeArgs');
    final value = await _api.readDescriptor(
      uuidArgs,
      hashCodeArgs,
    );
    return value;
  }

  @override
  Future<void> writeDescriptor(
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (descriptor is! MyGATTDescriptor) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = descriptor.hashCode;
    final trimmedValueArgs = value.trimGATT();
    logger.info('writeDescriptor: $uuidArgs.$hashCodeArgs - $trimmedValueArgs');
    await _api.writeDescriptor(uuidArgs, hashCodeArgs, trimmedValueArgs);
  }

  @override
  void onStateChanged(int stateNumberArgs) {
    final stateArgs = MyBluetoothLowEnergyStateArgs.values[stateNumberArgs];
    logger.info('onStateChanged: $stateArgs');
    final state = stateArgs.toState();
    if (_state == state) {
      return;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssiArgs,
    MyAdvertisementArgs advertisementArgs,
  ) {
    final uuidArgs = peripheralArgs.uuidArgs;
    logger.info('onDiscovered: $uuidArgs - $rssiArgs, $advertisementArgs');
    final peripheral = _peripherals.putIfAbsent(
      peripheralArgs.uuidArgs,
      () => peripheralArgs.toPeripheral(),
    );
    final rssi = rssiArgs;
    final advertisement = advertisementArgs.toAdvertisement();
    final eventArgs = DiscoveredEventArgs(
      peripheral,
      rssi,
      advertisement,
    );
    _discoveredController.add(eventArgs);
  }

  @override
  void onConnectionStateChanged(
    String uuidArgs,
    bool stateArgs,
  ) {
    logger.info('onConnectionStateChanged: $uuidArgs - $stateArgs');
    final peripheral = _peripherals[uuidArgs];
    if (peripheral == null) {
      return;
    }
    final state = stateArgs;
    final eventArgs = ConnectionStateChangedEventArgs(peripheral, state);
    _connectionStateChangedController.add(eventArgs);
    if (!state) {
      _characteristics.remove(uuidArgs);
    }
  }

  @override
  void onCharacteristicNotified(
    String uuidArgs,
    int hashCodeArgs,
    Uint8List valueArgs,
  ) {
    logger
        .info('onCharacteristicNotified: $uuidArgs.$hashCodeArgs - $valueArgs');
    final characteristic = _retrieveCharacteristic(uuidArgs, hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final value = valueArgs;
    final eventArgs = GATTCharacteristicNotifiedEventArgs(
      characteristic,
      value,
    );
    _characteristicNotifiedController.add(eventArgs);
  }

  MyGATTCharacteristic? _retrieveCharacteristic(
    String uuidArgs,
    int hashCodeArgs,
  ) {
    final characteristics = _characteristics[uuidArgs];
    if (characteristics == null) {
      return null;
    }
    return characteristics[hashCodeArgs];
  }
}
