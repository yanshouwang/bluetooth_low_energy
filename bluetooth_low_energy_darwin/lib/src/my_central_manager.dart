import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';

class MyCentralManager extends CentralManager
    implements MyCentralManagerFlutterApi {
  final MyCentralManagerHostApi _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<ConnectionStateChangedEventArgs>
      _connectionStateChangedController;
  final StreamController<GattCharacteristicNotifiedEventArgs>
      _characteristicNotifiedController;
  final Map<String, MyPeripheral> _peripherals;
  final Map<String, Map<int, MyGattCharacteristic2>> _characteristics;

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
    await _api.setUp();
    MyCentralManagerFlutterApi.setup(this);
  }

  @override
  Future<BluetoothLowEnergyState> getState() {
    return Future.value(_state);
  }

  @override
  Future<void> startDiscovery() async {
    await _api.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _api.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    await _api.connect(uuidArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    await _api.disconnect(uuidArgs);
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final rssi = await _api.readRSSI(uuidArgs);
    return rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    // 发现 GATT 服务
    final servicesArgs = await _api
        .discoverServices(uuidArgs)
        .then((args) => args.cast<MyGattServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      // 发现 GATT 特征值
      final characteristicsArgs = await _api
          .discoverCharacteristics(uuidArgs, serviceArgs.hashCodeArgs)
          .then((args) => args.cast<MyGattCharacteristicArgs>());
      for (var characteristicArgs in characteristicsArgs) {
        // 发现 GATT 描述值
        final descriptorsArgs = await _api
            .discoverDescriptors(uuidArgs, characteristicArgs.hashCodeArgs)
            .then((args) => args.cast<MyGattDescriptorArgs>());
        characteristicArgs.descriptorsArgs = descriptorsArgs;
      }
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    final services =
        servicesArgs.map((args) => args.toService2(peripheral)).toList();
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
    GattCharacteristic characteristic,
  ) async {
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final value = await _api.readCharacteristic(uuidArgs, hashCodeArgs);
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
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final trimmedValueArgs = value.trimGATT();
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    final fragmentSize = await _api.getMaximumWriteValueLength(
      uuidArgs,
      typeNumberArgs,
    );
    var start = 0;
    while (start < trimmedValueArgs.length) {
      final end = start + fragmentSize;
      final fragmentedValueArgs = end < trimmedValueArgs.length
          ? trimmedValueArgs.sublist(start, end)
          : trimmedValueArgs.sublist(start);
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
    GattCharacteristic characteristic, {
    required bool state,
  }) async {
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final stateArgs = state;
    await _api.setCharacteristicNotifyState(
      uuidArgs,
      hashCodeArgs,
      stateArgs,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = descriptor.hashCode;
    final value = await _api.readDescriptor(
      uuidArgs,
      hashCodeArgs,
    );
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
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = descriptor.hashCode;
    final valueArgs = value;
    await _api.writeDescriptor(
      uuidArgs,
      hashCodeArgs,
      valueArgs,
    );
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
    final eventArgs = GattCharacteristicNotifiedEventArgs(
      characteristic,
      value,
    );
    _characteristicNotifiedController.add(eventArgs);
  }

  MyGattCharacteristic2? _retrieveCharacteristic(
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
