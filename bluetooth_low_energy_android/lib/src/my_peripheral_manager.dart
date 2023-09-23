import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_bluetooth_low_energy_manager.dart';
import 'my_central.dart';
import 'my_gatt_characteristic.dart';

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
    state = myStateArgs.toState();
    MyPeripheralManagerFlutterApi.setup(this);
  }

  @override
  Future<void> addService(GattService service) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final customizedService = service as CustomizedGattService;
    final myServiceArgs = customizedService.toMyArgs();
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
    int status,
    Uint8List value,
  ) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _myApi.sendReadCharacteristicReply(
      central.hashCode,
      characteristic.hashCode,
      status,
      value,
    );
  }

  @override
  Future<void> sendWriteCharacteristicReply(
    Central central,
    GattCharacteristic characteristic,
    int status,
  ) async {
    await throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _myApi.sendWriteCharacteristicReply(
      central.hashCode,
      characteristic.hashCode,
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
    state = myStateArgs.toState();
  }

  @override
  void onReadCharacteristicCommandReceived(
    MyCentralArgs myCentralArgs,
    MyCustomizedGattCharacteristicArgs myCharacteristicArgs,
  ) {
    final myCentral = MyCentral.fromMyArgs(myCentralArgs);
    final myCharacteristic = MyGattCharacteristic.fromMyCustomizedArgs(
      myCharacteristicArgs,
    );
    final eventArgs = ReadGattCharacteristicCommandEventArgs(
      myCentral,
      myCharacteristic,
    );
    _readCharacteristicCommandReceivedController.add(eventArgs);
  }

  @override
  void onWriteCharacteristicCommandReceived(
    MyCentralArgs myCentralArgs,
    MyCustomizedGattCharacteristicArgs myCharacteristicArgs,
    Uint8List value,
  ) {
    final myCentral = MyCentral.fromMyArgs(myCentralArgs);
    final myCharacteristic = MyGattCharacteristic.fromMyCustomizedArgs(
      myCharacteristicArgs,
    );
    final eventArgs = WriteGattCharacteristicCommandEventArgs(
      myCentral,
      myCharacteristic,
      value,
    );
    _writeCharacteristicCommandReceivedController.add(eventArgs);
  }

  @override
  void onNotifyCharacteristicCommandReceived(
    MyCentralArgs myCentralArgs,
    MyCustomizedGattCharacteristicArgs myCharacteristicArgs,
    bool state,
  ) {
    final myCentral = MyCentral.fromMyArgs(myCentralArgs);
    final myCharacteristic = MyGattCharacteristic.fromMyCustomizedArgs(
      myCharacteristicArgs,
    );
    final eventArgs = NotifyGattCharacteristicCommandEventArgs(
      myCentral,
      myCharacteristic,
      state,
    );
    _notifyCharacteristicCommandReceivedController.add(eventArgs);
  }
}
