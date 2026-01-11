import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:logging/logging.dart';

import 'api.dart';
import 'api.g.dart';
import 'gatt_impl.dart';

Logger get _logger => Logger('PeripheralManager');

final class PeripheralManagerImpl
    implements PeripheralManager, PeripheralManagerFlutterApi {
  final PeripheralManagerHostApi _api;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
  _stateChangedController;
  final StreamController<GATTCharacteristicReadRequestedEventArgs>
  _characteristicReadRequestedController;
  final StreamController<GATTCharacteristicWriteRequestedEventArgs>
  _characteristicWriteRequestedController;
  final StreamController<GATTCharacteristicNotifyStateChangedEventArgs>
  _characteristicNotifyStateChangedController;
  final StreamController<EventArgs> _isReadyController;

  final Map<int, MutableGATTCharacteristicImpl> _characteristics;

  BluetoothLowEnergyState _state;

  PeripheralManagerImpl()
    : _api = PeripheralManagerHostApi(),
      _stateChangedController = StreamController.broadcast(),
      _characteristicReadRequestedController = StreamController.broadcast(),
      _characteristicWriteRequestedController = StreamController.broadcast(),
      _characteristicNotifyStateChangedController =
          StreamController.broadcast(),
      _isReadyController = StreamController.broadcast(),
      _characteristics = {},
      _state = BluetoothLowEnergyState.unknown {
    PeripheralManagerFlutterApi.setUp(this);
    _initialize();
  }

  @override
  BluetoothLowEnergyState get state => _state;
  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<CentralConnectionStateChangedEventArgs> get connectionStateChanged =>
      throw UnsupportedError(
        'connectionStateChanged is not supported on Darwin.',
      );
  @override
  Stream<CentralMTUChangedEventArgs> get mtuChanged =>
      throw UnsupportedError('mtuChanged is not supported on Darwin.');
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
      throw UnsupportedError(
        'descriptorReadRequested is not supported on Darwin.',
      );
  @override
  Stream<GATTDescriptorWriteRequestedEventArgs> get descriptorWriteRequested =>
      throw UnsupportedError(
        'descriptorWriteRequested is not supported on Darwin.',
      );
  Stream<EventArgs> get _isReady => _isReadyController.stream;

  bool isReadyDeliveredEarly = false;

  @override
  Future<bool> authorize() {
    throw UnsupportedError('authorize is not supported on Darwin.');
  }

  @override
  Future<void> showAppSettings() async {
    if (Platform.isIOS) {
      _logger.info('showAppSettings');
      await _api.showAppSettings();
    } else {
      throw UnsupportedError(
        'showAppSettings is not supported on ${Platform.operatingSystem}.',
      );
    }
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
    _logger.info('removeAllServices');
    await _api.removeAllServices();
    _characteristics.clear();
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
    throw UnsupportedError('disconnect is not supported on Darwin.');
  }

  @override
  Future<int> getMaximumNotifyLength(Central central) async {
    final uuidArgs = central.uuid.toArgs();
    _logger.info('getMaximumNotifyLength: $uuidArgs');
    final maximumNotifyLength = await _api.getMaximumNotifyLength(uuidArgs);
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
    final hashCodeArgs = request.hashCode;
    final valueArgs = value;
    const errorArgs = ATTErrorArgs.success;
    _logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
    await _api.respond(hashCodeArgs, valueArgs, errorArgs);
  }

  @override
  Future<void> respondReadRequestWithError(
    GATTReadRequest request, {
    required GATTError error,
  }) async {
    if (request is! GATTReadRequestImpl) {
      throw TypeError();
    }
    final hashCodeArgs = request.hashCode;
    const valueArgs = null;
    final errorArgs = error.toArgs();
    _logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
    await _api.respond(hashCodeArgs, valueArgs, errorArgs);
  }

  @override
  Future<void> respondWriteRequest(GATTWriteRequest request) async {
    if (request is! GATTWriteRequestImpl) {
      throw TypeError();
    }
    final hashCodeArgs = request.hashCode;
    const valueArgs = null;
    const errorArgs = ATTErrorArgs.success;
    _logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
    await _api.respond(hashCodeArgs, valueArgs, errorArgs);
  }

  @override
  Future<void> respondWriteRequestWithError(
    GATTWriteRequest request, {
    required GATTError error,
  }) async {
    if (request is! GATTWriteRequestImpl) {
      throw TypeError();
    }
    final hashCodeArgs = request.hashCode;
    const valueArgs = null;
    final errorArgs = error.toArgs();
    _logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
    await _api.respond(hashCodeArgs, valueArgs, errorArgs);
  }

  @override
  Future<void> notifyCharacteristic(
    Central central,
    GATTCharacteristic characteristic, {
    required Uint8List value,
  }) async {
    final hashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    final uuidArgs = central.uuid.toArgs();
    final uuidsArgs = [uuidArgs];
    while (true) {
      _logger.info('updateValue: $hashCodeArgs - $valueArgs, $uuidsArgs');
      final updated = await _api.updateValue(
        hashCodeArgs,
        valueArgs,
        uuidsArgs,
      );
      if (updated) {
        break;
      }
      if (isReadyDeliveredEarly) {
        isReadyDeliveredEarly = false;
      } else {
        await _isReady.first;
      }
    }
  }

  @override
  void onStateChanged(BluetoothLowEnergyStateArgs stateArgs) {
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
  void didReceiveRead(ATTRequestArgs requestArgs) async {
    final centralArgs = requestArgs.centralArgs;
    final hashCodeArgs = requestArgs.hashCodeArgs;
    final characteristicHashCodeArgs = requestArgs.characteristicHashCodeArgs;
    final offsetArgs = requestArgs.offsetArgs;
    final valueArgs = requestArgs.valueArgs;
    _logger.info(
      'didReceiveRead: ${centralArgs.uuidArgs} - $hashCodeArgs, $characteristicHashCodeArgs, $offsetArgs, $valueArgs',
    );
    final central = centralArgs.toCentral();
    final characteristic = _characteristics[characteristicHashCodeArgs];
    if (characteristic == null) {
      await _respond(hashCodeArgs, null, ATTErrorArgs.attributeNotFound);
    } else {
      final eventArgs = GATTCharacteristicReadRequestedEventArgs(
        central,
        characteristic,
        GATTReadRequestImpl(hashCode: hashCodeArgs, offset: offsetArgs),
      );
      _characteristicReadRequestedController.add(eventArgs);
    }
  }

  @override
  void didReceiveWrite(List<ATTRequestArgs?> requestsArgs) async {
    // When you respond to a write request, note that the first parameter of the respond(to:with
    // Result:) method expects a single CBATTRequest object, even though you received an array of
    // them from the peripheralManager(_:didReceiveWrite:) method. To respond properly,
    // pass in the first request of the requests array.
    // see: https://developer.apple.com/documentation/corebluetooth/cbperipheralmanagerdelegate/1393315-peripheralmanager#discussion
    final requestArgs = requestsArgs.cast<ATTRequestArgs>().first;
    final centralArgs = requestArgs.centralArgs;
    final hashCodeArgs = requestArgs.hashCodeArgs;
    final characteristicHashCodeArgs = requestArgs.characteristicHashCodeArgs;
    final offsetArgs = requestArgs.offsetArgs;
    final unsupported = requestsArgs.cast<ATTRequestArgs>().any(
      (args) =>
          args.centralArgs.uuidArgs != centralArgs.uuidArgs ||
          args.characteristicHashCodeArgs != characteristicHashCodeArgs,
    );
    if (unsupported) {
      await _respond(hashCodeArgs, null, ATTErrorArgs.unsupportedGroupType);
    } else {
      final central = centralArgs.toCentral();
      final characteristic = _characteristics[characteristicHashCodeArgs];
      if (characteristic == null) {
        await _respond(hashCodeArgs, null, ATTErrorArgs.attributeNotFound);
      } else {
        final elements = requestsArgs.cast<ATTRequestArgs>().fold(<int>[], (
          previousValue,
          args,
        ) {
          final valueArgs = args.valueArgs;
          if (valueArgs != null) {
            previousValue.insertAll(args.offsetArgs, valueArgs);
          }
          return previousValue;
        });
        final eventArgs = GATTCharacteristicWriteRequestedEventArgs(
          central,
          characteristic,
          GATTWriteRequestImpl(
            hashCode: hashCodeArgs,
            offset: offsetArgs,
            value: Uint8List.fromList(elements),
          ),
        );
        _characteristicWriteRequestedController.add(eventArgs);
      }
    }
  }

  @override
  void isReady() {
    final eventArgs = EventArgs();
    if (!_isReadyController.hasListener) {
      isReadyDeliveredEarly = true;
    } else {
      _isReadyController.add(eventArgs);
    }
  }

  @override
  void onCharacteristicNotifyStateChanged(
    CentralArgs centralArgs,
    int hashCodeArgs,
    bool stateArgs,
  ) {
    final uuidArgs = centralArgs.uuidArgs;
    _logger.info(
      'onCharacteristicNotifyStateChanged: $uuidArgs - $hashCodeArgs, $stateArgs',
    );
    final central = centralArgs.toCentral();
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      _logger.warning('The characteristic[$hashCodeArgs] is null.');
      return;
    }
    final eventArgs = GATTCharacteristicNotifyStateChangedEventArgs(
      central,
      characteristic,
      stateArgs,
    );
    _characteristicNotifyStateChangedController.add(eventArgs);
  }

  void _addService(GATTService service) {
    for (var includedService in service.includedServices) {
      _addService(includedService);
    }
    for (var characteristic in service.characteristics) {
      if (characteristic is! MutableGATTCharacteristicImpl) {
        throw TypeError();
      }
      _characteristics[characteristic.hashCode] = characteristic;
    }
  }

  void _removeService(GATTService service) {
    for (var includedService in service.includedServices) {
      _removeService(includedService);
    }
    for (var characteristic in service.characteristics) {
      final hashCodeArgs = characteristic.hashCode;
      _characteristics.remove(hashCodeArgs);
    }
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

  Future<void> _respond(
    int hashCodeArgs,
    Uint8List? valueArgs,
    ATTErrorArgs errorArgs,
  ) async {
    try {
      _logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
      await _api.respond(hashCodeArgs, valueArgs, errorArgs);
    } catch (e) {
      _logger.severe('respond failed.', e);
    }
  }
}

final class PeripheralManagerChannelImpl extends PeripheralManagerChannel {
  @override
  PeripheralManager create() => PeripheralManagerImpl();
}
