import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_bluetooth_low_energy_manager.dart';

class MyPeripheralManager extends MyBluetoothLowEnergyManager
    implements PeripheralManager, MyPeripheralManagerFlutterApi {
  final MyPeripheralManagerHostApi _myApi;
  final StreamController<ReadGattCharacteristicCommandEventArgs>
      _readCharacteristicCommandReceivedController;
  final StreamController<WriteGattCharacteristicCommandEventArgs>
      _writeCharacteristicCommandReceivedController;
  final StreamController<NotifyGattCharacteristicCommandEventArgs>
      _notifyCharacteristicCommandReceivedController;

  MyPeripheralManager()
      : _myApi = MyPeripheralManagerHostApi(),
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

  Future<void> setUp() async {
    final args = await _myApi.setUp();
    final myStateArgs =
        MyBluetoothLowEnergyStateArgs.values[args.myStateNumber];
    state = myStateArgs.toMyState();
    MyPeripheralManagerFlutterApi.setup(this);
  }

  @override
  Future<void> addService(GattService service) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myService = service as MyGattService;
    final myServiceArgs = myService.toMyArgs();
    await _myApi.addService(myServiceArgs);
  }

  @override
  Future<void> removeService(GattService service) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _myApi.removeService(service.hashCode);
  }

  @override
  Future<void> clearServices() async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _myApi.clearServices();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myAdvertisementArgs = advertisement.toMyArgs();
    await _myApi.startAdvertising(myAdvertisementArgs);
  }

  @override
  Future<void> stopAdvertising() async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _myApi.stopAdvertising();
  }

  @override
  Future<int> getMaximumWriteLength(Central central) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final maximumWriteLength = await _myApi.getMaximumWriteLength(
      central.hashCode,
    );
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
    await _myApi.sendReadCharacteristicReply(
      central.hashCode,
      characteristic.hashCode,
      id,
      offset,
      status,
      value,
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
    await _myApi.sendWriteCharacteristicReply(
      central.hashCode,
      characteristic.hashCode,
      id,
      offset,
      status,
    );
  }

  @override
  Future<void> notifyCharacteristicValueChanged(
    Central central,
    GattCharacteristic characteristic,
    Uint8List value,
  ) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _myApi.notifyCharacteristicValueChanged(
      central.hashCode,
      characteristic.hashCode,
      value,
    );
  }

  @override
  void onStateChanged(int myStateNumber) {
    final myStateArgs = MyBluetoothLowEnergyStateArgs.values[myStateNumber];
    state = myStateArgs.toMyState();
  }

  @override
  void onReadCharacteristicCommandReceived(
    MyCentralArgs myCentralArgs,
    MyGattCharacteristicArgs myCharacteristicArgs,
    int myId,
    int myOffset,
  ) {
    final myCentral = myCentralArgs.toMyCentral();
    final myCharacteristic = myCharacteristicArgs.toMyCharacteristic();
    final eventArgs = ReadGattCharacteristicCommandEventArgs(
      myCentral,
      myCharacteristic,
      myId,
      myOffset,
    );
    _readCharacteristicCommandReceivedController.add(eventArgs);
  }

  @override
  void onWriteCharacteristicCommandReceived(
    MyCentralArgs myCentralArgs,
    MyGattCharacteristicArgs myCharacteristicArgs,
    int myId,
    int myOffset,
    Uint8List myValue,
  ) {
    final myCentral = myCentralArgs.toMyCentral();
    final myCharacteristic = myCharacteristicArgs.toMyCharacteristic();
    final eventArgs = WriteGattCharacteristicCommandEventArgs(
      myCentral,
      myCharacteristic,
      myId,
      myOffset,
      myValue,
    );
    _writeCharacteristicCommandReceivedController.add(eventArgs);
  }

  @override
  void onNotifyCharacteristicCommandReceived(
    MyCentralArgs myCentralArgs,
    MyGattCharacteristicArgs myCharacteristicArgs,
    bool myState,
  ) {
    final myCentral = myCentralArgs.toMyCentral();
    final myCharacteristic = myCharacteristicArgs.toMyCharacteristic();
    final eventArgs = NotifyGattCharacteristicCommandEventArgs(
      myCentral,
      myCharacteristic,
      myState,
    );
    _notifyCharacteristicCommandReceivedController.add(eventArgs);
  }
}
