import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';

class MyCentralManager extends CentralManager
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

  MyCentralManager()
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
      throw BluetoothLowEnergyError(
        '$state is expected, but current state is ${this.state}.',
      );
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
    final peripheralHashCodeArgs = peripheral.hashCode;
    await _api.connect(peripheralHashCodeArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final peripheralHashCodeArgs = peripheral.hashCode;
    await _api.disconnect(peripheralHashCodeArgs);
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GattCharacteristicWriteType type,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final peripheralHashCodeArgs = peripheral.hashCode;
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    final maximumWriteLength = await _api.getMaximumWriteLength(
      peripheralHashCodeArgs,
      typeNumberArgs,
    );
    return maximumWriteLength;
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final peripheralHashCodeArgs = peripheral.hashCode;
    final rssi = await _api.readRSSI(peripheralHashCodeArgs);
    return rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final peripheralHashCodeArgs = peripheral.hashCode;
    final servicesArgs = await _api.discoverGATT(peripheralHashCodeArgs);
    final services = servicesArgs
        .cast<MyGattServiceArgs>()
        .map((args) => args.toService2())
        .toList();
    for (var service in services) {
      for (var charactersitic in service.characteristics) {
        for (var descriptor in charactersitic.descriptors) {
          descriptor.characteristic = charactersitic;
        }
        charactersitic.service = service;
      }
      service.peripheral = peripheral;
    }
    try {
      // 部分外围设备连接后会触发 onMtuChanged 回调，若在此之前调用协商 MTU 的方法，会在协商完成前返回，
      // 此时如果继续调用其他方法（如发现服务）会导致回调无法触发，
      // 因此为避免此情况发生，需要延迟到发现服务完成后再协商 MTU。
      // TODO: 思考更好的解决方式，可以在连接后立即协商 MTU。
      const mtuArgs = 517;
      await _api.requestMTU(peripheralHashCodeArgs, mtuArgs);
    } catch (error, stackTrace) {
      // 忽略协商 MTU 错误
      Logger.warning('requst MTU failed.', error, stackTrace);
    }
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
    final service = characteristic.service;
    final peripheral = service.peripheral;
    final peripheralHashCodeArgs = peripheral.hashCode;
    final characteristcHashCodeArgs = characteristic.hashCode;
    final value = await _api.readCharacteristic(
      peripheralHashCodeArgs,
      characteristcHashCodeArgs,
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
    final service = characteristic.service;
    final peripheral = service.peripheral;
    final peripheralHashCodeArgs = peripheral.hashCode;
    final characteristcHashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    await _api.writeCharacteristic(
      peripheralHashCodeArgs,
      characteristcHashCodeArgs,
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
    final service = characteristic.service;
    final peripheral = service.peripheral;
    final peripheralHashCodeArgs = peripheral.hashCode;
    final characteristcHashCodeArgs = characteristic.hashCode;
    final stateArgs = state;
    await _api.notifyCharacteristic(
      peripheralHashCodeArgs,
      characteristcHashCodeArgs,
      stateArgs,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final characteristic = descriptor.characteristic;
    final service = characteristic.service;
    final peripheral = service.peripheral;
    final peripheralHashCodeArgs = peripheral.hashCode;
    final descriptorHashCodeArgs = descriptor.hashCode;
    final value = await _api.readDescriptor(
      peripheralHashCodeArgs,
      descriptorHashCodeArgs,
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
    final characteristic = descriptor.characteristic;
    final service = characteristic.service;
    final peripheral = service.peripheral;
    final peripheralHashCodeArgs = peripheral.hashCode;
    final descriptorHashCodeArgs = descriptor.hashCode;
    final valueArgs = value;
    await _api.writeDescriptor(
      peripheralHashCodeArgs,
      descriptorHashCodeArgs,
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
    MyGattCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  ) {
    final characteristic = characteristicArgs.toCharacteristic2();
    final value = valueArgs;
    final eventArgs = GattCharacteristicValueChangedEventArgs(
      characteristic,
      value,
    );
    _characteristicValueChangedController.add(eventArgs);
  }
}
