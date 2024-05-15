import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_api.g.dart';
import 'my_gatt.dart';
import 'my_peripheral.dart';

final class MyCentralManager extends PlatformCentralManager
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

  BluetoothLowEnergyState _state;

  MyCentralManager()
      : _api = MyCentralManagerHostAPI(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _mtuChangedController = StreamController.broadcast(),
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
    final addressArgs = peripheral.addressArgs;
    logger.info('connect: $addressArgs');
    await _api.connect(addressArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.addressArgs;
    logger.info('disconnect: $addressArgs');
    await _api.disconnect(addressArgs);
    final peripheralArgs = peripheral.toArgs();
    onConnectionStateChanged(
      peripheralArgs,
      MyConnectionStateArgs.disconnected,
    );
  }

  @override
  Future<int> requestMTU(
    Peripheral peripheral, {
    required int mtu,
  }) {
    throw UnsupportedError('requestMTU is not supported on Windows.');
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GATTCharacteristicWriteType type,
  }) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final addressArgs = peripheral.addressArgs;
    logger.info('getMTU: $addressArgs');
    final mtuArgs = await _api.getMTU(addressArgs);
    final maximumWriteLength = (mtuArgs - 3).clamp(20, 512);
    return maximumWriteLength;
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
    final addressArgs = peripheral.addressArgs;
    const modeArgs = MyCacheModeArgs.uncached;
    logger.info('getServicesAsync: $addressArgs - $modeArgs');
    final servicesArgs = await _api
        .getServicesAsync(addressArgs, modeArgs)
        .then((args) => args.cast<MyGATTServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      await _getIncludedServices(addressArgs, serviceArgs, modeArgs);
    }
    final services = servicesArgs.map((args) => args.toService()).toList();
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
    Peripheral peripheral,
    GATTCharacteristic characteristic,
  ) async {
    if (peripheral is! MyPeripheral ||
        characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final addressArgs = peripheral.addressArgs;
    final handleArgs = characteristic.handleArgs;
    const modeArgs = MyCacheModeArgs.uncached;
    logger.info('readCharacteristic: $addressArgs.$handleArgs - $modeArgs');
    final value = await _api.readCharacteristic(
      addressArgs,
      handleArgs,
      modeArgs,
    );
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    Peripheral peripheral,
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  }) async {
    if (peripheral is! MyPeripheral ||
        characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final addressArgs = peripheral.addressArgs;
    final handleArgs = characteristic.handleArgs;
    final valueArgs = value;
    final typeArgs = type.toArgs();
    logger.info(
        'writeCharacteristic: $addressArgs.$handleArgs - $valueArgs, $typeArgs');
    await _api.writeCharacteristic(
      addressArgs,
      handleArgs,
      valueArgs,
      typeArgs,
    );
  }

  @override
  Future<void> setCharacteristicNotifyState(
    Peripheral peripheral,
    GATTCharacteristic characteristic, {
    required bool state,
  }) async {
    if (peripheral is! MyPeripheral ||
        characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final addressArgs = peripheral.addressArgs;
    final handleArgs = characteristic.handleArgs;
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
  Future<Uint8List> readDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor,
  ) async {
    if (peripheral is! MyPeripheral || descriptor is! MyGATTDescriptor) {
      throw TypeError();
    }
    final addressArgs = peripheral.addressArgs;
    final handleArgs = descriptor.handleArgs;
    const modeArgs = MyCacheModeArgs.uncached;
    logger.info('readDescriptor: $addressArgs.$handleArgs - $modeArgs');
    final value = await _api.readDescriptor(addressArgs, handleArgs, modeArgs);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (peripheral is! MyPeripheral || descriptor is! MyGATTDescriptor) {
      throw TypeError();
    }
    final addressArgs = peripheral.addressArgs;
    final handleArgs = descriptor.handleArgs;
    final valueArgs = value;
    logger.info('writeDescriptor: $addressArgs.$handleArgs - $valueArgs');
    await _api.writeDescriptor(addressArgs, handleArgs, valueArgs);
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
  void onConnectionStateChanged(
    MyPeripheralArgs peripheralArgs,
    MyConnectionStateArgs stateArgs,
  ) {
    final addressArgs = peripheralArgs.addressArgs;
    logger.info('onConnectionStateChanged: $addressArgs - $stateArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final state = stateArgs.toState();
    final eventArgs = PeripheralConnectionStateChangedEventArgs(
      peripheral,
      state,
    );
    _connectionStateChangedController.add(eventArgs);
  }

  @override
  void onMTUChanged(MyPeripheralArgs peripheralArgs, int mtuArgs) {
    final addressArgs = peripheralArgs.addressArgs;
    logger.info('onMTUChanged: $addressArgs - $mtuArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final mtu = mtuArgs;
    final eventArgs = PeripheralMTUChangedEventArgs(peripheral, mtu);
    _mtuChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicNotified(
    MyPeripheralArgs peripheralArgs,
    MyGATTCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  ) {
    final addressArgs = peripheralArgs.addressArgs;
    final handleArgs = characteristicArgs.handleArgs;
    logger.info(
        'onCharacteristicNotified: $addressArgs.$handleArgs - $valueArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final characteristic = characteristicArgs.toCharacteristic();
    final value = valueArgs;
    final eventArgs = GATTCharacteristicNotifiedEventArgs(
      peripheral,
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

  Future<void> _getIncludedServices(
    int addressArgs,
    MyGATTServiceArgs serviceArgs,
    MyCacheModeArgs modeArgs,
  ) async {
    final handleArgs = serviceArgs.handleArgs;
    logger
        .info('getIncludedServicesAsync: $addressArgs.$handleArgs - $modeArgs');
    final includedServicesArgs = await _api
        .getIncludedServicesAsync(addressArgs, handleArgs, modeArgs)
        .then((args) => args.cast<MyGATTServiceArgs>());
    for (var includedServiceArgs in includedServicesArgs) {
      await _getIncludedServices(addressArgs, includedServiceArgs, modeArgs);
    }
    serviceArgs.includedServicesArgs = includedServicesArgs;
    await _getCharacteristicsArgs(addressArgs, serviceArgs, modeArgs);
  }

  Future<void> _getCharacteristicsArgs(
    int addressArgs,
    MyGATTServiceArgs serviceArgs,
    MyCacheModeArgs modeArgs,
  ) async {
    final handleArgs = serviceArgs.handleArgs;
    logger
        .info('getCharacteristicsAsync: $addressArgs.$handleArgs - $modeArgs');
    final characteristicsArgs = await _api
        .getCharacteristicsAsync(addressArgs, handleArgs, modeArgs)
        .then((args) => args.cast<MyGATTCharacteristicArgs>());
    for (var characteristicArgs in characteristicsArgs) {
      await _getDescriptorsArgs(addressArgs, characteristicArgs, modeArgs);
    }
    serviceArgs.characteristicsArgs = characteristicsArgs;
  }

  Future<void> _getDescriptorsArgs(
    int addressArgs,
    MyGATTCharacteristicArgs characteristicArgs,
    MyCacheModeArgs modeArgs,
  ) async {
    final handleArgs = characteristicArgs.handleArgs;
    logger.info('getDescriptorsAsync: $addressArgs.$handleArgs - $modeArgs');
    final descriptorsArgs = await _api
        .getDescriptorsAsync(addressArgs, handleArgs, modeArgs)
        .then((args) => args.cast<MyGATTDescriptorArgs>());
    characteristicArgs.descriptorsArgs = descriptorsArgs;
  }
}
