import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_bluetooth_low_energy_manager.dart';

class MyPeripheralManager extends MyBluetoothLowEnergyManager
    implements PeripheralManager, MyPeripheralManagerFlutterApi {
  final MyPeripheralManagerHostApi _api;
  final StreamController<ReadGattCharacteristicCommandEventArgs>
      _readCharacteristicCommandReceivedController;
  final StreamController<WriteGattCharacteristicCommandEventArgs>
      _writeCharacteristicCommandReceivedController;
  final StreamController<NotifyGattCharacteristicCommandEventArgs>
      _notifyCharacteristicCommandReceivedController;

  MyPeripheralManager()
      : _api = MyPeripheralManagerHostApi(),
        _readCharacteristicCommandReceivedController =
            StreamController.broadcast(),
        _writeCharacteristicCommandReceivedController =
            StreamController.broadcast(),
        _notifyCharacteristicCommandReceivedController =
            StreamController.broadcast();

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
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (service is! MyGattService) {
      throw TypeError();
    }
    final serviceArgs = service.toArgs();
    await _api.addService(serviceArgs);
  }

  @override
  Future<void> removeService(GattService service) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final serviceHashCodeArgs = service.hashCode;
    await _api.removeService(serviceHashCodeArgs);
  }

  @override
  Future<void> clearServices() async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _api.clearServices();
  }

  @override
  Future<void> startAdvertising(AdvertiseData advertiseData) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final advertiseDataArgs = advertiseData.toArgs();
    await _api.startAdvertising(advertiseDataArgs);
  }

  @override
  Future<void> stopAdvertising() async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _api.stopAdvertising();
  }

  @override
  Future<int> getMaximumWriteLength(Central central) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final centralHashCodeArgs = central.hashCode;
    final maximumWriteLength =
        await _api.getMaximumWriteLength(centralHashCodeArgs);
    return maximumWriteLength;
  }

  @override
  Future<void> sendReadCharacteristicReply(
    Central central,
    GattCharacteristic characteristic,
    int id,
    int offset,
    bool status,
    Uint8List value,
  ) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
    Central central,
    GattCharacteristic characteristic,
    int id,
    int offset,
    bool status,
  ) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
    Central central,
    GattCharacteristic characteristic,
    Uint8List value,
  ) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
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
