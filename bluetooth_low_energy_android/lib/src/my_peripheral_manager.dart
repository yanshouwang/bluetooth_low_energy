// import 'dart:async';
// import 'dart:typed_data';

// import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/widgets.dart' hide ConnectionState;

// import 'my_api.dart';
// import 'my_api.g.dart';
// import 'my_central.dart';
// import 'my_gatt.dart';

// final class MyPeripheralManager extends PlatformPeripheralManager
//     with WidgetsBindingObserver
//     implements MyPeripheralManagerFlutterAPI {
//   final MyPeripheralManagerHostAPI _api;
//   final ListEquality<int> _valueEquality;
//   final StreamController<BluetoothLowEnergyStateChangedEvent>
//       _stateChangedController;
//   final StreamController<NameChangedEvent> _nameChangedController;
//   final StreamController<CentralConnectionStateChangedEvent>
//       _connnectionStateChangedController;
//   final StreamController<CentralMTUChangedEvent> _mtuChangedController;
//   final StreamController<GATTCharacteristicReadRequestedEvent>
//       _characteristicReadRequestedController;
//   final StreamController<GATTCharacteristicWriteRequestedEvent>
//       _characteristicWriteRequestedController;
//   final StreamController<GATTCharacteristicNotifyStateChangedEvent>
//       _characteristicNotifyStateChangedController;
//   final StreamController<GATTDescriptorReadRequestedEvent>
//       _descriptorReadRequestedController;
//   final StreamController<GATTDescriptorWriteRequestedEvent>
//       _descriptorWriteRequestedController;

//   final Map<int, MutableGATTCharacteristic> _characteristics;
//   final Map<int, MutableGATTDescriptor> _descriptors;
//   // CCC descriptor hashCodeArgs -> characteristic
//   final Map<int, MutableGATTCharacteristic> _cccdCharacteristics;
//   // central addressArgs -> characteristic hashCodeArgs -> CCC descriptor Value
//   final Map<String, Map<int, Uint8List>> _cccdValues;
//   final Map<String, int> _mtus;
//   final Map<String, int> _preparedHashCodeArgs;
//   final Map<String, List<int>> _preparedValue;

//   late final MyPeripheralManagerArgs _args;

//   BluetoothLowEnergyState _state;

//   MyPeripheralManager()
//       : _api = MyPeripheralManagerHostAPI(),
//         _valueEquality = const ListEquality(),
//         _stateChangedController = StreamController.broadcast(),
//         _nameChangedController = StreamController.broadcast(),
//         _connnectionStateChangedController = StreamController.broadcast(),
//         _mtuChangedController = StreamController.broadcast(),
//         _characteristicReadRequestedController = StreamController.broadcast(),
//         _characteristicWriteRequestedController = StreamController.broadcast(),
//         _characteristicNotifyStateChangedController =
//             StreamController.broadcast(),
//         _descriptorReadRequestedController = StreamController.broadcast(),
//         _descriptorWriteRequestedController = StreamController.broadcast(),
//         _characteristics = {},
//         _descriptors = {},
//         _cccdCharacteristics = {},
//         _cccdValues = {},
//         _mtus = {},
//         _preparedHashCodeArgs = {},
//         _preparedValue = {},
//         _state = BluetoothLowEnergyState.unknown;

//   UUID get cccUUID => UUID.short(0x2902);
//   @override
//   BluetoothLowEnergyState get state => _state;
//   @override
//   Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
//       _stateChangedController.stream;
//   @override
//   Stream<NameChangedEvent> get nameChanged => _nameChangedController.stream;
//   @override
//   Stream<CentralConnectionStateChangedEvent> get connectionStateChanged =>
//       _connnectionStateChangedController.stream;
//   @override
//   Stream<CentralMTUChangedEvent> get mtuChanged => _mtuChangedController.stream;
//   @override
//   Stream<GATTCharacteristicReadRequestedEvent>
//       get characteristicReadRequested =>
//           _characteristicReadRequestedController.stream;
//   @override
//   Stream<GATTCharacteristicWriteRequestedEvent>
//       get characteristicWriteRequested =>
//           _characteristicWriteRequestedController.stream;
//   @override
//   Stream<GATTCharacteristicNotifyStateChangedEvent>
//       get characteristicNotifyStateChanged =>
//           _characteristicNotifyStateChangedController.stream;
//   @override
//   Stream<GATTDescriptorReadRequestedEvent> get descriptorReadRequested =>
//       _descriptorReadRequestedController.stream;
//   @override
//   Stream<GATTDescriptorWriteRequestedEvent> get descriptorWriteRequested =>
//       _descriptorWriteRequestedController.stream;

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     logger.info('didChangeAppLifecycleState: $state');
//     if (state != AppLifecycleState.resumed) {
//       return;
//     }
//     _getState();
//   }

//   @override
//   void initialize() {
//     MyPeripheralManagerFlutterAPI.setUp(this);
//     final binding = WidgetsFlutterBinding.ensureInitialized();
//     binding.addObserver(this);
//     _initialize();
//   }

//   @override
//   Future<bool> authorize() async {
//     logger.info('authorize');
//     final authorized = await _api.authorize();
//     return authorized;
//   }

//   @override
//   Future<void> showAppSettings() async {
//     logger.info('showAppSettings');
//     await _api.showAppSettings();
//   }

//   @override
//   Future<String> getName() async {
//     logger.info('getName');
//     final name = await _api.getName();
//     return name;
//   }

//   @override
//   Future<void> setName(String name) async {
//     logger.info('setName: $name');
//     await _api.setName(name);
//     await nameChanged.first;
//   }

//   @override
//   Future<void> addService(GATTService service) async {
//     final serviceArgs = service.toArgs();
//     logger.info('addService: $serviceArgs');
//     await _api.addService(serviceArgs);
//     _addService(service);
//     _addServiceArgs(serviceArgs);
//   }

//   @override
//   Future<void> removeService(GATTService service) async {
//     final hashCodeArgs = service.hashCode;
//     logger.info('removeService: $hashCodeArgs');
//     await _api.removeService(hashCodeArgs);
//     _removeService(service);
//   }

//   @override
//   Future<void> removeAllServices() async {
//     logger.info('removeAllServices');
//     await _api.removeAllServices();
//     _characteristics.clear();
//     _descriptors.clear();
//     _cccdCharacteristics.clear();
//   }

//   @override
//   Future<void> startAdvertising(
//     Advertisement advertisement, {
//     bool? includeDeviceName,
//     bool? includeTXPowerLevel,
//   }) async {
//     final settingsArgs = MyAdvertiseSettingsArgs(
//       modeArgs: MyAdvertiseModeArgs.balanced,
//       connectableArgs: true,
//     );
//     final advertiseDataArgs = advertisement.toAdvertiseDataArgs();
//     final scanResponseArgs = MyAdvertiseDataArgs(
//       includeDeviceNameArgs: includeDeviceName,
//       includeTXPowerLevelArgs: includeTXPowerLevel,
//       serviceUUIDsArgs: [],
//       serviceDataArgs: {},
//       manufacturerSpecificDataArgs: [],
//     );
//     logger.info(
//         'startAdvertising: $settingsArgs, $advertiseDataArgs, $scanResponseArgs');
//     await _api.startAdvertising(
//       settingsArgs,
//       advertiseDataArgs,
//       scanResponseArgs,
//     );
//   }

//   @override
//   Future<void> stopAdvertising() async {
//     logger.info('stopAdvertising');
//     await _api.stopAdvertising();
//   }

//   @override
//   Future<int> getMaximumNotifyLength(Central central) {
//     if (central is! MyCentral) {
//       throw TypeError();
//     }
//     final addressArgs = central.addressArgs;
//     final mtu = _mtus[addressArgs] ?? 23;
//     final maximumNotifyLength = (mtu - 3).clamp(20, 512);
//     return Future.value(maximumNotifyLength);
//   }

//   @override
//   Future<void> respondReadRequestWithValue(
//     GATTReadRequest request, {
//     required Uint8List value,
//   }) async {
//     if (request is! MyGATTReadRequest) {
//       throw TypeError();
//     }
//     final addressArgs = request.addressArgs;
//     final idArgs = request.idArgs;
//     const statusArgs = MyGATTStatusArgs.success;
//     final offsetArgs = request.offset;
//     final valueArgs = value;
//     logger.info(
//         'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs');
//     await _api.sendResponse(
//       addressArgs,
//       idArgs,
//       statusArgs,
//       offsetArgs,
//       valueArgs,
//     );
//   }

//   @override
//   Future<void> respondReadRequestWithError(
//     GATTReadRequest request, {
//     required GATTError error,
//   }) async {
//     if (request is! MyGATTReadRequest) {
//       throw TypeError();
//     }
//     final addressArgs = request.addressArgs;
//     final idArgs = request.idArgs;
//     final statusArgs = error.toArgs();
//     final offsetArgs = request.offset;
//     const valueArgs = null;
//     logger.info(
//         'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs');
//     await _api.sendResponse(
//       addressArgs,
//       idArgs,
//       statusArgs,
//       offsetArgs,
//       valueArgs,
//     );
//   }

//   @override
//   Future<void> respondWriteRequest(GATTWriteRequest request) async {
//     if (request is! MyGATTWriteRequest) {
//       throw TypeError();
//     }
//     if (!request.responseNeededArgs) {
//       return;
//     }
//     final addressArgs = request.addressArgs;
//     final idArgs = request.idArgs;
//     const statusArgs = MyGATTStatusArgs.success;
//     final offsetArgs = request.offset;
//     const valueArgs = null;
//     logger.info(
//         'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs');
//     await _api.sendResponse(
//       addressArgs,
//       idArgs,
//       statusArgs,
//       offsetArgs,
//       valueArgs,
//     );
//   }

//   @override
//   Future<void> respondWriteRequestWithError(
//     GATTWriteRequest request, {
//     required GATTError error,
//   }) async {
//     if (request is! MyGATTWriteRequest) {
//       throw TypeError();
//     }
//     if (!request.responseNeededArgs) {
//       return;
//     }
//     final addressArgs = request.addressArgs;
//     final idArgs = request.idArgs;
//     final statusArgs = error.toArgs();
//     final offsetArgs = request.offset;
//     const valueArgs = null;
//     logger.info(
//         'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs');
//     await _api.sendResponse(
//       addressArgs,
//       idArgs,
//       statusArgs,
//       offsetArgs,
//       valueArgs,
//     );
//   }

//   @override
//   Future<void> notifyCharacteristic(
//     GATTCharacteristic characteristic, {
//     required Uint8List value,
//     required Central central,
//   }) async {
//     if (characteristic is! MutableGATTCharacteristic || central is! MyCentral) {
//       throw TypeError();
//     }
//     final addressArgs = central.addressArgs;
//     final hashCodeArgs = characteristic.hashCode;
//     final cccValue = _retrieveCCCValue(addressArgs, hashCodeArgs);
//     final notificationDisabled = _valueEquality.equals(
//       cccValue,
//       _args.disableNotificationValue,
//     );
//     if (notificationDisabled) {
//       logger.warning('Notification of this characteristic is disabled.');
//       return;
//     }
//     final confirmArgs = _valueEquality.equals(
//       cccValue,
//       _args.enableIndicationValue,
//     );
//     final valueArgs = value;
//     logger.info(
//         'notifyCharacteristicChanged: $addressArgs - $hashCodeArgs, $confirmArgs, $valueArgs');
//     await _api.notifyCharacteristicChanged(
//       addressArgs,
//       hashCodeArgs,
//       confirmArgs,
//       valueArgs,
//     );
//   }

//   @override
//   void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs) async {
//     logger.info('onStateChanged: $stateArgs');
//     final state = stateArgs.toState();
//     if (_state == state) {
//       return;
//     }
//     // Renew GATT server when bluetooth adapter state changed.
//     switch (state) {
//       case BluetoothLowEnergyState.poweredOn:
//         await _openGATTServer();
//         break;
//       case BluetoothLowEnergyState.poweredOff:
//         await _closeGATTServer();
//         break;
//       default:
//         break;
//     }
//     _state = state;
//     final eventArgs = BluetoothLowEnergyStateChangedEvent(state);
//     _stateChangedController.add(eventArgs);
//   }

//   @override
//   void onNameChanged(String? nameArgs) {
//     logger.info('onNameChanged: $nameArgs');
//     if (nameArgs == null) {
//       return;
//     }
//     final eventArgs = NameChangedEvent(nameArgs);
//     _nameChangedController.add(eventArgs);
//   }

//   @override
//   void onConnectionStateChanged(
//     MyCentralArgs centralArgs,
//     int statusArgs,
//     MyConnectionStateArgs stateArgs,
//   ) {
//     final addressArgs = centralArgs.addressArgs;
//     logger.info(
//         'onConnectionStateChanged: $addressArgs - $statusArgs, $stateArgs');
//     final central = MyCentral.fromArgs(centralArgs);
//     final state = stateArgs.toState();
//     if (state == ConnectionState.connected) {
//       _cccdValues[addressArgs] = {};
//     } else {
//       _mtus.remove(addressArgs);
//       _cccdValues.remove(addressArgs);
//       _preparedHashCodeArgs.remove(addressArgs);
//       _preparedValue.remove(addressArgs);
//     }
//     final eventArgs = CentralConnectionStateChangedEvent(central, state);
//     _connnectionStateChangedController.add(eventArgs);
//   }

//   @override
//   void onMTUChanged(MyCentralArgs centralArgs, int mtuArgs) {
//     final addressArgs = centralArgs.addressArgs;
//     logger.info('onMTUChanged: $addressArgs - $mtuArgs');
//     final central = MyCentral.fromArgs(centralArgs);
//     final mtu = mtuArgs;
//     _mtus[addressArgs] = mtu;
//     final eventArgs = CentralMTUChangedEvent(central, mtu);
//     _mtuChangedController.add(eventArgs);
//   }

//   @override
//   void onCharacteristicReadRequest(
//     MyCentralArgs centralArgs,
//     int idArgs,
//     int offsetArgs,
//     int hashCodeArgs,
//   ) async {
//     final addressArgs = centralArgs.addressArgs;
//     logger.info(
//         'onCharacteristicReadRequest: $addressArgs - $idArgs, $offsetArgs, $hashCodeArgs');
//     final central = MyCentral.fromArgs(centralArgs);
//     final characteristic = _characteristics[hashCodeArgs];
//     if (characteristic == null) {
//       await _sendResponse(
//         addressArgs,
//         idArgs,
//         MyGATTStatusArgs.failure,
//         offsetArgs,
//         null,
//       );
//     } else if (characteristic is ImmutableGATTCharacteristic) {
//       await _sendResponse(
//         addressArgs,
//         idArgs,
//         MyGATTStatusArgs.success,
//         offsetArgs,
//         characteristic.value.sublist(offsetArgs),
//       );
//     } else {
//       final eventArgs = GATTCharacteristicReadRequestedEvent(
//         central,
//         characteristic,
//         MyGATTReadRequest(
//           addressArgs: addressArgs,
//           idArgs: idArgs,
//           offset: offsetArgs,
//         ),
//       );
//       _characteristicReadRequestedController.add(eventArgs);
//     }
//   }

//   @override
//   void onCharacteristicWriteRequest(
//     MyCentralArgs centralArgs,
//     int idArgs,
//     int hashCodeArgs,
//     bool preparedWriteArgs,
//     bool responseNeededArgs,
//     int offsetArgs,
//     Uint8List valueArgs,
//   ) async {
//     final addressArgs = centralArgs.addressArgs;
//     logger.info(
//         'onCharacteristicWriteRequest: $addressArgs - $idArgs, $hashCodeArgs, $preparedWriteArgs, $responseNeededArgs, $offsetArgs, $valueArgs');
//     final central = MyCentral.fromArgs(centralArgs);
//     final characteristic = _characteristics[hashCodeArgs];
//     if (characteristic == null) {
//       if (!responseNeededArgs) {
//         return;
//       }
//       await _sendResponse(
//         addressArgs,
//         idArgs,
//         MyGATTStatusArgs.failure,
//         offsetArgs,
//         null,
//       );
//     } else if (preparedWriteArgs) {
//       final preparedHashCodeArgs = _preparedHashCodeArgs[addressArgs];
//       if (preparedHashCodeArgs != null &&
//           preparedHashCodeArgs != hashCodeArgs) {
//         if (!responseNeededArgs) {
//           return;
//         }
//         await _sendResponse(
//           addressArgs,
//           idArgs,
//           MyGATTStatusArgs.connectionCongested,
//           offsetArgs,
//           null,
//         );
//       } else {
//         if (preparedHashCodeArgs == null) {
//           _preparedHashCodeArgs[addressArgs] = hashCodeArgs;
//           // Change the immutable Uint8List to mutable.
//           _preparedValue[addressArgs] = [...valueArgs];
//         } else {
//           final preparedValue = _preparedValue[addressArgs];
//           // Here the prepared value must not be null.
//           if (preparedValue == null) {
//             throw ArgumentError.notNull();
//           }
//           preparedValue.insertAll(offsetArgs, valueArgs);
//         }
//         if (!responseNeededArgs) {
//           return;
//         }
//         await _sendResponse(
//           addressArgs,
//           idArgs,
//           MyGATTStatusArgs.success,
//           offsetArgs,
//           null,
//         );
//       }
//     } else if (characteristic is ImmutableGATTCharacteristic) {
//       if (!responseNeededArgs) {
//         return;
//       }
//       await _sendResponse(
//         addressArgs,
//         idArgs,
//         MyGATTStatusArgs.writeNotPermitted,
//         offsetArgs,
//         null,
//       );
//     } else {
//       final eventArgs = GATTCharacteristicWriteRequestedEvent(
//         central,
//         characteristic,
//         MyGATTWriteRequest(
//           addressArgs: addressArgs,
//           idArgs: idArgs,
//           responseNeededArgs: responseNeededArgs,
//           offset: offsetArgs,
//           value: valueArgs,
//         ),
//       );
//       _characteristicWriteRequestedController.add(eventArgs);
//     }
//   }

//   @override
//   void onDescriptorReadRequest(
//     MyCentralArgs centralArgs,
//     int idArgs,
//     int offsetArgs,
//     int hashCodeArgs,
//   ) async {
//     final addressArgs = centralArgs.addressArgs;
//     logger.info(
//         'onDescriptorReadRequest: $addressArgs - $idArgs, $offsetArgs, $hashCodeArgs');
//     final central = MyCentral.fromArgs(centralArgs);
//     final characteristic = _cccdCharacteristics[hashCodeArgs];
//     if (characteristic == null) {
//       final descriptor = _descriptors[hashCodeArgs];
//       if (descriptor == null) {
//         await _sendResponse(
//           addressArgs,
//           idArgs,
//           MyGATTStatusArgs.failure,
//           offsetArgs,
//           null,
//         );
//       } else if (descriptor is ImmutableGATTDescriptor) {
//         await _sendResponse(
//           addressArgs,
//           idArgs,
//           MyGATTStatusArgs.success,
//           offsetArgs,
//           descriptor.value.sublist(offsetArgs),
//         );
//       } else {
//         final eventArgs = GATTDescriptorReadRequestedEvent(
//           central,
//           descriptor,
//           MyGATTReadRequest(
//             addressArgs: addressArgs,
//             idArgs: idArgs,
//             offset: offsetArgs,
//           ),
//         );
//         _descriptorReadRequestedController.add(eventArgs);
//       }
//     } else {
//       final hashCodeArgs = characteristic.hashCode;
//       final cccValue = _retrieveCCCValue(addressArgs, hashCodeArgs);
//       final valueArgs = cccValue.sublist(offsetArgs);
//       await _sendResponse(
//         addressArgs,
//         idArgs,
//         MyGATTStatusArgs.success,
//         offsetArgs,
//         valueArgs,
//       );
//     }
//   }

//   @override
//   void onDescriptorWriteRequest(
//     MyCentralArgs centralArgs,
//     int idArgs,
//     int hashCodeArgs,
//     bool preparedWriteArgs,
//     bool responseNeededArgs,
//     int offsetArgs,
//     Uint8List valueArgs,
//   ) async {
//     final addressArgs = centralArgs.addressArgs;
//     logger.info(
//         'onDescriptorWriteRequest: $addressArgs - $idArgs, $hashCodeArgs, $preparedWriteArgs, $responseNeededArgs, $offsetArgs, $valueArgs');
//     final central = MyCentral.fromArgs(centralArgs);
//     if (preparedWriteArgs) {
//       final preparedHashCodeArgs = _preparedHashCodeArgs[addressArgs];
//       if (preparedHashCodeArgs != null &&
//           preparedHashCodeArgs != hashCodeArgs) {
//         if (!responseNeededArgs) {
//           return;
//         }
//         await _sendResponse(
//           addressArgs,
//           idArgs,
//           MyGATTStatusArgs.connectionCongested,
//           offsetArgs,
//           null,
//         );
//       } else {
//         if (preparedHashCodeArgs == null) {
//           _preparedHashCodeArgs[addressArgs] = hashCodeArgs;
//           // Change the immutable Uint8List to mutable.
//           _preparedValue[addressArgs] = [...valueArgs];
//         } else {
//           final preparedValue = _preparedValue[addressArgs];
//           // Here the prepared value must not be null.
//           if (preparedValue == null) {
//             throw ArgumentError.notNull();
//           }
//           preparedValue.insertAll(offsetArgs, valueArgs);
//         }
//         if (!responseNeededArgs) {
//           return;
//         }
//         await _sendResponse(
//           addressArgs,
//           idArgs,
//           MyGATTStatusArgs.success,
//           offsetArgs,
//           null,
//         );
//       }
//     } else {
//       final characteristic = _cccdCharacteristics[hashCodeArgs];
//       if (characteristic == null) {
//         final descriptor = _descriptors[hashCodeArgs];
//         if (descriptor == null) {
//           if (!responseNeededArgs) {
//             return;
//           }
//           await _sendResponse(
//             addressArgs,
//             idArgs,
//             MyGATTStatusArgs.failure,
//             offsetArgs,
//             null,
//           );
//         } else if (descriptor is ImmutableGATTDescriptor) {
//           if (!responseNeededArgs) {
//             return;
//           }
//           await _sendResponse(
//             addressArgs,
//             idArgs,
//             MyGATTStatusArgs.writeNotPermitted,
//             offsetArgs,
//             null,
//           );
//         } else {
//           final eventArgs = GATTDescriptorWriteRequestedEvent(
//             central,
//             descriptor,
//             MyGATTWriteRequest(
//               addressArgs: addressArgs,
//               idArgs: idArgs,
//               responseNeededArgs: responseNeededArgs,
//               offset: offsetArgs,
//               value: valueArgs,
//             ),
//           );
//           _descriptorWriteRequestedController.add(eventArgs);
//         }
//       } else {
//         final notificationDisabled = _valueEquality.equals(
//           valueArgs,
//           _args.disableNotificationValue,
//         );
//         final notificationEnabled = _valueEquality.equals(
//           valueArgs,
//           _args.enableNotificationValue,
//         );
//         final indicationEnabled = _valueEquality.equals(
//           valueArgs,
//           _args.enableIndicationValue,
//         );
//         if (!notificationDisabled &&
//             !notificationEnabled &&
//             !indicationEnabled) {
//           if (!responseNeededArgs) {
//             return;
//           }
//           await _sendResponse(
//             addressArgs,
//             idArgs,
//             MyGATTStatusArgs.requestNotSupported,
//             offsetArgs,
//             null,
//           );
//         } else {
//           final values = _cccdValues[addressArgs];
//           // Here the CCC values must not be null.
//           if (values == null) {
//             throw ArgumentError.notNull();
//           }
//           final hashCodeArgs = characteristic.hashCode;
//           final state = notificationEnabled || indicationEnabled;
//           if (state) {
//             values[hashCodeArgs] = valueArgs;
//           } else {
//             values.remove(hashCodeArgs);
//           }
//           final eventArgs = GATTCharacteristicNotifyStateChangedEvent(
//             central,
//             characteristic,
//             state,
//           );
//           _characteristicNotifyStateChangedController.add(eventArgs);
//           if (!responseNeededArgs) {
//             return;
//           }
//           await _sendResponse(
//             addressArgs,
//             idArgs,
//             MyGATTStatusArgs.success,
//             offsetArgs,
//             null,
//           );
//         }
//       }
//     }
//   }

//   @override
//   void onExecuteWrite(
//     MyCentralArgs centralArgs,
//     int idArgs,
//     bool executeArgs,
//   ) async {
//     final addressArgs = centralArgs.addressArgs;
//     logger.info('onExecuteWrite: $addressArgs - $idArgs, $executeArgs');
//     final central = MyCentral.fromArgs(centralArgs);
//     final hashCodeArgs = _preparedHashCodeArgs.remove(addressArgs);
//     final elements = _preparedValue.remove(addressArgs);
//     if (hashCodeArgs == null || elements == null) {
//       await _sendResponse(
//         addressArgs,
//         idArgs,
//         MyGATTStatusArgs.failure,
//         0,
//         null,
//       );
//     } else if (executeArgs) {
//       final characteristic = _characteristics[hashCodeArgs];
//       final descriptor = _descriptors[hashCodeArgs];
//       final cccCharacteristic = _cccdCharacteristics[hashCodeArgs];
//       final value = Uint8List.fromList(elements);
//       if (characteristic != null &&
//           descriptor == null &&
//           cccCharacteristic == null) {
//         // Characteristic write request.
//         if (characteristic is ImmutableGATTCharacteristic) {
//           await _sendResponse(
//             addressArgs,
//             idArgs,
//             MyGATTStatusArgs.writeNotPermitted,
//             0,
//             null,
//           );
//         } else {
//           final eventArgs = GATTCharacteristicWriteRequestedEvent(
//             central,
//             characteristic,
//             MyGATTWriteRequest(
//               addressArgs: addressArgs,
//               idArgs: idArgs,
//               responseNeededArgs: true,
//               offset: 0,
//               value: value,
//             ),
//           );
//           _characteristicWriteRequestedController.add(eventArgs);
//         }
//       } else if (descriptor != null &&
//           characteristic == null &&
//           cccCharacteristic == null) {
//         // Descriptor write request.
//         if (descriptor is ImmutableGATTDescriptor) {
//           await _sendResponse(
//             addressArgs,
//             idArgs,
//             MyGATTStatusArgs.writeNotPermitted,
//             0,
//             null,
//           );
//         } else {
//           final eventArgs = GATTDescriptorWriteRequestedEvent(
//             central,
//             descriptor,
//             MyGATTWriteRequest(
//               addressArgs: addressArgs,
//               idArgs: idArgs,
//               responseNeededArgs: true,
//               offset: 0,
//               value: value,
//             ),
//           );
//           _descriptorWriteRequestedController.add(eventArgs);
//         }
//       } else if (cccCharacteristic != null &&
//           characteristic == null &&
//           descriptor == null) {
//         // CCC descriptor write request.
//         final notificationDisabled = _valueEquality.equals(
//           value,
//           _args.disableNotificationValue,
//         );
//         final notificationEnabled = _valueEquality.equals(
//           value,
//           _args.enableNotificationValue,
//         );
//         final indicationEnabled = _valueEquality.equals(
//           value,
//           _args.enableIndicationValue,
//         );
//         if (!notificationDisabled &&
//             !notificationEnabled &&
//             !indicationEnabled) {
//           await _sendResponse(
//             addressArgs,
//             idArgs,
//             MyGATTStatusArgs.requestNotSupported,
//             0,
//             null,
//           );
//         } else {
//           final values = _cccdValues[addressArgs];
//           // Here the CCC values must not be null.
//           if (values == null) {
//             throw ArgumentError.notNull();
//           }
//           final hashCodeArgs = cccCharacteristic.hashCode;
//           final state = notificationEnabled || indicationEnabled;
//           if (state) {
//             values[hashCodeArgs] = value;
//           } else {
//             values.remove(hashCodeArgs);
//           }
//           final eventArgs = GATTCharacteristicNotifyStateChangedEvent(
//             central,
//             cccCharacteristic,
//             state,
//           );
//           _characteristicNotifyStateChangedController.add(eventArgs);
//           await _sendResponse(
//             addressArgs,
//             idArgs,
//             MyGATTStatusArgs.success,
//             0,
//             null,
//           );
//         }
//       } else {
//         await _sendResponse(
//           addressArgs,
//           idArgs,
//           MyGATTStatusArgs.failure,
//           0,
//           null,
//         );
//       }
//     } else {
//       await _sendResponse(
//         addressArgs,
//         idArgs,
//         MyGATTStatusArgs.success,
//         0,
//         null,
//       );
//     }
//   }

//   void _addService(GATTService service) {
//     for (var includedService in service.includedServices) {
//       _addService(includedService);
//     }
//     final characteristics =
//         service.characteristics.cast<MutableGATTCharacteristic>();
//     for (var characteristic in characteristics) {
//       final descriptors =
//           characteristic.descriptors.cast<MutableGATTDescriptor>();
//       for (var descriptor in descriptors) {
//         // Jump CCC descriptors.
//         if (descriptor.uuid == cccUUID) {
//           continue;
//         }
//         _descriptors[descriptor.hashCode] = descriptor;
//       }
//       _characteristics[characteristic.hashCode] = characteristic;
//     }
//   }

//   void _addServiceArgs(MyMutableGATTServiceArgs serviceArgs) {
//     final includedServicesArgs =
//         serviceArgs.includedServicesArgs.cast<MyMutableGATTServiceArgs>();
//     for (var includedServiceArgs in includedServicesArgs) {
//       _addServiceArgs(includedServiceArgs);
//     }
//     final characteristicsArgs =
//         serviceArgs.characteristicsArgs.cast<MyMutableGATTCharacteristicArgs>();
//     final cccUUIDArgs = cccUUID.toArgs();
//     for (var characteristicArgs in characteristicsArgs) {
//       final characteristic = _characteristics[characteristicArgs.hashCodeArgs];
//       if (characteristic == null) {
//         throw ArgumentError.notNull();
//       }
//       final cccDescriptorArgs = characteristicArgs.descriptorsArgs
//           .cast<MyMutableGATTDescriptorArgs>()
//           .firstWhere((args) => args.uuidArgs == cccUUIDArgs);
//       _cccdCharacteristics[cccDescriptorArgs.hashCodeArgs] = characteristic;
//     }
//   }

//   void _removeService(GATTService service) {
//     for (var includedService in service.includedServices) {
//       _removeService(includedService);
//     }
//     for (var characteristic in service.characteristics) {
//       for (var descriptor in characteristic.descriptors) {
//         final hashCodeArgs = descriptor.hashCode;
//         _descriptors.remove(hashCodeArgs);
//         _cccdCharacteristics.remove(hashCodeArgs);
//       }
//       final hashCodeArgs = characteristic.hashCode;
//       _characteristics.remove(hashCodeArgs);
//     }
//   }

//   Uint8List _retrieveCCCValue(String addressArgs, int hashCodeArgs) {
//     final values = _cccdValues[addressArgs];
//     if (values == null) {
//       throw ArgumentError.notNull();
//     }
//     final value = values[hashCodeArgs];
//     return value ?? _args.disableNotificationValue;
//   }

//   Future<void> _initialize() async {
//     // Here we use `Future()` to make it possible to change the `logLevel` before `initialize()`.
//     await Future(() async {
//       try {
//         logger.info('initialize');
//         _args = await _api.initialize();
//         _getState();
//       } catch (e) {
//         logger.severe('initialize failed.', e);
//       }
//     });
//   }

//   Future<void> _getState() async {
//     try {
//       logger.info('getState');
//       final stateArgs = await _api.getState();
//       onStateChanged(stateArgs);
//     } catch (e) {
//       logger.severe('getState failed.', e);
//     }
//   }

//   Future<void> _openGATTServer() async {
//     try {
//       logger.info('openGATTServer');
//       await _api.openGATTServer();
//     } catch (e) {
//       logger.severe('openGATTServer failed.', e);
//     }
//   }

//   Future<void> _closeGATTServer() async {
//     try {
//       logger.info('closeGATTServer');
//       await _api.closeGATTServer();
//     } catch (e) {
//       logger.severe('closeGATTServer failed.', e);
//     }
//   }

//   Future<void> _sendResponse(
//     String addressArgs,
//     int idArgs,
//     MyGATTStatusArgs statusArgs,
//     int offsetArgs,
//     Uint8List? valueArgs,
//   ) async {
//     try {
//       logger.info(
//           'sendResponse: $addressArgs - $idArgs, $statusArgs, $offsetArgs, $valueArgs');
//       await _api.sendResponse(
//         addressArgs,
//         idArgs,
//         statusArgs,
//         offsetArgs,
//         valueArgs,
//       );
//     } catch (e) {
//       logger.severe('sendResponse failed.', e);
//     }
//   }
// }
