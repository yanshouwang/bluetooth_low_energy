import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_api.g.dart';
import 'my_gatt.dart';
import 'my_peripheral.dart';

final class MyCentralManager extends BaseCentralManager
    implements MyCentralManagerFlutterAPI {
  final MyCentralManagerHostAPI _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralConnectionStateChangedEventArgs>
      _connectionStateChangedController;
  final StreamController<PeripheralMTUChangedEventArgs> _mtuChangedController;
  final StreamController<GATTCharacteristicNotifiedEventArgs>
      _characteristicNotifiedController;

  final Map<int, Peripheral> _peripherals;
  final Map<int, Map<int, MyGATTCharacteristic>> _characteristics;

  BluetoothLowEnergyState _state;

  MyCentralManager()
      : _api = MyCentralManagerHostAPI(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _mtuChangedController = StreamController.broadcast(),
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
  Stream<PeripheralConnectionStateChangedEventArgs>
      get connectionStateChanged => _connectionStateChangedController.stream;
  @override
  Stream<PeripheralMTUChangedEventArgs> get mtuChanged =>
      _mtuChangedController.stream;
  @override
  Stream<GATTCharacteristicNotifiedEventArgs> get characteristicNotified =>
      _characteristicNotifiedController.stream;

  @override
  void initialize() {
    MyCentralManagerFlutterAPI.setUp(this);
    _initialize();
  }

  @override
  Future<bool> authorize() {
    throw UnsupportedError('authorize is not supported on Windows.');
  }

  @override
  Future<void> showAppSettings() {
    throw UnsupportedError('showAppSettings is not supported on Windows.');
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
  Future<List<Peripheral>> retrieveConnectedPeripherals() {
    throw UnsupportedError(
        'retrieveConnectedPeripherals is not supported on Windows.');
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('connect: $addressArgs');
    await _api.connect(addressArgs);
    onConnectionStateChanged(addressArgs, MyConnectionStateArgs.connected);
    _updateMTU(addressArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('disconnect: $addressArgs');
    await _api.disconnect(addressArgs);
    onConnectionStateChanged(addressArgs, MyConnectionStateArgs.disconnected);
  }

  @override
  Future<int> requestMTU(Peripheral peripheral, int mtu) {
    throw UnsupportedError('requestMTU is not supported on Windows.');
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    throw UnsupportedError('readRSSI is not supported on Windows.');
  }

  @override
  Future<List<GATTService>> discoverGATT(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    // 发现 GATT 服务
    final addressArgs = peripheral.address;
    logger.info('discoverServices: $addressArgs');
    final servicesArgs = await _api
        .discoverServices(addressArgs)
        .then((args) => args.cast<MyGATTServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      // 发现 GATT 特征值
      final handleArgs = serviceArgs.handleArgs;
      logger.info('discoverCharacteristics: $addressArgs.$handleArgs');
      final characteristicsArgs = await _api
          .discoverCharacteristics(addressArgs, handleArgs)
          .then((args) => args.cast<MyGATTCharacteristicArgs>());
      for (var characteristicArgs in characteristicsArgs) {
        // 发现 GATT 描述值
        final handleArgs = characteristicArgs.handleArgs;
        logger.info('discoverDescriptors: $addressArgs.$handleArgs');
        final descriptorsArgs = await _api
            .discoverDescriptors(addressArgs, handleArgs)
            .then((args) => args.cast<MyGATTDescriptorArgs>());
        characteristicArgs.descriptorsArgs = descriptorsArgs;
      }
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    final services =
        servicesArgs.map((args) => args.toService(peripheral)).toList();
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
    GATTCharacteristic characteristic,
  ) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final addressArgs = peripheral.address;
    final handleArgs = characteristic.handle;
    logger.info('readCharacteristic: $addressArgs.$handleArgs');
    final value = await _api.readCharacteristic(addressArgs, handleArgs);
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
    final addressArgs = peripheral.address;
    final handleArgs = characteristic.handle;
    final trimmedValueArgs = value.trimGATT();
    final typeArgs = type.toArgs();
    logger.info(
        'writeCharacteristic: $addressArgs.$handleArgs - $trimmedValueArgs, $typeArgs');
    await _api.writeCharacteristic(
      addressArgs,
      handleArgs,
      trimmedValueArgs,
      typeArgs,
    );
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
    final addressArgs = peripheral.address;
    final handleArgs = characteristic.handle;
    final stateArgs = state
        ? characteristic.properties.contains(GATTCharacteristicProperty.notify)
            ? MyGATTCharacteristicNotifyStateArgs.notify
            : MyGATTCharacteristicNotifyStateArgs.indicate
        : MyGATTCharacteristicNotifyStateArgs.none;
    logger.info(
        'setCharacteristicNotifyState: $addressArgs.$handleArgs - $stateArgs');
    await _api.setCharacteristicNotifyState(
      addressArgs,
      handleArgs,
      stateArgs,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GATTDescriptor descriptor) async {
    if (descriptor is! MyGATTDescriptor) {
      throw TypeError();
    }
    final peripheral = descriptor.peripheral;
    final addressArgs = peripheral.address;
    final handleArgs = descriptor.handle;
    logger.info('readDescriptor: $addressArgs.$handleArgs');
    final value = await _api.readDescriptor(addressArgs, handleArgs);
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
    final addressArgs = peripheral.address;
    final handleArgs = descriptor.handle;
    final trimmedValueArgs = value.trimGATT();
    logger
        .info('writeDescriptor: $addressArgs.$handleArgs - $trimmedValueArgs');
    await _api.writeDescriptor(addressArgs, handleArgs, trimmedValueArgs);
  }

  @override
  void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs) {
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
  void onConnectionStateChanged(
    int addressArgs,
    MyConnectionStateArgs stateArgs,
  ) {
    logger.info('onConnectionStateChanged: $addressArgs - $stateArgs');
    final peripheral = _peripherals[addressArgs];
    if (peripheral == null) {
      return;
    }
    final state = stateArgs.toState();
    if (state == ConnectionState.disconnected) {
      _characteristics.remove(addressArgs);
    }
    final eventArgs =
        PeripheralConnectionStateChangedEventArgs(peripheral, state);
    _connectionStateChangedController.add(eventArgs);
  }

  @override
  void onMTUChanged(int addressArgs, int mtuArgs) {
    logger.info('onMTUChanged: $addressArgs - $mtuArgs');
    final peripheral = _peripherals[addressArgs];
    if (peripheral == null) {
      return;
    }
    final mtu = mtuArgs;
    final eventArgs = PeripheralMTUChangedEventArgs(peripheral, mtu);
    _mtuChangedController.add(eventArgs);
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
    final eventArgs = GATTCharacteristicNotifiedEventArgs(
      characteristic,
      value,
    );
    _characteristicNotifiedController.add(eventArgs);
  }

  Future<void> _initialize() async {
    // Here we use `Future()` to make it possible to change the `logLevel` before `initialize()`.
    await Future(() async {
      try {
        logger.info('initialize');
        await _api.initialize();
        _updateState();
      } catch (e) {
        logger.severe('initialize failed.', e);
      }
    });
  }

  Future<void> _updateState() async {
    try {
      logger.info('getState');
      final stateArgs = await _api.getState();
      onStateChanged(stateArgs);
    } catch (e) {
      logger.severe('getState failed.', e);
    }
  }

  Future<void> _updateMTU(int addressArgs) async {
    try {
      logger.info('getMTU: $addressArgs');
      final mtuArgs = await _api.getMTU(addressArgs);
      onMTUChanged(addressArgs, mtuArgs);
    } catch (e) {
      logger.severe('getMTU failed.', e);
    }
  }

  GATTCharacteristic? _retrieveCharacteristic(int addressArgs, int handleArgs) {
    final characteristics = _characteristics[addressArgs];
    if (characteristics == null) {
      return null;
    }
    return characteristics[handleArgs];
  }
}
