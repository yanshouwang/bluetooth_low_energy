import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:logging/logging.dart';

import 'api.dart';
import 'api.g.dart';
import 'gatt_impl.dart';
import 'peripheral_impl.dart';

Logger get _logger => Logger('CentralManager');

final class DiscoveryArgs {
  final PeripheralArgs peripheralArgs;
  final int rssiArgs;
  final int timestampArgs;
  final AdvertisementTypeArgs typeArgs;
  final AdvertisementArgs advertisementArgs;

  DiscoveryArgs(
    this.peripheralArgs,
    this.rssiArgs,
    this.timestampArgs,
    this.typeArgs,
    this.advertisementArgs,
  );
}

final class CentralManagerImpl
    implements CentralManager, CentralManagerFlutterApi {
  final CentralManagerHostApi _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
  _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralConnectionStateChangedEventArgs>
  _connectionStateChangedController;
  final StreamController<PeripheralMTUChangedEventArgs> _mtuChangedController;
  final StreamController<GATTCharacteristicNotifiedEventArgs>
  _characteristicNotifiedController;
  final Map<int, DiscoveryArgs> _discoveriesArgs;

  BluetoothLowEnergyState _state;

  CentralManagerImpl()
    : _api = CentralManagerHostApi(),
      _stateChangedController = StreamController.broadcast(),
      _discoveredController = StreamController.broadcast(),
      _connectionStateChangedController = StreamController.broadcast(),
      _mtuChangedController = StreamController.broadcast(),
      _characteristicNotifiedController = StreamController.broadcast(),
      _discoveriesArgs = {},
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
      _mtuChangedController.stream;
  @override
  Stream<GATTCharacteristicNotifiedEventArgs> get characteristicNotified =>
      _characteristicNotifiedController.stream;

  @override
  Future<bool> authorize() {
    throw UnsupportedError('authorize is not supported on Windows.');
  }

  @override
  Future<void> showAppSettings() {
    throw UnsupportedError('showAppSettings is not supported on Windows.');
  }

  @override
  Future<void> startDiscovery({List<UUID>? serviceUUIDs}) async {
    _discoveriesArgs.clear();
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
  Future<List<Peripheral>> retrieveConnectedPeripherals() {
    throw UnsupportedError(
      'retrieveConnectedPeripherals is not supported on Windows.',
    );
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    _logger.info('connect: $addressArgs');
    await _api.connect(addressArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    _logger.info('disconnect: $addressArgs');
    await _api.disconnect(addressArgs);
  }

  @override
  Future<int> requestMTU(Peripheral peripheral, {required int mtu}) {
    throw UnsupportedError('requestMTU is not supported on Windows.');
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GATTCharacteristicWriteType type,
  }) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    _logger.info('getMTU: $addressArgs');
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
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final servicesArgs = await _getServices(
      addressArgs,
      CacheModeArgs.uncached,
    );
    final services = servicesArgs.map((args) => args.toService()).toList();
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
    Peripheral peripheral,
    GATTCharacteristic characteristic,
  ) async {
    if (peripheral is! PeripheralImpl ||
        characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final handleArgs = characteristic.handle;
    const modeArgs = CacheModeArgs.uncached;
    _logger.info('readCharacteristic: $addressArgs.$handleArgs - $modeArgs');
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
    if (peripheral is! PeripheralImpl ||
        characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final handleArgs = characteristic.handle;
    final valueArgs = value;
    final typeArgs = type.toArgs();
    _logger.info(
      'writeCharacteristic: $addressArgs.$handleArgs - $valueArgs, $typeArgs',
    );
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
    if (peripheral is! PeripheralImpl ||
        characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final handleArgs = characteristic.handle;
    final stateArgs =
        state
            ? characteristic.properties.contains(
                  GATTCharacteristicProperty.notify,
                )
                ? GATTCharacteristicNotifyStateArgs.notify
                : GATTCharacteristicNotifyStateArgs.indicate
            : GATTCharacteristicNotifyStateArgs.none;
    _logger.info(
      'setCharacteristicNotifyState: $addressArgs.$handleArgs - $stateArgs',
    );
    await _api.setCharacteristicNotifyState(addressArgs, handleArgs, stateArgs);
  }

  @override
  Future<Uint8List> readDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor,
  ) async {
    if (peripheral is! PeripheralImpl || descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final handleArgs = descriptor.handle;
    const modeArgs = CacheModeArgs.uncached;
    _logger.info('readDescriptor: $addressArgs.$handleArgs - $modeArgs');
    final value = await _api.readDescriptor(addressArgs, handleArgs, modeArgs);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (peripheral is! PeripheralImpl || descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final handleArgs = descriptor.handle;
    final valueArgs = value;
    _logger.info('writeDescriptor: $addressArgs.$handleArgs - $valueArgs');
    await _api.writeDescriptor(addressArgs, handleArgs, valueArgs);
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
    int timestampArgs,
    AdvertisementTypeArgs typeArgs,
    AdvertisementArgs advertisementArgs,
  ) {
    final addressArgs = peripheralArgs.addressArgs;
    _logger.info(
      'onDiscovered: $addressArgs - $rssiArgs, $timestampArgs, $typeArgs, $advertisementArgs',
    );
    if (typeArgs == AdvertisementTypeArgs.connectableDirected ||
        typeArgs == AdvertisementTypeArgs.nonConnectableUndirected ||
        typeArgs == AdvertisementTypeArgs.extended) {
      // No need to wait SCAN_REQ.
      final peripheral = peripheralArgs.toPeripheral();
      final rssi = rssiArgs;
      final advertisement = advertisementArgs.toAdvertisement();
      final eventArgs = DiscoveredEventArgs(peripheral, rssi, advertisement);
      _discoveredController.add(eventArgs);
    } else {
      final oldDiscoveryArgs = _discoveriesArgs.remove(addressArgs);
      final newDiscoveryArgs = DiscoveryArgs(
        peripheralArgs,
        rssiArgs,
        timestampArgs,
        typeArgs,
        advertisementArgs,
      );
      // TODO: Should we ignore this?
      final ignored =
          oldDiscoveryArgs == null ||
          _checkDiscoveryArgs(oldDiscoveryArgs, newDiscoveryArgs);
      if (ignored) {
        // Note that ADV_IND will be ignored if the advertiser never reply the
        // SCAN_REQ.
        _discoveriesArgs[addressArgs] = newDiscoveryArgs;
      } else {
        final peripheral = oldDiscoveryArgs.peripheralArgs.toPeripheral();
        final rssi = oldDiscoveryArgs.rssiArgs;
        final oldAdvertisement =
            typeArgs == AdvertisementTypeArgs.scanResponse
                ? oldDiscoveryArgs.advertisementArgs.toAdvertisement()
                : advertisementArgs.toAdvertisement();
        final newAdvertisement =
            typeArgs == AdvertisementTypeArgs.scanResponse
                ? advertisementArgs.toAdvertisement()
                : oldDiscoveryArgs.advertisementArgs.toAdvertisement();
        final name =
            newAdvertisement.name?.isNotEmpty == true
                ? newAdvertisement.name
                : oldAdvertisement.name;
        final serviceUUIDs =
            {
              ...oldAdvertisement.serviceUUIDs,
              ...newAdvertisement.serviceUUIDs,
            }.toList();
        final serviceData = {
          ...oldAdvertisement.serviceData,
          ...newAdvertisement.serviceData,
        };
        final manufacturerSpecificData = [
          ...oldAdvertisement.manufacturerSpecificData,
          ...newAdvertisement.manufacturerSpecificData,
        ];
        final advertisement = Advertisement(
          name: name,
          serviceUUIDs: serviceUUIDs,
          serviceData: serviceData,
          manufacturerSpecificData: manufacturerSpecificData,
        );
        final eventArgs = DiscoveredEventArgs(peripheral, rssi, advertisement);
        _discoveredController.add(eventArgs);
      }
    }
  }

  @override
  void onConnectionStateChanged(
    PeripheralArgs peripheralArgs,
    ConnectionStateArgs stateArgs,
  ) {
    final addressArgs = peripheralArgs.addressArgs;
    _logger.info('onConnectionStateChanged: $addressArgs - $stateArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final state = stateArgs.toState();
    final eventArgs = PeripheralConnectionStateChangedEventArgs(
      peripheral,
      state,
    );
    _connectionStateChangedController.add(eventArgs);
  }

  @override
  void onMTUChanged(PeripheralArgs peripheralArgs, int mtuArgs) {
    final addressArgs = peripheralArgs.addressArgs;
    _logger.info('onMTUChanged: $addressArgs - $mtuArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final mtu = mtuArgs;
    final eventArgs = PeripheralMTUChangedEventArgs(peripheral, mtu);
    _mtuChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicNotified(
    PeripheralArgs peripheralArgs,
    GATTCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  ) {
    final addressArgs = peripheralArgs.addressArgs;
    final handleArgs = characteristicArgs.handleArgs;
    _logger.info(
      'onCharacteristicNotified: $addressArgs.$handleArgs - $valueArgs',
    );
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

  Future<List<GATTServiceArgs>> _getServices(
    int addressArgs,
    CacheModeArgs modeArgs,
  ) async {
    _logger.info('getServices: $addressArgs - $modeArgs');
    final servicesArgs = await _api
        .getServices(addressArgs, modeArgs)
        .then((args) => args.cast<GATTServiceArgs>());
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

  Future<List<GATTServiceArgs>> _getIncludedServices(
    int addressArgs,
    int handleArgs,
    CacheModeArgs modeArgs,
  ) async {
    _logger.info('getIncludedServices: $addressArgs.$handleArgs - $modeArgs');
    final servicesArgs = await _api
        .getIncludedServices(addressArgs, handleArgs, modeArgs)
        .then((args) => args.cast<GATTServiceArgs>());
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

  Future<List<GATTCharacteristicArgs>> _getCharacteristics(
    int addressArgs,
    int handleArgs,
    CacheModeArgs modeArgs,
  ) async {
    _logger.info('getCharacteristics: $addressArgs.$handleArgs - $modeArgs');
    final characteristicsArgs = await _api
        .getCharacteristics(addressArgs, handleArgs, modeArgs)
        .then((args) => args.cast<GATTCharacteristicArgs>());
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

  Future<List<GATTDescriptorArgs>> _getDescriptors(
    int addressArgs,
    int handleArgs,
    CacheModeArgs modeArgs,
  ) async {
    _logger.info('getDescriptors: $addressArgs,$handleArgs - $modeArgs');
    final descriptorsArgs = await _api
        .getDescriptors(addressArgs, handleArgs, modeArgs)
        .then((args) => args.cast<GATTDescriptorArgs>());
    return descriptorsArgs;
  }

  bool _checkDiscoveryArgs(
    DiscoveryArgs oldDiscoveryArgs,
    DiscoveryArgs newDiscoveryArgs,
  ) {
    final oldAddressArgs = oldDiscoveryArgs.peripheralArgs.addressArgs;
    final newAddressArgs = newDiscoveryArgs.peripheralArgs.addressArgs;
    if (oldAddressArgs != newAddressArgs) {
      _logger.fine(
        'ignored by different addressArgs $oldAddressArgs, $newAddressArgs',
      );
      return true;
    }
    final address = (newAddressArgs & 0xFFFFFFFFFFFF)
        .toRadixString(16)
        .padLeft(12, '0');
    if (oldDiscoveryArgs.typeArgs == newDiscoveryArgs.typeArgs) {
      _logger.fine(
        'ignored by same typeArgs $address: ${oldDiscoveryArgs.typeArgs}:${oldDiscoveryArgs.timestampArgs}, ${newDiscoveryArgs.typeArgs}:${newDiscoveryArgs.timestampArgs}',
      );
      return true;
    }
    if (oldDiscoveryArgs.typeArgs != AdvertisementTypeArgs.scanResponse &&
        newDiscoveryArgs.typeArgs != AdvertisementTypeArgs.scanResponse) {
      _logger.fine(
        'ignored by wrong typeArgs $address:  ${oldDiscoveryArgs.typeArgs}:${oldDiscoveryArgs.timestampArgs}, ${newDiscoveryArgs.typeArgs}:${newDiscoveryArgs.timestampArgs}',
      );
      return true;
    }
    final interval =
        newDiscoveryArgs.typeArgs == AdvertisementTypeArgs.scanResponse
            ? newDiscoveryArgs.timestampArgs - oldDiscoveryArgs.timestampArgs
            : oldDiscoveryArgs.timestampArgs - newDiscoveryArgs.timestampArgs;
    final ignored = interval < 0 || interval > 1000;
    if (ignored) {
      _logger.fine(
        'ignored by wrong timestampArgs $address: $interval, ${oldDiscoveryArgs.typeArgs}:${oldDiscoveryArgs.timestampArgs}, ${newDiscoveryArgs.typeArgs}:${newDiscoveryArgs.timestampArgs}',
      );
    }
    return ignored;
  }
}

final class CentralManagerChannelImpl extends CentralManagerChannel {
  @override
  CentralManager create() => CentralManagerImpl();
}
