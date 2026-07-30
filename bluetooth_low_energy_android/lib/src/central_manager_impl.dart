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
  final StreamController<PeripheralBondStateChangedEventArgs>
  _bondStateChangedController;
  final StreamController<PeripheralMTUChangedEventArgs> _mtuChangedController;
  final StreamController<GATTCharacteristicNotifiedEventArgs>
  _characteristicNotifiedController;
  final Map<int, StreamController<Uint8List>> _l2capChannelControllers;

  /// Inbound bytes that arrived before [openL2CAPChannel] built the channel
  /// object for that id. The native side waits for `startL2CAPChannel` before
  /// it reads, so these should stay empty; they are the second line of defence
  /// that keeps a stray early event delayed rather than dropped.
  final Map<int, List<Uint8List>> _l2capPendingChunks;

  /// Close notifications for ids with no channel object yet; the value is the
  /// error description, null on a clean close.
  final Map<int, String?> _l2capPendingClosures;

  final Map<String, int> _mtus;

  late final CentralManagerArgs _args;

  BluetoothLowEnergyState _state;

  CentralManagerImpl()
    : _api = CentralManagerHostApi(),
      _stateChangedController = StreamController.broadcast(),
      _discoveredController = StreamController.broadcast(),
      _connectionStateChangedController = StreamController.broadcast(),
      _bondStateChangedController = StreamController.broadcast(),
      _mtuChangedController = StreamController.broadcast(),
      _characteristicNotifiedController = StreamController.broadcast(),
      _l2capChannelControllers = {},
      _l2capPendingChunks = {},
      _l2capPendingClosures = {},
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
  Stream<PeripheralBondStateChangedEventArgs> get bondStateChanged =>
      _bondStateChangedController.stream;
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
  Future<Peripheral> getPeripheral(String address) async {
    final addressArgs = address;
    _logger.info('getPeripheral: $addressArgs');
    final peripheralArgs = await _api.getPeripheral(addressArgs);
    final peripheral = peripheralArgs.toPeripheral();
    return peripheral;
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals({List<UUID>? serviceUUIDs}) async {
    _logger.info('retrieveConnectedPeripherals');
    final peripheralsArgs = await _api.retrieveConnectedPeripherals();
    final peripherals = peripheralsArgs
        .map((args) => args.toPeripheral())
        .toList();
    return peripherals;
  }

  @override
  Future<List<Peripheral>> retrievePeripherals(List<UUID> identifiers) async => [];

  @override
  Future<List<({String address, String? name})>> getBondedDevices() async {
    _logger.info('getBondedDevices');
    final bondedArgs = await _api.getBondedDevices();
    return bondedArgs
        .map((args) => (address: args.addressArgs, name: args.nameArgs))
        .toList();
  }

  @override
  Future<void> removeBond(String address) async {
    _logger.info('removeBond: $address');
    final ok = await _api.removeBond(address);
    if (!ok) {
      throw StateError('removeBond failed for $address');
    }
  }

  @override
  Future<void> createBond(String address) async {
    _logger.info('createBond: $address');
    final ok = await _api.createBond(address);
    if (!ok) {
      throw StateError('createBond failed for $address');
    }
  }

  @override
  Future<L2CAPChannel> openL2CAPChannel(
    Peripheral peripheral, {
    required int psm,
  }) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    _logger.info('openL2CAPChannel: $addressArgs - $psm');
    final idArgs = await _api.openL2CAPChannel(addressArgs, psm);
    final controller = StreamController<Uint8List>();
    _l2capChannelControllers[idArgs] = controller;
    _drainPendingL2CAPEvents(idArgs, controller);
    final channel = L2CAPChannelImpl(this, idArgs, psm, controller.stream);
    // Only now, with a stream in place to receive them, may the peer's bytes
    // start flowing.
    if (!controller.isClosed) {
      await _api.startL2CAPChannel(idArgs);
    }
    return channel;
  }

  /// Hands the channel whatever arrived before it existed, oldest first, and
  /// applies a close notification that raced ahead of it.
  void _drainPendingL2CAPEvents(
    int idArgs,
    StreamController<Uint8List> controller,
  ) {
    final chunks = _l2capPendingChunks.remove(idArgs);
    if (chunks != null) {
      for (final chunk in chunks) {
        controller.add(chunk);
      }
    }
    if (!_l2capPendingClosures.containsKey(idArgs)) {
      return;
    }
    final errorArgs = _l2capPendingClosures.remove(idArgs);
    _l2capChannelControllers.remove(idArgs);
    if (errorArgs != null) {
      controller.addError(StateError(errorArgs));
    }
    controller.close();
  }

  Future<void> _writeL2CAPChannel(int idArgs, Uint8List value) async {
    _logger.info('writeL2CAPChannel: $idArgs - ${value.length} bytes');
    await _api.writeL2CAPChannel(idArgs, value);
  }

  Future<void> _closeL2CAPChannel(int idArgs) async {
    _logger.info('closeL2CAPChannel: $idArgs');
    await _api.closeL2CAPChannel(idArgs);
    // The map entry stays until the native close notification lands: it marks
    // the id as known, so anything still in flight is ignored rather than
    // mistaken for an early event and buffered.
    await _l2capChannelControllers[idArgs]?.close();
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
    final value = state
        ? characteristic.properties.contains(GATTCharacteristicProperty.notify)
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
  void onBondStateChanged(
    PeripheralArgs peripheralArgs,
    BondStateArgs bondStateArgs,
  ) {
    final addressArgs = peripheralArgs.addressArgs;
    _logger.info('onBondStateChanged: $addressArgs - $bondStateArgs');
    final peripheral = peripheralArgs.toPeripheral();
    final bondState = bondStateArgs.toBondState();
    final eventArgs = PeripheralBondStateChangedEventArgs(peripheral, bondState);
    _bondStateChangedController.add(eventArgs);
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

  @override
  void onL2CAPChannelReceived(int idArgs, Uint8List valueArgs) {
    final controller = _l2capChannelControllers[idArgs];
    if (controller == null) {
      // No channel object for this id yet - hold the bytes for it.
      _logger.warning(
        'onL2CAPChannelReceived: $idArgs - '
        '${valueArgs.length} bytes arrived before the channel was ready',
      );
      _l2capPendingChunks.putIfAbsent(idArgs, () => []).add(valueArgs);
      return;
    }
    if (controller.isClosed) {
      return;
    }
    controller.add(valueArgs);
  }

  @override
  void onL2CAPChannelClosed(int idArgs, String? errorArgs) {
    _logger.info('onL2CAPChannelClosed: $idArgs - $errorArgs');
    final controller = _l2capChannelControllers.remove(idArgs);
    if (controller == null) {
      // Same window as above: remember the close so the channel object can end
      // its stream as soon as it exists.
      _l2capPendingClosures[idArgs] = errorArgs;
      return;
    }
    if (controller.isClosed) {
      return;
    }
    if (errorArgs != null) {
      controller.addError(StateError(errorArgs));
    }
    controller.close();
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

final class L2CAPChannelImpl implements L2CAPChannel {
  final CentralManagerImpl _manager;
  final int _idArgs;
  @override
  final int psm;
  @override
  final Stream<Uint8List> stream;

  L2CAPChannelImpl(this._manager, this._idArgs, this.psm, this.stream);

  @override
  Future<void> write(Uint8List value) => _manager._writeL2CAPChannel(_idArgs, value);

  @override
  Future<void> close() => _manager._closeL2CAPChannel(_idArgs);
}

final class CentralManagerChannelImpl extends CentralManagerChannel {
  @override
  CentralManager create() => CentralManagerImpl();
}
