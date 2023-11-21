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

  MyCentralManager2()
      : _api = MyCentralManagerHostApi(),
        _state = BluetoothLowEnergyState.unknown,
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast();

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
    final peripheralArgs = peripheral.toArgs();
    await _api.connect(peripheralArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final peripheralArgs = peripheral.toArgs();
    await _api.disconnect(peripheralArgs);
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GattCharacteristicWriteType type,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final peripheralArgs = peripheral.toArgs();
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    final maximumWriteLength = await _api.getMaximumWriteLength(
      peripheralArgs,
      typeNumberArgs,
    );
    return maximumWriteLength;
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final peripheralArgs = peripheral.toArgs();
    final rssi = await _api.readRSSI(peripheralArgs);
    return rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final peripheralArgs = peripheral.toArgs();
    // 发现 GATT 服务
    final servicesArgs = await _api
        .discoverServices(peripheralArgs)
        .then((args) => args.cast<MyGattServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      // 发现 GATT 特征值
      final characteristicsArgs = await _api
          .discoverCharacteristics(peripheralArgs, serviceArgs)
          .then((args) => args.cast<MyGattCharacteristicArgs>());
      for (var characteristicArgs in characteristicsArgs) {
        // 发现 GATT 描述值
        final descriptorsArgs = await _api
            .discoverDescriptors(peripheralArgs, characteristicArgs)
            .then((args) => args.cast<MyGattDescriptorArgs>());
        characteristicArgs.descriptorsArgs = descriptorsArgs;
      }
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    final services =
        servicesArgs.map((args) => args.toService2(peripheral)).toList();
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
    final peripheralArgs = peripheral.toArgs();
    final characteristicArgs = characteristic.toArgs();
    final value = await _api.readCharacteristic(
      peripheralArgs,
      characteristicArgs,
    );
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
    final peripheralArgs = peripheral.toArgs();
    final characteristicArgs = characteristic.toArgs();
    final valueArgs = value;
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    await _api.writeCharacteristic(
      peripheralArgs,
      characteristicArgs,
      valueArgs,
      typeNumberArgs,
    );
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
    final peripheralArgs = peripheral.toArgs();
    final characteristicArgs = characteristic.toArgs();
    final stateArgs = state;
    await _api.notifyCharacteristic(
      peripheralArgs,
      characteristicArgs,
      stateArgs,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final peripheralArgs = peripheral.toArgs();
    final descriptorArgs = descriptor.toArgs();
    final value = await _api.readDescriptor(
      peripheralArgs,
      descriptorArgs,
    );
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
    final peripheralArgs = peripheral.toArgs();
    final descriptorArgs = descriptor.toArgs();
    final valueArgs = value;
    await _api.writeDescriptor(
      peripheralArgs,
      descriptorArgs,
      valueArgs,
    );
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
    final peripheral = peripheralArgs.toPeripheral();
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
  void onPeripheralStateChanged(
    MyPeripheralArgs peripheralArgs,
    bool stateArgs,
  ) {
    final peripheral = peripheralArgs.toPeripheral();
    final state = stateArgs;
    final eventArgs = PeripheralStateChangedEventArgs(peripheral, state);
    _peripheralStateChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicValueChanged(
    MyPeripheralArgs peripheralArgs,
    MyGattCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  ) {
    final peripheral = peripheralArgs.toPeripheral();
    final characteristic = characteristicArgs.toCharacteristic2(peripheral);
    final value = valueArgs;
    final eventArgs = GattCharacteristicValueChangedEventArgs(
      characteristic,
      value,
    );
    _characteristicValueChangedController.add(eventArgs);
  }
}
