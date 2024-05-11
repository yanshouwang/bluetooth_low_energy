import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart' hide ConnectionState;

import 'my_api.dart';
import 'my_api.g.dart';
import 'my_central.dart';

final class MyPeripheralManager extends BasePeripheralManager
    with WidgetsBindingObserver
    implements MyPeripheralManagerFlutterAPI {
  final MyPeripheralManagerHostAPI _api;
  final ListEquality<int> _valueEquality;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<CentralMTUChangedEventArgs> _mtuChangedController;
  final StreamController<GATTCharacteristicReadEventArgs>
      _characteristicReadController;
  final StreamController<GATTCharacteristicWrittenEventArgs>
      _characteristicWrittenController;
  final StreamController<GATTCharacteristicNotifyStateChangedEventArgs>
      _characteristicNotifyStateChangedController;

  final Map<String, MyCentral> _centrals;
  final Map<int, Map<int, MutableGATTCharacteristic>> _characteristics;
  final Map<int, Map<int, MutableGATTDescriptor>> _descriptors;
  // CCCD hashCode -> characteristic
  final Map<int, Map<int, MutableGATTCharacteristic>> _cccCharacteristics;
  // characteristic hashCode -> CCCD
  final Map<int, Map<int, MutableGATTDescriptor>> _cccDescriptors;
  final Map<String, int> _mtus;
  final Map<String, MutableGATTCharacteristic> _preparedCharacteristics;
  final Map<String, MutableGATTDescriptor> _preparedDescriptors;
  final Map<String, List<int>> _preparedValue;

  late final MyPeripheralManagerArgs _args;

  BluetoothLowEnergyState _state;

  MyPeripheralManager()
      : _api = MyPeripheralManagerHostAPI(),
        _valueEquality = const ListEquality(),
        _stateChangedController = StreamController.broadcast(),
        _mtuChangedController = StreamController.broadcast(),
        _characteristicReadController = StreamController.broadcast(),
        _characteristicWrittenController = StreamController.broadcast(),
        _characteristicNotifyStateChangedController =
            StreamController.broadcast(),
        _centrals = {},
        _characteristics = {},
        _descriptors = {},
        _cccCharacteristics = {},
        _cccDescriptors = {},
        _mtus = {},
        _preparedCharacteristics = {},
        _preparedDescriptors = {},
        _preparedValue = {},
        _state = BluetoothLowEnergyState.unknown;

  @override
  BluetoothLowEnergyState get state => _state;
  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<CentralMTUChangedEventArgs> get mtuChanged =>
      _mtuChangedController.stream;
  @override
  Stream<GATTCharacteristicReadEventArgs> get characteristicRead =>
      _characteristicReadController.stream;
  @override
  Stream<GATTCharacteristicWrittenEventArgs> get characteristicWritten =>
      _characteristicWrittenController.stream;
  @override
  Stream<GATTCharacteristicNotifyStateChangedEventArgs>
      get characteristicNotifyStateChanged =>
          _characteristicNotifyStateChangedController.stream;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    logger.info('didChangeAppLifecycleState: $state');
    if (state != AppLifecycleState.resumed) {
      return;
    }
    _updateState();
  }

  @override
  void initialize() async {
    MyPeripheralManagerFlutterAPI.setUp(this);
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.addObserver(this);
    _initialize();
  }

  @override
  Future<bool> authorize() async {
    logger.info('authorize');
    final authorized = await _api.authorize();
    _updateState();
    return authorized;
  }

  @override
  Future<void> showAppSettings() async {
    logger.info('showAppSettings');
    await _api.authorize();
    _updateState();
  }

  @override
  Future<void> addService(GATTService service) async {
    if (service is! MutableGATTService) {
      throw TypeError();
    }
    final characteristics = <int, MutableGATTCharacteristic>{};
    final descriptors = <int, MutableGATTDescriptor>{};
    final cccCharacteristics = <int, MutableGATTCharacteristic>{};
    final cccDescriptors = <int, MutableGATTDescriptor>{};
    final characteristicsArgs = <MyMutableGATTCharacteristicArgs>[];
    for (var characteristic in service.characteristics) {
      final descriptorsArgs = <MyMutableGATTDescriptorArgs>[];
      final properties = characteristic.properties;
      final canNotify =
          properties.contains(GATTCharacteristicProperty.notify) ||
              properties.contains(GATTCharacteristicProperty.indicate);
      if (canNotify) {
        // CLIENT_CHARACTERISTIC_CONFIG
        final cccDescriptor = MutableGATTDescriptor(
          uuid: UUID.short(0x2902),
          value: _args.disableNotificationValue,
        );
        final cccDescriptorArgs = cccDescriptor.toArgs();
        descriptorsArgs.add(cccDescriptorArgs);
        descriptors[cccDescriptorArgs.hashCodeArgs] = cccDescriptor;
        cccCharacteristics[cccDescriptor.hashCode] = characteristic;
        cccDescriptors[characteristic.hashCode] = cccDescriptor;
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
    await _api.addService(serviceArgs);
    _characteristics[serviceArgs.hashCodeArgs] = characteristics;
    _descriptors[serviceArgs.hashCodeArgs] = descriptors;
    _cccCharacteristics[serviceArgs.hashCodeArgs] = cccCharacteristics;
    _cccDescriptors[serviceArgs.hashCodeArgs] = cccDescriptors;
  }

  @override
  Future<void> removeService(GATTService service) async {
    final hashCodeArgs = service.hashCode;
    logger.info('removeService: $hashCodeArgs');
    await _api.removeService(hashCodeArgs);
    _characteristics.remove(hashCodeArgs);
    _descriptors.remove(hashCodeArgs);
    _cccCharacteristics.remove(hashCodeArgs);
    _cccDescriptors.remove(hashCodeArgs);
  }

  @override
  Future<void> clearServices() async {
    logger.info('clearServices');
    await _api.clearServices();
    _characteristics.clear();
    _descriptors.clear();
    _cccCharacteristics.clear();
    _cccDescriptors.clear();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement) async {
    final advertisementArgs = advertisement.toArgs();
    logger.info('startAdvertising: $advertisementArgs');
    await _api.startAdvertising(advertisementArgs);
  }

  @override
  Future<void> stopAdvertising() async {
    logger.info('stopAdvertising');
    await _api.stopAdvertising();
  }

  @override
  Future<Uint8List> readCharacteristic(GATTCharacteristic characteristic) {
    if (characteristic is! MutableGATTCharacteristic) {
      throw TypeError();
    }
    final hashCodeArgs = characteristic.hashCode;
    logger.info('readCharacteristic: $hashCodeArgs');
    final value = characteristic.value;
    return Future.value(value);
  }

  @override
  Future<void> writeCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
  }) {
    if (characteristic is! MutableGATTCharacteristic) {
      throw TypeError();
    }
    characteristic.value = value;
    return Future.value();
  }

  @override
  Future<void> notifyCharacteristic(
    GATTCharacteristic characteristic, {
    List<Central>? centrals,
  }) async {
    if (characteristic is! MutableGATTCharacteristic) {
      throw TypeError();
    }
    final descriptor = _retrieveCCCDescriptor(characteristic.hashCode);
    if (descriptor == null) {
      throw ArgumentError.notNull();
    }
    final value = descriptor.value;
    final notificationEnabled = _valueEquality.equals(
      value,
      _args.enableNotificationValue,
    );
    final indicationEnabled = _valueEquality.equals(
      value,
      _args.enableIndicationValue,
    );
    if (!notificationEnabled && !indicationEnabled) {
      logger.warning('Notification of this characteristic is disabled.');
      return;
    }
    final hashCodeArgs = characteristic.hashCode;
    final confirm = indicationEnabled;
    centrals ??= _centrals.values.toList();
    for (var central in centrals) {
      if (central is! MyCentral) {
        throw TypeError();
      }
      final addressArgs = central.address;
      final trimmedValueArgs = characteristic.value;
      if (trimmedValueArgs == null) {
        throw ArgumentError.notNull();
      }
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
        await _api.notifyCharacteristicChanged(
          addressArgs,
          hashCodeArgs,
          confirm,
          fragmentedValueArgs,
        );
        start = end;
      }
    }
  }

  @override
  void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs) async {
    logger.info('onStateChanged: $stateArgs');
    final state = stateArgs.toState();
    if (_state == state) {
      return;
    }
    // Renew GATT server when bluetooth adapter state changed.
    switch (state) {
      case BluetoothLowEnergyState.poweredOn:
        await _openGATTServer();
        break;
      case BluetoothLowEnergyState.poweredOff:
        await _closeGATTServer();
        break;
      default:
        break;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onConnectionStateChanged(
    MyCentralArgs centralArgs,
    int statusArgs,
    MyConnectionStateArgs stateArgs,
  ) {
    final addressArgs = centralArgs.addressArgs;
    logger.info(
        'onConnectionStateChanged: $addressArgs - $statusArgs, $stateArgs');
    final central = centralArgs.toCentral();
    final state = stateArgs.toState();
    if (state == ConnectionState.connected) {
      _centrals[addressArgs] = central;
    } else {
      _centrals.remove(addressArgs);
      _mtus.remove(addressArgs);
    }
  }

  @override
  void onMTUChanged(String addressArgs, int mtuArgs) {
    logger.info('onMTUChanged: $addressArgs - $mtuArgs');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
    final mtu = mtuArgs;
    _mtus[addressArgs] = mtu;
    final eventArgs = CentralMTUChangedEventArgs(central, mtu);
    _mtuChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicReadRequest(
    String addressArgs,
    int idArgs,
    int offsetArgs,
    int hashCodeArgs,
  ) async {
    logger.info(
        'onCharacteristicReadRequest: $addressArgs - $idArgs, $offsetArgs, $hashCodeArgs');
    final central = _centrals[addressArgs];
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (central == null || characteristic == null) {
      const statusArgs = MyGATTStatusArgs.failure;
      await _sendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        null,
      );
    } else {
      const statusArgs = MyGATTStatusArgs.success;
      final offset = offsetArgs;
      final valueArgs = _onCharacteristicRead(central, characteristic, offset);
      await _sendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        valueArgs,
      );
    }
  }

  @override
  void onCharacteristicWriteRequest(
    String addressArgs,
    int idArgs,
    int hashCodeArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
    int offsetArgs,
    Uint8List valueArgs,
  ) async {
    logger.info(
        'onCharacteristicWriteRequest: $addressArgs - $idArgs, $hashCodeArgs, $preparedWriteArgs, $responseNeededArgs, $offsetArgs, $valueArgs');
    final central = _centrals[addressArgs];
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (central == null || characteristic == null) {
      if (!responseNeededArgs) {
        return;
      }
      const statusArgs = MyGATTStatusArgs.failure;
      await _sendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        null,
      );
    } else {
      final MyGATTStatusArgs statusArgs;
      if (preparedWriteArgs) {
        final preparedCharacteristic = _preparedCharacteristics[addressArgs];
        if (preparedCharacteristic != null &&
            preparedCharacteristic != characteristic) {
          statusArgs = MyGATTStatusArgs.connectionCongested;
        } else {
          final preparedValueArgs = _preparedValue[addressArgs];
          if (preparedValueArgs == null) {
            _preparedCharacteristics[addressArgs] = characteristic;
            // Change the immutable Uint8List to mutable.
            _preparedValue[addressArgs] = [...valueArgs];
          } else {
            preparedValueArgs.insertAll(offsetArgs, valueArgs);
          }
          statusArgs = MyGATTStatusArgs.success;
        }
      } else {
        final value = valueArgs;
        _onCharacteristicWritten(central, characteristic, value);
        statusArgs = MyGATTStatusArgs.success;
      }
      if (!responseNeededArgs) {
        return;
      }
      await _sendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        null,
      );
    }
  }

  @override
  void onDescriptorReadRequest(
    String addressArgs,
    int idArgs,
    int offsetArgs,
    int hashCodeArgs,
  ) async {
    logger.info(
        'onDescriptorReadRequest: $addressArgs - $idArgs, $offsetArgs, $hashCodeArgs');
    final central = _centrals[addressArgs];
    final descriptor = _retrieveDescriptor(hashCodeArgs);
    if (central == null || descriptor == null) {
      const statusArgs = MyGATTStatusArgs.failure;
      await _sendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        null,
      );
    } else {
      const statusArgs = MyGATTStatusArgs.success;
      final offset = offsetArgs;
      final value = descriptor.value ?? Uint8List.fromList([]);
      final valueArgs = value.sublist(offset);
      await _sendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        valueArgs,
      );
    }
  }

  @override
  void onDescriptorWriteRequest(
    String addressArgs,
    int idArgs,
    int hashCodeArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
    int offsetArgs,
    Uint8List valueArgs,
  ) async {
    logger.info(
        'onDescriptorWriteRequest: $addressArgs - $idArgs, $hashCodeArgs, $preparedWriteArgs, $responseNeededArgs, $offsetArgs, $valueArgs');
    final central = _centrals[addressArgs];
    final descriptor = _retrieveDescriptor(hashCodeArgs);
    if (central == null || descriptor == null) {
      if (!responseNeededArgs) {
        return;
      }
      const statusArgs = MyGATTStatusArgs.failure;
      await _sendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        null,
      );
    } else {
      final MyGATTStatusArgs statusArgs;
      if (preparedWriteArgs) {
        final preparedDescriptor = _preparedDescriptors[addressArgs];
        if (preparedDescriptor != null && preparedDescriptor != descriptor) {
          statusArgs = MyGATTStatusArgs.connectionCongested;
        } else {
          final preparedValueArgs = _preparedValue[addressArgs];
          if (preparedValueArgs == null) {
            _preparedDescriptors[addressArgs] = descriptor;
            // Change the immutable Uint8List to mutable.
            _preparedValue[addressArgs] = [...valueArgs];
          } else {
            preparedValueArgs.insertAll(offsetArgs, valueArgs);
          }
          statusArgs = MyGATTStatusArgs.success;
        }
      } else {
        final value = valueArgs;
        if (descriptor.uuid == UUID.short(0x2902)) {
          final characteristic =
              _retrieveCCCCharacteristic(descriptor.hashCode);
          if (characteristic == null) {
            statusArgs = MyGATTStatusArgs.failure;
          } else {
            descriptor.value = value;
            statusArgs = MyGATTStatusArgs.success;
            final state =
                _valueEquality.equals(value, _args.enableNotificationValue) ||
                    _valueEquality.equals(value, _args.enableIndicationValue);
            final eventArgs = GATTCharacteristicNotifyStateChangedEventArgs(
              central,
              characteristic,
              state,
            );
            _characteristicNotifyStateChangedController.add(eventArgs);
          }
        } else {
          descriptor.value = value;
          statusArgs = MyGATTStatusArgs.success;
        }
      }
      if (!responseNeededArgs) {
        return;
      }
      await _sendResponse(
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
    const statusArgs = MyGATTStatusArgs.success;
    await _sendResponse(
      addressArgs,
      idArgs,
      statusArgs,
      0,
      null,
    );
  }

  Future<void> _initialize() async {
    // Here we use `Future()` to make it possible to change the `logLevel` before `initialize()`.
    await Future(() async {
      try {
        logger.info('initialize');
        _args = await _api.initialize();
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

  Future<void> _openGATTServer() async {
    try {
      logger.info('openGATTServer');
      await _api.openGATTServer();
    } catch (e) {
      logger.severe('openGATTServer failed.', e);
    }
  }

  Future<void> _closeGATTServer() async {
    try {
      logger.info('closeGATTServer');
      await _api.closeGATTServer();
    } catch (e) {
      logger.severe('closeGATTServer failed.', e);
    }
  }

  Future<void> _sendResponse(
    String addressArgs,
    int idArgs,
    MyGATTStatusArgs statusArgs,
    int offsetArgs,
    Uint8List? valueArgs,
  ) async {
    try {
      logger.info(
          'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs');
      await _api.sendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        valueArgs,
      );
    } catch (e) {
      logger.severe('sendResponse failed.', e);
    }
  }

  Uint8List _onCharacteristicRead(
    MyCentral central,
    MutableGATTCharacteristic characteristic,
    int offset,
  ) {
    final value = characteristic.value ?? Uint8List.fromList([]);
    final trimmedValue = value.sublist(offset);
    if (offset == 0) {
      final eventArgs = GATTCharacteristicReadEventArgs(
        central,
        characteristic,
        value,
      );
      _characteristicReadController.add(eventArgs);
    }
    return trimmedValue;
  }

  void _onCharacteristicWritten(
    MyCentral central,
    MutableGATTCharacteristic characteristic,
    Uint8List value,
  ) async {
    characteristic.value = value;
    final trimmedValue = characteristic.value;
    if (trimmedValue == null) {
      throw ArgumentError.notNull();
    }
    final eventArgs = GATTCharacteristicWrittenEventArgs(
      central,
      characteristic,
      trimmedValue,
    );
    _characteristicWrittenController.add(eventArgs);
  }

  MutableGATTCharacteristic? _retrieveCharacteristic(int hashCodeArgs) {
    final characteristics = _characteristics.values
        .reduce((value, element) => value..addAll(element));
    return characteristics[hashCodeArgs];
  }

  MutableGATTCharacteristic? _retrieveCCCCharacteristic(int hashCode) {
    final characteristics = _cccCharacteristics.values
        .reduce((value, element) => value..addAll(element));
    return characteristics[hashCode];
  }

  MutableGATTDescriptor? _retrieveCCCDescriptor(int hashCode) {
    final descriptors = _cccDescriptors.values
        .reduce((value, element) => value..addAll(element));
    return descriptors[hashCode];
  }

  MutableGATTDescriptor? _retrieveDescriptor(int hashCodeArgs) {
    final descriptors =
        _descriptors.values.reduce((value, element) => value..addAll(element));
    return descriptors[hashCodeArgs];
  }
}
