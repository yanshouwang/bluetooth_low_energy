// import 'dart:async';
// import 'dart:typed_data';

// import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
// import 'package:flutter/widgets.dart' hide ConnectionState;

// import 'my_api.dart';
// import 'my_api.g.dart';
// import 'my_gatt.dart';
// import 'my_peripheral.dart';

// final class MyCentralManager extends PlatformCentralManager
//     with WidgetsBindingObserver
//     implements MyCentralManagerFlutterAPI {
//   final MyCentralManagerHostAPI _api;
//   final StreamController<BluetoothLowEnergyStateChangedEvent>
//       _stateChangedController;
//   final StreamController<NameChangedEvent> _nameChangedController;
//   final StreamController<DiscoveredEvent> _discoveredController;
//   final StreamController<PeripheralConnectionStateChangedEvent>
//       _connectionStateChangedController;
//   final StreamController<PeripheralMTUChangedEvent> _mtuChangedController;
//   final StreamController<GATTCharacteristicNotifiedEvent>
//       _characteristicNotifiedController;

//   final Map<String, int> _mtus;

//   late final MyCentralManagerArgs _args;

//   BluetoothLowEnergyState _state;

//   MyCentralManager()
//       : _api = MyCentralManagerHostAPI(),
//         _stateChangedController = StreamController.broadcast(),
//         _nameChangedController = StreamController.broadcast(),
//         _discoveredController = StreamController.broadcast(),
//         _connectionStateChangedController = StreamController.broadcast(),
//         _mtuChangedController = StreamController.broadcast(),
//         _characteristicNotifiedController = StreamController.broadcast(),
//         _mtus = {},
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
//   Stream<DiscoveredEvent> get discovered => _discoveredController.stream;
//   @override
//   Stream<PeripheralConnectionStateChangedEvent> get connectionStateChanged =>
//       _connectionStateChangedController.stream;
//   @override
//   Stream<PeripheralMTUChangedEvent> get mtuChanged =>
//       _mtuChangedController.stream;
//   @override
//   Stream<GATTCharacteristicNotifiedEvent> get characteristicNotified =>
//       _characteristicNotifiedController.stream;

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
//     MyCentralManagerFlutterAPI.setUp(this);
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
//   Future<void> startDiscovery({
//     List<UUID>? serviceUUIDs,
//   }) async {
//     final serviceUUIDsArgs =
//         serviceUUIDs?.map((uuid) => uuid.toArgs()).toList() ?? [];
//     logger.info('startDiscovery: $serviceUUIDsArgs');
//     await _api.startDiscovery(serviceUUIDsArgs);
//   }

//   @override
//   Future<void> stopDiscovery() async {
//     logger.info('stopDiscovery');
//     await _api.stopDiscovery();
//   }

//   @override
//   Future<List<Peripheral>> retrieveConnectedPeripherals() async {
//     logger.info('retrieveConnectedPeripherals');
//     final peripheralsArgs = await _api.retrieveConnectedPeripherals();
//     final peripherals = peripheralsArgs
//         .cast<MyPeripheralArgs>()
//         .map((peripheralArgs) => MyPeripheral.fromArgs(peripheralArgs))
//         .toList();
//     return peripherals;
//   }

//   @override
//   Future<void> connect(Peripheral peripheral) async {
//     if (peripheral is! MyPeripheral) {
//       throw TypeError();
//     }
//     final addressArgs = peripheral.addressArgs;
//     logger.info('connect: $addressArgs');
//     await _api.connect(addressArgs);
//   }

//   @override
//   Future<void> disconnect(Peripheral peripheral) async {
//     if (peripheral is! MyPeripheral) {
//       throw TypeError();
//     }
//     final addressArgs = peripheral.addressArgs;
//     logger.info('disconnect: $addressArgs');
//     await _api.disconnect(addressArgs);
//   }

//   @override
//   Future<int> requestMTU(
//     Peripheral peripheral, {
//     required int mtu,
//   }) async {
//     if (peripheral is! MyPeripheral) {
//       throw TypeError();
//     }
//     final addressArgs = peripheral.addressArgs;
//     final mtuArgs = mtu;
//     logger.info('requestMTU: $addressArgs - $mtuArgs');
//     final size = await _api.requestMTU(addressArgs, mtuArgs);
//     return size;
//   }

//   @override
//   Future<int> getMaximumWriteLength(
//     Peripheral peripheral, {
//     required GATTCharacteristicWriteType type,
//   }) {
//     if (peripheral is! MyPeripheral) {
//       throw TypeError();
//     }
//     final addressArgs = peripheral.addressArgs;
//     final mtu = _mtus[addressArgs] ?? 23;
//     final maximumWriteLength = (mtu - 3).clamp(20, 512);
//     return Future.value(maximumWriteLength);
//   }

//   @override
//   Future<int> readRSSI(Peripheral peripheral) async {
//     if (peripheral is! MyPeripheral) {
//       throw TypeError();
//     }
//     final addressArgs = peripheral.addressArgs;
//     logger.info('readRSSI: $addressArgs');
//     final rssi = await _api.readRSSI(addressArgs);
//     return rssi;
//   }

//   @override
//   Future<List<GATTService>> discoverGATT(Peripheral peripheral) async {
//     if (peripheral is! MyPeripheral) {
//       throw TypeError();
//     }
//     final addressArgs = peripheral.addressArgs;
//     logger.info('discoverGATT: $addressArgs');
//     final servicesArgs = await _api.discoverGATT(addressArgs);
//     final services = servicesArgs
//         .cast<MyGATTServiceArgs>()
//         .map((serviceArgs) => MyGATTService.fromArgs(
//               addressArgs: addressArgs,
//               serviceArgs: serviceArgs,
//             ))
//         .toList();
//     return services;
//   }

//   @override
//   Future<Uint8List> readCharacteristic(
//       GATTCharacteristic characteristic) async {
//     if (characteristic is! MyGATTCharacteristic) {
//       throw TypeError();
//     }
//     final addressArgs = characteristic.addressArgs;
//     final hashCodeArgs = characteristic.hashCodeArgs;
//     logger.info('readCharacteristic: $addressArgs.$hashCodeArgs');
//     final value = await _api.readCharacteristic(addressArgs, hashCodeArgs);
//     return value;
//   }

//   @override
//   Future<void> writeCharacteristic(
//     GATTCharacteristic characteristic, {
//     required Uint8List value,
//     required GATTCharacteristicWriteType type,
//   }) async {
//     if (characteristic is! MyGATTCharacteristic) {
//       throw TypeError();
//     }
//     final addressArgs = characteristic.addressArgs;
//     final hashCodeArgs = characteristic.hashCodeArgs;
//     final valueArgs = value;
//     final typeArgs = type.toArgs();
//     logger.info(
//         'writeCharacteristic: $addressArgs.$hashCodeArgs - $valueArgs, $typeArgs');
//     await _api.writeCharacteristic(
//       addressArgs,
//       hashCodeArgs,
//       valueArgs,
//       typeArgs,
//     );
//   }

//   @override
//   Future<void> setCharacteristicNotifyState(
//     GATTCharacteristic characteristic, {
//     required bool state,
//   }) async {
//     if (characteristic is! MyGATTCharacteristic) {
//       throw TypeError();
//     }
//     final addressArgs = characteristic.addressArgs;
//     final hashCodeArgs = characteristic.hashCodeArgs;
//     final enableArgs = state;
//     logger.info(
//         'setCharacteristicNotification: $addressArgs.$hashCodeArgs - $enableArgs');
//     await _api.setCharacteristicNotification(
//       addressArgs,
//       hashCodeArgs,
//       enableArgs,
//     );
//     // Seems the docs is not correct, this operation is necessary for all characteristics.
//     // https://developer.android.com/guide/topics/connectivity/bluetooth/transfer-ble-data#notification
//     final descriptor = characteristic.descriptors
//         .firstWhere((descriptor) => descriptor.uuid == cccUUID);
//     final value = state
//         ? characteristic.properties.contains(GATTCharacteristicProperty.notify)
//             ? _args.enableNotificationValue
//             : _args.enableIndicationValue
//         : _args.disableNotificationValue;
//     await writeDescriptor(
//       descriptor,
//       value: value,
//     );
//   }

//   @override
//   Future<Uint8List> readDescriptor(GATTDescriptor descriptor) async {
//     if (descriptor is! MyGATTDescriptor) {
//       throw TypeError();
//     }
//     final addressArgs = descriptor.addressArgs;
//     final hashCodeArgs = descriptor.hashCodeArgs;
//     logger.info('readDescriptor: $addressArgs.$hashCodeArgs');
//     final value = await _api.readDescriptor(addressArgs, hashCodeArgs);
//     return value;
//   }

//   @override
//   Future<void> writeDescriptor(
//     GATTDescriptor descriptor, {
//     required Uint8List value,
//   }) async {
//     if (descriptor is! MyGATTDescriptor) {
//       throw TypeError();
//     }
//     final addressArgs = descriptor.addressArgs;
//     final hashCodeArgs = descriptor.hashCodeArgs;
//     final valueArgs = value;
//     logger.info('writeDescriptor: $addressArgs.$hashCodeArgs - $valueArgs');
//     await _api.writeDescriptor(addressArgs, hashCodeArgs, valueArgs);
//   }

//   @override
//   void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs) {
//     logger.info('onStateChanged: $stateArgs');
//     final state = stateArgs.toState();
//     if (_state == state) {
//       return;
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
//   void onDiscovered(
//     MyPeripheralArgs peripheralArgs,
//     int rssiArgs,
//     MyAdvertisementArgs advertisementArgs,
//   ) {
//     final addressArgs = peripheralArgs.addressArgs;
//     logger.info('onDiscovered: $addressArgs - $rssiArgs, $advertisementArgs');
//     final peripheral = MyPeripheral.fromArgs(peripheralArgs);
//     final rssi = rssiArgs;
//     final advertisement = advertisementArgs.toAdvertisement();
//     final eventArgs = DiscoveredEvent(
//       peripheral,
//       rssi,
//       advertisement,
//     );
//     _discoveredController.add(eventArgs);
//   }

//   @override
//   void onConnectionStateChanged(
//     MyPeripheralArgs peripheralArgs,
//     MyConnectionStateArgs stateArgs,
//   ) {
//     final addressArgs = peripheralArgs.addressArgs;
//     logger.info('onConnectionStateChanged: $addressArgs - $stateArgs');
//     final peripheral = MyPeripheral.fromArgs(peripheralArgs);
//     final state = stateArgs.toState();
//     if (state == ConnectionState.disconnected) {
//       _mtus.remove(addressArgs);
//     }
//     final eventArgs = PeripheralConnectionStateChangedEvent(
//       peripheral,
//       state,
//     );
//     _connectionStateChangedController.add(eventArgs);
//   }

//   @override
//   void onMTUChanged(MyPeripheralArgs peripheralArgs, int mtuArgs) {
//     final addressArgs = peripheralArgs.addressArgs;
//     logger.info('onMTUChanged: $addressArgs - $mtuArgs');
//     final peripheral = MyPeripheral.fromArgs(peripheralArgs);
//     final mtu = mtuArgs;
//     _mtus[addressArgs] = mtu;
//     final eventArgs = PeripheralMTUChangedEvent(peripheral, mtu);
//     _mtuChangedController.add(eventArgs);
//   }

//   @override
//   void onCharacteristicNotified(
//     MyPeripheralArgs peripheralArgs,
//     MyGATTCharacteristicArgs characteristicArgs,
//     Uint8List valueArgs,
//   ) {
//     final addressArgs = peripheralArgs.addressArgs;
//     final hashCodeArgs = characteristicArgs.hashCodeArgs;
//     logger.info(
//         'onCharacteristicNotified: $addressArgs.$hashCodeArgs - $valueArgs');
//     final peripheral = MyPeripheral.fromArgs(peripheralArgs);
//     final characteristic = MyGATTCharacteristic.fromArgs(
//       addressArgs: addressArgs,
//       characteristicArgs: characteristicArgs,
//     );
//     final value = valueArgs;
//     final eventArgs = GATTCharacteristicNotifiedEvent(
//       peripheral,
//       characteristic,
//       value,
//     );
//     _characteristicNotifiedController.add(eventArgs);
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
// }
