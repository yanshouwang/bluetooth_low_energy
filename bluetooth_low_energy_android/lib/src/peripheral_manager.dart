import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'bluetooth_low_energy_manager.dart';
import 'pigeon.g.dart';

base class AndroidPeripheralManagerImpl extends PeripheralManagerImpl
    implements PeripheralManagerEventChannel {
  final PeripheralManagerCommandChannel _channel;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<GattCharacteristicReadEventArgs>
      _characteristicReadController;
  final StreamController<GattCharacteristicWrittenEventArgs>
      _characteristicWrittenController;
  final StreamController<GattCharacteristicNotifyStateChangedEventArgs>
      _characteristicNotifyStateChangedController;

  final Map<String, AndroidCentralImpl> _centrals;
  final Map<int, Map<int, GattCharacteristicImpl>> _characteristics;
  final Map<int, Map<int, GattDescriptorImpl>> _descriptors;
  final Map<String, int> _mtus;
  final Map<String, Map<int, bool>> _confirms;
  final Map<String, GattCharacteristicImpl> _preparedCharacteristics;
  final Map<String, GattDescriptorImpl> _preparedDescriptors;
  final Map<String, List<int>> _preparedValue;

  BluetoothLowEnergyState _state;

  AndroidPeripheralManagerImpl()
      : _channel = PeripheralManagerCommandChannel(),
        _stateChangedController = StreamController.broadcast(),
        _characteristicReadController = StreamController.broadcast(),
        _characteristicWrittenController = StreamController.broadcast(),
        _characteristicNotifyStateChangedController =
            StreamController.broadcast(),
        _centrals = {},
        _characteristics = {},
        _descriptors = {},
        _mtus = {},
        _confirms = {},
        _preparedCharacteristics = {},
        _preparedDescriptors = {},
        _preparedValue = {},
        _state = BluetoothLowEnergyState.unknown;

  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<GattCharacteristicReadEventArgs> get characteristicRead =>
      _characteristicReadController.stream;
  @override
  Stream<GattCharacteristicWrittenEventArgs> get characteristicWritten =>
      _characteristicWrittenController.stream;
  @override
  Stream<GattCharacteristicNotifyStateChangedEventArgs>
      get characteristicNotifyStateChanged =>
          _characteristicNotifyStateChangedController.stream;

  @override
  void initialize() async {
    logger.info('initialize');
    PeripheralManagerEventChannel.setUp(this);
    await _channel.initialize();
  }

  @override
  Future<BluetoothLowEnergyState> getState() {
    logger.info('getState');
    return Future.value(_state);
  }

  @override
  Future<void> addService(GattService service) async {
    if (service is! GattServiceImpl) {
      throw TypeError();
    }
    final characteristics = <int, GattCharacteristicImpl>{};
    final descriptors = <int, GattDescriptorImpl>{};
    final characteristicsArgs = <GattCharacteristicArgs>[];
    for (var characteristic in service.characteristics) {
      final descriptorsArgs = <GattDescriptorArgs>[];
      final properties = characteristic.properties;
      final canNotify =
          properties.contains(GattCharacteristicProperty.notify) ||
              properties.contains(GattCharacteristicProperty.indicate);
      if (canNotify) {
        // CLIENT_CHARACTERISTIC_CONFIG
        final cccDescriptor = GattDescriptorImpl(
          uuid: UUID.short(0x2902),
          value: Uint8List.fromList([0x00, 0x00]),
        );
        final cccDescriptorArgs = cccDescriptor.toArgs();
        descriptorsArgs.add(cccDescriptorArgs);
        descriptors[cccDescriptorArgs.hashCodeArgs] = cccDescriptor;
      }
      for (var descriptor in characteristic.descriptors) {
        final descriptorArgs = descriptor.toArgs();
        descriptorsArgs.add(descriptorArgs);
        descriptors[descriptorArgs.hashCodeArgs] = descriptor;
      }
      final characteristicArgs = characteristic.toArgs(descriptorsArgs);
      characteristicsArgs.add(characteristicArgs);
      characteristics[characteristicArgs.hashCodeArgs] = characteristic;
    }
    final serviceArgs = service.toArgs(characteristicsArgs);
    logger.info('addService: $serviceArgs');
    await _channel.addService(serviceArgs);
    _characteristics[serviceArgs.hashCodeArgs] = characteristics;
    _descriptors[serviceArgs.hashCodeArgs] = descriptors;
  }

  @override
  Future<void> removeService(GattService service) async {
    final hashCodeArgs = service.hashCode;
    logger.info('removeService: $hashCodeArgs');
    await _channel.removeService(hashCodeArgs);
    _characteristics.remove(hashCodeArgs);
    _descriptors.remove(hashCodeArgs);
  }

  @override
  Future<void> clearServices() async {
    logger.info('clearServices');
    await _channel.clearServices();
    _characteristics.clear();
    _descriptors.clear();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement) async {
    final advertisementArgs = advertisement.toArgs();
    logger.info('startAdvertising: $advertisementArgs');
    await _channel.startAdvertising(advertisementArgs);
  }

  @override
  Future<void> stopAdvertising() async {
    logger.info('stopAdvertising');
    await _channel.stopAdvertising();
  }

  @override
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic) {
    if (characteristic is! GattCharacteristicImpl) {
      throw TypeError();
    }
    final hashCodeArgs = characteristic.hashCode;
    logger.info('readCharacteristic: $hashCodeArgs');
    final value = characteristic.value;
    return Future.value(value);
  }

  @override
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    Central? central,
  }) async {
    if (characteristic is! GattCharacteristicImpl) {
      throw TypeError();
    }
    characteristic.value = value;
    if (central == null) {
      return;
    }
    if (central is! AndroidCentralImpl) {
      throw TypeError();
    }
    final addressArgs = central.address;
    final hashCodeArgs = characteristic.hashCode;
    final confirm = _retrieveConfirm(addressArgs, hashCodeArgs);
    if (confirm == null) {
      logger.warning('The central is not listening.');
      return;
    }
    final trimmedValueArgs = characteristic.value;
    // Fragments the value by MTU - 3 size.
    // If mtu is null, use 23 as default MTU size.
    final mtu = _mtus[addressArgs] ?? 23;
    final fragmentSize = (mtu - 3).clamp(20, 512);
    var start = 0;
    while (start < trimmedValueArgs.length) {
      final end = start + fragmentSize;
      final fragmentedValueArgs = end < trimmedValueArgs.length
          ? trimmedValueArgs.sublist(start, end)
          : trimmedValueArgs.sublist(start);
      logger.info(
          'notifyCharacteristicChanged: $hashCodeArgs - $fragmentedValueArgs, $confirm, $addressArgs');
      await _channel.notifyCharacteristicChanged(
        hashCodeArgs,
        fragmentedValueArgs,
        confirm,
        addressArgs,
      );
      start = end;
    }
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
  void onConnectionStateChanged(CentralArgs centralArgs, bool stateArgs) {
    final addressArgs = centralArgs.addressArgs;
    logger.info('onConnectionStateChanged: $addressArgs - $stateArgs');
    final central = centralArgs.toCentral();
    final state = stateArgs;
    if (state) {
      _centrals[addressArgs] = central;
    } else {
      _centrals.remove(addressArgs);
      _mtus.remove(addressArgs);
      _confirms.remove(addressArgs);
    }
  }

  @override
  void onMtuChanged(String addressArgs, int mtuArgs) {
    logger.info('onMtuChanged: $addressArgs - $mtuArgs');
    final mtu = mtuArgs;
    _mtus[addressArgs] = mtu;
  }

  @override
  void onCharacteristicReadRequest(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
  ) async {
    logger.info(
        'onCharacteristicReadRequest: $addressArgs.$hashCodeArgs - $idArgs, $offsetArgs');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    const statusArgs = GattStatusArgs.success;
    final offset = offsetArgs;
    final valueArgs = _onCharacteristicRead(central, characteristic, offset);
    await _trySendResponse(
      addressArgs,
      idArgs,
      statusArgs,
      offsetArgs,
      valueArgs,
    );
  }

  @override
  void onCharacteristicWriteRequest(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
  ) async {
    logger.info(
        'onCharacteristicWriteRequest: $addressArgs.$hashCodeArgs - $idArgs, $offsetArgs, $valueArgs, $preparedWriteArgs, $responseNeededArgs');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final GattStatusArgs statusArgs;
    if (preparedWriteArgs) {
      final preparedCharacteristic = _preparedCharacteristics[addressArgs];
      if (preparedCharacteristic != null &&
          preparedCharacteristic != characteristic) {
        statusArgs = GattStatusArgs.connectionCongested;
      } else {
        final preparedValueArgs = _preparedValue[addressArgs];
        if (preparedValueArgs == null) {
          _preparedCharacteristics[addressArgs] = characteristic;
          // Change the immutable Uint8List to mutable.
          _preparedValue[addressArgs] = [...valueArgs];
        } else {
          preparedValueArgs.insertAll(offsetArgs, valueArgs);
        }
        statusArgs = GattStatusArgs.success;
      }
    } else {
      final value = valueArgs;
      _onCharacteristicWritten(central, characteristic, value);
      statusArgs = GattStatusArgs.success;
    }
    if (responseNeededArgs) {
      await _trySendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        null,
      );
    }
  }

  @override
  void onCharacteristicNotifyStateChanged(
    String addressArgs,
    int hashCodeArgs,
    int stateNumberArgs,
  ) {
    final stateArgs = GattCharacteristicNotifyStateArgs.values[stateNumberArgs];
    logger.info(
        'onCharacteristicNotifyStateChanged: $addressArgs.$hashCodeArgs - $stateArgs');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final state = stateArgs != GattCharacteristicNotifyStateArgs.none;
    final confirms = _confirms.putIfAbsent(addressArgs, () => {});
    if (state) {
      confirms[hashCodeArgs] =
          stateArgs == GattCharacteristicNotifyStateArgs.indicate;
    } else {
      confirms.remove(hashCodeArgs);
    }
    final eventArgs = GattCharacteristicNotifyStateChangedEventArgs(
      central,
      characteristic,
      state,
    );
    _characteristicNotifyStateChangedController.add(eventArgs);
  }

  @override
  void onDescriptorReadRequest(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
  ) async {
    logger.info(
        'onDescriptorReadRequest: $addressArgs.$hashCodeArgs - $idArgs, $offsetArgs');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
    final descriptor = _retrieveDescriptor(hashCodeArgs);
    if (descriptor == null) {
      return;
    }
    const statusArgs = GattStatusArgs.success;
    final offset = offsetArgs;
    final valueArgs = descriptor.value.sublist(offset);
    await _trySendResponse(
      addressArgs,
      idArgs,
      statusArgs,
      offsetArgs,
      valueArgs,
    );
  }

  @override
  void onDescriptorWriteRequest(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
  ) async {
    logger.info(
        'onDescriptorWriteRequest: $addressArgs.$hashCodeArgs - $idArgs, $offsetArgs, $valueArgs, $preparedWriteArgs, $responseNeededArgs');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
    final descriptor = _retrieveDescriptor(hashCodeArgs);
    if (descriptor == null) {
      return;
    }
    final GattStatusArgs statusArgs;
    if (preparedWriteArgs) {
      final preparedDescriptor = _preparedCharacteristics[addressArgs];
      if (preparedDescriptor != null && preparedDescriptor != descriptor) {
        statusArgs = GattStatusArgs.connectionCongested;
      } else {
        final preparedValueArgs = _preparedValue[addressArgs];
        if (preparedValueArgs == null) {
          _preparedDescriptors[addressArgs] = descriptor;
          // Change the immutable Uint8List to mutable.
          _preparedValue[addressArgs] = [...valueArgs];
        } else {
          preparedValueArgs.insertAll(offsetArgs, valueArgs);
        }
        statusArgs = GattStatusArgs.success;
      }
    } else {
      descriptor.value = valueArgs;
      statusArgs = GattStatusArgs.success;
    }
    if (responseNeededArgs) {
      await _trySendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        null,
      );
    }
  }

  @override
  void onExecuteWrite(String addressArgs, int idArgs, bool executeArgs) async {
    logger.info('onExecuteWrite: $addressArgs - $idArgs, $executeArgs');
    final central = _centrals[addressArgs];
    final characteristic = _preparedCharacteristics.remove(addressArgs);
    final descriptor = _preparedDescriptors.remove(addressArgs);
    final elements = _preparedValue.remove(addressArgs);
    if (central == null || elements == null) {
      return;
    }
    final value = Uint8List.fromList(elements);
    final execute = executeArgs;
    if (execute) {
      if (characteristic == null && descriptor == null) {
        return;
      }
      if (characteristic != null) {
        _onCharacteristicWritten(central, characteristic, value);
      }
      if (descriptor != null) {
        descriptor.value = value;
      }
    }
    await _trySendResponse(
      addressArgs,
      idArgs,
      GattStatusArgs.success,
      0,
      null,
    );
  }

  GattCharacteristicImpl? _retrieveCharacteristic(int hashCodeArgs) {
    final characteristics = _characteristics.values
        .reduce((value, element) => value..addAll(element));
    return characteristics[hashCodeArgs];
  }

  GattDescriptorImpl? _retrieveDescriptor(int hashCodeArgs) {
    final descriptors =
        _descriptors.values.reduce((value, element) => value..addAll(element));
    return descriptors[hashCodeArgs];
  }

  bool? _retrieveConfirm(String addressArgs, int hashCodeArgs) {
    final confirms = _confirms[addressArgs];
    if (confirms == null) {
      return null;
    }
    return confirms[hashCodeArgs];
  }

  Future<void> _trySendResponse(
    String addressArgs,
    int idArgs,
    GattStatusArgs statusArgs,
    int offsetArgs,
    Uint8List? valueArgs,
  ) async {
    final statusNumberArgs = statusArgs.index;
    try {
      _channel.sendResponse(
        addressArgs,
        idArgs,
        statusNumberArgs,
        offsetArgs,
        valueArgs,
      );
    } catch (e, stack) {
      logger.shout('Send response failed.', e, stack);
    }
  }

  Uint8List _onCharacteristicRead(
    CentralImpl central,
    GattCharacteristicImpl characteristic,
    int offset,
  ) {
    final value = characteristic.value;
    final trimmedValue = value.sublist(offset);
    if (offset == 0) {
      final eventArgs = GattCharacteristicReadEventArgs(
        central,
        characteristic,
        value,
      );
      _characteristicReadController.add(eventArgs);
    }
    return trimmedValue;
  }

  void _onCharacteristicWritten(
    CentralImpl central,
    GattCharacteristicImpl characteristic,
    Uint8List value,
  ) async {
    characteristic.value = value;
    final trimmedValue = characteristic.value;
    final eventArgs = GattCharacteristicWrittenEventArgs(
      central,
      characteristic,
      trimmedValue,
    );
    _characteristicWrittenController.add(eventArgs);
  }
}

base class AndroidCentralImpl extends CentralImpl {
  final String address;

  AndroidCentralImpl({
    required this.address,
  }) : super(
          uuid: UUID.fromAddress(address),
        );
}

extension GattCharacteristicPropertyX on GattCharacteristicProperty {
  GattCharacteristicPropertyArgs toArgs() {
    return GattCharacteristicPropertyArgs.values[index];
  }
}

extension ManufacturerSpecificDataX on ManufacturerSpecificData {
  ManufacturerSpecificDataArgs toArgs() {
    final idArgs = id;
    final dataArgs = data;
    return ManufacturerSpecificDataArgs(
      idArgs: idArgs,
      dataArgs: dataArgs,
    );
  }
}

extension AdvertisementX on Advertisement {
  AdvertisementArgs toArgs() {
    final nameArgs = name;
    final serviceUUIDsArgs = serviceUUIDs.map((uuid) => uuid.toArgs()).toList();
    final serviceDataArgs = serviceData.map((uuid, data) {
      final uuidArgs = uuid.toArgs();
      final dataArgs = data;
      return MapEntry(uuidArgs, dataArgs);
    });
    final manufacturerSpecificDataArgs = manufacturerSpecificData?.toArgs();
    return AdvertisementArgs(
      nameArgs: nameArgs,
      serviceUUIDsArgs: serviceUUIDsArgs,
      serviceDataArgs: serviceDataArgs,
      manufacturerSpecificDataArgs: manufacturerSpecificDataArgs,
    );
  }
}

extension GattDescriptorX on GattDescriptorImpl {
  GattDescriptorArgs toArgs() {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    final valueArgs = value;
    return GattDescriptorArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      valueArgs: valueArgs,
    );
  }
}

extension GattCharacteristicX on GattCharacteristicImpl {
  GattCharacteristicArgs toArgs(List<GattDescriptorArgs> descriptorsArgs) {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    final propertyNumbersArgs = properties.map((property) {
      final propertyArgs = property.toArgs();
      return propertyArgs.index;
    }).toList();
    return GattCharacteristicArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      propertyNumbersArgs: propertyNumbersArgs,
      descriptorsArgs: descriptorsArgs,
    );
  }
}

extension GattServiceX on GattServiceImpl {
  GattServiceArgs toArgs(List<GattCharacteristicArgs> characteristicsArgs) {
    final hashCodeArgs = hashCode;
    final uuidArgs = uuid.toArgs();
    return GattServiceArgs(
      hashCodeArgs: hashCodeArgs,
      uuidArgs: uuidArgs,
      characteristicsArgs: characteristicsArgs,
    );
  }
}

extension CentralArgsX on CentralArgs {
  AndroidCentralImpl toCentral() {
    return AndroidCentralImpl(
      address: addressArgs,
    );
  }
}
