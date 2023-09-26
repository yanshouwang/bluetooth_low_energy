import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_gatt_characteristic.dart';
import 'my_gatt_descriptor.dart';
import 'my_gatt_service.dart';
import 'my_peripheral.dart';

class MyCentralManager extends CentralManager
    implements MyCentralControllerFlutterApi {
  MyCentralManager()
      : _myApi = MyCentralControllerHostApi(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _state = BluetoothLowEnergyState.unknown;

  final MyCentralControllerHostApi _myApi;
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
    final myStateArgs = MyCentralStateArgs.values[args.myStateNumber];
    _state = myStateArgs.toState();
    MyCentralControllerFlutterApi.setup(this);
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
  Future<int> readRSSI(Peripheral peripheral) {
    // TODO: implement readRSSI
    throw UnimplementedError();
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    await _myApi.discoverGATT(myPeripheral.hashCode);
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
      myService.hashCode,
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
      myService.hashCode,
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
      myService.hashCode,
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
      myCharacteristic.hashCode,
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
      myCharacteristic.hashCode,
      myDescriptor.hashCode,
      value,
    );
  }

  @override
  void onStateChanged(int myStateNumber) {
    final myStateArgs = MyCentralStateArgs.values[myStateNumber];
    final state = myStateArgs.toState();
    if (_state == state) {
      return;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onDiscovered(
    MyPeripheralArgs myPeripheralArgs,
    int rssi,
    MyAdvertisementArgs myAdvertisementArgs,
  ) {
    final myPeripheral = MyPeripheral.fromMyArgs(myPeripheralArgs);
    _myPeripherals[myPeripheral.hashCode] = myPeripheral;
    final advertisement = myAdvertisementArgs.toAdvertisement();
    final eventArgs = DiscoveredEventArgs(
      myPeripheral,
      rssi,
      advertisement,
    );
    _discoveredController.add(eventArgs);
  }

  @override
  void onPeripheralStateChanged(int myPeripheralKey, bool state) {
    final myPeripheral = _myPeripherals[myPeripheralKey];
    if (myPeripheral == null) {
      return;
    }
    final eventArgs = PeripheralStateChangedEventArgs(myPeripheral, state);
    _peripheralStateChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicValueChanged(int myCharacteristicKey, Uint8List value) {
    final myCharacteristic =
        _myCharacteristics[myCharacteristicKey] as MyGattCharacteristic;
    final eventArgs = GattCharacteristicValueChangedEventArgs(
      myCharacteristic,
      value,
    );
    _characteristicValueChangedController.add(eventArgs);
  }
}

extension on MyAdvertisementArgs {
  Advertisement toAdvertisement() {
    final serviceUUIDs = this
        .serviceUUIDs
        .cast<String>()
        .map((uuid) => UUID.fromString(uuid))
        .toList();
    final serviceData = this.serviceData.cast<String, Uint8List>().map(
      (uuid, data) {
        final key = UUID.fromString(uuid);
        final value = data;
        return MapEntry(key, value);
      },
    );
    return Advertisement(
      name: name,
      manufacturerSpecificData: manufacturerSpecificData.cast<int, Uint8List>(),
      serviceUUIDs: serviceUUIDs,
      serviceData: serviceData,
    );
  }
}

extension on MyCentralStateArgs {
  BluetoothLowEnergyState toState() {
    return BluetoothLowEnergyState.values[index];
  }
}

extension on GattCharacteristicWriteType {
  MyGattCharacteristicWriteTypeArgs toMyArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}
