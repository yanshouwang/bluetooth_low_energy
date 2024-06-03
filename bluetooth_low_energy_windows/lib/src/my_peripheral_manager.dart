import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_api.g.dart';
import 'my_central.dart';
import 'my_gatt.dart';

final class MyPeripheralManager extends PlatformPeripheralManager
    implements MyPeripheralManagerFlutterAPI {
  final MyPeripheralManagerHostAPI _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<CentralMTUChangedEventArgs> _mtuChangedController;
  final StreamController<GATTCharacteristicReadRequestedEventArgs>
      _characteristicReadRequestedController;
  final StreamController<GATTCharacteristicWriteRequestedEventArgs>
      _characteristicWriteRequestedController;
  final StreamController<GATTCharacteristicNotifyStateChangedEventArgs>
      _characteristicNotifyStateChangedController;
  final StreamController<GATTDescriptorReadRequestedEventArgs>
      _descriptorReadRequestedController;
  final StreamController<GATTDescriptorWriteRequestedEventArgs>
      _descriptorWriteRequestedController;

  final Map<int, GATTService> _services;
  final Map<int, MutableGATTCharacteristic> _characteristics;
  final Map<int, MutableGATTDescriptor> _descriptors;
  final Map<int, Set<MyCentralArgs>> _subscribedCentralsArgs;

  BluetoothLowEnergyState _state;

  MyPeripheralManager()
      : _api = MyPeripheralManagerHostAPI(),
        _stateChangedController = StreamController.broadcast(),
        _mtuChangedController = StreamController.broadcast(),
        _characteristicReadRequestedController = StreamController.broadcast(),
        _characteristicWriteRequestedController = StreamController.broadcast(),
        _characteristicNotifyStateChangedController =
            StreamController.broadcast(),
        _descriptorReadRequestedController = StreamController.broadcast(),
        _descriptorWriteRequestedController = StreamController.broadcast(),
        _services = {},
        _characteristics = {},
        _descriptors = {},
        _subscribedCentralsArgs = {},
        _state = BluetoothLowEnergyState.unknown;

  UUID get cccUUID => UUID.short(0x2902);
  @override
  BluetoothLowEnergyState get state => _state;
  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<CentralConnectionStateChangedEventArgs> get connectionStateChanged =>
      throw UnsupportedError(
          'connectionStateChanged is not supported on Windows.');
  @override
  Stream<CentralMTUChangedEventArgs> get mtuChanged =>
      _mtuChangedController.stream;
  @override
  Stream<GATTCharacteristicReadRequestedEventArgs>
      get characteristicReadRequested =>
          _characteristicReadRequestedController.stream;
  @override
  Stream<GATTCharacteristicWriteRequestedEventArgs>
      get characteristicWriteRequested =>
          _characteristicWriteRequestedController.stream;
  @override
  Stream<GATTCharacteristicNotifyStateChangedEventArgs>
      get characteristicNotifyStateChanged =>
          _characteristicNotifyStateChangedController.stream;
  @override
  Stream<GATTDescriptorReadRequestedEventArgs> get descriptorReadRequested =>
      _descriptorReadRequestedController.stream;
  @override
  Stream<GATTDescriptorWriteRequestedEventArgs> get descriptorWriteRequested =>
      _descriptorWriteRequestedController.stream;

  @override
  void initialize() {
    MyPeripheralManagerFlutterAPI.setUp(this);
    _initialize();
  }

  @override
  Future<bool> authorize() async {
    throw UnsupportedError('authorize is not supported on Windows.');
  }

  @override
  Future<void> showAppSettings() async {
    throw UnsupportedError('showAppSettings is not supported on Windows.');
  }

  @override
  Future<void> addService(GATTService service) async {
    final serviceArgs = service.toArgs();
    logger.info('addService: $serviceArgs');
    await _api.addService(serviceArgs);
    _addService(service);
  }

  @override
  Future<void> removeService(GATTService service) async {
    final hashCodeArgs = service.hashCode;
    logger.info('removeService: $hashCodeArgs');
    await _api.removeService(hashCodeArgs);
    _removeService(service);
  }

  @override
  Future<void> removeAllServices() async {
    final services = _services.values;
    for (var service in services) {
      final hashCodeArgs = service.hashCode;
      logger.info('removeService: $hashCodeArgs');
      await _api.removeService(hashCodeArgs);
    }
    _services.clear();
    _characteristics.clear();
    _descriptors.clear();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement) async {
    final advertisementArgs = advertisement.toArgs();
    logger.info('startAdvertising: $advertisementArgs');
    await _api.startAdvertising(advertisementArgs);
  }

  @override
  Future<void> stopAdvertising() async {
    logger.info('stopAdvertising');
    await _api.stopAdvertising();
  }

  @override
  Future<int> getMaximumNotifyLength(Central central) async {
    if (central is! MyCentral) {
      throw TypeError();
    }
    final addressArgs = central.addressArgs;
    final maximumNotifyLength = await _api.getMaxNotificationSize(addressArgs);
    return maximumNotifyLength;
  }

  @override
  Future<void> respondReadRequestWithValue(
    GATTReadRequest request, {
    required Uint8List value,
  }) async {
    if (request is! MyGATTReadRequest) {
      throw TypeError();
    }
    final idArgs = request.idArgs;
    final valueArgs = value;
    logger.info('respondReadRequestWithValue: $idArgs - $valueArgs');
    await _api.respondReadRequestWithValue(idArgs, valueArgs);
  }

  @override
  Future<void> respondReadRequestWithError(
    GATTReadRequest request, {
    required GATTError error,
  }) async {
    if (request is! MyGATTReadRequest) {
      throw TypeError();
    }
    final idArgs = request.idArgs;
    final errorArgs = error.toArgs();
    logger.info('respondReadRequestWithProtocolError: $idArgs - $errorArgs');
    await _api.respondReadRequestWithProtocolError(idArgs, errorArgs);
  }

  @override
  Future<void> respondWriteRequest(GATTWriteRequest request) async {
    if (request is! MyGATTWriteRequest) {
      throw TypeError();
    }
    if (request.typeArgs == MyGATTCharacteristicWriteTypeArgs.withoutResponse) {
      return;
    }
    final idArgs = request.idArgs;
    logger.info('respondWriteRequest: $idArgs');
    await _api.respondWriteRequest(idArgs);
  }

  @override
  Future<void> respondWriteRequestWithError(
    GATTWriteRequest request, {
    required GATTError error,
  }) async {
    if (request is! MyGATTWriteRequest) {
      throw TypeError();
    }
    if (request.typeArgs == MyGATTCharacteristicWriteTypeArgs.withoutResponse) {
      return;
    }
    final idArgs = request.idArgs;
    final errorArgs = error.toArgs();
    logger.info('respondWriteRequestWithProtocolError: $idArgs - $errorArgs');
    await _api.respondWriteRequestWithProtocolError(idArgs, errorArgs);
  }

  @override
  Future<void> notifyCharacteristic(
    Central central,
    GATTCharacteristic characteristic, {
    required Uint8List value,
  }) async {
    if (central is! MyCentral || characteristic is! MutableGATTCharacteristic) {
      throw TypeError();
    }
    final addressArgs = central.addressArgs;
    final hashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    logger.info('notifyValue: $addressArgs - $hashCodeArgs, $valueArgs');
    await _api.notifyValue(
      addressArgs,
      hashCodeArgs,
      valueArgs,
    );
  }

  @override
  void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs) async {
    logger.info('onStateChanged: $stateArgs');
    final state = stateArgs.toState();
    if (_state == state) {
      return;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onMTUChanged(MyCentralArgs centralArgs, int mtuArgs) {
    final addressArgs = centralArgs.addressArgs;
    logger.info('onMTUChanged: $addressArgs - $mtuArgs');
    final central = centralArgs.toCentral();
    final mtu = mtuArgs;
    final eventArgs = CentralMTUChangedEventArgs(central, mtu);
    _mtuChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicReadRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    MyGATTReadRequestArgs requestArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    logger.info(
        'onCharacteristicReadRequest: $addressArgs - $hashCodeArgs, $requestArgs');
    final central = centralArgs.toCentral();
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      await _respondReadRequestWithProtocolError(
        requestArgs.idArgs,
        MyGATTProtocolErrorArgs.attributeNotFound,
      );
    } else {
      final eventArgs = GATTCharacteristicReadRequestedEventArgs(
        central,
        characteristic,
        MyGATTReadRequest(
          idArgs: requestArgs.idArgs,
          offset: requestArgs.offsetArgs,
          lengthArgs: requestArgs.lengthArgs,
        ),
      );
      _characteristicReadRequestedController.add(eventArgs);
    }
  }

  @override
  void onCharacteristicWriteRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    MyGATTWriteRequestArgs requestArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    logger.info(
        'onCharacteristicWriteRequest: $addressArgs - $hashCodeArgs, $requestArgs');
    final central = centralArgs.toCentral();
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      if (requestArgs.typeArgs ==
          MyGATTCharacteristicWriteTypeArgs.withoutResponse) {
        return;
      }
      await _respondWriteRequestWithProtocolError(
        requestArgs.idArgs,
        MyGATTProtocolErrorArgs.attributeNotFound,
      );
    } else {
      final eventArgs = GATTCharacteristicWriteRequestedEventArgs(
        central,
        characteristic,
        MyGATTWriteRequest(
          idArgs: requestArgs.idArgs,
          offset: requestArgs.offsetArgs,
          value: requestArgs.valueArgs,
          typeArgs: requestArgs.typeArgs,
        ),
      );
      _characteristicWriteRequestedController.add(eventArgs);
    }
  }

  @override
  void onCharacteristicSubscribedClientsChanged(
    int hashCodeArgs,
    List<MyCentralArgs?> centralsArgs,
  ) {
    logger.info(
        'onCharacteristicSubscribedClientsChanged: $hashCodeArgs - $centralsArgs');
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      logger.warning('The characteristic[$hashCodeArgs] is null.');
      return;
    }
    final oldSubscribedCentralsArgs =
        _subscribedCentralsArgs[hashCodeArgs] ?? {};
    final newSubscribedCentralsArgs =
        centralsArgs.cast<MyCentralArgs>().toSet();
    final removedCentralsArgs =
        oldSubscribedCentralsArgs.difference(newSubscribedCentralsArgs);
    final addedCentralsArgs =
        newSubscribedCentralsArgs.difference(oldSubscribedCentralsArgs);
    for (var centralArgs in removedCentralsArgs) {
      final central = centralArgs.toCentral();
      final eventArgs = GATTCharacteristicNotifyStateChangedEventArgs(
        central,
        characteristic,
        false,
      );
      _characteristicNotifyStateChangedController.add(eventArgs);
    }
    for (var centralArgs in addedCentralsArgs) {
      final central = centralArgs.toCentral();
      final eventArgs = GATTCharacteristicNotifyStateChangedEventArgs(
        central,
        characteristic,
        true,
      );
      _characteristicNotifyStateChangedController.add(eventArgs);
    }
    _subscribedCentralsArgs[hashCodeArgs] = newSubscribedCentralsArgs;
  }

  @override
  void onDescriptorReadRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    MyGATTReadRequestArgs requestArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    logger.info(
        'onDescriptorReadRequest: $addressArgs - $hashCodeArgs, $requestArgs');
    final central = centralArgs.toCentral();
    final descriptor = _descriptors[hashCodeArgs];
    if (descriptor == null) {
      await _respondReadRequestWithProtocolError(
        requestArgs.idArgs,
        MyGATTProtocolErrorArgs.attributeNotFound,
      );
    } else {
      final eventArgs = GATTDescriptorReadRequestedEventArgs(
        central,
        descriptor,
        MyGATTReadRequest(
          idArgs: requestArgs.idArgs,
          offset: requestArgs.offsetArgs,
          lengthArgs: requestArgs.lengthArgs,
        ),
      );
      _descriptorReadRequestedController.add(eventArgs);
    }
  }

  @override
  void onDescriptorWriteRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    MyGATTWriteRequestArgs requestArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    logger.info(
        'onDescriptorWriteRequest: $addressArgs - $hashCodeArgs, $requestArgs');
    final central = centralArgs.toCentral();
    final descriptor = _descriptors[hashCodeArgs];
    if (descriptor == null) {
      if (requestArgs.typeArgs ==
          MyGATTCharacteristicWriteTypeArgs.withoutResponse) {
        return;
      }
      await _respondWriteRequestWithProtocolError(
        requestArgs.idArgs,
        MyGATTProtocolErrorArgs.attributeNotFound,
      );
    } else {
      final eventArgs = GATTDescriptorWriteRequestedEventArgs(
        central,
        descriptor,
        MyGATTWriteRequest(
          idArgs: requestArgs.idArgs,
          offset: requestArgs.offsetArgs,
          value: requestArgs.valueArgs,
          typeArgs: requestArgs.typeArgs,
        ),
      );
      _descriptorWriteRequestedController.add(eventArgs);
    }
  }

  void _addService(GATTService service) {
    for (var includedService in service.includedServices) {
      _addService(includedService);
    }
    final characteristics =
        service.characteristics.cast<MutableGATTCharacteristic>();
    for (var characteristic in characteristics) {
      final descriptors =
          characteristic.descriptors.cast<MutableGATTDescriptor>();
      for (var descriptor in descriptors) {
        _descriptors[descriptor.hashCode] = descriptor;
      }
      _characteristics[characteristic.hashCode] = characteristic;
    }
    _services[service.hashCode] = service;
  }

  void _removeService(GATTService service) {
    for (var includedService in service.includedServices) {
      _removeService(includedService);
    }
    for (var characteristic in service.characteristics) {
      for (var descriptor in characteristic.descriptors) {
        _descriptors.remove(descriptor.hashCode);
      }
      _characteristics.remove(characteristic.hashCode);
    }
    _services.remove(service.hashCode);
  }

  Future<void> _initialize() async {
    // Here we use `Future()` to make it possible to change the `logLevel` before `initialize()`.
    await Future(() async {
      try {
        logger.info('initialize');
        await _api.initialize();
        _getState();
      } catch (e) {
        logger.severe('initialize failed.', e);
      }
    });
  }

  Future<void> _getState() async {
    try {
      logger.info('getState');
      final stateArgs = await _api.getState();
      onStateChanged(stateArgs);
    } catch (e) {
      logger.severe('getState failed.', e);
    }
  }

  Future<void> _respondReadRequestWithProtocolError(
    int idArgs,
    MyGATTProtocolErrorArgs errorArgs,
  ) async {
    try {
      logger.info('respondReadRequestWithProtocolError: $idArgs - $errorArgs');
      await _api.respondReadRequestWithProtocolError(idArgs, errorArgs);
    } catch (e) {
      logger.severe('respondReadRequestWithProtocolError failed.', e);
    }
  }

  Future<void> _respondWriteRequestWithProtocolError(
    int idArgs,
    MyGATTProtocolErrorArgs errorArgs,
  ) async {
    try {
      logger.info('respondWriteRequestWithProtocolError: $idArgs - $errorArgs');
      await _api.respondWriteRequestWithProtocolError(idArgs, errorArgs);
    } catch (e) {
      logger.severe('respondWriteRequestWithProtocolError failed.', e);
    }
  }
}
