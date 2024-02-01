import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';

class MyPeripheralManager extends PeripheralManager
    implements MyPeripheralManagerFlutterApi {
  final MyPeripheralManagerHostApi _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<GattCharacteristicReadEventArgs>
      _characteristicReadController;
  final StreamController<GattCharacteristicWrittenEventArgs>
      _characteristicWrittenController;
  final StreamController<GattCharacteristicNotifyStateChangedEventArgs>
      _characteristicNotifyStateChangedController;

  final Map<int, Map<int, MyGattCharacteristic>> _characteristics;
  final Map<String, Map<int, bool>> _listeners;

  BluetoothLowEnergyState _state;

  MyPeripheralManager()
      : _api = MyPeripheralManagerHostApi(),
        _stateChangedController = StreamController.broadcast(),
        _characteristicReadController = StreamController.broadcast(),
        _characteristicWrittenController = StreamController.broadcast(),
        _characteristicNotifyStateChangedController =
            StreamController.broadcast(),
        _characteristics = {},
        _listeners = {},
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
  Future<void> setUp() async {
    logger.info('setUp');
    await _api.setUp();
    MyPeripheralManagerFlutterApi.setup(this);
  }

  @override
  Future<BluetoothLowEnergyState> getState() {
    logger.info('getState');
    return Future.value(_state);
  }

  @override
  Future<void> addService(GattService service) async {
    if (service is! MyGattService) {
      throw TypeError();
    }
    final characteristics = <int, MyGattCharacteristic>{};
    final characteristicsArgs = <MyGattCharacteristicArgs>[];
    for (var characteristic in service.characteristics) {
      final descriptorsArgs = <MyGattDescriptorArgs>[];
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
  Future<void> removeService(GattService service) async {
    final hashCodeArgs = service.hashCode;
    logger.info('removeService: $hashCodeArgs');
    await _api.removeService(hashCodeArgs);
    _characteristics.remove(hashCodeArgs);
  }

  @override
  Future<void> clearServices() async {
    logger.info('clearServices');
    await _api.clearServices();
    _characteristics.clear();
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
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic) {
    if (characteristic is! MyGattCharacteristic) {
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
    if (characteristic is! MyGattCharacteristic) {
      throw TypeError();
    }
    characteristic.value = value;
    if (central == null) {
      return;
    }
    if (central is! MyCentral) {
      throw TypeError();
    }
    final uuidArgs = central.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final listener = _retrieveListener(uuidArgs, hashCodeArgs);
    if (listener == null) {
      logger.warning('The central is not listening.');
      return;
    }
    final uuidsArgs = [uuidArgs];
    final trimmedValueArgs = characteristic.value;
    final fragmentSize = await _api.getMaximumUpdateValueLength(uuidArgs);
    var start = 0;
    while (start < trimmedValueArgs.length) {
      final end = start + fragmentSize;
      final fragmentedValueArgs = end < trimmedValueArgs.length
          ? trimmedValueArgs.sublist(start, end)
          : trimmedValueArgs.sublist(start);
      logger.info(
          'notifyCharacteristicChanged: $hashCodeArgs - $fragmentedValueArgs, $uuidsArgs');
      await _api.updateCharacteristic(
        hashCodeArgs,
        fragmentedValueArgs,
        uuidsArgs,
      );
      start = end;
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
  void onCharacteristicReadRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
  ) async {
    final uuidArgs = centralArgs.uuidArgs;
    logger.info(
        'onCharacteristicReadRequest: $uuidArgs.$hashCodeArgs - $idArgs, $offsetArgs');
    final central = centralArgs.toCentral();
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    const errorArgs = MyGattErrorArgs.success;
    final offset = offsetArgs;
    final valueArgs = _onCharacteristicRead(central, characteristic, offset);
    await _tryRespond(
      idArgs,
      errorArgs,
      valueArgs,
    );
  }

  @override
  void onCharacteristicWriteRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
  ) async {
    final uuidArgs = centralArgs.uuidArgs;
    logger.info(
        'onCharacteristicWriteRequest: $uuidArgs.$hashCodeArgs - $idArgs, $offsetArgs, $valueArgs');
    final central = centralArgs.toCentral();
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    const errorArgs = MyGattErrorArgs.success;
    final value = valueArgs;
    _onCharacteristicWritten(central, characteristic, value);
    await _tryRespond(
      idArgs,
      errorArgs,
      null,
    );
  }

  @override
  void onCharacteristicNotifyStateChanged(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    bool stateArgs,
  ) {
    final uuidArgs = centralArgs.uuidArgs;
    logger.info(
        'onCharacteristicNotifyStateChanged: $uuidArgs.$hashCodeArgs - $stateArgs');
    final central = centralArgs.toCentral();
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final state = stateArgs;
    final listeners = _listeners.putIfAbsent(uuidArgs, () => {});
    if (state) {
      listeners[hashCodeArgs] = true;
    } else {
      listeners.remove(hashCodeArgs);
    }
    final eventArgs = GattCharacteristicNotifyStateChangedEventArgs(
      central,
      characteristic,
      state,
    );
    _characteristicNotifyStateChangedController.add(eventArgs);
  }

  MyGattCharacteristic? _retrieveCharacteristic(int hashCodeArgs) {
    final characteristics = _characteristics.values
        .reduce((value, element) => value..addAll(element));
    return characteristics[hashCodeArgs];
  }

  bool? _retrieveListener(String uuidArgs, int hashCodeArgs) {
    final listeners = _listeners[uuidArgs];
    if (listeners == null) {
      return null;
    }
    return listeners[hashCodeArgs];
  }

  Future<void> _tryRespond(
    int idArgs,
    MyGattErrorArgs errorArgs,
    Uint8List? valueArgs,
  ) async {
    final errorNumberArgs = errorArgs.index;
    try {
      _api.respond(
        idArgs,
        errorNumberArgs,
        valueArgs,
      );
    } catch (e, stack) {
      logger.shout('Respond failed.', e, stack);
    }
  }

  Uint8List _onCharacteristicRead(
    MyCentral central,
    MyGattCharacteristic characteristic,
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
    MyCentral central,
    MyGattCharacteristic characteristic,
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
