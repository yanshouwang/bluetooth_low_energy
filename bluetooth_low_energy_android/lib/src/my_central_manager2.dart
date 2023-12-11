import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';
import 'my_peripheral2.dart';

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
  final Map<String, MyPeripheral2> _peripherals;
  final Map<String, List<MyGattCharacteristic2>> _characteristics;
  final Map<String, int> _mtus;

  MyCentralManager2()
      : _api = MyCentralManagerHostApi(),
        _state = BluetoothLowEnergyState.unknown,
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _peripherals = {},
        _characteristics = {},
        _mtus = {};

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
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    await _api.connect(addressArgs);
    try {
      await _api.requestMTU(addressArgs, 517);
    } catch (error, stackTrace) {
      // 忽略协商 MTU 错误
      logger.warning('requstMTU failed.', error, stackTrace);
    }
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    await _api.disconnect(addressArgs);
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final rssi = await _api.readRSSI(addressArgs);
    return rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final servicesArgs = await _api.discoverGATT(addressArgs);
    final services = servicesArgs
        .cast<MyGattServiceArgs>()
        .map((args) => args.toService2())
        .toList();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        for (var descriptor in characteristic.descriptors) {
          descriptor.characteristic = characteristic;
        }
        characteristic.service = service;
      }
      service.peripheral = peripheral;
    }
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
    final service = characteristic.service;
    final peripheral = service.peripheral;
    final addressArgs = peripheral.address;
    final hashCodeArgs = characteristic.hashCode;
    final value = await _api.readCharacteristic(addressArgs, hashCodeArgs);
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
    final addressArgs = peripheral.address;
    final hashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    await _api.writeCharacteristic(
      addressArgs,
      hashCodeArgs,
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
    final addressArgs = peripheral.address;
    final hashCodeArgs = characteristic.hashCode;
    final stateArgs = state;
    await _api.notifyCharacteristic(
      addressArgs,
      hashCodeArgs,
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
    final addressArgs = peripheral.address;
    final hashCodeArgs = descriptor.hashCode;
    final value = await _api.readDescriptor(addressArgs, hashCodeArgs);
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
    final addressArgs = peripheral.address;
    final hashCodeArgs = descriptor.hashCode;
    final valueArgs = value;
    await _api.writeDescriptor(addressArgs, hashCodeArgs, valueArgs);
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
  void onPeripheralStateChanged(String addressArgs, bool stateArgs) {
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
  void onMtuChanged(String addressArgs, int mtuArgs) {
    final address = addressArgs;
    final mtu = mtuArgs;
    _mtus[address] = mtu;
    logger.info('onMtuChanged: $addressArgs - $mtu');
  }

  @override
  void onCharacteristicValueChanged(int hashCodeArgs, Uint8List valueArgs) {
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
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

  MyGattCharacteristic2? _retrieveCharacteristic(int hashCodeArgs) {
    final characteristics = _characteristics.values
        .expand((characteristics) => characteristics)
        .toList();
    final i = characteristics.indexWhere(
        (characteristic) => characteristic.hashCode == hashCodeArgs);
    if (i < 0) {
      return null;
    }
    return characteristics[i];
  }
}
