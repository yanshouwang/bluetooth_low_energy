import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_central2.dart';

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
  final Map<String, MyCentral2> _centrals;
  final Map<int, Map<int, MyGattCharacteristic>> _characteristics;
  final Map<String, int> _mtus;
  final Map<String, Map<int, bool>> _confirms;

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
        _centrals = {},
        _characteristics = {},
        _mtus = {},
        _confirms = {};

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
    if (central is! MyCentral2) {
      throw TypeError();
    }
    final addressArgs = central.address;
    final idArgs = id;
    final offsetArgs = offset;
    final statusArgs = status;
    final valueArgs = value;
    await _api.sendReadCharacteristicReply(
      addressArgs,
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
    if (central is! MyCentral2) {
      throw TypeError();
    }
    final addressArgs = central.address;
    final idArgs = id;
    final offsetArgs = offset;
    final statusArgs = status;
    await _api.sendWriteCharacteristicReply(
      addressArgs,
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
    if (central is! MyCentral2) {
      throw TypeError();
    }
    final addressArgs = central.address;
    final hashCodeArgs = characteristic.hashCode;
    final confirms = _confirms[addressArgs];
    if (confirms == null) {
      throw StateError('The central has not subscribed any characteristic.');
    }
    final confirm = confirms[hashCodeArgs];
    if (confirm == null) {
      throw StateError('The central has not subscribed this characteristic.');
    }
    final valueArgs = value;
    // fragments the value by MTU - 3 size.
    // If mtu is null, use 23 as default MTU size.
    final mtu = _mtus[addressArgs] ?? 23;
    final trimmedSize = (mtu - 3).clamp(20, 512);
    var start = 0;
    while (start < valueArgs.length) {
      final end = start + trimmedSize;
      final trimmedValueArgs = end < valueArgs.length
          ? valueArgs.sublist(start, end)
          : valueArgs.sublist(start);
      await _api.notifyCharacteristicValueChanged(
        addressArgs,
        hashCodeArgs,
        confirm,
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
  void onCentralStateChanged(MyCentralArgs centralArgs, bool stateArgs) {
    final addressArgs = centralArgs.addressArgs;
    logger.info('onCentralStateChanged: $addressArgs - $stateArgs');
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
  void onReadCharacteristicCommandReceived(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
  ) {
    logger.info(
        'onReadCharacteristicCommandReceived: $addressArgs.$hashCodeArgs - $idArgs, $offsetArgs');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
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
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
  ) {
    logger.info(
        'onWriteCharacteristicCommandReceived: $addressArgs.$hashCodeArgs - $idArgs, $offsetArgs, $valueArgs');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
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
    String addressArgs,
    int hashCodeArgs,
    int stateNumberArgs,
  ) {
    final stateArgs =
        MyGattCharacteristicNotifyStateArgs.values[stateNumberArgs];
    logger.info(
        'onNotifyCharacteristicCommandReceived: $addressArgs.$hashCodeArgs - $stateArgs');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final state = stateArgs != MyGattCharacteristicNotifyStateArgs.none;
    final confirms = _confirms.putIfAbsent(addressArgs, () => {});
    if (state) {
      confirms[hashCodeArgs] =
          stateArgs == MyGattCharacteristicNotifyStateArgs.indicate;
    } else {
      confirms.remove(hashCodeArgs);
    }
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
