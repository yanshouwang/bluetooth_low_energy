import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_api.g.dart';

final class MyPeripheralManager extends BasePeripheralManager
    implements MyPeripheralManagerFlutterAPI {
  final MyPeripheralManagerHostAPI _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<GATTCharacteristicReadEventArgs>
      _characteristicReadController;
  final StreamController<GATTCharacteristicWrittenEventArgs>
      _characteristicWrittenController;
  final StreamController<GATTCharacteristicNotifyStateChangedEventArgs>
      _characteristicNotifyStateChangedController;
  final StreamController<EventArgs> _isReadyController;

  final Map<int, Map<int, MutableGATTCharacteristic>> _characteristics;
  final Map<int, Map<String, Central>> _subscribedCentrals;

  BluetoothLowEnergyState _state;

  MyPeripheralManager()
      : _api = MyPeripheralManagerHostAPI(),
        _stateChangedController = StreamController.broadcast(),
        _characteristicReadController = StreamController.broadcast(),
        _characteristicWrittenController = StreamController.broadcast(),
        _characteristicNotifyStateChangedController =
            StreamController.broadcast(),
        _isReadyController = StreamController.broadcast(),
        _subscribedCentrals = {},
        _characteristics = {},
        _state = BluetoothLowEnergyState.unknown;

  @override
  BluetoothLowEnergyState get state => _state;
  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<CentralMTUChangedEventArgs> get mtuChanged =>
      throw UnsupportedError('mtuChanged is not supported on Darwin.');
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
  Stream<EventArgs> get _isReady => _isReadyController.stream;

  @override
  void initialize() {
    MyPeripheralManagerFlutterAPI.setUp(this);
    _initialize();
  }

  @override
  Future<bool> authorize() {
    throw UnsupportedError('authorize is not supported on Darwin.');
  }

  @override
  Future<void> showAppSettings() {
    throw UnsupportedError('showAppSettings is not supported on Darwin.');
  }

  @override
  Future<void> addService(GATTService service) async {
    if (service is! MutableGATTService) {
      throw TypeError();
    }
    final characteristics = <int, MutableGATTCharacteristic>{};
    final characteristicsArgs = <MyMutableGATTCharacteristicArgs>[];
    for (var characteristic in service.characteristics) {
      final descriptorsArgs = <MyMutableGATTDescriptorArgs>[];
      for (var descriptor in characteristic.descriptors) {
        final descriptorArgs = descriptor.toArgs();
        descriptorsArgs.add(descriptorArgs);
      }
      final characteristicArgs = characteristic.toArgs(descriptorsArgs);
      characteristicsArgs.add(characteristicArgs);
      characteristics[characteristicArgs.hashCodeArgs] = characteristic;
    }
    final serviceArgs = service.toArgs(characteristicsArgs);
    logger.info('addService: $serviceArgs');
    await _api.addService(serviceArgs);
    _characteristics[serviceArgs.hashCodeArgs] = characteristics;
  }

  @override
  Future<void> removeService(GATTService service) async {
    final hashCodeArgs = service.hashCode;
    logger.info('removeService: $hashCodeArgs');
    await _api.removeService(hashCodeArgs);
    final characteristics = _characteristics.remove(hashCodeArgs);
    if (characteristics == null) {
      return;
    }
    for (var key in characteristics.keys) {
      _subscribedCentrals.remove(key);
    }
  }

  @override
  Future<void> clearServices() async {
    logger.info('clearServices');
    await _api.clearServices();
    _characteristics.clear();
    _subscribedCentrals.clear();
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
    Central? central,
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
    final hashCodeArgs = characteristic.hashCode;
    final subscribedCentrals = _subscribedCentrals[hashCodeArgs];
    if (subscribedCentrals == null) {
      return;
    }
    centrals ??= subscribedCentrals.values.toList();
    for (var central in centrals) {
      final uuidArgs = central.uuid.toArgs();
      final subscribed = subscribedCentrals.containsKey(uuidArgs);
      if (!subscribed) {
        continue;
      }
      final uuidsArgs = [uuidArgs];
      final trimmedValueArgs = characteristic.value;
      if (trimmedValueArgs == null) {
        throw ArgumentError.notNull();
      }
      final fragmentSize = await _api.maximumUpdateValueLength(uuidArgs);
      var start = 0;
      while (start < trimmedValueArgs.length) {
        final end = start + fragmentSize;
        final fragmentedValueArgs = end < trimmedValueArgs.length
            ? trimmedValueArgs.sublist(start, end)
            : trimmedValueArgs.sublist(start);
        while (true) {
          logger.info(
              'updateValue: $hashCodeArgs - $fragmentedValueArgs, $uuidsArgs');
          final updated = await _api.updateValue(
            hashCodeArgs,
            fragmentedValueArgs,
            uuidsArgs,
          );
          if (updated) {
            break;
          }
          await _isReady.first;
        }
        start = end;
      }
    }
  }

  @override
  void onStateChanged(int stateNumberArgs) {
    final stateArgs = MyBluetoothLowEnergyStateArgs.values[stateNumberArgs];
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
  void didReceiveRead(MyATTRequestArgs requestArgs) async {
    final centralArgs = requestArgs.centralArgs;
    final hashCodeArgs = requestArgs.hashCodeArgs;
    final characteristicHashCodeArgs = requestArgs.characteristicHashCodeArgs;
    final offsetArgs = requestArgs.offsetArgs;
    final valueArgs = requestArgs.valueArgs;
    logger.info(
        'didReceiveRead: ${centralArgs.uuidArgs} - $hashCodeArgs, $characteristicHashCodeArgs, $offsetArgs, $valueArgs');
    final central = centralArgs.toCentral();
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      const errorArgs = MyATTErrorArgs.attributeNotFound;
      await _respond(hashCodeArgs, errorArgs, null);
    } else {
      const errorArgs = MyATTErrorArgs.success;
      final offset = offsetArgs;
      final valueArgs = _onCharacteristicRead(central, characteristic, offset);
      await _respond(hashCodeArgs, errorArgs, valueArgs);
    }
  }

  @override
  void didReceiveWrite(List<MyATTRequestArgs?> requestsArgs) async {
    // When you respond to a write request, note that the first parameter of the respond(to:with
    // Result:) method expects a single CBATTRequest object, even though you received an array of
    // them from the peripheralManager(_:didReceiveWrite:) method. To respond properly,
    // pass in the first request of the requests array.
    // see: https://developer.apple.com/documentation/corebluetooth/cbperipheralmanagerdelegate/1393315-peripheralmanager#discussion
    final requestArgs = requestsArgs.firstOrNull;
    if (requestArgs == null) {
      return;
    }
    final centralArgs = requestArgs.centralArgs;
    final hashCodeArgs = requestArgs.hashCodeArgs;
    final characteristicHashCodeArgs = requestArgs.characteristicHashCodeArgs;
    final offsetArgs = requestArgs.offsetArgs;
    final valueArgs = requestArgs.valueArgs;
    logger.info(
        'didReceiveWrite: ${centralArgs.uuidArgs} - $hashCodeArgs, $characteristicHashCodeArgs, $offsetArgs, $valueArgs');
    if (requestsArgs.length > 1) {
      // TODO: how to respond multi requests.
      const errorArgs = MyATTErrorArgs.requestNotSupported;
      await _respond(hashCodeArgs, errorArgs, null);
    }
    final central = centralArgs.toCentral();
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      const errorArgs = MyATTErrorArgs.attributeNotFound;
      await _respond(hashCodeArgs, errorArgs, null);
    } else if (valueArgs == null) {
      const errorArgs = MyATTErrorArgs.requestNotSupported;
      await _respond(hashCodeArgs, errorArgs, null);
    } else {
      const errorArgs = MyATTErrorArgs.success;
      final value = valueArgs;
      _onCharacteristicWritten(central, characteristic, value);
      await _respond(
        hashCodeArgs,
        errorArgs,
        null,
      );
    }
  }

  @override
  void isReady() {
    final eventArgs = EventArgs();
    _isReadyController.add(eventArgs);
  }

  @override
  void onCharacteristicNotifyStateChanged(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    bool stateArgs,
  ) {
    final uuidArgs = centralArgs.uuidArgs;
    logger.info(
        'onCharacteristicNotifyStateChanged: $uuidArgs - $hashCodeArgs, $stateArgs');
    final central = centralArgs.toCentral();
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final state = stateArgs;
    final subscribedCentrals =
        _subscribedCentrals.putIfAbsent(hashCodeArgs, () => {});
    if (state) {
      subscribedCentrals[uuidArgs] = central;
    } else {
      subscribedCentrals.remove(uuidArgs);
    }
    final eventArgs = GATTCharacteristicNotifyStateChangedEventArgs(
      central,
      characteristic,
      state,
    );
    _characteristicNotifyStateChangedController.add(eventArgs);
  }

  Future<void> _initialize() async {
    // Here we use `Future()` to make it possible to change the `logLevel` before `initialize()`.
    await Future(() async {
      try {
        logger.info('initialize');
        await _api.initialize();
      } catch (e) {
        logger.severe('initialize failed.', e);
      }
    });
  }

  Future<void> _respond(
    int hashCodeArgs,
    MyATTErrorArgs errorArgs,
    Uint8List? valueArgs,
  ) async {
    final errorNumberArgs = errorArgs.index;
    try {
      logger.info('respond: $hashCodeArgs - $valueArgs, $errorNumberArgs');
      await _api.respond(
        hashCodeArgs,
        valueArgs,
        errorNumberArgs,
      );
    } catch (e) {
      logger.severe('respond failed.', e);
    }
  }

  Uint8List _onCharacteristicRead(
    Central central,
    MutableGATTCharacteristic characteristic,
    int offset,
  ) {
    final value = characteristic.value ?? Uint8List.fromList([]);
    if (offset == 0) {
      final eventArgs = GATTCharacteristicReadEventArgs(
        central,
        characteristic,
        value,
      );
      _characteristicReadController.add(eventArgs);
    }
    return value.sublist(offset);
  }

  void _onCharacteristicWritten(
    Central central,
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
}
