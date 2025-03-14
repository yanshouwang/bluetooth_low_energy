import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:hybrid_logging/hybrid_logging.dart';

import 'api.g.dart' as api;

api.BluetoothLowEnergyAndroidPlugin get _instance =>
    api.BluetoothLowEnergyAndroidPlugin.instance;
api.Context get _context => _instance.context;
Future<api.Activity> get _activity =>
    _instance.getActivity().then((e) => ArgumentError.checkNotNull(e));

base mixin BluetoothLowEnergyManagerImpl on BluetoothLowEnergyManager {
  Future<api.PackageManager> get _packageManager =>
      _context.getPackageManager();
  Future<api.BluetoothManager> get _bluetoothManager =>
      api.ContextCompat.getBluetoothManager(_context)
          .then((e) => ArgumentError.checkNotNull(e));
  Future<api.BluetoothAdapter> get _bluetoothAdapter =>
      _bluetoothManager.then((e) => e.getAdapter());
  api.Permission get _permission;
  int get _requestCode => _permission.index;

  @override
  // TODO: implement stateChanged
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
      throw UnimplementedError();

  @override
  // TODO: implement nameChanged
  Stream<NameChangedEvent> get nameChanged => throw UnimplementedError();

  @override
  Future<BluetoothLowEnergyState> getState() async {
    final packageManager = await _packageManager;
    final hasBluetoothLowEnergy =
        await packageManager.hasSystemFeature(api.Feature.bluetoothLowEnergy);
    if (hasBluetoothLowEnergy) {
      final isGranted =
          await api.ContextCompat.checkSelfPermission(_context, _permission);
      if (isGranted) {
        final bluetoothAdapter = await _bluetoothAdapter;
        final state = await bluetoothAdapter.getState();
        return state.obj;
      } else {
        return BluetoothLowEnergyState.unauthorized;
      }
    } else {
      return BluetoothLowEnergyState.unsupported;
    }
  }

  @override
  Future<String> getName() async {
    final bluetoothAdapter = await _bluetoothAdapter;
    final name = await bluetoothAdapter.getName();
    return name;
  }

  @override
  Future<void> setName(String name) async {
    final bluetoothAdapter = await _bluetoothAdapter;
    await bluetoothAdapter.setName(name);
    await nameChanged.first;
  }

  @override
  Future<void> turnOn() async {
    final bluetoothAdapter = await _bluetoothAdapter;
    final enabling = await bluetoothAdapter.enable();
  }

  @override
  Future<void> turnOff() async {
    final bluetoothAdapter = await _bluetoothAdapter;
    final disabling = await bluetoothAdapter.disable();
  }

  Future<bool> _requestPermissions() async {
    final activity = await _activity;
    final completer = Completer<bool>();
    final listener = api.RequestPermissionsResultListener(
      onRequestPermissionsResult: (_, requestCode, result) {
        if (requestCode != _requestCode) {
          return;
        }
        completer.complete(result);
      },
    );
    await _instance.addRequestPermissionsResultListener(listener);
    try {
      await api.ActivityCompat.requestPermissions(
          activity, _permission, _requestCode);
      final isGranted = await completer.future;
      return isGranted;
    } finally {
      await _instance.removeRequestPermissionsResultListener(listener);
    }
  }
}

final class CentralManagerImpl extends CentralManager
    with BluetoothLowEnergyManagerImpl, TypeLogger, LoggerController {
  @override
  final api.Permission _permission;

  CentralManagerImpl()
      : _permission = api.Permission.central,
        super.impl();

  @override
  // TODO: implement characteristicNotified
  Stream<GATTCharacteristicNotifiedEvent> get characteristicNotified =>
      throw UnimplementedError();

  @override
  Future<void> connect(Peripheral peripheral) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  // TODO: implement connectionStateChanged
  Stream<PeripheralConnectionStateChangedEvent> get connectionStateChanged =>
      throw UnimplementedError();

  @override
  Future<void> disconnect(Peripheral peripheral) {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<List<GATTService>> discoverServices(Peripheral peripheral) {
    // TODO: implement discoverServices
    throw UnimplementedError();
  }

  @override
  // TODO: implement discovered
  Stream<DiscoveredEvent> get discovered => throw UnimplementedError();

  @override
  Future<int> getMaximumWriteLength(Peripheral peripheral,
      {required GATTCharacteristicWriteType type}) {
    // TODO: implement getMaximumWriteLength
    throw UnimplementedError();
  }

  @override
  // TODO: implement mtuChanged
  Stream<PeripheralMTUChangedEvent> get mtuChanged =>
      throw UnimplementedError();

  @override
  Future<Uint8List> readCharacteristic(GATTCharacteristic characteristic) {
    // TODO: implement readCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readDescriptor(GATTDescriptor descriptor) {
    // TODO: implement readDescriptor
    throw UnimplementedError();
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) {
    // TODO: implement readRSSI
    throw UnimplementedError();
  }

  @override
  Future<void> requestConnectionPriority(Peripheral peripheral,
      {required ConnectionPriority priority}) {
    // TODO: implement requestConnectionPriority
    throw UnimplementedError();
  }

  @override
  Future<int> requestMTU(Peripheral peripheral, {required int mtu}) {
    // TODO: implement requestMTU
    throw UnimplementedError();
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() {
    // TODO: implement retrieveConnectedPeripherals
    throw UnimplementedError();
  }

  @override
  Future<void> setCharacteristicNotifyState(GATTCharacteristic characteristic,
      {required bool state}) {
    // TODO: implement setCharacteristicNotifyState
    throw UnimplementedError();
  }

  @override
  Future<void> startDiscovery({List<UUID>? serviceUUIDs}) {
    // TODO: implement startDiscovery
    throw UnimplementedError();
  }

  @override
  Future<void> stopDiscovery() {
    // TODO: implement stopDiscovery
    throw UnimplementedError();
  }

  @override
  Future<void> writeCharacteristic(GATTCharacteristic characteristic,
      {required Uint8List value, required GATTCharacteristicWriteType type}) {
    // TODO: implement writeCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> writeDescriptor(GATTDescriptor descriptor,
      {required Uint8List value}) {
    // TODO: implement writeDescriptor
    throw UnimplementedError();
  }
}

final class PeripheralManagerImpl extends PeripheralManager
    with BluetoothLowEnergyManagerImpl, TypeLogger, LoggerController {
  @override
  final api.Permission _permission;

  PeripheralManagerImpl()
      : _permission = api.Permission.peripheral,
        super.impl();

  @override
  Future<void> addService(GATTService service) {
    // TODO: implement addService
    throw UnimplementedError();
  }

  @override
  // TODO: implement characteristicNotifyStateChanged
  Stream<GATTCharacteristicNotifyStateChangedEvent>
      get characteristicNotifyStateChanged => throw UnimplementedError();

  @override
  // TODO: implement characteristicReadRequested
  Stream<GATTCharacteristicReadRequestedEvent>
      get characteristicReadRequested => throw UnimplementedError();

  @override
  // TODO: implement characteristicWriteRequested
  Stream<GATTCharacteristicWriteRequestedEvent>
      get characteristicWriteRequested => throw UnimplementedError();

  @override
  // TODO: implement connectionStateChanged
  Stream<CentralConnectionStateChangedEvent> get connectionStateChanged =>
      throw UnimplementedError();

  @override
  // TODO: implement descriptorReadRequested
  Stream<GATTDescriptorReadRequestedEvent> get descriptorReadRequested =>
      throw UnimplementedError();

  @override
  // TODO: implement descriptorWriteRequested
  Stream<GATTDescriptorWriteRequestedEvent> get descriptorWriteRequested =>
      throw UnimplementedError();

  @override
  Future<int> getMaximumNotifyLength(Central central) {
    // TODO: implement getMaximumNotifyLength
    throw UnimplementedError();
  }

  @override
  // TODO: implement mtuChanged
  Stream<CentralMTUChangedEvent> get mtuChanged => throw UnimplementedError();

  @override
  Future<void> notifyCharacteristic(GATTCharacteristic characteristic,
      {required Uint8List value, List<Central>? centrals}) {
    // TODO: implement notifyCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> removeAllServices() {
    // TODO: implement removeAllServices
    throw UnimplementedError();
  }

  @override
  Future<void> removeService(GATTService service) {
    // TODO: implement removeService
    throw UnimplementedError();
  }

  @override
  Future<void> respondReadRequestWithError(GATTReadRequest request,
      {required GATTError error}) {
    // TODO: implement respondReadRequestWithError
    throw UnimplementedError();
  }

  @override
  Future<void> respondReadRequestWithValue(GATTReadRequest request,
      {required Uint8List value}) {
    // TODO: implement respondReadRequestWithValue
    throw UnimplementedError();
  }

  @override
  Future<void> respondWriteRequest(GATTWriteRequest request) {
    // TODO: implement respondWriteRequest
    throw UnimplementedError();
  }

  @override
  Future<void> respondWriteRequestWithError(GATTWriteRequest request,
      {required GATTError error}) {
    // TODO: implement respondWriteRequestWithError
    throw UnimplementedError();
  }

  @override
  Future<void> startAdvertising(Advertisement advertisement,
      {bool? includeDeviceName, bool? includeTXPowerLevel}) {
    // TODO: implement startAdvertising
    throw UnimplementedError();
  }

  @override
  Future<void> stopAdvertising() {
    // TODO: implement stopAdvertising
    throw UnimplementedError();
  }
}

extension on api.BluetoothAdapterState {
  BluetoothLowEnergyState get obj {
    switch (this) {
      case api.BluetoothAdapterState.off:
        return BluetoothLowEnergyState.off;
      case api.BluetoothAdapterState.turningOn:
        return BluetoothLowEnergyState.turningOn;
      case api.BluetoothAdapterState.on:
        return BluetoothLowEnergyState.on;
      case api.BluetoothAdapterState.turningOff:
        return BluetoothLowEnergyState.turningOff;
    }
  }
}
