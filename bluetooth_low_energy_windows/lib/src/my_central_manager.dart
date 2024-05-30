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
  final Map<int, MyDiscoveryArgs> _discoveriesArgs;

  BluetoothLowEnergyState _state;

  MyCentralManager()
      : _api = MyCentralManagerHostAPI(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _mtuChangedController = StreamController.broadcast(),
        _characteristicNotifiedController = StreamController.broadcast(),
        _discoveriesArgs = {},
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
    _discoveriesArgs.clear();
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
    final servicesArgs = await _getServices(
      peripheral.addressArgs,
      MyCacheModeArgs.uncached,
    );
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
    int timestampArgs,
    MyAdvertisementTypeArgs typeArgs,
    MyAdvertisementArgs advertisementArgs,
  ) {
    final addressArgs = peripheralArgs.addressArgs;
    logger.info(
        'onDiscovered: $addressArgs - $rssiArgs, $timestampArgs, $typeArgs, $advertisementArgs');
    if (typeArgs == MyAdvertisementTypeArgs.connectableDirected ||
        typeArgs == MyAdvertisementTypeArgs.nonConnectableUndirected ||
        typeArgs == MyAdvertisementTypeArgs.extended) {
      // No need to wait SCAN_REQ.
      final peripheral = peripheralArgs.toPeripheral();
      final rssi = rssiArgs;
      final advertisement = advertisementArgs.toAdvertisement();
      final eventArgs = DiscoveredEventArgs(
        peripheral,
        rssi,
        advertisement,
      );
      _discoveredController.add(eventArgs);
    } else {
      final oldDiscoveryArgs = _discoveriesArgs.remove(addressArgs);
      final newDiscoveryArgs = MyDiscoveryArgs(
        peripheralArgs,
        rssiArgs,
        timestampArgs,
        typeArgs,
        advertisementArgs,
      );
      final ignored = oldDiscoveryArgs == null ||
          _checkDiscoveryArgs(oldDiscoveryArgs, newDiscoveryArgs);
      if (ignored) {
        // Note that ADV_IND will be ignored if the advertiser never reply the
        // SCAN_REQ.
        // TODO: should we ignore this?
        _discoveriesArgs[addressArgs] = newDiscoveryArgs;
      } else {
        final peripheral = oldDiscoveryArgs.peripheralArgs.toPeripheral();
        final rssi = oldDiscoveryArgs.rssiArgs;
        final oldAdvertisement =
            typeArgs == MyAdvertisementTypeArgs.scanResponse
                ? oldDiscoveryArgs.advertisementArgs.toAdvertisement()
                : advertisementArgs.toAdvertisement();
        final newAdvertisement =
            typeArgs == MyAdvertisementTypeArgs.scanResponse
                ? advertisementArgs.toAdvertisement()
                : oldDiscoveryArgs.advertisementArgs.toAdvertisement();
        final name = newAdvertisement.name?.isNotEmpty == true
            ? newAdvertisement.name
            : oldAdvertisement.name;
        final serviceUUIDs = {
          ...oldAdvertisement.serviceUUIDs,
          ...newAdvertisement.serviceUUIDs,
        }.toList();
        final serviceData = {
          ...oldAdvertisement.serviceData,
          ...newAdvertisement.serviceData,
        };
        final manufacturerSpecificData =
            newAdvertisement.manufacturerSpecificData ??
                oldAdvertisement.manufacturerSpecificData;
        final advertisement = Advertisement(
          name: name,
          serviceUUIDs: serviceUUIDs,
          serviceData: serviceData,
          manufacturerSpecificData: manufacturerSpecificData,
        );
        final eventArgs = DiscoveredEventArgs(
          peripheral,
          rssi,
          advertisement,
        );
        _discoveredController.add(eventArgs);
      }
    }
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

  Future<List<MyGATTServiceArgs>> _getServices(
    int addressArgs,
    MyCacheModeArgs modeArgs,
  ) async {
    logger.info('getServices: $addressArgs - $modeArgs');
    final servicesArgs = await _api
        .getServices(addressArgs, modeArgs)
        .then((args) => args.cast<MyGATTServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      final handleArgs = serviceArgs.handleArgs;
      final includedServicesArgs = await _getIncludedServices(
        addressArgs,
        handleArgs,
        modeArgs,
      );
      serviceArgs.includedServicesArgs = includedServicesArgs;
      final characteristicsArgs = await _getCharacteristics(
        addressArgs,
        handleArgs,
        modeArgs,
      );
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    return servicesArgs;
  }

  Future<List<MyGATTServiceArgs>> _getIncludedServices(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  ) async {
    logger.info('getIncludedServices: $addressArgs.$handleArgs - $modeArgs');
    final servicesArgs = await _api
        .getIncludedServices(addressArgs, handleArgs, modeArgs)
        .then((args) => args.cast<MyGATTServiceArgs>());
    for (var serviceArgs in servicesArgs) {
      final handleArgs = serviceArgs.handleArgs;
      final includedServicesArgs = await _getIncludedServices(
        addressArgs,
        handleArgs,
        modeArgs,
      );
      serviceArgs.includedServicesArgs = includedServicesArgs;
      final characteristicsArgs = await _getCharacteristics(
        addressArgs,
        handleArgs,
        modeArgs,
      );
      serviceArgs.characteristicsArgs = characteristicsArgs;
    }
    return servicesArgs;
  }

  Future<List<MyGATTCharacteristicArgs>> _getCharacteristics(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  ) async {
    logger.info('getCharacteristics: $addressArgs.$handleArgs - $modeArgs');
    final characteristicsArgs = await _api
        .getCharacteristics(addressArgs, handleArgs, modeArgs)
        .then((args) => args.cast<MyGATTCharacteristicArgs>());
    for (var characteristicArgs in characteristicsArgs) {
      final handleArgs = characteristicArgs.handleArgs;
      final descriptorsArgs = await _getDescriptors(
        addressArgs,
        handleArgs,
        modeArgs,
      );
      characteristicArgs.descriptorsArgs = descriptorsArgs;
    }
    return characteristicsArgs;
  }

  Future<List<MyGATTDescriptorArgs>> _getDescriptors(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  ) async {
    logger.info('getDescriptors: $addressArgs,$handleArgs - $modeArgs');
    final descriptorsArgs = await _api
        .getDescriptors(addressArgs, handleArgs, modeArgs)
        .then((args) => args.cast<MyGATTDescriptorArgs>());
    return descriptorsArgs;
  }

  bool _checkDiscoveryArgs(
    MyDiscoveryArgs oldDiscoveryArgs,
    MyDiscoveryArgs newDiscoveryArgs,
  ) {
    final oldAddressArgs = oldDiscoveryArgs.peripheralArgs.addressArgs;
    final newAddressArgs = newDiscoveryArgs.peripheralArgs.addressArgs;
    if (oldAddressArgs != newAddressArgs) {
      logger.fine(
          'ignored by different addressArgs $oldAddressArgs, $newAddressArgs');
      return true;
    }
    final address =
        (newAddressArgs & 0xFFFFFFFFFFFF).toRadixString(16).padLeft(12, '0');
    if (oldDiscoveryArgs.typeArgs == newDiscoveryArgs.typeArgs) {
      logger.fine(
          'ignored by same typeArgs $address: ${oldDiscoveryArgs.typeArgs}:${oldDiscoveryArgs.timestampArgs}, ${newDiscoveryArgs.typeArgs}:${newDiscoveryArgs.timestampArgs}');
      return true;
    }
    if (oldDiscoveryArgs.typeArgs != MyAdvertisementTypeArgs.scanResponse &&
        newDiscoveryArgs.typeArgs != MyAdvertisementTypeArgs.scanResponse) {
      logger.fine(
          'ignored by wrong typeArgs $address:  ${oldDiscoveryArgs.typeArgs}:${oldDiscoveryArgs.timestampArgs}, ${newDiscoveryArgs.typeArgs}:${newDiscoveryArgs.timestampArgs}');
      return true;
    }
    final interval =
        newDiscoveryArgs.typeArgs == MyAdvertisementTypeArgs.scanResponse
            ? newDiscoveryArgs.timestampArgs - oldDiscoveryArgs.timestampArgs
            : oldDiscoveryArgs.timestampArgs - newDiscoveryArgs.timestampArgs;
    final ignored = interval < 0 || interval > 1000;
    if (ignored) {
      logger.fine(
          'ignored by wrong timestampArgs $address: $interval, ${oldDiscoveryArgs.typeArgs}:${oldDiscoveryArgs.timestampArgs}, ${newDiscoveryArgs.typeArgs}:${newDiscoveryArgs.timestampArgs}');
    }
    return ignored;
  }
}

final class MyDiscoveryArgs {
  final MyPeripheralArgs peripheralArgs;
  final int rssiArgs;
  final int timestampArgs;
  final MyAdvertisementTypeArgs typeArgs;
  final MyAdvertisementArgs advertisementArgs;

  MyDiscoveryArgs(
    this.peripheralArgs,
    this.rssiArgs,
    this.timestampArgs,
    this.typeArgs,
    this.advertisementArgs,
  );
}
