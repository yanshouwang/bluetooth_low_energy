import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_bluetooth_low_energy_manager.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';

class MyCentralManager extends MyBluetoothLowEnergyManager
    implements CentralManager, MyCentralManagerFlutterApi {
  final MyCentralManagerHostApi _api;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralStateChangedEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueChangedEventArgs>
      _characteristicValueChangedController;

  MyCentralManager()
      : _api = MyCentralManagerHostApi(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast();

  @override
  Stream<DiscoveredEventArgs> get discovered => _discoveredController.stream;
  @override
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;
  @override
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged =>
          _characteristicValueChangedController.stream;

  Future<void> setUp() async {
    final args = await _api.setUp();
    final stateArgs =
        MyBluetoothLowEnergyStateArgs.values[args.stateNumberArgs];
    state = stateArgs.toState();
    MyCentralManagerFlutterApi.setup(this);
  }

  @override
  Future<void> startDiscovery() async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _api.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _api.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final peripheralHashCodeArgs = peripheral.hashCode;
    await _api.connect(peripheralHashCodeArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final peripheralHashCodeArgs = peripheral.hashCode;
    await _api.disconnect(peripheralHashCodeArgs);
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GattCharacteristicWriteType type,
  }) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final peripheralHashCodeArgs = peripheral.hashCode;
    final maximumWriteLength =
        await _api.getMaximumWriteLength(peripheralHashCodeArgs);
    return maximumWriteLength;
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final peripheralHashCodeArgs = peripheral.hashCode;
    final rssi = await _api.readRSSI(peripheralHashCodeArgs);
    return rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
    GattCharacteristic characteristic,
  ) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
