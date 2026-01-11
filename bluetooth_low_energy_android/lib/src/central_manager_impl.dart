import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/widgets.dart' hide ConnectionState;
import 'package:logging/logging.dart';

import 'api.dart';
import 'api.g.dart';
import 'gatt_impl.dart';
import 'peripheral_impl.dart';

Logger get _logger => Logger('CentralManager');

final class CentralManagerImpl
    with WidgetsBindingObserver
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

  final Map<String, int> _mtus;

  late final CentralManagerArgs _args;

  BluetoothLowEnergyState _state;

  CentralManagerImpl()
    : _api = CentralManagerHostApi(),
      _stateChangedController = StreamController.broadcast(),
      _discoveredController = StreamController.broadcast(),
      _connectionStateChangedController = StreamController.broadcast(),
      _mtuChangedController = StreamController.broadcast(),
      _characteristicNotifiedController = StreamController.broadcast(),
      _mtus = {},
      _state = BluetoothLowEnergyState.unknown {
    CentralManagerFlutterApi.setUp(this);
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.addObserver(this);
    _initialize();
  }

  UUID get cccUUID => UUID.short(0x2902);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _logger.info('didChangeAppLifecycleState: $state');
    if (state != AppLifecycleState.resumed) {
      return;
    }
    _getState();
  }

  @override
  Future<bool> authorize() async {
    _logger.info('authorize');
    final authorized = await _api.authorize();
    return authorized;
  }

  @override
  Future<void> showAppSettings() async {
    _logger.info('showAppSettings');
    await _api.showAppSettings();
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
  Future<List<Peripheral>> retrieveConnectedPeripherals() async {
    _logger.info('retrieveConnectedPeripherals');
    final peripheralsArgs = await _api.retrieveConnectedPeripherals();
    final peripherals =
        peripheralsArgs
            .cast<PeripheralArgs>()
            .map((args) => args.toPeripheral())
            .toList();
    return peripherals;
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
  Future<int> requestMTU(Peripheral peripheral, {required int mtu}) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final mtuArgs = mtu;
    _logger.info('requestMTU: $addressArgs - $mtuArgs');
    final size = await _api.requestMTU(addressArgs, mtuArgs);
    return size;
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GATTCharacteristicWriteType type,
  }) {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final mtu = _mtus[addressArgs] ?? 23;
    final maximumWriteLength = (mtu - 3).clamp(20, 512);
    return Future.value(maximumWriteLength);
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    _logger.info('readRSSI: $addressArgs');
    final rssi = await _api.readRSSI(addressArgs);
    return rssi;
  }

  @override
  Future<List<GATTService>> discoverGATT(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    _logger.info('discoverGATT: $addressArgs');
    final servicesArgs = await _api.discoverGATT(addressArgs);
    final services =
        servicesArgs
            .cast<GATTServiceArgs>()
            .map((args) => args.toService())
            .toList();
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
    final hashCodeArgs = characteristic.hashCode;
    _logger.info('readCharacteristic: $addressArgs.$hashCodeArgs');
    final value = await _api.readCharacteristic(addressArgs, hashCodeArgs);
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
    final hashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    final typeArgs = type.toArgs();
    _logger.info(
      'writeCharacteristic: $addressArgs.$hashCodeArgs - $valueArgs, $typeArgs',
    );
    await _api.writeCharacteristic(
      addressArgs,
      hashCodeArgs,
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
    final hashCodeArgs = characteristic.hashCode;
    final enableArgs = state;
    _logger.info(
      'setCharacteristicNotification: $addressArgs.$hashCodeArgs - $enableArgs',
    );
    await _api.setCharacteristicNotification(
      addressArgs,
      hashCodeArgs,
      enableArgs,
    );
    // Seems the docs is not correct, this operation is necessary for all characteristics.
    // https://developer.android.com/guide/topics/connectivity/bluetooth/transfer-ble-data#notification
    final descriptor = characteristic.descriptors.firstWhere(
      (descriptor) => descriptor.uuid == cccUUID,
    );
    final value =
        state
            ? characteristic.properties.contains(
                  GATTCharacteristicProperty.notify,
                )
                ? _args.enableNotificationValue
                : _args.enableIndicationValue
            : _args.disableNotificationValue;
    await writeDescriptor(peripheral, descriptor, value: value);
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
    final hashCodeArgs = descriptor.hashCode;
    _logger.info('readDescriptor: $addressArgs.$hashCodeArgs');
    final value = await _api.readDescriptor(addressArgs, hashCodeArgs);
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
    final hashCodeArgs = descriptor.hashCode;
    final valueArgs = value;
    _logger.info('writeDescriptor: $addressArgs.$hashCodeArgs - $valueArgs');
    await _api.writeDescriptor(addressArgs, hashCodeArgs, valueArgs);
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
    final addressArgs = peripheralArgs.addressArgs;
    _logger.info('onDiscovered: $addressArgs - $rssiArgs, $advertisementArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final rssi = rssiArgs;
    final advertisement = advertisementArgs.toAdvertisement();
    final eventArgs = DiscoveredEventArgs(peripheral, rssi, advertisement);
    _discoveredController.add(eventArgs);
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
    if (state == ConnectionState.disconnected) {
      _mtus.remove(addressArgs);
    }
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
    _mtus[addressArgs] = mtu;
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
    final hashCodeArgs = characteristicArgs.hashCodeArgs;
    _logger.info(
      'onCharacteristicNotified: $addressArgs.$hashCodeArgs - $valueArgs',
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
        _args = await _api.initialize();
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
}

final class CentralManagerChannelImpl extends CentralManagerChannel {
  @override
  CentralManager create() => CentralManagerImpl();
}
