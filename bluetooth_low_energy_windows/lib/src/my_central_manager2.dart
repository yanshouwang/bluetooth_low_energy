import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';

class MyCentralManager2 extends MyCentralManager
    implements MyCentralManagerFlutterApi {
  final MyCentralManagerHostApi _api;
  BluetoothLowEnergyState _state;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralStateChangedEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueChangedEventArgs>
      _characteristicValueChangedController;

  final Map<int, MyPeripheral> _peripherals;
  final Map<int, List<MyGattCharacteristic2>> _characteristics;

  MyCentralManager2()
      : _api = MyCentralManagerHostApi(),
        _state = BluetoothLowEnergyState.unknown,
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _peripherals = {},
        _characteristics = {};

  @override
  BluetoothLowEnergyState get state => _state;
  @protected
  set state(BluetoothLowEnergyState value) {
    if (_state == value) {
      return;
    }
    _state = value;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<DiscoveredEventArgs> get discovered => _discoveredController.stream;
  @override
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;
  @override
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged =>
          _characteristicValueChangedController.stream;

  Future<void> _throwWithoutState(BluetoothLowEnergyState state) async {
    if (this.state != state) {
      throw StateError(
          '$state is expected, but current state is ${this.state}.');
    }
  }

  @override
  Future<void> setUp() async {
    final args = await _api.setUp();
    final stateArgs =
        MyBluetoothLowEnergyStateArgs.values[args.stateNumberArgs];
    state = stateArgs.toState();
    MyCentralManagerFlutterApi.setup(this);
  }

  @override
  Future<void> startDiscovery() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _api.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _api.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.uuid.toAddressArgs();
    await _api.connect(addressArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.uuid.toAddressArgs();
    await _api.disconnect(addressArgs);
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    // TODO: Windows doesn't support read RSSI after connected.
    throw UnimplementedError();
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.uuid.toAddressArgs();
    // 释放 GATT 缓存
    await _api.clearGATT(addressArgs);
    // 发现 GATT 服务
    final servicesArgs = await _api
        .discoverServices(addressArgs)
        .then((args) => args.cast<MyGattServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      // 发现 GATT 特征值
      final characteristicsArgs = await _api
          .discoverCharacteristics(addressArgs, serviceArgs.handleArgs)
          .then((args) => args.cast<MyGattCharacteristicArgs>());
      for (var characteristicArgs in characteristicsArgs) {
        // 发现 GATT 描述值
        final descriptorsArgs = await _api
            .discoverDescriptors(addressArgs, characteristicArgs.handleArgs)
            .then((args) => args.cast<MyGattDescriptorArgs>());
        characteristicArgs.descriptorsArgs = descriptorsArgs;
      }
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    final services =
        servicesArgs.map((args) => args.toService2(peripheral)).toList();
    final characteristics =
        services.expand((service) => service.characteristics).toList();
    _characteristics[addressArgs] = characteristics;
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
    GattCharacteristic characteristic,
  ) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final addressArgs = peripheral.uuid.toAddressArgs();
    final handleArgs = characteristic.handle;
    final value = await _api.readCharacteristic(addressArgs, handleArgs);
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final addressArgs = peripheral.uuid.toAddressArgs();
    final handleArgs = characteristic.handle;
    final valueArgs = value;
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    if (type == GattCharacteristicWriteType.withoutResponse) {
      // When write without response, fragments the value by 512 bytes.
      var start = 0;
      while (start < valueArgs.length) {
        final end = start + 512;
        final trimmedValueArgs = end < valueArgs.length
            ? valueArgs.sublist(start, end)
            : valueArgs.sublist(start);
        await _api.writeCharacteristic(
          addressArgs,
          handleArgs,
          trimmedValueArgs,
          typeNumberArgs,
        );
        start = end;
      }
    } else {
      await _api.writeCharacteristic(
        addressArgs,
        handleArgs,
        valueArgs,
        typeNumberArgs,
      );
    }
  }

  @override
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
    await _api.notifyCharacteristic(addressArgs, handleArgs, stateNumberArgs);
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final addressArgs = peripheral.uuid.toAddressArgs();
    final handleArgs = descriptor.handle;
    final value = await _api.readDescriptor(addressArgs, handleArgs);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final addressArgs = peripheral.uuid.toAddressArgs();
    final handleArgs = descriptor.handle;
    final valueArgs = value;
    await _api.writeDescriptor(addressArgs, handleArgs, valueArgs);
  }

  @override
  void onStateChanged(int stateNumberArgs) {
    final stateArgs = MyBluetoothLowEnergyStateArgs.values[stateNumberArgs];
    state = stateArgs.toState();
  }

  @override
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssiArgs,
    MyAdvertisementArgs advertisementArgs,
  ) {
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
  void onPeripheralStateChanged(int addressArgs, bool stateArgs) {
    final peripheral = _peripherals[addressArgs];
    if (peripheral == null) {
      return;
    }
    final state = stateArgs;
    final eventArgs = PeripheralStateChangedEventArgs(peripheral, state);
    _peripheralStateChangedController.add(eventArgs);
    if (!state) {
      _characteristics.remove(addressArgs);
    }
  }

  @override
  void onCharacteristicValueChanged(
    int addressArgs,
    int handleArgs,
    Uint8List valueArgs,
  ) {
    final characteristic = _retrieveCharacteristic(addressArgs, handleArgs);
    if (characteristic == null) {
      return;
    }
    final value = valueArgs;
    final eventArgs = GattCharacteristicValueChangedEventArgs(
      characteristic,
      value,
    );
    _characteristicValueChangedController.add(eventArgs);
  }

  GattCharacteristic? _retrieveCharacteristic(int addressArgs, int handleArgs) {
    final characteristics = _characteristics[addressArgs];
    if (characteristics == null) {
      return null;
    }
    final i = characteristics
        .indexWhere((characteristic) => characteristic.handle == handleArgs);
    if (i < 0) {
      return null;
    }
    return characteristics[i];
  }
}
