import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'my_api.dart';
import 'my_central2.dart';

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
  final Map<String, MyCentral2> _centrals;
  final Map<int, Map<int, MyGattCharacteristic>> _characteristics;
  final Map<String, int> _mtus;
  final Map<String, Map<int, bool>> _confirms;
  final Map<String, MyGattCharacteristic> _preparedCharacteristics;
  final Map<String, Uint8List> _preparedValues;

  MyPeripheralManager()
      : _api = MyPeripheralManagerHostApi(),
        _stateChangedController = StreamController.broadcast(),
        _characteristicReadController = StreamController.broadcast(),
        _characteristicWrittenController = StreamController.broadcast(),
        _characteristicNotifyStateChangedController =
            StreamController.broadcast(),
        _centrals = {},
        _characteristics = {},
        _mtus = {},
        _confirms = {},
        _preparedCharacteristics = {},
        _preparedValues = {};

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
    await _api.setUp();
    MyPeripheralManagerFlutterApi.setup(this);
  }

  @override
  Future<BluetoothLowEnergyState> getState() async {
    final stateNumberArgs = await _api.getState();
    final stateArgs = MyBluetoothLowEnergyStateArgs.values[stateNumberArgs];
    final state = stateArgs.toState();
    return state;
  }

  @override
  Future<void> addService(GattService service) async {
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
    final hashCodeArgs = service.hashCode;
    await _api.removeService(hashCodeArgs);
    _characteristics.remove(service.hashCode);
  }

  @override
  Future<void> clearServices() async {
    await _api.clearServices();
    _characteristics.clear();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement) async {
    final advertisementArgs = advertisement.toArgs();
    await _api.startAdvertising(advertisementArgs);
  }

  @override
  Future<void> stopAdvertising() async {
    await _api.stopAdvertising();
  }

  @override
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
  }) async {
    if (characteristic is! MyGattCharacteristic) {
      throw TypeError();
    }
    characteristic.value = value;
    for (var addressArgs in _confirms.keys) {
      final hashCodeArgs = characteristic.hashCode;
      final confirm = _retrieveConfirm(addressArgs, hashCodeArgs);
      if (confirm == null) {
        continue;
      }
      final valueArgs = characteristic.value;
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
        await _api.notifyCharacteristicChanged(
          addressArgs,
          hashCodeArgs,
          confirm,
          trimmedValueArgs,
        );
        start = end;
        characteristic.value = trimmedValueArgs;
      }
    }
  }

  @override
  void onStateChanged(int stateNumberArgs) {
    final stateArgs = MyBluetoothLowEnergyStateArgs.values[stateNumberArgs];
    logger.info('onStateChanged: $stateArgs');
    final state = stateArgs.toState();
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onConnectionStateChanged(MyCentralArgs centralArgs, bool stateArgs) {
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
    const statusArgs = MyGattStatusArgs.success;
    final statusNumberArgs = statusArgs.index;
    final offset = offsetArgs;
    final value = characteristic.value;
    final valueArgs = value.sublist(offset);
    try {
      await _api.sendResponse(
        addressArgs,
        idArgs,
        statusNumberArgs,
        offsetArgs,
        valueArgs,
      );
    } catch (e, stack) {
      logger.shout('Send read response failed.', e, stack);
    }
    if (offset != 0) {
      return;
    }
    final eventArgs = GattCharacteristicReadEventArgs(
      central,
      characteristic,
      value,
    );
    _characteristicReadController.add(eventArgs);
  }

  @override
  void onCharacteristicWriteRequest(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
    bool preparedWrite,
    bool responseNeeded,
  ) async {
    logger.info(
        'onCharacteristicWriteRequest: $addressArgs.$hashCodeArgs - $idArgs, $offsetArgs, $valueArgs, $preparedWrite, $responseNeeded');
    final central = _centrals[addressArgs];
    if (central == null) {
      return;
    }
    final characteristic = _retrieveCharacteristic(hashCodeArgs);
    if (characteristic == null) {
      return;
    }
    final value = valueArgs;
    characteristic.value = value;
    if (preparedWrite) {
      final preparedCharacteristic = _preparedCharacteristics[addressArgs];
      if (preparedCharacteristic != null &&
          preparedCharacteristic != characteristic) {
        return;
      }
    }
    if (responseNeeded) {
      const statusArgs = true;
      try {
        await _api.sendResponse(
          addressArgs,
          idArgs,
          statusArgs,
          offsetArgs,
          valueArgs,
        );
      } catch (e, stack) {
        logger.shout('Send write response failed.', e, stack);
      }
    }
    final eventArgs = GattCharacteristicWrittenEventArgs(
      central,
      characteristic,
      value,
    );
    _characteristicWrittenController.add(eventArgs);
  }

  @override
  void onExecuteWrite(String addressArgs, int idArgs, bool execute) async {
    logger
        .info('onCharacteristicWriteRequest: $addressArgs - $idArgs, $execute');
    const statusArgs = MyGattStatusArgs.success;
    final statusNumberArgs = statusArgs.index;
    const offsetArgs = 0;
    const valueArgs = null;
    try {
      _api.sendResponse(
        addressArgs,
        idArgs,
        statusNumberArgs,
        offsetArgs,
        valueArgs,
      );
    } catch (e, stack) {
      logger.shout('Send execute write response failed.', e, stack);
    }
  }

  @override
  void onCharacteristicNotifyStateChanged(
    String addressArgs,
    int hashCodeArgs,
    int stateNumberArgs,
  ) {
    final stateArgs =
        MyGattCharacteristicNotifyStateArgs.values[stateNumberArgs];
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
    final state = stateArgs != MyGattCharacteristicNotifyStateArgs.none;
    final confirms = _confirms.putIfAbsent(addressArgs, () => {});
    if (state) {
      confirms[hashCodeArgs] =
          stateArgs == MyGattCharacteristicNotifyStateArgs.indicate;
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

  MyGattCharacteristic? _retrieveCharacteristic(int hashCodeArgs) {
    final characteristics = _characteristics.values
        .reduce((value, element) => value..addAll(element));
    return characteristics[hashCodeArgs];
  }

  bool? _retrieveConfirm(String addressArgs, int hashCodeArgs) {
    final confirms = _confirms[addressArgs];
    if (confirms == null) {
      return null;
    }
    return confirms[hashCodeArgs];
  }
}
