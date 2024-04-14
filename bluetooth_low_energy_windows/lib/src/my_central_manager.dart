import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';

class MyCentralManager extends CentralManagerAPI
    implements MyCentralManagerFlutterApi {
  final MyCentralManagerHostApi _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<ConnectionStateChangedEventArgs>
      _connectionStateChangedController;
  final StreamController<GattCharacteristicNotifiedEventArgs>
      _characteristicNotifiedController;

  final Map<int, MyPeripheral> _peripherals;
  final Map<int, Map<int, MyGattCharacteristic2>> _characteristics;

  BluetoothLowEnergyState _state;

  MyCentralManager()
      : _api = MyCentralManagerHostApi(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _characteristicNotifiedController = StreamController.broadcast(),
        _peripherals = {},
        _characteristics = {},
        _state = BluetoothLowEnergyState.unknown;

  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<DiscoveredEventArgs> get discovered => _discoveredController.stream;
  @override
  Stream<ConnectionStateChangedEventArgs> get connectionStateChanged =>
      _connectionStateChangedController.stream;
  @override
  Stream<GattCharacteristicNotifiedEventArgs> get characteristicNotified =>
      _characteristicNotifiedController.stream;

  @override
  Future<void> setUp() async {
    logger.info('setUp');
    await _api.setUp();
    MyCentralManagerFlutterApi.setup(this);
  }

  @override
  Future<BluetoothLowEnergyState> getState() {
    logger.info('getState');
    return Future.value(_state);
  }

  @override
  Future<void> startDiscovery() async {
    logger.info('startDiscovery');
    await _api.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    logger.info('stopDiscovery');
    await _api.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.uuid.toAddressArgs();
    logger.info('connect: $addressArgs');
    await _api.connect(addressArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.uuid.toAddressArgs();
    logger.info('disconnect: $addressArgs');
    await _api.disconnect(addressArgs);
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.uuid.toAddressArgs();
    logger.info('readRSSI: $addressArgs');
    // TODO: Windows doesn't support read RSSI after connected.
    throw UnimplementedError();
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    // 发现 GATT 服务
    final addressArgs = peripheral.uuid.toAddressArgs();
    logger.info('discoverServices: $addressArgs');
    final servicesArgs = await _api
        .discoverServices(addressArgs)
        .then((args) => args.cast<MyGattServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      // 发现 GATT 特征值
      final handleArgs = serviceArgs.handleArgs;
      logger.info('discoverCharacteristics: $addressArgs.$handleArgs');
      final characteristicsArgs = await _api
          .discoverCharacteristics(addressArgs, handleArgs)
          .then((args) => args.cast<MyGattCharacteristicArgs>());
      for (var characteristicArgs in characteristicsArgs) {
        // 发现 GATT 描述值
        final handleArgs = characteristicArgs.handleArgs;
        logger.info('discoverDescriptors: $addressArgs.$handleArgs');
        final descriptorsArgs = await _api
            .discoverDescriptors(addressArgs, handleArgs)
            .then((args) => args.cast<MyGattDescriptorArgs>());
        characteristicArgs.descriptorsArgs = descriptorsArgs;
      }
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    final services =
        servicesArgs.map((args) => args.toService2(peripheral)).toList();
    final characteristics =
        services.expand((service) => service.characteristics).toList();
    _characteristics[addressArgs] = {
      for (var characteristic in characteristics)
        characteristic.handle: characteristic
    };
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
    GattCharacteristic characteristic,
  ) async {
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final addressArgs = peripheral.uuid.toAddressArgs();
    final handleArgs = characteristic.handle;
    logger.info('readCharacteristic: $addressArgs.$handleArgs');
    final value = await _api.readCharacteristic(addressArgs, handleArgs);
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) async {
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final addressArgs = peripheral.uuid.toAddressArgs();
    final handleArgs = characteristic.handle;
    final trimmedValueArgs = value.trimGATT();
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    logger.info(
        'writeCharacteristic: $addressArgs.$handleArgs - $trimmedValueArgs, $typeArgs');
    await _api.writeCharacteristic(
      addressArgs,
      handleArgs,
      trimmedValueArgs,
      typeNumberArgs,
    );
  }

  @override
  Future<void> setCharacteristicNotifyState(
    GattCharacteristic characteristic, {
    required bool state,
  }) async {
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final addressArgs = peripheral.uuid.toAddressArgs();
    final handleArgs = characteristic.handle;
    final stateArgs = state
        ? characteristic.properties.contains(GattCharacteristicProperty.notify)
            ? MyGattCharacteristicNotifyStateArgs.notify
            : MyGattCharacteristicNotifyStateArgs.indicate
        : MyGattCharacteristicNotifyStateArgs.none;
    final stateNumberArgs = stateArgs.index;
    logger.info(
        'setCharacteristicNotifyState: $addressArgs.$handleArgs - $stateArgs');
    await _api.setCharacteristicNotifyState(
      addressArgs,
      handleArgs,
      stateNumberArgs,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final addressArgs = peripheral.uuid.toAddressArgs();
    final handleArgs = descriptor.handle;
    logger.info('readDescriptor: $addressArgs.$handleArgs');
    final value = await _api.readDescriptor(addressArgs, handleArgs);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final addressArgs = peripheral.uuid.toAddressArgs();
    final handleArgs = descriptor.handle;
    final trimmedValueArgs = value.trimGATT();
    logger
        .info('writeDescriptor: $addressArgs.$handleArgs - $trimmedValueArgs');
    await _api.writeDescriptor(addressArgs, handleArgs, trimmedValueArgs);
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
    final addressArgs = peripheralArgs.addressArgs;
    logger.info('onDiscovered: $addressArgs - $rssiArgs, $advertisementArgs');
    final peripheral = _peripherals.putIfAbsent(
      peripheralArgs.addressArgs,
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
  void onConnectionStateChanged(int addressArgs, bool stateArgs) {
    logger.info('onConnectionStateChanged: $addressArgs - $stateArgs');
    final peripheral = _peripherals[addressArgs];
    if (peripheral == null) {
      return;
    }
    final state = stateArgs;
    final eventArgs = ConnectionStateChangedEventArgs(peripheral, state);
    _connectionStateChangedController.add(eventArgs);
    if (!state) {
      _characteristics.remove(addressArgs);
    }
  }

  @override
  void onCharacteristicNotified(
    int addressArgs,
    int handleArgs,
    Uint8List valueArgs,
  ) {
    logger.info(
        'onCharacteristicNotified: $addressArgs.$handleArgs - $valueArgs');
    final characteristic = _retrieveCharacteristic(addressArgs, handleArgs);
    if (characteristic == null) {
      return;
    }
    final value = valueArgs;
    final eventArgs = GattCharacteristicNotifiedEventArgs(
      characteristic,
      value,
    );
    _characteristicNotifiedController.add(eventArgs);
  }

  GattCharacteristic? _retrieveCharacteristic(int addressArgs, int handleArgs) {
    final characteristics = _characteristics[addressArgs];
    if (characteristics == null) {
      return null;
    }
    return characteristics[handleArgs];
  }
}
