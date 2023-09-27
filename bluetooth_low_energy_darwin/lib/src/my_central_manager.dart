import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';

class MyCentralManager extends CentralManager
    implements MyCentralManagerFlutterApi {
  MyCentralManager()
      : _myApi = MyCentralManagerHostApi(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _state = BluetoothLowEnergyState.unknown;

  final MyCentralManagerHostApi _myApi;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralStateChangedEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueChangedEventArgs>
      _characteristicValueChangedController;

  BluetoothLowEnergyState _state;
  @override
  BluetoothLowEnergyState get state => _state;

  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<DiscoveredEventArgs> get discovered => _discoveredController.stream;
  @override
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;
  @override
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged =>
          _characteristicValueChangedController.stream;

  Future<void> _throwWithoutState(BluetoothLowEnergyState state) async {
    if (this.state != state) {
      throw BluetoothLowEnergyError(
        '$state is expected, but current state is ${this.state}.',
      );
    }
  }

  Future<void> setUp() async {
    await _throwWithoutState(BluetoothLowEnergyState.unknown);
    final args = await _myApi.setUp();
    final myStateArgs =
        MyBluetoothLowEnergyStateArgs.values[args.myStateNumber];
    _state = myStateArgs.toMyState();
    MyCentralManagerFlutterApi.setup(this);
  }

  @override
  Future<void> startDiscovery() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _myApi.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _myApi.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    await _myApi.connect(myPeripheral.hashCode);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    await _myApi.disconnect(myPeripheral.hashCode);
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GattCharacteristicWriteType type,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    final myTypeArgs = type.toMyArgs();
    final myTypeNumber = myTypeArgs.index;
    final maximumWriteLength = await _myApi.getMaximumWriteLength(
      myPeripheral.hashCode,
      myTypeNumber,
    );
    return maximumWriteLength;
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    final rssi = await _myApi.readRSSI(
      myPeripheral.hashCode,
    );
    return rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    final myServiceArgses = await _myApi.discoverGATT(myPeripheral.hashCode);
    final myServices = myServiceArgses
        .cast<MyGattServiceArgs>()
        .map((myServiceArgs) => myServiceArgs.toMyService())
        .toList();
    for (var myService in myServices) {
      for (var myCharactersitic in myService.characteristics) {
        for (var myDescriptor in myCharactersitic.descriptors) {
          myDescriptor.myCharacteristic = myCharactersitic;
        }
        myCharactersitic.myService = myService;
      }
      myService.myPeripheral = myPeripheral;
    }
    return myServices;
  }

  @override
  Future<Uint8List> readCharacteristic(
    GattCharacteristic characteristic,
  ) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    final value = await _myApi.readCharacteristic(
      myPeripheral.hashCode,
      myCharacteristic.hashCode,
    );
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    final myTypeArgs = type.toMyArgs();
    final myTypeNumber = myTypeArgs.index;
    await _myApi.writeCharacteristic(
      myPeripheral.hashCode,
      myCharacteristic.hashCode,
      value,
      myTypeNumber,
    );
  }

  @override
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    await _myApi.notifyCharacteristic(
      myPeripheral.hashCode,
      myCharacteristic.hashCode,
      state,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myDescriptor = descriptor as MyGattDescriptor;
    final myCharacteristic = myDescriptor.myCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    final value = await _myApi.readDescriptor(
      myPeripheral.hashCode,
      myDescriptor.hashCode,
    );
    return value;
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myDescriptor = descriptor as MyGattDescriptor;
    final myCharacteristic = myDescriptor.myCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    await _myApi.writeDescriptor(
      myPeripheral.hashCode,
      myDescriptor.hashCode,
      value,
    );
  }

  @override
  void onStateChanged(int myStateNumber) {
    final myStateArgs = MyBluetoothLowEnergyStateArgs.values[myStateNumber];
    final myState = myStateArgs.toMyState();
    if (_state == myState) {
      return;
    }
    _state = myState;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(myState);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onDiscovered(
    MyPeripheralArgs myPeripheralArgs,
    int myRSSI,
    MyAdvertisementArgs myAdvertisementArgs,
  ) {
    final myPeripheral = myPeripheralArgs.toMyPeripheral();
    final myAdvertisement = myAdvertisementArgs.toMyAdvertisement();
    final eventArgs = DiscoveredEventArgs(
      myPeripheral,
      myRSSI,
      myAdvertisement,
    );
    _discoveredController.add(eventArgs);
  }

  @override
  void onPeripheralStateChanged(
    MyPeripheralArgs myPeripheralArgs,
    bool myState,
  ) {
    final myPeripheral = myPeripheralArgs.toMyPeripheral();
    final eventArgs = PeripheralStateChangedEventArgs(myPeripheral, myState);
    _peripheralStateChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicValueChanged(
    MyGattCharacteristicArgs myCharacteristicArgs,
    Uint8List myValue,
  ) {
    final myCharacteristic = myCharacteristicArgs.toMyCharacteristic();
    final eventArgs = GattCharacteristicValueChangedEventArgs(
      myCharacteristic,
      myValue,
    );
    _characteristicValueChangedController.add(eventArgs);
  }
}
