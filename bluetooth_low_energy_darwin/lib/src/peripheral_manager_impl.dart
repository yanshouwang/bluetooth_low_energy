import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_darwin/src/gatt_impl.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:hybrid_logging/hybrid_logging.dart';

import 'central_impl.dart';
import 'pigeon.dart';

final class IsReadyEventArgs extends EventArgs {}

final class PeripheralManagerImpl
    with TypeLogger, LoggerController
    implements PeripheralManager, PeripheralManagerFlutterAPI {
  static PeripheralManagerImpl? _instance;

  final PeripheralManagerHostAPI _api;
  final StreamController<BluetoothLowEnergyStateChangedEvent>
      _stateChangedController;
  final StreamController<GATTCharacteristicReadRequestedEvent>
      _characteristicReadRequestedController;
  final StreamController<GATTCharacteristicWriteRequestedEvent>
      _characteristicWriteRequestedController;
  final StreamController<GATTCharacteristicNotifyStateChangedEvent>
      _characteristicNotifyStateChangedController;
  final StreamController<IsReadyEventArgs> _isReadyController;

  final Map<int, MutableGATTCharacteristic> _characteristics;

  BluetoothLowEnergyState _state;

  PeripheralManagerImpl._()
      : _api = PeripheralManagerHostAPI(),
        _stateChangedController = StreamController.broadcast(),
        _characteristicReadRequestedController = StreamController.broadcast(),
        _characteristicWriteRequestedController = StreamController.broadcast(),
        _characteristicNotifyStateChangedController =
            StreamController.broadcast(),
        _isReadyController = StreamController.broadcast(),
        _characteristics = {},
        _state = BluetoothLowEnergyState.unknown {
    PeripheralManagerFlutterAPI.setUp(this);
    _initialize();
  }

  factory PeripheralManagerImpl() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = PeripheralManagerImpl._();
    }
    return instance;
  }

  @override
  BluetoothLowEnergyState get state => _state;
  @override
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<NameChangedEvent> get nameChanged =>
      throw UnsupportedError('nameChanged is not supported on Darwin.');
  @override
  Stream<CentralConnectionStateChangedEvent> get connectionStateChanged =>
      throw UnsupportedError(
          'connectionStateChanged is not supported on Darwin.');
  @override
  Stream<CentralMTUChangedEvent> get mtuChanged =>
      throw UnsupportedError('mtuChanged is not supported on Darwin.');
  @override
  Stream<GATTCharacteristicReadRequestedEvent>
      get characteristicReadRequested =>
          _characteristicReadRequestedController.stream;
  @override
  Stream<GATTCharacteristicWriteRequestedEvent>
      get characteristicWriteRequested =>
          _characteristicWriteRequestedController.stream;
  @override
  Stream<GATTCharacteristicNotifyStateChangedEvent>
      get characteristicNotifyStateChanged =>
          _characteristicNotifyStateChangedController.stream;
  @override
  Stream<GATTDescriptorReadRequestedEvent> get descriptorReadRequested =>
      throw UnsupportedError(
          'descriptorReadRequested is not supported on Darwin.');
  @override
  Stream<GATTDescriptorWriteRequestedEvent> get descriptorWriteRequested =>
      throw UnsupportedError(
          'descriptorWriteRequested is not supported on Darwin.');
  Stream<void> get _isReady => _isReadyController.stream;

  @override
  Future<bool> authorize() {
    throw UnsupportedError('authorize is not supported on Darwin.');
  }

  @override
  Future<void> showAppSettings() async {
    if (Platform.isIOS) {
      logger.info('showAppSettings');
      await _api.showAppSettings();
    } else {
      throw UnsupportedError(
          'showAppSettings is not supported on ${Platform.operatingSystem}.');
    }
  }

  @override
  Future<String> getName() {
    throw UnsupportedError('getName is not supported on Darwin.');
  }

  @override
  Future<void> setName(String name) {
    throw UnsupportedError('setName is not supported on Darwin.');
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
    logger.info('removeAllServices');
    await _api.removeAllServices();
    _characteristics.clear();
  }

  @override
  Future<void> startAdvertising(
    Advertisement advertisement, {
    bool? includeDeviceName,
    bool? includeTXPowerLevel,
  }) async {
    if (includeDeviceName != null || includeTXPowerLevel != null) {
      throw UnsupportedError(
          'includeDeviceName and includeTXPowerLevel is not supported on Darwin.');
    }
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
    final uuidArgs = central.uuid.toArgs();
    logger.info('getMaximumNotifyLength: $uuidArgs');
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
    final hashCodeArgs = request.hashCodeArgs;
    final valueArgs = value;
    const errorArgs = ATTErrorArgs.success;
    logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
    await _api.respond(
      hashCodeArgs,
      valueArgs,
      errorArgs,
    );
  }

  @override
  Future<void> respondReadRequestWithError(
    GATTReadRequest request, {
    required GATTError error,
  }) async {
    if (request is! GATTReadRequestImpl) {
      throw TypeError();
    }
    final hashCodeArgs = request.hashCodeArgs;
    const valueArgs = null;
    final errorArgs = error.toArgs();
    logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
    await _api.respond(
      hashCodeArgs,
      valueArgs,
      errorArgs,
    );
  }

  @override
  Future<void> respondWriteRequest(GATTWriteRequest request) async {
    if (request is! GATTWriteRequestImpl) {
      throw TypeError();
    }
    final hashCodeArgs = request.hashCodeArgs;
    const valueArgs = null;
    const errorArgs = ATTErrorArgs.success;
    logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
    await _api.respond(
      hashCodeArgs,
      valueArgs,
      errorArgs,
    );
  }

  @override
  Future<void> respondWriteRequestWithError(
    GATTWriteRequest request, {
    required GATTError error,
  }) async {
    if (request is! GATTWriteRequestImpl) {
      throw TypeError();
    }
    final hashCodeArgs = request.hashCodeArgs;
    const valueArgs = null;
    final errorArgs = error.toArgs();
    logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
    await _api.respond(
      hashCodeArgs,
      valueArgs,
      errorArgs,
    );
  }

  @override
  Future<void> notifyCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    List<Central>? centrals,
  }) async {
    final hashCodeArgs = characteristic.hashCode;
    final valueArgs = value;
    final uuidsArgs = centrals?.map((central) {
      if (central is! CentralImpl) {
        throw TypeError();
      }
      return central.uuidArgs;
    }).toList();
    while (true) {
      logger.info('updateValue: $hashCodeArgs - $valueArgs, $uuidsArgs');
      final updated = await _api.updateValue(
        hashCodeArgs,
        valueArgs,
        uuidsArgs,
      );
      if (updated) {
        break;
      }
      await _isReady.first;
    }
  }

  @override
  void onStateChanged(BluetoothLowEnergyStateArgs stateArgs) {
    logger.info('onStateChanged: $stateArgs');
    final state = stateArgs.toState();
    if (_state == state) {
      return;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEvent(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void didReceiveRead(ATTRequestArgs requestArgs) async {
    final hashCodeArgs = requestArgs.hashCodeArgs;
    final characteristicHashCodeArgs = requestArgs.characteristicHashCodeArgs;
    final centralArgs = requestArgs.centralArgs;
    final offsetArgs = requestArgs.offsetArgs;
    logger.info(
        'didReceiveRead: $hashCodeArgs - $characteristicHashCodeArgs, ${centralArgs.uuidArgs}, $offsetArgs');
    final characteristic = _characteristics[characteristicHashCodeArgs];
    if (characteristic == null) {
      await _respond(hashCodeArgs, null, ATTErrorArgs.attributeNotFound);
    } else {
      final central = CentralImpl.fromArgs(centralArgs);
      final eventArgs = GATTCharacteristicReadRequestedEvent(
        characteristic,
        central,
        GATTReadRequestImpl(
          hashCodeArgs: hashCodeArgs,
          offset: offsetArgs,
        ),
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
    final hashCodeArgs = requestArgs.hashCodeArgs;
    final characteristicHashCodeArgs = requestArgs.characteristicHashCodeArgs;
    final centralArgs = requestArgs.centralArgs;
    final offsetArgs = requestArgs.offsetArgs;
    final valueArgs = requestArgs.valueArgs;
    logger.info(
        'didReceiveWrite: $hashCodeArgs - $characteristicHashCodeArgs, ${centralArgs.uuidArgs}, $offsetArgs, $valueArgs');
    final unsupported = requestsArgs.cast<ATTRequestArgs>().any((args) =>
        args.centralArgs.uuidArgs != centralArgs.uuidArgs ||
        args.characteristicHashCodeArgs != characteristicHashCodeArgs);
    if (unsupported) {
      await _respond(hashCodeArgs, null, ATTErrorArgs.unsupportedGroupType);
    } else {
      final characteristic = _characteristics[characteristicHashCodeArgs];
      if (characteristic == null) {
        await _respond(hashCodeArgs, null, ATTErrorArgs.attributeNotFound);
      } else {
        final central = CentralImpl.fromArgs(centralArgs);
        final elements = requestsArgs.cast<ATTRequestArgs>().fold(
          <int>[],
          (previousValue, args) {
            final valueArgs = args.valueArgs;
            if (valueArgs != null) {
              previousValue.insertAll(args.offsetArgs, valueArgs);
            }
            return previousValue;
          },
        );
        final eventArgs = GATTCharacteristicWriteRequestedEvent(
          characteristic,
          central,
          GATTWriteRequestImpl(
            hashCodeArgs: hashCodeArgs,
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
    logger.info('isReady');
    final eventArgs = IsReadyEventArgs();
    _isReadyController.add(eventArgs);
  }

  @override
  void onCharacteristicNotifyStateChanged(
    int hashCodeArgs,
    CentralArgs centralArgs,
    bool stateArgs,
  ) {
    logger.info(
        'onCharacteristicNotifyStateChanged: $hashCodeArgs - ${centralArgs.uuidArgs}, $stateArgs');
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      logger.warning('The characteristic[$hashCodeArgs] is null.');
      return;
    }
    final central = CentralImpl.fromArgs(centralArgs);
    final eventArgs = GATTCharacteristicNotifyStateChangedEvent(
      characteristic,
      central,
      stateArgs,
    );
    _characteristicNotifyStateChangedController.add(eventArgs);
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

  void _addService(GATTService service) {
    for (var includedService in service.includedServices) {
      _addService(includedService);
    }
    for (var characteristic in service.characteristics) {
      if (characteristic is! MutableGATTCharacteristic) {
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

  Future<void> _respond(
    int hashCodeArgs,
    Uint8List? valueArgs,
    ATTErrorArgs errorArgs,
  ) async {
    try {
      logger.info('respond: $hashCodeArgs - $valueArgs, $errorArgs');
      await _api.respond(
        hashCodeArgs,
        valueArgs,
        errorArgs,
      );
    } catch (e) {
      logger.severe('respond failed.', e);
    }
  }
}
