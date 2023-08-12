import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_gatt_characteristic.dart';
import 'my_gatt_descriptor.dart';
import 'my_gatt_service.dart';
import 'my_peripheral.dart';

class MyCentralController extends CentralController
    implements MyCentralControllerFlutterApi {
  MyCentralController()
      : _myApi = MyCentralControllerHostApi(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _myPeripherals = {},
        _myServices = {},
        _myCharacteristics = {},
        _myDescriptors = {},
        _state = CentralState.unknown;

  final MyCentralControllerHostApi _myApi;
  final StreamController<CentralStateChangedEventArgs> _stateChangedController;
  final StreamController<CentralDiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralStateChangedEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueChangedEventArgs>
      _characteristicValueChangedController;
  final Map<int, MyPeripheral> _myPeripherals;
  final Map<int, MyGattService> _myServices;
  final Map<int, MyGattCharacteristic> _myCharacteristics;
  final Map<int, MyGattDescriptor> _myDescriptors;

  CentralState _state;
  @override
  CentralState get state => _state;

  @override
  Stream<CentralStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<CentralDiscoveredEventArgs> get discovered =>
      _discoveredController.stream;
  @override
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;
  @override
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged =>
          _characteristicValueChangedController.stream;

  void _throwWithState(CentralState state) {
    if (this.state == state) {
      throw BluetoothLowEnergyError('$state is unexpected.');
    }
  }

  void _throwWithoutState(CentralState state) {
    if (this.state != state) {
      throw BluetoothLowEnergyError(
        '$state is expected, but current state is ${this.state}.',
      );
    }
  }

  @override
  Future<void> setUp() async {
    _throwWithoutState(CentralState.unknown);
    final args = await _myApi.setUp();
    final myStateArgs = MyCentralStateArgs.values[args.myStateNumber];
    _state = myStateArgs.toState();
    MyCentralControllerFlutterApi.setup(this);
  }

  @override
  Future<void> tearDown() async {
    _throwWithState(CentralState.unknown);
    await _myApi.tearDown();
    MyCentralControllerFlutterApi.setup(null);
    _myPeripherals.clear();
    _myServices.clear();
    _myCharacteristics.clear();
    _myDescriptors.clear();
    _state = CentralState.unknown;
  }

  @override
  Future<void> startDiscovery() {
    _throwWithoutState(CentralState.poweredOn);
    return _myApi.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() {
    _throwWithoutState(CentralState.poweredOn);
    return _myApi.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) {
    _throwWithoutState(CentralState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    return _myApi.connect(myPeripheral.hashCode);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) {
    _throwWithoutState(CentralState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    return _myApi.disconnect(myPeripheral.hashCode);
  }

  @override
  Future<void> discoverGATT(Peripheral peripheral) {
    _throwWithoutState(CentralState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    return _myApi.discoverGATT(myPeripheral.hashCode);
  }

  @override
  Future<List<GattService>> getServices(Peripheral peripheral) async {
    _throwWithoutState(CentralState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    final myServiceArgses = await _myApi.getServices(myPeripheral.hashCode);
    return myServiceArgses
        .whereType<MyGattServiceArgs>()
        .map(
          (myServiceArgs) => _myServices.putIfAbsent(
            myServiceArgs.key,
            () => MyGattService.fromMyArgs(
              myPeripheral,
              myServiceArgs,
            ),
          ),
        )
        .toList();
  }

  @override
  Future<List<GattCharacteristic>> getCharacteristics(
    GattService service,
  ) async {
    _throwWithoutState(CentralState.poweredOn);
    final myService = service as MyGattService;
    final myCharactersiticArgses = await _myApi.getCharacteristics(
      myService.hashCode,
    );
    return myCharactersiticArgses
        .whereType<MyGattCharacteristicArgs>()
        .map(
          (myCharacteristicArgs) => _myCharacteristics.putIfAbsent(
            myCharacteristicArgs.key,
            () => MyGattCharacteristic.fromMyArgs(
              myService,
              myCharacteristicArgs,
            ),
          ),
        )
        .toList();
  }

  @override
  Future<List<GattDescriptor>> getDescriptors(
    GattCharacteristic characteristic,
  ) async {
    _throwWithoutState(CentralState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final myDescriptorArgses = await _myApi.getDescriptors(
      myCharacteristic.hashCode,
    );
    return myDescriptorArgses
        .whereType<MyGattDescriptorArgs>()
        .map(
          (myDescriptorArgs) => _myDescriptors.putIfAbsent(
            myDescriptorArgs.key,
            () => MyGattDescriptor.fromMyArgs(
              myCharacteristic,
              myDescriptorArgs,
            ),
          ),
        )
        .toList();
  }

  @override
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic) {
    _throwWithoutState(CentralState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    return _myApi.readCharacteristic(
      myPeripheral.hashCode,
      myCharacteristic.hashCode,
    );
  }

  @override
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) {
    _throwWithoutState(CentralState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    final typeArgs = type.toMyArgs();
    final typeNumber = typeArgs.index;
    return _myApi.writeCharacteristic(
      myPeripheral.hashCode,
      myCharacteristic.hashCode,
      value,
      typeNumber,
    );
  }

  @override
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) {
    _throwWithoutState(CentralState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    return _myApi.notifyCharacteristic(
      myPeripheral.hashCode,
      myCharacteristic.hashCode,
      state,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) {
    _throwWithoutState(CentralState.poweredOn);
    final myDescriptor = descriptor as MyGattDescriptor;
    final myCharacteristic = myDescriptor.myCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    return _myApi.readDescriptor(myPeripheral.hashCode, myDescriptor.hashCode);
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) {
    _throwWithoutState(CentralState.poweredOn);
    final myDescriptor = descriptor as MyGattDescriptor;
    final myCharacteristic = myDescriptor.myCharacteristic;
    final myService = myCharacteristic.myService;
    final myPeripheral = myService.myPeripheral;
    return _myApi.writeDescriptor(
      myPeripheral.hashCode,
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
    final eventArgs = CentralStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onDiscovered(
    MyPeripheralArgs myPeripheralArgs,
    int rssi,
    MyAdvertisementArgs myAdvertisementArgs,
  ) {
    final myPeripheral = _myPeripherals.putIfAbsent(
      myPeripheralArgs.key,
      () => MyPeripheral.fromMyArgs(myPeripheralArgs),
    );
    final advertisement = myAdvertisementArgs.toAdvertisement();
    final eventArgs = CentralDiscoveredEventArgs(
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
    return Advertisement(
      name: name,
      manufacturerSpecificData: manufacturerSpecificData.cast<int, Uint8List>(),
    );
  }
}

extension on MyCentralStateArgs {
  CentralState toState() {
    return CentralState.values[index];
  }
}

extension on GattCharacteristicWriteType {
  MyGattCharacteristicWriteTypeArgs toMyArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}
