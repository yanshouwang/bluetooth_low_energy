import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';
import 'my_peripheral2.dart';

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

  final Map<String, MyPeripheral2> _peripherals;
  final Map<String, Map<int, MyGattCharacteristic2>> _characteristics;
  final Map<String, int> _mtus;

  BluetoothLowEnergyState _state;

  MyCentralManager()
      : _api = MyCentralManagerHostApi(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _characteristicNotifiedController = StreamController.broadcast(),
        _peripherals = {},
        _characteristics = {},
        _mtus = {},
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
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    await _api.disconnect(addressArgs);
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final rssi = await _api.readRSSI(addressArgs);
    return rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final servicesArgs = await _api.discoverGATT(addressArgs);
    final services = servicesArgs
        .cast<MyGattServiceArgs>()
        .map((args) => args.toService2(peripheral))
        .toList();
    final characteristics =
        services.expand((service) => service.characteristics).toList();
    _characteristics[addressArgs] = {
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
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final addressArgs = peripheral.address;
    final hashCodeArgs = characteristic.hashCode;
    final trimmedValueArgs = value.trimGATT();
    final typeArgs = type.toArgs();
    final typeNumberArgs = typeArgs.index;
    // When write without response, fragments the value by MTU - 3 size.
    // If mtu is null, use 23 as default MTU size.
    if (type == GattCharacteristicWriteType.withResponse) {
      await _api.writeCharacteristic(
        addressArgs,
        hashCodeArgs,
        trimmedValueArgs,
        typeNumberArgs,
      );
    } else {
      final mtu = _mtus[addressArgs] ?? 23;
      final fragmentSize = (mtu - 3).clamp(20, 512);
      var start = 0;
      while (start < trimmedValueArgs.length) {
        final end = start + fragmentSize;
        final fragmentedValueArgs = end < trimmedValueArgs.length
            ? trimmedValueArgs.sublist(start, end)
            : trimmedValueArgs.sublist(start);
        await _api.writeCharacteristic(
          addressArgs,
          hashCodeArgs,
          fragmentedValueArgs,
          typeNumberArgs,
        );
        start = end;
      }
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
    final addressArgs = peripheral.address;
    final hashCodeArgs = characteristic.hashCode;
    final stateArgs = state
        ? characteristic.properties.contains(GattCharacteristicProperty.notify)
            ? MyGattCharacteristicNotifyStateArgs.notify
            : MyGattCharacteristicNotifyStateArgs.indicate
        : MyGattCharacteristicNotifyStateArgs.none;
    final stateNumberArgs = stateArgs.index;
    await _api.setCharacteristicNotifyState(
      addressArgs,
      hashCodeArgs,
      stateNumberArgs,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
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
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final addressArgs = peripheral.address;
    final hashCodeArgs = descriptor.hashCode;
    final valueArgs = value;
    await _api.writeDescriptor(addressArgs, hashCodeArgs, valueArgs);
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
  void onConnectionStateChanged(String addressArgs, bool stateArgs) {
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
      _mtus.remove(addressArgs);
    }
  }

  @override
  void onMtuChanged(String addressArgs, int mtuArgs) {
    logger.info('onMtuChanged: $addressArgs - $mtuArgs');
    final mtu = mtuArgs;
    _mtus[addressArgs] = mtu;
  }

  @override
  void onCharacteristicNotified(
    String addressArgs,
    int hashCodeArgs,
    Uint8List valueArgs,
  ) {
    logger.info(
        'onCharacteristicNotified: $addressArgs.$hashCodeArgs - $valueArgs');
    final characteristic = _retrieveCharacteristic(addressArgs, hashCodeArgs);
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
    String addressArgs,
    int hashCodeArgs,
  ) {
    final characteristics = _characteristics[addressArgs];
    if (characteristics == null) {
      return null;
    }
    return characteristics[hashCodeArgs];
  }
}
