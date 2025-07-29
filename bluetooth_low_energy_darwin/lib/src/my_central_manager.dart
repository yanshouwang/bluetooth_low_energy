import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_api.g.dart';
import 'my_gatt.dart';

final class MyCentralManager extends PlatformCentralManager
    implements MyCentralManagerFlutterAPI {
  final MyCentralManagerHostAPI _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
  _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralConnectionStateChangedEventArgs>
  _connectionStateChangedController;
  final StreamController<GATTCharacteristicNotifiedEventArgs>
  _characteristicNotifiedController;

  BluetoothLowEnergyState _state;

  MyCentralManager()
    : _api = MyCentralManagerHostAPI(),
      _stateChangedController = StreamController.broadcast(),
      _discoveredController = StreamController.broadcast(),
      _connectionStateChangedController = StreamController.broadcast(),
      _characteristicNotifiedController = StreamController.broadcast(),
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
      throw UnsupportedError('mtuChanged is not supported on Darwin.');
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
    throw UnsupportedError('authorize is not supported on Darwin.');
  }

  @override
  Future<void> showAppSettings() async {
    if (Platform.isIOS) {
      logger.info('showAppSettings');
      await _api.showAppSettings();
    } else {
      throw UnsupportedError(
        'showAppSettings is not supported on ${Platform.operatingSystem}.',
      );
    }
  }

  @override
  Future<void> startDiscovery({List<UUID>? serviceUUIDs}) async {
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
  Future<List<Peripheral>> retrieveConnectedPeripherals() async {
    logger.info('retrieveConnectedPeripherals');
    final peripheralsArgs = await _api.retrieveConnectedPeripherals();
    final peripherals =
        peripheralsArgs
            .cast<MyPeripheralArgs>()
            .map((args) => args.toPeripheral())
            .toList();
    return peripherals;
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    final uuidArgs = peripheral.uuid.toArgs();
    logger.info('connect: $uuidArgs');
    await _api.connect(uuidArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    final uuidArgs = peripheral.uuid.toArgs();
    logger.info('disconnect: $uuidArgs');
    await _api.disconnect(uuidArgs);
  }

  @override
  Future<int> requestMTU(Peripheral peripheral, {required int mtu}) {
    throw UnsupportedError('requestMTU is not supported on Darwin.');
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GATTCharacteristicWriteType type,
  }) async {
    final uuidArgs = peripheral.uuid.toArgs();
    final typeArgs = type.toArgs();
    logger.info('getMaximumWriteLength: $uuidArgs - $typeArgs');
    final maximumWriteLength = await _api.getMaximumWriteLength(
      uuidArgs,
      typeArgs,
    );
    return maximumWriteLength;
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    final uuidArgs = peripheral.uuid.toArgs();
    logger.info('readRSSI: $uuidArgs');
    final rssi = await _api.readRSSI(uuidArgs);
    return rssi;
  }

  @override
  Future<List<GATTService>> discoverGATT(Peripheral peripheral) async {
    // 发现 GATT 服务
    final uuidArgs = peripheral.uuid.toArgs();
    final servicesArgs = await _discoverServices(uuidArgs);
    final services = servicesArgs.map((args) => args.toService()).toList();
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
    Peripheral peripheral,
    GATTCharacteristic characteristic,
  ) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    logger.info('readCharacteristic: $uuidArgs.$hashCodeArgs');
    final value = await _api.readCharacteristic(uuidArgs, hashCodeArgs);
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    Peripheral peripheral,
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  }) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    final typeArgs = type.toArgs();
    logger.info(
      'writeCharacteristic: $uuidArgs.$hashCodeArgs - $valueArgs, $typeArgs',
    );
    await _api.writeCharacteristic(uuidArgs, hashCodeArgs, valueArgs, typeArgs);
  }

  @override
  Future<void> setCharacteristicNotifyState(
    Peripheral peripheral,
    GATTCharacteristic characteristic, {
    required bool state,
  }) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final stateArgs = state;
    logger.info(
      'setCharacteristicNotifyState: $uuidArgs.$hashCodeArgs - $stateArgs',
    );
    await _api.setCharacteristicNotifyState(uuidArgs, hashCodeArgs, stateArgs);
  }

  @override
  Future<Uint8List> readDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor,
  ) async {
    if (descriptor is! MyGATTDescriptor) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = descriptor.hashCode;
    logger.info('readDescriptor: $uuidArgs.$hashCodeArgs');
    final value = await _api.readDescriptor(uuidArgs, hashCodeArgs);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (descriptor is! MyGATTDescriptor) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = descriptor.hashCode;
    final valueArgs = value;
    logger.info('writeDescriptor: $uuidArgs.$hashCodeArgs - $valueArgs');
    await _api.writeDescriptor(uuidArgs, hashCodeArgs, valueArgs);
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
    final uuidArgs = peripheralArgs.uuidArgs;
    logger.info('onDiscovered: $uuidArgs - $rssiArgs, $advertisementArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final advertisement = advertisementArgs.toAdvertisement();
    final eventArgs = DiscoveredEventArgs(peripheral, rssiArgs, advertisement);
    _discoveredController.add(eventArgs);
  }

  @override
  void onConnectionStateChanged(
    MyPeripheralArgs peripheralArgs,
    MyConnectionStateArgs stateArgs,
  ) {
    final uuidArgs = peripheralArgs.uuidArgs;
    logger.info('onConnectionStateChanged: $uuidArgs - $stateArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final state = stateArgs.toState();
    final eventArgs = PeripheralConnectionStateChangedEventArgs(
      peripheral,
      state,
    );
    _connectionStateChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicNotified(
    MyPeripheralArgs peripheralArgs,
    MyGATTCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  ) {
    final uuidArgs = peripheralArgs.uuidArgs;
    final hashCodeArgs = characteristicArgs.hashCodeArgs;
    logger.info(
      'onCharacteristicNotified: $uuidArgs.$hashCodeArgs - $valueArgs',
    );
    final peripheral = peripheralArgs.toPeripheral();
    final characteristic = characteristicArgs.toCharacteristic();
    final eventArgs = GATTCharacteristicNotifiedEventArgs(
      peripheral,
      characteristic,
      valueArgs,
    );
    _characteristicNotifiedController.add(eventArgs);
  }

  Future<void> _initialize() async {
    // Here we use `Future()` to make it possible to change the `logLevel` before `initialize()`.
    await Future(() async {
      try {
        logger.info('initialize');
        await _api.initialize();
        _getState();
      } catch (e) {
        logger.severe('initialize failed.', e);
      }
    });
  }

  Future<void> _getState() async {
    try {
      logger.info('getState');
      final stateArgs = await _api.getState();
      onStateChanged(stateArgs);
    } catch (e) {
      logger.severe('getState failed.', e);
    }
  }

  Future<List<MyGATTServiceArgs>> _discoverServices(String uuidArgs) async {
    logger.info('discoverServices: $uuidArgs');
    final servicesArgs = await _api
        .discoverServices(uuidArgs)
        .then((args) => args.cast<MyGATTServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      final hashCodeArgs = serviceArgs.hashCodeArgs;
      final includedServicesArgs = await _discoverIncludedServices(
        uuidArgs,
        hashCodeArgs,
      );
      serviceArgs.includedServicesArgs = includedServicesArgs;
      final characteristicsArgs = await _discoverCharacteristics(
        uuidArgs,
        hashCodeArgs,
      );
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    return servicesArgs;
  }

  Future<List<MyGATTServiceArgs>> _discoverIncludedServices(
    String uuidArgs,
    int hashCodeArgs,
  ) async {
    logger.info('discoverIncludedServices: $uuidArgs.$hashCodeArgs');
    final servicesArgs = await _api
        .discoverIncludedServices(uuidArgs, hashCodeArgs)
        .then((args) => args.cast<MyGATTServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      final hashCodeArgs = serviceArgs.hashCodeArgs;
      final includedServicesArgs = await _discoverIncludedServices(
        uuidArgs,
        hashCodeArgs,
      );
      serviceArgs.includedServicesArgs = includedServicesArgs;
      final characteristicsArgs = await _discoverCharacteristics(
        uuidArgs,
        hashCodeArgs,
      );
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    return servicesArgs;
  }

  Future<List<MyGATTCharacteristicArgs>> _discoverCharacteristics(
    String uuidArgs,
    int hashCodeArgs,
  ) async {
    logger.info('discoverCharacteristics: $uuidArgs.$hashCodeArgs');
    final characteristicsArgs = await _api
        .discoverCharacteristics(uuidArgs, hashCodeArgs)
        .then((args) => args.cast<MyGATTCharacteristicArgs>());
    for (var characteristicArgs in characteristicsArgs) {
      final hashCodeArgs = characteristicArgs.hashCodeArgs;
      final descriptorsArgs = await _discoverDescriptors(
        uuidArgs,
        hashCodeArgs,
      );
      characteristicArgs.descriptorsArgs = descriptorsArgs;
    }
    return characteristicsArgs;
  }

  Future<List<MyGATTDescriptorArgs>> _discoverDescriptors(
    String uuidArgs,
    int hashCodeArgs,
  ) async {
    logger.info('discoverDescriptors: $uuidArgs.$hashCodeArgs');
    final descriptorsArgs = await _api
        .discoverDescriptors(uuidArgs, hashCodeArgs)
        .then((args) => args.cast<MyGATTDescriptorArgs>());
    return descriptorsArgs;
  }
}
