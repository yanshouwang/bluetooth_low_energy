import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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

  MyPeripheralManager2()
      : _api = MyPeripheralManagerHostApi(),
        _state = BluetoothLowEnergyState.unknown,
        _stateChangedController = StreamController.broadcast(),
        _readCharacteristicCommandReceivedController =
            StreamController.broadcast(),
        _writeCharacteristicCommandReceivedController =
            StreamController.broadcast(),
        _notifyCharacteristicCommandReceivedController =
            StreamController.broadcast();

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
      throw PlatformException(
        code: 'state-error',
        message: '$state is expected, but current state is ${this.state}.',
      );
    }
  }

  @override
  Future<void> setUp() async {
    await super.setUp();
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
  }

  @override
  Future<void> removeService(GattService service) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final serviceHashCodeArgs = service.hashCode;
    await _api.removeService(serviceHashCodeArgs);
  }

  @override
  Future<void> clearServices() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _api.clearServices();
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
  Future<int> getMaximumWriteLength(Central central) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final centralHashCodeArgs = central.hashCode;
    final maximumWriteLength =
        await _api.getMaximumWriteLength(centralHashCodeArgs);
    return maximumWriteLength;
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
    final centralHashCodeArgs = central.hashCode;
    final characteristicHashCodeArgs = characteristic.hashCode;
    final idArgs = id;
    final offsetArgs = offset;
    final statusArgs = status;
    final valueArgs = value;
    await _api.sendReadCharacteristicReply(
      centralHashCodeArgs,
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
    final centralHashCodeArgs = central.hashCode;
    final characteristicHashCodeArgs = characteristic.hashCode;
    final idArgs = id;
    final offsetArgs = offset;
    final statusArgs = status;
    await _api.sendWriteCharacteristicReply(
      centralHashCodeArgs,
      characteristicHashCodeArgs,
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
    final centralHashCodeArgs = central.hashCode;
    final characteristicHashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    await _api.notifyCharacteristicValueChanged(
      centralHashCodeArgs,
      characteristicHashCodeArgs,
      valueArgs,
    );
  }

  @override
  void onStateChanged(int stateNumberArgs) {
    final stateArgs = MyBluetoothLowEnergyStateArgs.values[stateNumberArgs];
    state = stateArgs.toState();
  }

  @override
  void onReadCharacteristicCommandReceived(
    MyCentralArgs centralArgs,
    MyGattCharacteristicArgs characteristicArgs,
    int idArgs,
    int offsetArgs,
  ) {
    final central = centralArgs.toCentral();
    final characteristic = characteristicArgs.toCharacteristic2();
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
    MyGattCharacteristicArgs characteristicArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
  ) {
    final central = centralArgs.toCentral();
    final characteristic = characteristicArgs.toCharacteristic2();
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
    MyGattCharacteristicArgs characteristicArgs,
    bool stateArgs,
  ) {
    final central = centralArgs.toCentral();
    final characteristic = characteristicArgs.toCharacteristic2();
    final state = stateArgs;
    final eventArgs = NotifyGattCharacteristicCommandEventArgs(
      central,
      characteristic,
      state,
    );
    _notifyCharacteristicCommandReceivedController.add(eventArgs);
  }
}
