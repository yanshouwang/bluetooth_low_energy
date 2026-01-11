import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:logging/logging.dart';

import 'api.dart';
import 'api.g.dart';
import 'central_impl.dart';
import 'gatt_impl.dart';

Logger get _logger => Logger('PeripheralManager');

final class PeripheralManagerImpl
    implements PeripheralManager, PeripheralManagerFlutterApi {
  final PeripheralManagerHostApi _api;
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
  final Map<int, MutableGATTCharacteristicImpl> _characteristics;
  final Map<int, MutableGATTDescriptorImpl> _descriptors;
  final Map<int, Set<CentralArgs>> _subscribedCentralsArgs;

  BluetoothLowEnergyState _state;

  PeripheralManagerImpl()
    : _api = PeripheralManagerHostApi(),
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
      _state = BluetoothLowEnergyState.unknown {
    PeripheralManagerFlutterApi.setUp(this);
    _initialize();
  }

  UUID get cccUUID => UUID.short(0x2902);
  @override
  BluetoothLowEnergyState get state => _state;
  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<CentralConnectionStateChangedEventArgs> get connectionStateChanged =>
      throw UnsupportedError(
        'connectionStateChanged is not supported on Windows.',
      );
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
    _logger.info('addService: $serviceArgs');
    await _api.addService(serviceArgs);
    _addService(service);
  }

  @override
  Future<void> removeService(GATTService service) async {
    final hashCodeArgs = service.hashCode;
    _logger.info('removeService: $hashCodeArgs');
    await _api.removeService(hashCodeArgs);
    _removeService(service);
  }

  @override
  Future<void> removeAllServices() async {
    final services = _services.values;
    for (var service in services) {
      final hashCodeArgs = service.hashCode;
      _logger.info('removeService: $hashCodeArgs');
      await _api.removeService(hashCodeArgs);
    }
    _services.clear();
    _characteristics.clear();
    _descriptors.clear();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement) async {
    final advertisementArgs = advertisement.toArgs();
    _logger.info('startAdvertising: $advertisementArgs');
    await _api.startAdvertising(advertisementArgs);
  }

  @override
  Future<void> stopAdvertising() async {
    _logger.info('stopAdvertising');
    await _api.stopAdvertising();
  }

  @override
  Future<void> disconnect(Central central) {
    // TODO: Check is this supported on Windows.
    throw UnsupportedError('disconnect is not supported on Windows.');
  }

  @override
  Future<int> getMaximumNotifyLength(Central central) async {
    if (central is! CentralImpl) {
      throw TypeError();
    }
    final addressArgs = central.address;
    final maximumNotifyLength = await _api.getMaxNotificationSize(addressArgs);
    return maximumNotifyLength;
  }

  @override
  Future<void> respondReadRequestWithValue(
    GATTReadRequest request, {
    required Uint8List value,
  }) async {
    if (request is! GATTReadRequestImpl) {
      throw TypeError();
    }
    final idArgs = request.id;
    final valueArgs = value;
    _logger.info('respondReadRequestWithValue: $idArgs - $valueArgs');
    await _api.respondReadRequestWithValue(idArgs, valueArgs);
  }

  @override
  Future<void> respondReadRequestWithError(
    GATTReadRequest request, {
    required GATTError error,
  }) async {
    if (request is! GATTReadRequestImpl) {
      throw TypeError();
    }
    final idArgs = request.id;
    final errorArgs = error.toArgs();
    _logger.info('respondReadRequestWithProtocolError: $idArgs - $errorArgs');
    await _api.respondReadRequestWithProtocolError(idArgs, errorArgs);
  }

  @override
  Future<void> respondWriteRequest(GATTWriteRequest request) async {
    if (request is! GATTWriteRequestImpl) {
      throw TypeError();
    }
    if (request.type == GATTCharacteristicWriteType.withoutResponse) {
      return;
    }
    final idArgs = request.id;
    _logger.info('respondWriteRequest: $idArgs');
    await _api.respondWriteRequest(idArgs);
  }

  @override
  Future<void> respondWriteRequestWithError(
    GATTWriteRequest request, {
    required GATTError error,
  }) async {
    if (request is! GATTWriteRequestImpl) {
      throw TypeError();
    }
    if (request.type == GATTCharacteristicWriteType.withoutResponse) {
      return;
    }
    final idArgs = request.id;
    final errorArgs = error.toArgs();
    _logger.info('respondWriteRequestWithProtocolError: $idArgs - $errorArgs');
    await _api.respondWriteRequestWithProtocolError(idArgs, errorArgs);
  }

  @override
  Future<void> notifyCharacteristic(
    Central central,
    GATTCharacteristic characteristic, {
    required Uint8List value,
  }) async {
    if (central is! CentralImpl ||
        characteristic is! MutableGATTCharacteristicImpl) {
      throw TypeError();
    }
    final addressArgs = central.address;
    final hashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    _logger.info('notifyValue: $addressArgs - $hashCodeArgs, $valueArgs');
    await _api.notifyValue(addressArgs, hashCodeArgs, valueArgs);
  }

  @override
  void onStateChanged(BluetoothLowEnergyStateArgs stateArgs) async {
    _logger.info('onStateChanged: $stateArgs');
    final state = stateArgs.toState();
    if (_state == state) {
      return;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onMTUChanged(CentralArgs centralArgs, int mtuArgs) {
    final addressArgs = centralArgs.addressArgs;
    _logger.info('onMTUChanged: $addressArgs - $mtuArgs');
    final central = centralArgs.toCentral();
    final mtu = mtuArgs;
    final eventArgs = CentralMTUChangedEventArgs(central, mtu);
    _mtuChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicReadRequest(
    CentralArgs centralArgs,
    int hashCodeArgs,
    GATTReadRequestArgs requestArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    _logger.info(
      'onCharacteristicReadRequest: $addressArgs - $hashCodeArgs, $requestArgs',
    );
    final central = centralArgs.toCentral();
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      await _respondReadRequestWithProtocolError(
        requestArgs.idArgs,
        GATTProtocolErrorArgs.attributeNotFound,
      );
    } else {
      final eventArgs = GATTCharacteristicReadRequestedEventArgs(
        central,
        characteristic,
        GATTReadRequestImpl(
          id: requestArgs.idArgs,
          offset: requestArgs.offsetArgs,
          length: requestArgs.lengthArgs,
        ),
      );
      _characteristicReadRequestedController.add(eventArgs);
    }
  }

  @override
  void onCharacteristicWriteRequest(
    CentralArgs centralArgs,
    int hashCodeArgs,
    GATTWriteRequestArgs requestArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    _logger.info(
      'onCharacteristicWriteRequest: $addressArgs - $hashCodeArgs, $requestArgs',
    );
    final central = centralArgs.toCentral();
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      if (requestArgs.typeArgs ==
          GATTCharacteristicWriteTypeArgs.withoutResponse) {
        return;
      }
      await _respondWriteRequestWithProtocolError(
        requestArgs.idArgs,
        GATTProtocolErrorArgs.attributeNotFound,
      );
    } else {
      final eventArgs = GATTCharacteristicWriteRequestedEventArgs(
        central,
        characteristic,
        GATTWriteRequestImpl(
          id: requestArgs.idArgs,
          offset: requestArgs.offsetArgs,
          value: requestArgs.valueArgs,
          type: requestArgs.typeArgs.toType(),
        ),
      );
      _characteristicWriteRequestedController.add(eventArgs);
    }
  }

  @override
  void onCharacteristicSubscribedClientsChanged(
    int hashCodeArgs,
    List<CentralArgs?> centralsArgs,
  ) {
    _logger.info(
      'onCharacteristicSubscribedClientsChanged: $hashCodeArgs - $centralsArgs',
    );
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      _logger.warning('The characteristic[$hashCodeArgs] is null.');
      return;
    }
    final oldSubscribedCentralsArgs =
        _subscribedCentralsArgs[hashCodeArgs] ?? {};
    final newSubscribedCentralsArgs = centralsArgs.cast<CentralArgs>().toSet();
    final removedCentralsArgs = oldSubscribedCentralsArgs.difference(
      newSubscribedCentralsArgs,
    );
    final addedCentralsArgs = newSubscribedCentralsArgs.difference(
      oldSubscribedCentralsArgs,
    );
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
    CentralArgs centralArgs,
    int hashCodeArgs,
    GATTReadRequestArgs requestArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    _logger.info(
      'onDescriptorReadRequest: $addressArgs - $hashCodeArgs, $requestArgs',
    );
    final central = centralArgs.toCentral();
    final descriptor = _descriptors[hashCodeArgs];
    if (descriptor == null) {
      await _respondReadRequestWithProtocolError(
        requestArgs.idArgs,
        GATTProtocolErrorArgs.attributeNotFound,
      );
    } else {
      final eventArgs = GATTDescriptorReadRequestedEventArgs(
        central,
        descriptor,
        GATTReadRequestImpl(
          id: requestArgs.idArgs,
          offset: requestArgs.offsetArgs,
          length: requestArgs.lengthArgs,
        ),
      );
      _descriptorReadRequestedController.add(eventArgs);
    }
  }

  @override
  void onDescriptorWriteRequest(
    CentralArgs centralArgs,
    int hashCodeArgs,
    GATTWriteRequestArgs requestArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    _logger.info(
      'onDescriptorWriteRequest: $addressArgs - $hashCodeArgs, $requestArgs',
    );
    final central = centralArgs.toCentral();
    final descriptor = _descriptors[hashCodeArgs];
    if (descriptor == null) {
      if (requestArgs.typeArgs ==
          GATTCharacteristicWriteTypeArgs.withoutResponse) {
        return;
      }
      await _respondWriteRequestWithProtocolError(
        requestArgs.idArgs,
        GATTProtocolErrorArgs.attributeNotFound,
      );
    } else {
      final eventArgs = GATTDescriptorWriteRequestedEventArgs(
        central,
        descriptor,
        GATTWriteRequestImpl(
          id: requestArgs.idArgs,
          offset: requestArgs.offsetArgs,
          value: requestArgs.valueArgs,
          type: requestArgs.typeArgs.toType(),
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
        service.characteristics.cast<MutableGATTCharacteristicImpl>();
    for (var characteristic in characteristics) {
      final descriptors =
          characteristic.descriptors.cast<MutableGATTDescriptorImpl>();
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
        _logger.info('initialize');
        await _api.initialize();
        _getState();
      } catch (e) {
        _logger.severe('initialize failed.', e);
      }
    });
  }

  Future<void> _getState() async {
    try {
      _logger.info('getState');
      final stateArgs = await _api.getState();
      onStateChanged(stateArgs);
    } catch (e) {
      _logger.severe('getState failed.', e);
    }
  }

  Future<void> _respondReadRequestWithProtocolError(
    int idArgs,
    GATTProtocolErrorArgs errorArgs,
  ) async {
    try {
      _logger.info('respondReadRequestWithProtocolError: $idArgs - $errorArgs');
      await _api.respondReadRequestWithProtocolError(idArgs, errorArgs);
    } catch (e) {
      _logger.severe('respondReadRequestWithProtocolError failed.', e);
    }
  }

  Future<void> _respondWriteRequestWithProtocolError(
    int idArgs,
    GATTProtocolErrorArgs errorArgs,
  ) async {
    try {
      _logger.info(
        'respondWriteRequestWithProtocolError: $idArgs - $errorArgs',
      );
      await _api.respondWriteRequestWithProtocolError(idArgs, errorArgs);
    } catch (e) {
      _logger.severe('respondWriteRequestWithProtocolError failed.', e);
    }
  }
}

final class PeripheralManagerChannelImpl extends PeripheralManagerChannel {
  @override
  PeripheralManager create() => PeripheralManagerImpl();
}
