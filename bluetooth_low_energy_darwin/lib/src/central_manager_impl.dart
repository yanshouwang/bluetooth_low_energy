import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:hybrid_logging/hybrid_logging.dart';

import 'gatt_impl.dart';
import 'peripheral_impl.dart';
import 'pigeon.dart';

final class CentralManagerImpl
    with TypeLogger, LoggerController
    implements CentralManager, CentralManagerFlutterAPI {
  static CentralManagerImpl? _instance;

  final CentralManagerHostAPI _api;
  final StreamController<BluetoothLowEnergyStateChangedEvent>
      _stateChangedController;
  final StreamController<DiscoveredEvent> _discoveredController;
  final StreamController<PeripheralConnectionStateChangedEvent>
      _connectionStateChangedController;
  final StreamController<GATTCharacteristicNotifiedEvent>
      _characteristicNotifiedController;

  BluetoothLowEnergyState _state;

  CentralManagerImpl._()
      : _api = CentralManagerHostAPI(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _characteristicNotifiedController = StreamController.broadcast(),
        _state = BluetoothLowEnergyState.unknown {
    CentralManagerFlutterAPI.setUp(this);
    _initialize();
  }

  factory CentralManagerImpl() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = CentralManagerImpl._();
    }
    return instance;
  }

  @override
  BluetoothLowEnergyState get state => _state;
  @override
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<NameChangedEvent> get nameChanged =>
      throw UnsupportedError('nameChanged is not supported on Darwin.');
  @override
  Stream<DiscoveredEvent> get discovered => _discoveredController.stream;
  @override
  Stream<PeripheralConnectionStateChangedEvent> get connectionStateChanged =>
      _connectionStateChangedController.stream;
  @override
  Stream<PeripheralMTUChangedEvent> get mtuChanged =>
      throw UnsupportedError('mtuChanged is not supported on Darwin.');
  @override
  Stream<GATTCharacteristicNotifiedEvent> get characteristicNotified =>
      _characteristicNotifiedController.stream;

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
          'showAppSettings is not supported on ${Platform.operatingSystem}.');
    }
  }

  @override
  Future<String> getName() {
    throw UnsupportedError('getName is not supported on Darwin.');
  }

  @override
  Future<void> setName(String name) {
    throw UnsupportedError('setName is not supported on Darwin.');
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
  Future<List<Peripheral>> retrieveConnectedPeripherals() async {
    logger.info('retrieveConnectedPeripherals');
    final peripheralsArgs = await _api.retrieveConnectedPeripherals();
    final peripherals = peripheralsArgs
        .cast<PeripheralArgs>()
        .map((args) => PeripheralImpl.fromArgs(args))
        .toList();
    return peripherals;
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuidArgs;
    logger.info('connect: $uuidArgs');
    await _api.connect(uuidArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuidArgs;
    logger.info('disconnect: $uuidArgs');
    await _api.disconnect(uuidArgs);
  }

  @override
  Future<int> requestMTU(
    Peripheral peripheral, {
    required int mtu,
  }) {
    throw UnsupportedError('requestMTU is not supported on Darwin.');
  }

  @override
  Future<void> requestConnectionPriority(
    Peripheral peripheral, {
    required ConnectionPriority priority,
  }) {
    throw UnsupportedError(
        'requestConnectionPriority is not supported on Darwin.');
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GATTCharacteristicWriteType type,
  }) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuidArgs;
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
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuidArgs;
    logger.info('readRSSI: $uuidArgs');
    final rssi = await _api.readRSSI(uuidArgs);
    return rssi;
  }

  @override
  Future<List<GATTService>> discoverServices(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuidArgs;
    final servicesArgs = await _discoverServices(uuidArgs);
    final services = servicesArgs
        .map((serviceArgs) => GATTServiceImpl.fromArgs(
              uuidArgs: uuidArgs,
              serviceArgs: serviceArgs,
            ))
        .toList();
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
      GATTCharacteristic characteristic) async {
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final uuidArgs = characteristic.uuidArgs;
    final hashCodeArgs = characteristic.hashCodeArgs;
    logger.info('readCharacteristic: $uuidArgs.$hashCodeArgs');
    final value = await _api.readCharacteristic(uuidArgs, hashCodeArgs);
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  }) async {
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final uuidArgs = characteristic.uuidArgs;
    final hashCodeArgs = characteristic.hashCodeArgs;
    final valueArgs = value;
    final typeArgs = type.toArgs();
    logger.info(
        'writeCharacteristic: $uuidArgs.$hashCodeArgs - $valueArgs, $typeArgs');
    await _api.writeCharacteristic(uuidArgs, hashCodeArgs, valueArgs, typeArgs);
  }

  @override
  Future<void> setCharacteristicNotifyState(
    GATTCharacteristic characteristic, {
    required bool state,
  }) async {
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final uuidArgs = characteristic.uuidArgs;
    final hashCodeArgs = characteristic.hashCodeArgs;
    final stateArgs = state;
    logger.info(
        'setCharacteristicNotifyState: $uuidArgs.$hashCodeArgs - $stateArgs');
    await _api.setCharacteristicNotifyState(uuidArgs, hashCodeArgs, stateArgs);
  }

  @override
  Future<Uint8List> readDescriptor(GATTDescriptor descriptor) async {
    if (descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    final uuidArgs = descriptor.uuidArgs;
    final hashCodeArgs = descriptor.hashCodeArgs;
    logger.info('readDescriptor: $uuidArgs.$hashCodeArgs');
    final value = await _api.readDescriptor(uuidArgs, hashCodeArgs);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    final uuidArgs = descriptor.uuidArgs;
    final hashCodeArgs = descriptor.hashCodeArgs;
    final valueArgs = value;
    logger.info('writeDescriptor: $uuidArgs.$hashCodeArgs - $valueArgs');
    await _api.writeDescriptor(uuidArgs, hashCodeArgs, valueArgs);
  }

  @override
  void onStateChanged(BluetoothLowEnergyStateArgs stateArgs) {
    logger.info('onStateChanged: $stateArgs');
    final state = stateArgs.toState();
    if (_state == state) {
      return;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEvent(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onDiscovered(
    PeripheralArgs peripheralArgs,
    int rssiArgs,
    AdvertisementArgs advertisementArgs,
  ) {
    final uuidArgs = peripheralArgs.uuidArgs;
    logger.info('onDiscovered: $uuidArgs - $rssiArgs, $advertisementArgs');
    final peripheral = PeripheralImpl.fromArgs(peripheralArgs);
    final advertisement = advertisementArgs.toAdvertisement();
    final eventArgs = DiscoveredEvent(
      peripheral,
      rssiArgs,
      advertisement,
    );
    _discoveredController.add(eventArgs);
  }

  @override
  void onConnectionStateChanged(
    PeripheralArgs peripheralArgs,
    ConnectionStateArgs stateArgs,
  ) {
    final uuidArgs = peripheralArgs.uuidArgs;
    logger.info('onConnectionStateChanged: $uuidArgs - $stateArgs');
    final peripheral = PeripheralImpl.fromArgs(peripheralArgs);
    final state = stateArgs.toState();
    final eventArgs = PeripheralConnectionStateChangedEvent(
      peripheral,
      state,
    );
    _connectionStateChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicNotified(
    PeripheralArgs peripheralArgs,
    GATTCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  ) {
    final uuidArgs = peripheralArgs.uuidArgs;
    final hashCodeArgs = characteristicArgs.hashCodeArgs;
    logger
        .info('onCharacteristicNotified: $uuidArgs.$hashCodeArgs - $valueArgs');
    final characteristic = GATTCharacteristicImpl.fromArgs(
      uuidArgs: uuidArgs,
      characteristicArgs: characteristicArgs,
    );
    final eventArgs = GATTCharacteristicNotifiedEvent(
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

  Future<List<GATTServiceArgs>> _discoverServices(String uuidArgs) async {
    logger.info('discoverServices: $uuidArgs');
    final servicesArgs = await _api
        .discoverServices(uuidArgs)
        .then((args) => args.cast<GATTServiceArgs>());
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

  Future<List<GATTServiceArgs>> _discoverIncludedServices(
    String uuidArgs,
    int hashCodeArgs,
  ) async {
    logger.info('discoverIncludedServices: $uuidArgs.$hashCodeArgs');
    final servicesArgs = await _api
        .discoverIncludedServices(uuidArgs, hashCodeArgs)
        .then((args) => args.cast<GATTServiceArgs>());
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

  Future<List<GATTCharacteristicArgs>> _discoverCharacteristics(
    String uuidArgs,
    int hashCodeArgs,
  ) async {
    logger.info('discoverCharacteristics: $uuidArgs.$hashCodeArgs');
    final characteristicsArgs = await _api
        .discoverCharacteristics(uuidArgs, hashCodeArgs)
        .then((args) => args.cast<GATTCharacteristicArgs>());
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

  Future<List<GATTDescriptorArgs>> _discoverDescriptors(
    String uuidArgs,
    int hashCodeArgs,
  ) async {
    logger.info('discoverDescriptors: $uuidArgs.$hashCodeArgs');
    final descriptorsArgs = await _api
        .discoverDescriptors(uuidArgs, hashCodeArgs)
        .then((args) => args.cast<GATTDescriptorArgs>());
    return descriptorsArgs;
  }
}
