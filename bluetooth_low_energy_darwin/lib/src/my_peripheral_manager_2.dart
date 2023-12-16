import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';

class MyPeripheralManager2 extends MyPeripheralManager
    implements MyPeripheralManagerFlutterApi {
  final MyPeripheralManagerHostApi _api;
  BluetoothLowEnergyState _state;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<ReadGattCharacteristicCommandEventArgs>
      _readCharacteristicCommandReceivedController;
  final StreamController<WriteGattCharacteristicCommandEventArgs>
      _writeCharacteristicCommandReceivedController;
  final StreamController<NotifyGattCharacteristicCommandEventArgs>
      _notifyCharacteristicCommandReceivedController;
  final Map<int, Map<int, MyGattCharacteristic>> _characteristics;

  MyPeripheralManager2()
      : _api = MyPeripheralManagerHostApi(),
        _state = BluetoothLowEnergyState.unknown,
        _stateChangedController = StreamController.broadcast(),
        _readCharacteristicCommandReceivedController =
            StreamController.broadcast(),
        _writeCharacteristicCommandReceivedController =
            StreamController.broadcast(),
        _notifyCharacteristicCommandReceivedController =
            StreamController.broadcast(),
        _characteristics = {};

  @override
  BluetoothLowEnergyState get state => _state;
  @protected
  set state(BluetoothLowEnergyState value) {
    if (_state == value) {
      return;
    }
    _state = value;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<ReadGattCharacteristicCommandEventArgs>
      get readCharacteristicCommandReceived =>
          _readCharacteristicCommandReceivedController.stream;
  @override
  Stream<WriteGattCharacteristicCommandEventArgs>
      get writeCharacteristicCommandReceived =>
          _writeCharacteristicCommandReceivedController.stream;
  @override
  Stream<NotifyGattCharacteristicCommandEventArgs>
      get notifyCharacteristicCommandReceived =>
          _notifyCharacteristicCommandReceivedController.stream;

  Future<void> _throwWithoutState(BluetoothLowEnergyState state) async {
    if (this.state != state) {
      throw StateError(
          '$state is expected, but current state is ${this.state}.');
    }
  }

  @override
  Future<void> setUp() async {
    final args = await _api.setUp();
    final stateArgs =
        MyBluetoothLowEnergyStateArgs.values[args.stateNumberArgs];
    state = stateArgs.toState();
    MyPeripheralManagerFlutterApi.setup(this);
  }

  @override
  Future<void> addService(GattService service) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (service is! MyGattService) {
      throw TypeError();
    }
    final serviceArgs = service.toArgs();
    await _api.addService(serviceArgs);
    _characteristics[service.hashCode] = {
      for (var characteristics in service.characteristics)
        characteristics.hashCode: characteristics
    };
  }

  @override
  Future<void> removeService(GattService service) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final serviceHashCodeArgs = service.hashCode;
    await _api.removeService(serviceHashCodeArgs);
    _characteristics.remove(service.hashCode);
  }

  @override
  Future<void> clearServices() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _api.clearServices();
    _characteristics.clear();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final advertisementArgs = advertisement.toArgs();
    await _api.startAdvertising(advertisementArgs);
  }

  @override
  Future<void> stopAdvertising() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _api.stopAdvertising();
  }

  @override
  Future<void> sendReadCharacteristicReply(
    Central central, {
    required GattCharacteristic characteristic,
    required int id,
    required int offset,
    required bool status,
    required Uint8List value,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (central is! MyCentral || characteristic is! MyGattCharacteristic) {
      throw TypeError();
    }
    final uuidArgs = central.uuid.toArgs();
    final characteristicHashCodeArgs = characteristic.hashCode;
    final idArgs = id;
    final offsetArgs = offset;
    final statusArgs = status;
    final valueArgs = value;
    await _api.sendReadCharacteristicReply(
      uuidArgs,
      characteristicHashCodeArgs,
      idArgs,
      offsetArgs,
      statusArgs,
      valueArgs,
    );
  }

  @override
  Future<void> sendWriteCharacteristicReply(
    Central central, {
    required GattCharacteristic characteristic,
    required int id,
    required int offset,
    required bool status,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (central is! MyCentral || characteristic is! MyGattCharacteristic) {
      throw TypeError();
    }
    final uuidArgs = central.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final idArgs = id;
    final offsetArgs = offset;
    final statusArgs = status;
    await _api.sendWriteCharacteristicReply(
      uuidArgs,
      hashCodeArgs,
      idArgs,
      offsetArgs,
      statusArgs,
    );
  }

  @override
  Future<void> notifyCharacteristicValueChanged(
    Central central, {
    required GattCharacteristic characteristic,
    required Uint8List value,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (central is! MyCentral || characteristic is! MyGattCharacteristic) {
      throw TypeError();
    }
    final uuidArgs = central.uuid.toArgs();
    final hashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    final trimmedSize = await _api.getMaximumUpdateValueLength(uuidArgs);
    var start = 0;
    while (start < valueArgs.length) {
      final end = start + trimmedSize;
      final trimmedValueArgs = end < valueArgs.length
          ? valueArgs.sublist(start, end)
          : valueArgs.sublist(start);
      await _api.notifyCharacteristicValueChanged(
        uuidArgs,
        hashCodeArgs,
        trimmedValueArgs,
      );
      start = end;
    }
  }

  @override
  void onStateChanged(int stateNumberArgs) {
    final stateArgs = MyBluetoothLowEnergyStateArgs.values[stateNumberArgs];
    logger.info('onStateChanged: $stateArgs');
    state = stateArgs.toState();
  }

  @override
  void onReadCharacteristicCommandReceived(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
  ) {
    final uuidArgs = centralArgs.uuidArgs;
    logger.info(
        'onReadCharacteristicCommandReceived: $uuidArgs.$hashCodeArgs - $idArgs, $offsetArgs');
    final central = centralArgs.toCentral();
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final id = idArgs;
    final offset = offsetArgs;
    final eventArgs = ReadGattCharacteristicCommandEventArgs(
      central,
      characteristic,
      id,
      offset,
    );
    _readCharacteristicCommandReceivedController.add(eventArgs);
  }

  @override
  void onWriteCharacteristicCommandReceived(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
  ) {
    final uuidArgs = centralArgs.uuidArgs;
    logger.info(
        'onWriteCharacteristicCommandReceived: $uuidArgs.$hashCodeArgs - $idArgs, $offsetArgs, $valueArgs');
    final central = centralArgs.toCentral();
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final id = idArgs;
    final offset = offsetArgs;
    final value = valueArgs;
    final eventArgs = WriteGattCharacteristicCommandEventArgs(
      central,
      characteristic,
      id,
      offset,
      value,
    );
    _writeCharacteristicCommandReceivedController.add(eventArgs);
  }

  @override
  void onNotifyCharacteristicCommandReceived(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    bool stateArgs,
  ) {
    final uuidArgs = centralArgs.uuidArgs;
    logger.info(
        'onNotifyCharacteristicCommandReceived: $uuidArgs.$hashCodeArgs - $stateArgs');
    final central = centralArgs.toCentral();
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final state = stateArgs;
    final eventArgs = NotifyGattCharacteristicCommandEventArgs(
      central,
      characteristic,
      state,
    );
    _notifyCharacteristicCommandReceivedController.add(eventArgs);
  }

  MyGattCharacteristic? _retrieveCharacteristic(int hashCodeArgs) {
    final characteristics = _characteristics.values
        .reduce((value, element) => value..addAll(element));
    return characteristics[hashCodeArgs];
  }
}
