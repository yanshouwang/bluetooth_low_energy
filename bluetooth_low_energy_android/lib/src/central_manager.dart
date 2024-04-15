import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'bluetooth_low_energy_manager.dart';
import 'pigeon.g.dart';

abstract interface class AndroidCentralManager {
  Stream<MtuChangedEventArgs> get mtuChanged;

  Future<bool> requestPermission();
  Future<void> requestMTU(Peripheral peripheral, int mtu);
}

base class MtuChangedEventArgs extends EventArgs {
  final Peripheral peripheral;
  final int mtu;

  MtuChangedEventArgs(this.peripheral, this.mtu);
}

base class AndroidCentralManagerImpl extends CentralManagerImpl
    implements AndroidCentralManager, CentralManagerEventChannel {
  final CentralManagerCommandChannel _channel;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<ConnectionStateChangedEventArgs>
      _connectionStateChangedController;
  final StreamController<MtuChangedEventArgs> _mtuChangedController;
  final StreamController<GattCharacteristicNotifiedEventArgs>
      _characteristicNotifiedController;

  final Map<String, AndroidPeripheralImpl> _peripherals;
  final Map<String, Map<int, AndroidGattCharacteristicImpl>> _characteristics;
  final Map<String, int> _mtus;

  BluetoothLowEnergyState _state;

  AndroidCentralManagerImpl()
      : _channel = CentralManagerCommandChannel(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _mtuChangedController = StreamController.broadcast(),
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
  Stream<MtuChangedEventArgs> get mtuChanged => _mtuChangedController.stream;
  @override
  Stream<GattCharacteristicNotifiedEventArgs> get characteristicNotified =>
      _characteristicNotifiedController.stream;

  @override
  void initialize() async {
    logger.info('initialize');
    CentralManagerEventChannel.setUp(this);
    await _channel.initialize();
  }

  @override
  Future<bool> requestPermission() async {
    logger.info('requestPermission');
    final state = await _channel.requestPermission();
    return state;
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
  Future<List<Peripheral>> retrieveConnectedPeripherals() {
    // TODO: implement retrieveConnectedPeripherals
    throw UnimplementedError();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! AndroidPeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('connect: $addressArgs');
    await _channel.connect(addressArgs);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! AndroidPeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('disconnect: $addressArgs');
    await _channel.disconnect(addressArgs);
  }

  @override
  Future<void> requestMTU(Peripheral peripheral, int mtu) async {
    if (peripheral is! AndroidPeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    final mtuArgs = mtu;
    logger.info('requestMTU: $addressArgs - $mtuArgs');
    await _channel.requestMTU(addressArgs, mtuArgs);
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    if (peripheral is! AndroidPeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('readRSSI: $addressArgs');
    final rssi = await _channel.readRSSI(addressArgs);
    return rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    if (peripheral is! AndroidPeripheralImpl) {
      throw TypeError();
    }
    final addressArgs = peripheral.address;
    logger.info('discoverServices: $addressArgs');
    final servicesArgs = await _channel.discoverServices(addressArgs);
    final services = servicesArgs
        .cast<GattServiceArgs>()
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
    if (characteristic is! AndroidGattCharacteristicImpl) {
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
    if (characteristic is! AndroidGattCharacteristicImpl) {
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
    if (characteristic is! AndroidGattCharacteristicImpl) {
      throw TypeError();
    }
    final peripheral = characteristic.peripheral;
    final addressArgs = peripheral.address;
    final hashCodeArgs = characteristic.hashCode;
    final stateArgs = state
        ? characteristic.properties.contains(GattCharacteristicProperty.notify)
            ? GattCharacteristicNotifyStateArgs.notify
            : GattCharacteristicNotifyStateArgs.indicate
        : GattCharacteristicNotifyStateArgs.none;
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
    if (descriptor is! AndroidGattDescriptorImpl) {
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
    if (descriptor is! AndroidGattDescriptorImpl) {
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
    final stateArgs = BluetoothLowEnergyStateArgs.values[stateNumberArgs];
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
    PeripheralArgs peripheralArgs,
    int rssiArgs,
    AdvertisementArgs advertisementArgs,
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
    final eventArgs = MtuChangedEventArgs(peripheral, mtu);
    _mtuChangedController.add(eventArgs);
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

  AndroidGattCharacteristicImpl? _retrieveCharacteristic(
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

base class AndroidPeripheralImpl extends PeripheralImpl {
  final String address;

  AndroidPeripheralImpl({
    required this.address,
  }) : super(
          uuid: UUID.fromAddress(address),
        );
}

base class AndroidGattDescriptorImpl extends GattDescriptorImpl {
  final AndroidPeripheralImpl peripheral;
  @override
  final int hashCode;

  AndroidGattDescriptorImpl({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
  });

  @override
  bool operator ==(Object other) {
    return other is AndroidGattDescriptorImpl &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}

base class AndroidGattCharacteristicImpl extends GattCharacteristicImpl {
  final AndroidPeripheralImpl peripheral;
  @override
  final int hashCode;

  AndroidGattCharacteristicImpl({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
    required super.properties,
    required List<AndroidGattDescriptorImpl> descriptors,
  }) : super(descriptors: descriptors);

  @override
  List<AndroidGattDescriptorImpl> get descriptors =>
      super.descriptors.cast<AndroidGattDescriptorImpl>();

  @override
  bool operator ==(Object other) {
    return other is AndroidGattCharacteristicImpl &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}

base class AndroidGattServiceImpl extends GattServiceImpl {
  final AndroidPeripheralImpl peripheral;
  @override
  final int hashCode;

  AndroidGattServiceImpl({
    required this.peripheral,
    required this.hashCode,
    required super.uuid,
    required List<AndroidGattCharacteristicImpl> characteristics,
  }) : super(characteristics: characteristics);

  @override
  List<AndroidGattCharacteristicImpl> get characteristics =>
      super.characteristics.cast<AndroidGattCharacteristicImpl>();

  @override
  bool operator ==(Object other) {
    return other is AndroidGattServiceImpl &&
        other.peripheral == peripheral &&
        other.hashCode == hashCode;
  }
}

extension GattCharacteristicPropertyArgsX on GattCharacteristicPropertyArgs {
  GattCharacteristicProperty toProperty() {
    return GattCharacteristicProperty.values[index];
  }
}

extension ManufacturerSpecificDataArgsX on ManufacturerSpecificDataArgs {
  ManufacturerSpecificData toManufacturerSpecificData() {
    final id = idArgs;
    final data = dataArgs;
    return ManufacturerSpecificData(
      id: id,
      data: data,
    );
  }
}

extension AdvertisementArgsX on AdvertisementArgs {
  Advertisement toAdvertisement() {
    final name = nameArgs;
    final serviceUUIDs =
        serviceUUIDsArgs.cast<String>().map((args) => args.toUUID()).toList();
    final serviceData = serviceDataArgs.cast<String, Uint8List>().map(
      (uuidArgs, dataArgs) {
        final uuid = uuidArgs.toUUID();
        final data = dataArgs;
        return MapEntry(uuid, data);
      },
    );
    final manufacturerSpecificData =
        manufacturerSpecificDataArgs?.toManufacturerSpecificData();
    return Advertisement(
      name: name,
      serviceUUIDs: serviceUUIDs,
      serviceData: serviceData,
      manufacturerSpecificData: manufacturerSpecificData,
    );
  }
}

extension PeripheralArgsX on PeripheralArgs {
  AndroidPeripheralImpl toPeripheral() {
    return AndroidPeripheralImpl(
      address: addressArgs,
    );
  }
}

extension GattDescriptorArgsX on GattDescriptorArgs {
  AndroidGattDescriptorImpl toDescriptor(AndroidPeripheralImpl peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    return AndroidGattDescriptorImpl(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
    );
  }
}

extension GattCharacteristicArgsX on GattCharacteristicArgs {
  AndroidGattCharacteristicImpl toCharacteristic(
      AndroidPeripheralImpl peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    final properties = propertyNumbersArgs.cast<int>().map(
      (args) {
        final propertyArgs = GattCharacteristicPropertyArgs.values[args];
        return propertyArgs.toProperty();
      },
    ).toList();
    final descriptors = descriptorsArgs
        .cast<GattDescriptorArgs>()
        .map((args) => args.toDescriptor(peripheral))
        .toList();
    return AndroidGattCharacteristicImpl(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension GattServiceArgsX on GattServiceArgs {
  AndroidGattServiceImpl toService(AndroidPeripheralImpl peripheral) {
    final hashCode = hashCodeArgs;
    final uuid = uuidArgs.toUUID();
    final characteristics = characteristicsArgs
        .cast<GattCharacteristicArgs>()
        .map((args) => args.toCharacteristic(peripheral))
        .toList();
    return AndroidGattServiceImpl(
      peripheral: peripheral,
      hashCode: hashCode,
      uuid: uuid,
      characteristics: characteristics,
    );
  }
}

extension GattCharacteristicWriteTypeX on GattCharacteristicWriteType {
  GattCharacteristicWriteTypeArgs toArgs() {
    return GattCharacteristicWriteTypeArgs.values[index];
  }
}
