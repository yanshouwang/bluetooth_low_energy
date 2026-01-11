import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart' hide ConnectionState;
import 'package:logging/logging.dart';

import 'api.dart';
import 'api.g.dart';
import 'central_impl.dart';
import 'gatt_impl.dart';

Logger get _logger => Logger('PeripheralManager');

final class PeripheralManagerImpl
    with WidgetsBindingObserver
    implements PeripheralManager, PeripheralManagerFlutterApi {
  final PeripheralManagerHostApi _api;
  final ListEquality<int> _valueEquality;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
  _stateChangedController;
  final StreamController<CentralConnectionStateChangedEventArgs>
  _connnectionStateChangedController;
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

  final Map<int, MutableGATTCharacteristicImpl> _characteristics;
  final Map<int, MutableGATTDescriptorImpl> _descriptors;
  // CCC descriptor hashCodeArgs -> characteristic
  final Map<int, MutableGATTCharacteristicImpl> _cccdCharacteristics;
  // central addressArgs -> characteristic hashCodeArgs -> CCC descriptor Value
  final Map<String, Map<int, Uint8List>> _cccdValues;
  final Map<String, int> _mtus;
  final Map<String, int> _preparedHashCodeArgs;
  final Map<String, List<int>> _preparedValue;

  late final PeripheralManagerArgs _args;

  BluetoothLowEnergyState _state;

  PeripheralManagerImpl()
    : _api = PeripheralManagerHostApi(),
      _valueEquality = const ListEquality(),
      _stateChangedController = StreamController.broadcast(),
      _connnectionStateChangedController = StreamController.broadcast(),
      _mtuChangedController = StreamController.broadcast(),
      _characteristicReadRequestedController = StreamController.broadcast(),
      _characteristicWriteRequestedController = StreamController.broadcast(),
      _characteristicNotifyStateChangedController =
          StreamController.broadcast(),
      _descriptorReadRequestedController = StreamController.broadcast(),
      _descriptorWriteRequestedController = StreamController.broadcast(),
      _characteristics = {},
      _descriptors = {},
      _cccdCharacteristics = {},
      _cccdValues = {},
      _mtus = {},
      _preparedHashCodeArgs = {},
      _preparedValue = {},
      _state = BluetoothLowEnergyState.unknown {
    PeripheralManagerFlutterApi.setUp(this);
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.addObserver(this);
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
      _connnectionStateChangedController.stream;
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _logger.info('didChangeAppLifecycleState: $state');
    if (state != AppLifecycleState.resumed) {
      return;
    }
    _getState();
  }

  @override
  Future<bool> authorize() async {
    _logger.info('authorize');
    final authorized = await _api.authorize();
    return authorized;
  }

  @override
  Future<void> showAppSettings() async {
    _logger.info('showAppSettings');
    await _api.showAppSettings();
  }

  @override
  Future<void> addService(GATTService service) async {
    final serviceArgs = service.toArgs();
    _logger.info('addService: $serviceArgs');
    await _api.addService(serviceArgs);
    _addService(service);
    _addServiceArgs(serviceArgs);
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
    _descriptors.clear();
    _cccdCharacteristics.clear();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement) async {
    final nameArgs = advertisement.name;
    if (nameArgs != null) {
      _logger.info('setName: $nameArgs');
      final newNameArgs = await _api.setName(nameArgs);
      if (newNameArgs != nameArgs) {
        throw ArgumentError(
          'Name changed, but $newNameArgs is different from $nameArgs',
        );
      }
    }
    final settingsArgs = AdvertiseSettingsArgs(
      modeArgs: AdvertiseModeArgs.balanced,
      connectableArgs: true,
    );
    final advertiseDataArgs = advertisement.toAdvertiseDataArgs();
    final scanResponseArgs = advertisement.toScanResponseArgs();
    _logger.info(
      'startAdvertising: $settingsArgs, $advertiseDataArgs, $scanResponseArgs',
    );
    await _api.startAdvertising(
      settingsArgs,
      advertiseDataArgs,
      scanResponseArgs,
    );
  }

  @override
  Future<void> stopAdvertising() async {
    _logger.info('stopAdvertising');
    await _api.stopAdvertising();
  }

  @override
  Future<void> disconnect(Central central) async {
    if (central is! CentralImpl) {
      throw TypeError();
    }
    final addressArgs = central.address;
    _logger.info('disconnect: $addressArgs');
    await _api.disconnect(addressArgs);
  }

  @override
  Future<int> getMaximumNotifyLength(Central central) {
    if (central is! CentralImpl) {
      throw TypeError();
    }
    final addressArgs = central.address;
    final mtu = _mtus[addressArgs] ?? 23;
    final maximumNotifyLength = (mtu - 3).clamp(20, 512);
    return Future.value(maximumNotifyLength);
  }

  @override
  Future<void> respondReadRequestWithValue(
    GATTReadRequest request, {
    required Uint8List value,
  }) async {
    if (request is! GATTReadRequestImpl) {
      throw TypeError();
    }
    final addressArgs = request.address;
    final idArgs = request.id;
    const statusArgs = GATTStatusArgs.success;
    final offsetArgs = request.offset;
    final valueArgs = value;
    _logger.info(
      'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs',
    );
    await _api.sendResponse(
      addressArgs,
      idArgs,
      statusArgs,
      offsetArgs,
      valueArgs,
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
    final addressArgs = request.address;
    final idArgs = request.id;
    final statusArgs = error.toArgs();
    final offsetArgs = request.offset;
    const valueArgs = null;
    _logger.info(
      'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs',
    );
    await _api.sendResponse(
      addressArgs,
      idArgs,
      statusArgs,
      offsetArgs,
      valueArgs,
    );
  }

  @override
  Future<void> respondWriteRequest(GATTWriteRequest request) async {
    if (request is! GATTWriteRequestImpl) {
      throw TypeError();
    }
    if (!request.responseNeeded) {
      return;
    }
    final addressArgs = request.address;
    final idArgs = request.id;
    const statusArgs = GATTStatusArgs.success;
    final offsetArgs = request.offset;
    const valueArgs = null;
    _logger.info(
      'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs',
    );
    await _api.sendResponse(
      addressArgs,
      idArgs,
      statusArgs,
      offsetArgs,
      valueArgs,
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
    if (!request.responseNeeded) {
      return;
    }
    final addressArgs = request.address;
    final idArgs = request.id;
    final statusArgs = error.toArgs();
    final offsetArgs = request.offset;
    const valueArgs = null;
    _logger.info(
      'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs',
    );
    await _api.sendResponse(
      addressArgs,
      idArgs,
      statusArgs,
      offsetArgs,
      valueArgs,
    );
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
    final cccValue = _retrieveCCCValue(addressArgs, hashCodeArgs);
    final notificationDisabled = _valueEquality.equals(
      cccValue,
      _args.disableNotificationValue,
    );
    if (notificationDisabled) {
      _logger.warning('Notification of this characteristic is disabled.');
      return;
    }
    final confirmArgs = _valueEquality.equals(
      cccValue,
      _args.enableIndicationValue,
    );
    final valueArgs = value;
    _logger.info(
      'notifyCharacteristicChanged: $addressArgs - $hashCodeArgs, $confirmArgs, $valueArgs',
    );
    await _api.notifyCharacteristicChanged(
      addressArgs,
      hashCodeArgs,
      confirmArgs,
      valueArgs,
    );
  }

  @override
  void onStateChanged(BluetoothLowEnergyStateArgs stateArgs) async {
    _logger.info('onStateChanged: $stateArgs');
    final state = stateArgs.toState();
    if (_state == state) {
      return;
    }
    // Renew GATT server when bluetooth adapter state changed.
    switch (state) {
      case BluetoothLowEnergyState.poweredOn:
        await _openGATTServer();
        break;
      case BluetoothLowEnergyState.poweredOff:
        await _closeGATTServer();
        break;
      default:
        break;
    }
    _state = state;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
    _stateChangedController.add(eventArgs);
  }

  @override
  void onConnectionStateChanged(
    CentralArgs centralArgs,
    int statusArgs,
    ConnectionStateArgs stateArgs,
  ) {
    final addressArgs = centralArgs.addressArgs;
    _logger.info(
      'onConnectionStateChanged: $addressArgs - $statusArgs, $stateArgs',
    );
    final central = centralArgs.toCentral();
    final state = stateArgs.toState();
    if (state == ConnectionState.connected) {
      _cccdValues[addressArgs] = {};
    } else {
      _mtus.remove(addressArgs);
      _cccdValues.remove(addressArgs);
      _preparedHashCodeArgs.remove(addressArgs);
      _preparedValue.remove(addressArgs);
    }
    final eventArgs = CentralConnectionStateChangedEventArgs(central, state);
    _connnectionStateChangedController.add(eventArgs);
  }

  @override
  void onMTUChanged(CentralArgs centralArgs, int mtuArgs) {
    final addressArgs = centralArgs.addressArgs;
    _logger.info('onMTUChanged: $addressArgs - $mtuArgs');
    final central = centralArgs.toCentral();
    final mtu = mtuArgs;
    _mtus[addressArgs] = mtu;
    final eventArgs = CentralMTUChangedEventArgs(central, mtu);
    _mtuChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicReadRequest(
    CentralArgs centralArgs,
    int idArgs,
    int offsetArgs,
    int hashCodeArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    _logger.info(
      'onCharacteristicReadRequest: $addressArgs - $idArgs, $offsetArgs, $hashCodeArgs',
    );
    final central = centralArgs.toCentral();
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      await _sendResponse(
        addressArgs,
        idArgs,
        GATTStatusArgs.failure,
        offsetArgs,
        null,
      );
    } else if (characteristic is ImmutableGATTCharacteristicImpl) {
      await _sendResponse(
        addressArgs,
        idArgs,
        GATTStatusArgs.success,
        offsetArgs,
        characteristic.value.sublist(offsetArgs),
      );
    } else {
      final eventArgs = GATTCharacteristicReadRequestedEventArgs(
        central,
        characteristic,
        GATTReadRequestImpl(
          address: addressArgs,
          id: idArgs,
          offset: offsetArgs,
        ),
      );
      _characteristicReadRequestedController.add(eventArgs);
    }
  }

  @override
  void onCharacteristicWriteRequest(
    CentralArgs centralArgs,
    int idArgs,
    int hashCodeArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
    int offsetArgs,
    Uint8List valueArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    _logger.info(
      'onCharacteristicWriteRequest: $addressArgs - $idArgs, $hashCodeArgs, $preparedWriteArgs, $responseNeededArgs, $offsetArgs, $valueArgs',
    );
    final central = centralArgs.toCentral();
    final characteristic = _characteristics[hashCodeArgs];
    if (characteristic == null) {
      if (!responseNeededArgs) {
        return;
      }
      await _sendResponse(
        addressArgs,
        idArgs,
        GATTStatusArgs.failure,
        offsetArgs,
        null,
      );
    } else if (preparedWriteArgs) {
      final preparedHashCodeArgs = _preparedHashCodeArgs[addressArgs];
      if (preparedHashCodeArgs != null &&
          preparedHashCodeArgs != hashCodeArgs) {
        if (!responseNeededArgs) {
          return;
        }
        await _sendResponse(
          addressArgs,
          idArgs,
          GATTStatusArgs.connectionCongested,
          offsetArgs,
          null,
        );
      } else {
        if (preparedHashCodeArgs == null) {
          _preparedHashCodeArgs[addressArgs] = hashCodeArgs;
          // Change the immutable Uint8List to mutable.
          _preparedValue[addressArgs] = [...valueArgs];
        } else {
          final preparedValue = _preparedValue[addressArgs];
          // Here the prepared value must not be null.
          if (preparedValue == null) {
            throw ArgumentError.notNull();
          }
          preparedValue.insertAll(offsetArgs, valueArgs);
        }
        if (!responseNeededArgs) {
          return;
        }
        await _sendResponse(
          addressArgs,
          idArgs,
          GATTStatusArgs.success,
          offsetArgs,
          null,
        );
      }
    } else if (characteristic is ImmutableGATTCharacteristicImpl) {
      if (!responseNeededArgs) {
        return;
      }
      await _sendResponse(
        addressArgs,
        idArgs,
        GATTStatusArgs.writeNotPermitted,
        offsetArgs,
        null,
      );
    } else {
      final eventArgs = GATTCharacteristicWriteRequestedEventArgs(
        central,
        characteristic,
        GATTWriteRequestImpl(
          address: addressArgs,
          id: idArgs,
          responseNeeded: responseNeededArgs,
          offset: offsetArgs,
          value: valueArgs,
        ),
      );
      _characteristicWriteRequestedController.add(eventArgs);
    }
  }

  @override
  void onDescriptorReadRequest(
    CentralArgs centralArgs,
    int idArgs,
    int offsetArgs,
    int hashCodeArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    _logger.info(
      'onDescriptorReadRequest: $addressArgs - $idArgs, $offsetArgs, $hashCodeArgs',
    );
    final central = centralArgs.toCentral();
    final characteristic = _cccdCharacteristics[hashCodeArgs];
    if (characteristic == null) {
      final descriptor = _descriptors[hashCodeArgs];
      if (descriptor == null) {
        await _sendResponse(
          addressArgs,
          idArgs,
          GATTStatusArgs.failure,
          offsetArgs,
          null,
        );
      } else if (descriptor is ImmutableGATTDescriptorImpl) {
        await _sendResponse(
          addressArgs,
          idArgs,
          GATTStatusArgs.success,
          offsetArgs,
          descriptor.value.sublist(offsetArgs),
        );
      } else {
        final eventArgs = GATTDescriptorReadRequestedEventArgs(
          central,
          descriptor,
          GATTReadRequestImpl(
            address: addressArgs,
            id: idArgs,
            offset: offsetArgs,
          ),
        );
        _descriptorReadRequestedController.add(eventArgs);
      }
    } else {
      final hashCodeArgs = characteristic.hashCode;
      final cccValue = _retrieveCCCValue(addressArgs, hashCodeArgs);
      final valueArgs = cccValue.sublist(offsetArgs);
      await _sendResponse(
        addressArgs,
        idArgs,
        GATTStatusArgs.success,
        offsetArgs,
        valueArgs,
      );
    }
  }

  @override
  void onDescriptorWriteRequest(
    CentralArgs centralArgs,
    int idArgs,
    int hashCodeArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
    int offsetArgs,
    Uint8List valueArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    _logger.info(
      'onDescriptorWriteRequest: $addressArgs - $idArgs, $hashCodeArgs, $preparedWriteArgs, $responseNeededArgs, $offsetArgs, $valueArgs',
    );
    final central = centralArgs.toCentral();
    if (preparedWriteArgs) {
      final preparedHashCodeArgs = _preparedHashCodeArgs[addressArgs];
      if (preparedHashCodeArgs != null &&
          preparedHashCodeArgs != hashCodeArgs) {
        if (!responseNeededArgs) {
          return;
        }
        await _sendResponse(
          addressArgs,
          idArgs,
          GATTStatusArgs.connectionCongested,
          offsetArgs,
          null,
        );
      } else {
        if (preparedHashCodeArgs == null) {
          _preparedHashCodeArgs[addressArgs] = hashCodeArgs;
          // Change the immutable Uint8List to mutable.
          _preparedValue[addressArgs] = [...valueArgs];
        } else {
          final preparedValue = _preparedValue[addressArgs];
          // Here the prepared value must not be null.
          if (preparedValue == null) {
            throw ArgumentError.notNull();
          }
          preparedValue.insertAll(offsetArgs, valueArgs);
        }
        if (!responseNeededArgs) {
          return;
        }
        await _sendResponse(
          addressArgs,
          idArgs,
          GATTStatusArgs.success,
          offsetArgs,
          null,
        );
      }
    } else {
      final characteristic = _cccdCharacteristics[hashCodeArgs];
      if (characteristic == null) {
        final descriptor = _descriptors[hashCodeArgs];
        if (descriptor == null) {
          if (!responseNeededArgs) {
            return;
          }
          await _sendResponse(
            addressArgs,
            idArgs,
            GATTStatusArgs.failure,
            offsetArgs,
            null,
          );
        } else if (descriptor is ImmutableGATTDescriptorImpl) {
          if (!responseNeededArgs) {
            return;
          }
          await _sendResponse(
            addressArgs,
            idArgs,
            GATTStatusArgs.writeNotPermitted,
            offsetArgs,
            null,
          );
        } else {
          final eventArgs = GATTDescriptorWriteRequestedEventArgs(
            central,
            descriptor,
            GATTWriteRequestImpl(
              address: addressArgs,
              id: idArgs,
              responseNeeded: responseNeededArgs,
              offset: offsetArgs,
              value: valueArgs,
            ),
          );
          _descriptorWriteRequestedController.add(eventArgs);
        }
      } else {
        final notificationDisabled = _valueEquality.equals(
          valueArgs,
          _args.disableNotificationValue,
        );
        final notificationEnabled = _valueEquality.equals(
          valueArgs,
          _args.enableNotificationValue,
        );
        final indicationEnabled = _valueEquality.equals(
          valueArgs,
          _args.enableIndicationValue,
        );
        if (!notificationDisabled &&
            !notificationEnabled &&
            !indicationEnabled) {
          if (!responseNeededArgs) {
            return;
          }
          await _sendResponse(
            addressArgs,
            idArgs,
            GATTStatusArgs.requestNotSupported,
            offsetArgs,
            null,
          );
        } else {
          final values = _cccdValues[addressArgs];
          // Here the CCC values must not be null.
          if (values == null) {
            throw ArgumentError.notNull();
          }
          final hashCodeArgs = characteristic.hashCode;
          final state = notificationEnabled || indicationEnabled;
          if (state) {
            values[hashCodeArgs] = valueArgs;
          } else {
            values.remove(hashCodeArgs);
          }
          final eventArgs = GATTCharacteristicNotifyStateChangedEventArgs(
            central,
            characteristic,
            state,
          );
          _characteristicNotifyStateChangedController.add(eventArgs);
          if (!responseNeededArgs) {
            return;
          }
          await _sendResponse(
            addressArgs,
            idArgs,
            GATTStatusArgs.success,
            offsetArgs,
            null,
          );
        }
      }
    }
  }

  @override
  void onExecuteWrite(
    CentralArgs centralArgs,
    int idArgs,
    bool executeArgs,
  ) async {
    final addressArgs = centralArgs.addressArgs;
    _logger.info('onExecuteWrite: $addressArgs - $idArgs, $executeArgs');
    final central = centralArgs.toCentral();
    final hashCodeArgs = _preparedHashCodeArgs.remove(addressArgs);
    final elements = _preparedValue.remove(addressArgs);
    if (hashCodeArgs == null || elements == null) {
      await _sendResponse(addressArgs, idArgs, GATTStatusArgs.failure, 0, null);
    } else if (executeArgs) {
      final characteristic = _characteristics[hashCodeArgs];
      final descriptor = _descriptors[hashCodeArgs];
      final cccCharacteristic = _cccdCharacteristics[hashCodeArgs];
      final value = Uint8List.fromList(elements);
      if (characteristic != null &&
          descriptor == null &&
          cccCharacteristic == null) {
        // Characteristic write request.
        if (characteristic is ImmutableGATTCharacteristicImpl) {
          await _sendResponse(
            addressArgs,
            idArgs,
            GATTStatusArgs.writeNotPermitted,
            0,
            null,
          );
        } else {
          final eventArgs = GATTCharacteristicWriteRequestedEventArgs(
            central,
            characteristic,
            GATTWriteRequestImpl(
              address: addressArgs,
              id: idArgs,
              responseNeeded: true,
              offset: 0,
              value: value,
            ),
          );
          _characteristicWriteRequestedController.add(eventArgs);
        }
      } else if (descriptor != null &&
          characteristic == null &&
          cccCharacteristic == null) {
        // Descriptor write request.
        if (descriptor is ImmutableGATTDescriptorImpl) {
          await _sendResponse(
            addressArgs,
            idArgs,
            GATTStatusArgs.writeNotPermitted,
            0,
            null,
          );
        } else {
          final eventArgs = GATTDescriptorWriteRequestedEventArgs(
            central,
            descriptor,
            GATTWriteRequestImpl(
              address: addressArgs,
              id: idArgs,
              responseNeeded: true,
              offset: 0,
              value: value,
            ),
          );
          _descriptorWriteRequestedController.add(eventArgs);
        }
      } else if (cccCharacteristic != null &&
          characteristic == null &&
          descriptor == null) {
        // CCC descriptor write request.
        final notificationDisabled = _valueEquality.equals(
          value,
          _args.disableNotificationValue,
        );
        final notificationEnabled = _valueEquality.equals(
          value,
          _args.enableNotificationValue,
        );
        final indicationEnabled = _valueEquality.equals(
          value,
          _args.enableIndicationValue,
        );
        if (!notificationDisabled &&
            !notificationEnabled &&
            !indicationEnabled) {
          await _sendResponse(
            addressArgs,
            idArgs,
            GATTStatusArgs.requestNotSupported,
            0,
            null,
          );
        } else {
          final values = _cccdValues[addressArgs];
          // Here the CCC values must not be null.
          if (values == null) {
            throw ArgumentError.notNull();
          }
          final hashCodeArgs = cccCharacteristic.hashCode;
          final state = notificationEnabled || indicationEnabled;
          if (state) {
            values[hashCodeArgs] = value;
          } else {
            values.remove(hashCodeArgs);
          }
          final eventArgs = GATTCharacteristicNotifyStateChangedEventArgs(
            central,
            cccCharacteristic,
            state,
          );
          _characteristicNotifyStateChangedController.add(eventArgs);
          await _sendResponse(
            addressArgs,
            idArgs,
            GATTStatusArgs.success,
            0,
            null,
          );
        }
      } else {
        await _sendResponse(
          addressArgs,
          idArgs,
          GATTStatusArgs.failure,
          0,
          null,
        );
      }
    } else {
      await _sendResponse(addressArgs, idArgs, GATTStatusArgs.success, 0, null);
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
        // Jump CCC descriptors.
        if (descriptor.uuid == cccUUID) {
          continue;
        }
        _descriptors[descriptor.hashCode] = descriptor;
      }
      _characteristics[characteristic.hashCode] = characteristic;
    }
  }

  void _addServiceArgs(MutableGATTServiceArgs serviceArgs) {
    final includedServicesArgs =
        serviceArgs.includedServicesArgs.cast<MutableGATTServiceArgs>();
    for (var includedServiceArgs in includedServicesArgs) {
      _addServiceArgs(includedServiceArgs);
    }
    final characteristicsArgs =
        serviceArgs.characteristicsArgs.cast<MutableGATTCharacteristicArgs>();
    final cccUUIDArgs = cccUUID.toArgs();
    for (var characteristicArgs in characteristicsArgs) {
      final characteristic = _characteristics[characteristicArgs.hashCodeArgs];
      if (characteristic == null) {
        throw ArgumentError.notNull();
      }
      final cccDescriptorArgs = characteristicArgs.descriptorsArgs
          .cast<MutableGATTDescriptorArgs>()
          .firstWhere((args) => args.uuidArgs == cccUUIDArgs);
      _cccdCharacteristics[cccDescriptorArgs.hashCodeArgs] = characteristic;
    }
  }

  void _removeService(GATTService service) {
    for (var includedService in service.includedServices) {
      _removeService(includedService);
    }
    for (var characteristic in service.characteristics) {
      for (var descriptor in characteristic.descriptors) {
        final hashCodeArgs = descriptor.hashCode;
        _descriptors.remove(hashCodeArgs);
        _cccdCharacteristics.remove(hashCodeArgs);
      }
      final hashCodeArgs = characteristic.hashCode;
      _characteristics.remove(hashCodeArgs);
    }
  }

  Uint8List _retrieveCCCValue(String addressArgs, int hashCodeArgs) {
    final values = _cccdValues[addressArgs];
    if (values == null) {
      throw ArgumentError.notNull();
    }
    final value = values[hashCodeArgs];
    return value ?? _args.disableNotificationValue;
  }

  Future<void> _initialize() async {
    // Here we use `Future()` to make it possible to change the `logLevel` before `initialize()`.
    await Future(() async {
      try {
        _logger.info('initialize');
        _args = await _api.initialize();
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

  Future<void> _openGATTServer() async {
    try {
      _logger.info('openGATTServer');
      await _api.openGATTServer();
    } catch (e) {
      _logger.severe('openGATTServer failed.', e);
    }
  }

  Future<void> _closeGATTServer() async {
    try {
      _logger.info('closeGATTServer');
      await _api.closeGATTServer();
    } catch (e) {
      _logger.severe('closeGATTServer failed.', e);
    }
  }

  Future<void> _sendResponse(
    String addressArgs,
    int idArgs,
    GATTStatusArgs statusArgs,
    int offsetArgs,
    Uint8List? valueArgs,
  ) async {
    try {
      _logger.info(
        'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs',
      );
      await _api.sendResponse(
        addressArgs,
        idArgs,
        statusArgs,
        offsetArgs,
        valueArgs,
      );
    } catch (e) {
      _logger.severe('sendResponse failed.', e);
    }
  }
}

final class PeripheralManagerChannelImpl extends PeripheralManagerChannel {
  @override
  PeripheralManager create() => PeripheralManagerImpl();
}
