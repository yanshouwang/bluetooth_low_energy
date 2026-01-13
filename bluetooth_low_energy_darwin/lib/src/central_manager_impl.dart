import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:logging/logging.dart';

import 'api.dart';
import 'api.g.dart';
import 'gatt_impl.dart';

Logger get _logger => Logger('CentralManager');

final class CentralManagerImpl
    implements CentralManager, CentralManagerFlutterApi {
  final CentralManagerHostApi _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
  _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralConnectionStateChangedEventArgs>
  _connectionStateChangedController;
  final StreamController<GATTCharacteristicNotifiedEventArgs>
  _characteristicNotifiedController;

  BluetoothLowEnergyState _state;

  CentralManagerImpl()
    : _api = CentralManagerHostApi(),
      _stateChangedController = StreamController.broadcast(),
      _discoveredController = StreamController.broadcast(),
      _connectionStateChangedController = StreamController.broadcast(),
      _characteristicNotifiedController = StreamController.broadcast(),
      _state = BluetoothLowEnergyState.unknown {
    CentralManagerFlutterApi.setUp(this);
    _initialize();
  }

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
  Future<bool> authorize() {
    throw UnsupportedError('authorize is not supported on Darwin.');
  }

  @override
  Future<void> showAppSettings() async {
    if (Platform.isIOS) {
      _logger.info('showAppSettings');
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
    _logger.info('startDiscovery: $serviceUUIDsArgs');
    await _api.startDiscovery(serviceUUIDsArgs);
  }

  @override
  Future<void> stopDiscovery() async {
    _logger.info('stopDiscovery');
    await _api.stopDiscovery();
  }

  @override
  Future<Peripheral> getPeripheral(String address) {
    throw UnsupportedError('getPeripheral is not supported on Darwin.');
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() async {
    _logger.info('retrieveConnectedPeripherals');
    final peripheralsArgs = await _api.retrieveConnectedPeripherals();
    final peripherals = peripheralsArgs
        .map((args) => args.toPeripheral())
        .toList();
    return peripherals;
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    final uuidArgs = peripheral.uuid.toArgs();
    _logger.info('connect: $uuidArgs');
    await _api.connect(uuidArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    final uuidArgs = peripheral.uuid.toArgs();
    _logger.info('disconnect: $uuidArgs');
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
    _logger.info('getMaximumWriteLength: $uuidArgs - $typeArgs');
    final maximumWriteLength = await _api.getMaximumWriteLength(
      uuidArgs,
      typeArgs,
    );
    return maximumWriteLength;
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    final uuidArgs = peripheral.uuid.toArgs();
    _logger.info('readRSSI: $uuidArgs');
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
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    _logger.info('readCharacteristic: $uuidArgs.$hashCodeArgs');
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
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    final typeArgs = type.toArgs();
    _logger.info(
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
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final stateArgs = state;
    _logger.info(
      'setCharacteristicNotifyState: $uuidArgs.$hashCodeArgs - $stateArgs',
    );
    await _api.setCharacteristicNotifyState(uuidArgs, hashCodeArgs, stateArgs);
  }

  @override
  Future<Uint8List> readDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor,
  ) async {
    if (descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = descriptor.hashCode;
    _logger.info('readDescriptor: $uuidArgs.$hashCodeArgs');
    final value = await _api.readDescriptor(uuidArgs, hashCodeArgs);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    final uuidArgs = peripheral.uuid.toArgs();
    final hashCodeArgs = descriptor.hashCode;
    final valueArgs = value;
    _logger.info('writeDescriptor: $uuidArgs.$hashCodeArgs - $valueArgs');
    await _api.writeDescriptor(uuidArgs, hashCodeArgs, valueArgs);
  }

  @override
  void onStateChanged(BluetoothLowEnergyStateArgs stateArgs) {
    _logger.info('onStateChanged: $stateArgs');
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
    PeripheralArgs peripheralArgs,
    int rssiArgs,
    AdvertisementArgs advertisementArgs,
  ) {
    final uuidArgs = peripheralArgs.uuidArgs;
    _logger.info('onDiscovered: $uuidArgs - $rssiArgs, $advertisementArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final advertisement = advertisementArgs.toAdvertisement();
    final eventArgs = DiscoveredEventArgs(peripheral, rssiArgs, advertisement);
    _discoveredController.add(eventArgs);
  }

  @override
  void onConnectionStateChanged(
    PeripheralArgs peripheralArgs,
    ConnectionStateArgs stateArgs,
  ) {
    final uuidArgs = peripheralArgs.uuidArgs;
    _logger.info('onConnectionStateChanged: $uuidArgs - $stateArgs');
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
    PeripheralArgs peripheralArgs,
    GATTCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  ) {
    final uuidArgs = peripheralArgs.uuidArgs;
    final hashCodeArgs = characteristicArgs.hashCodeArgs;
    _logger.info(
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
        _logger.info('initialize');
        await _api.initialize();
        _getState();
      } catch (e) {
        _logger.severe('initialize failed.', e);
      }
    });
  }

  Future<void> _getState() async {
    try {
      _logger.info('getState');
      final stateArgs = await _api.getState();
      onStateChanged(stateArgs);
    } catch (e) {
      _logger.severe('getState failed.', e);
    }
  }

  Future<List<GATTServiceArgs>> _discoverServices(String uuidArgs) async {
    _logger.info('discoverServices: $uuidArgs');
    final servicesArgs = await _api.discoverServices(uuidArgs);
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
    _logger.info('discoverIncludedServices: $uuidArgs.$hashCodeArgs');
    final servicesArgs = await _api.discoverIncludedServices(
      uuidArgs,
      hashCodeArgs,
    );
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
    _logger.info('discoverCharacteristics: $uuidArgs.$hashCodeArgs');
    final characteristicsArgs = await _api.discoverCharacteristics(
      uuidArgs,
      hashCodeArgs,
    );
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
    _logger.info('discoverDescriptors: $uuidArgs.$hashCodeArgs');
    final descriptorsArgs = await _api.discoverDescriptors(
      uuidArgs,
      hashCodeArgs,
    );
    return descriptorsArgs;
  }
}

final class CentralManagerChannelImpl extends CentralManagerChannel {
  @override
  CentralManager create() => CentralManagerImpl();
}
