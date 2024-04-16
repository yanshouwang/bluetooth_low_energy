import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_channels.dart';
import 'my_gatt_characteristic.dart';
import 'my_gatt_descriptor.dart';
import 'my_peripheral.dart';

base class MyCentralManager extends BaseCentralManager
    implements MyCentralManagerEventChannel {
  final MyCentralManagerMessageChannel _channel;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<ConnectionStateChangedEventArgs>
      _connectionStateChangedController;
  final StreamController<GattCharacteristicNotifiedEventArgs>
      _characteristicNotifiedController;

  final Map<String, MyPeripheral> _peripherals;
  final Map<String, Map<int, MyGattCharacteristic>> _characteristics;
  final Map<String, int> _mtus;

  BluetoothLowEnergyState _state;

  MyCentralManager()
      : _channel = MyCentralManagerMessageChannel(),
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
  void initialize() async {
    logger.info('initialize');
    MyCentralManagerEventChannel.setUp(this);
    await _channel.initialize();
  }

  @override
  Future<void> authorize() async {
    logger.info('authorize');
    await _channel.authorize();
  }

  @override
  Future<BluetoothLowEnergyState> getState() {
    logger.info('getState');
    return Future.value(_state);
  }

  @override
  Future<void> startDiscovery({
    List<UUID>? serviceUUIDs,
  }) async {
    logger.info('startDiscovery');
    final serviceUUIDsArgs =
        serviceUUIDs?.map((uuid) => uuid.toArgs()).toList() ?? [];
    await _channel.startDiscovery(serviceUUIDsArgs);
  }

  @override
  Future<void> stopDiscovery() async {
    logger.info('stopDiscovery');
    await _channel.stopDiscovery();
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() async {
    logger.info('retrieveConnectedPeripherals');
    final peripheralsArgs = await _channel.retrieveConnectedPeripherals();
    final peripherals = peripheralsArgs.cast<MyPeripheralArgs>().map((args) {
      final peripheral = _peripherals.putIfAbsent(
        args.addressArgs,
        () => args.toPeripheral(),
      );
      return peripheral;
    }).toList();
    return peripherals;
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('connect: $addressArgs');
    await _channel.connect(addressArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('disconnect: $addressArgs');
    await _channel.disconnect(addressArgs);
  }

  @override
  Future<int> requestMTU(Peripheral peripheral, int mtu) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final mtuArgs = mtu;
    logger.info('requestMTU: $addressArgs - $mtuArgs');
    final size = await _channel.requestMTU(addressArgs, mtuArgs);
    return size;
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('readRSSI: $addressArgs');
    final rssi = await _channel.readRSSI(addressArgs);
    return rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('discoverServices: $addressArgs');
    final servicesArgs = await _channel.discoverServices(addressArgs);
    final services = servicesArgs
        .cast<MyGattServiceArgs>()
        .map((args) => args.toService(peripheral))
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
    if (characteristic is! MyGattCharacteristic) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final addressArgs = peripheral.address;
    final hashCodeArgs = characteristic.hashCode;
    logger.info('readCharacteristic: $addressArgs.$hashCodeArgs');
    final value = await _channel.readCharacteristic(addressArgs, hashCodeArgs);
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) async {
    if (characteristic is! MyGattCharacteristic) {
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
      logger.info(
          'writeCharacteristic: $addressArgs.$hashCodeArgs - $trimmedValueArgs, $typeArgs');
      await _channel.writeCharacteristic(
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
        logger.info(
            'writeCharacteristic: $addressArgs.$hashCodeArgs - $fragmentedValueArgs, $typeArgs');
        await _channel.writeCharacteristic(
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
    if (characteristic is! MyGattCharacteristic) {
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
    logger.info(
        'setCharacteristicNotifyState: $addressArgs.$hashCodeArgs - $stateArgs');
    await _channel.setCharacteristicNotifyState(
      addressArgs,
      hashCodeArgs,
      stateNumberArgs,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    if (descriptor is! MyGattDescriptor) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final addressArgs = peripheral.address;
    final hashCodeArgs = descriptor.hashCode;
    logger.info('readDescriptor: $addressArgs.$hashCodeArgs');
    final value = await _channel.readDescriptor(addressArgs, hashCodeArgs);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (descriptor is! MyGattDescriptor) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final addressArgs = peripheral.address;
    final hashCodeArgs = descriptor.hashCode;
    final trimmedValueArgs = value.trimGATT();
    logger.info(
        'writeDescriptor: $addressArgs.$hashCodeArgs - $trimmedValueArgs');
    await _channel.writeDescriptor(addressArgs, hashCodeArgs, trimmedValueArgs);
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
    final peripheral = _peripherals[addressArgs];
    if (peripheral == null) {
      return;
    }
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

  MyGattCharacteristic? _retrieveCharacteristic(
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
