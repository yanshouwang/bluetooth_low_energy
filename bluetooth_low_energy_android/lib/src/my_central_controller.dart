import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.g.dart';
import 'my_gatt_characteristic.dart';
import 'my_gatt_descriptor.dart';
import 'my_gatt_service.dart';
import 'my_peripheral.dart';

final centralController = MyCentralController._();

class MyCentralController extends CentralController
    implements MyCentralControllerFlutterApi {
  MyCentralController._()
      : _api = MyCentralControllerHostApi(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _state = CentralControllerState.unauthorized;

  final MyCentralControllerHostApi _api;
  final StreamController<CentralControllerStateChangedEventArgs>
      _stateChangedController;
  final StreamController<CentralControllerDiscoveredEventArgs>
      _discoveredController;
  final StreamController<PeripheralStateChangedEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueChangedEventArgs>
      _characteristicValueChangedController;

  CentralControllerState _state;
  @override
  CentralControllerState get state => _state;

  @override
  Future<void> initialize() async {
    await _api.initialize();
    final stateNumber = await _api.getState();
    final stateArgs = MyCentralControllerStateArgs.values[stateNumber];
    _state = stateArgs.toState();
    MyCentralControllerFlutterApi.setup(this);
  }

  Future<void> free(int hashCode) {
    return _api.free(hashCode);
  }

  @override
  Stream<CentralControllerStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<CentralControllerDiscoveredEventArgs> get discovered =>
      _discoveredController.stream;
  @override
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;
  @override
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged =>
          _characteristicValueChangedController.stream;

  @override
  Future<void> startDiscovery() {
    return _api.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() {
    return _api.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) {
    return _api.connect(peripheral.hashCode);
  }

  @override
  void disconnect(Peripheral peripheral) {
    _api.disconnect(peripheral.hashCode).ignore();
  }

  @override
  Future<void> discoverGATT(Peripheral peripheral) {
    return _api.discoverGATT(peripheral.hashCode);
  }

  @override
  Future<List<GattService>> getServices(Peripheral peripheral) async {
    final argses = await _api.getServices(peripheral.hashCode);
    return argses
        .whereType<MyGattServiceArgs>()
        .map((args) => MyGattService.fromArgs(args))
        .toList();
  }

  @override
  Future<List<GattCharacteristic>> getCharacteristics(
    GattService service,
  ) async {
    final argses = await _api.getCharacteristics(service.hashCode);
    return argses
        .whereType<MyGattCharacteristicArgs>()
        .map((args) => MyGattCharacteristic.fromArgs(args))
        .toList();
  }

  @override
  Future<List<GattDescriptor>> getDescriptors(
    GattCharacteristic characteristic,
  ) async {
    final argses = await _api.getDescriptors(characteristic.hashCode);
    return argses
        .whereType<MyGattDescriptorArgs>()
        .map((args) => MyGattDescriptor.fromArgs(args))
        .toList();
  }

  @override
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic) {
    return _api.readCharacteristic(characteristic.hashCode);
  }

  @override
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) {
    final typeArgs = type.toArgs();
    final typeNumber = typeArgs.index;
    return _api.writeCharacteristic(characteristic.hashCode, value, typeNumber);
  }

  @override
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) {
    return _api.notifyCharacteristic(characteristic.hashCode, state);
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) {
    return _api.readDescriptor(descriptor.hashCode);
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) {
    return _api.writeDescriptor(descriptor.hashCode, value);
  }

  @override
  void onStateChanged(int stateNumber) {
    final stateArgs = MyCentralControllerStateArgs.values[stateNumber];
    final state = stateArgs.toState();
    if (_state == state) {
      return;
    }
    _state = state;
    final eventArgs = CentralControllerStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssi,
    MyAdvertisementArgs advertisementArgs,
  ) {
    final peripheral = MyPeripheral.fromArgs(peripheralArgs);
    final advertisement = advertisementArgs.toAdvertisement();
    final eventArgs = CentralControllerDiscoveredEventArgs(
      peripheral,
      rssi,
      advertisement,
    );
    _discoveredController.add(eventArgs);
  }

  @override
  void onPeripheralStateChanged(
    MyPeripheralArgs peripheralArgs,
    bool state,
    String? errorMessage,
  ) {
    final peripheral = MyPeripheral.fromArgs(peripheralArgs);
    final error =
        errorMessage == null ? null : BluetoothLowEnergyError(errorMessage);
    final eventArgs = PeripheralStateChangedEventArgs(peripheral, state, error);
    _peripheralStateChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicValueChanged(
    MyGattCharacteristicArgs characteristicArgs,
    Uint8List value,
  ) {
    final characteristic = MyGattCharacteristic.fromArgs(characteristicArgs);
    final eventArgs = GattCharacteristicValueChangedEventArgs(
      characteristic,
      value,
    );
    _characteristicValueChangedController.add(eventArgs);
  }
}

extension on MyAdvertisementArgs {
  Advertisement toAdvertisement() {
    return Advertisement(
      name: name,
      manufacturerSpecificData: manufacturerSpecificData,
    );
  }
}

extension on MyCentralControllerStateArgs {
  CentralControllerState toState() {
    return CentralControllerState.values[index];
  }
}

extension on GattCharacteristicWriteType {
  MyGattCharacteristicWriteTypeArgs toArgs() {
    return MyGattCharacteristicWriteTypeArgs.values[index];
  }
}
