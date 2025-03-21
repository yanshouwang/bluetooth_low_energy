import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:hybrid_logging/hybrid_logging.dart';

import 'api.g.dart' as api;

api.BluetoothLowEnergyAndroidPlugin get _instance =>
    api.BluetoothLowEnergyAndroidPlugin.instance;
api.Context get _context => _instance.context;
Future<api.Activity> get _activity =>
    _instance.getActivity().then((e) => ArgumentError.checkNotNull(e));

base mixin BluetoothLowEnergyManagerImpl
    on BluetoothLowEnergyManager, WidgetsBindingObserver {
  late final BluetoothLowEnergyState _state;
  late final StreamController<BluetoothLowEnergyStateChangedEvent>
      _stateChangedController;
  late final StreamController<NameChangedEvent> _nameChangedController;
  late final api.BroadcastReceiver _stateReceiver;
  late final api.BroadcastReceiver _nameReceiver;

  Future<api.PackageManager> get _packageManager =>
      _context.getPackageManager();
  Future<api.BluetoothManager> get _bluetoothManager =>
      api.ContextCompat.getBluetoothManager(_context)
          .then((e) => ArgumentError.checkNotNull(e));
  Future<api.BluetoothAdapter> get _bluetoothAdapter =>
      _bluetoothManager.then((e) => e.getAdapter());
  List<api.Permission> get _permissions;
  int get _requestCode;

  @override
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
      _stateChangedController.stream;

  @override
  Stream<NameChangedEvent> get nameChanged => _nameChangedController.stream;

  @mustCallSuper
  void _initialize() async {
    _state = BluetoothLowEnergyState.unknown;
    _stateChangedController = StreamController.broadcast(
      onListen: _onListenStateChanged,
      onCancel: _onCancelStateChanged,
    );
    _nameChangedController = StreamController.broadcast(
      onListen: _onListenNameChanged,
      onCancel: _onCancelNameChanged,
    );
    _stateReceiver = api.BroadcastReceiver(
      onReceive: (_, context, intent) async {
        final state = await intent
            .getBluetoothAdapterStateExtra(api.Extra.bluetoothAdapterState);
        if (state == null) {
          return;
        }
        _onStateChanged(state.obj);
      },
    );
    _nameReceiver = api.BroadcastReceiver(
      onReceive: (_, context, intent) async {
        final name =
            await intent.getStringExtra(api.Extra.bluetoothAdapterLocalName);
        if (name == null) {
          return;
        }
        _onNameChanged(name);
      },
    );
    final isAuthorized = await _isAuthorized();
    if (!isAuthorized) {
      final shouldShowRationale = await _shouldShowAuthorizeRationale();
      if (!shouldShowRationale) {
        await _authorize();
      }
    }
    _invokeStateChanged();
  }

  @override
  Future<BluetoothLowEnergyState> getState() async {
    final packageManager = await _packageManager;
    final hasBluetoothLowEnergy =
        await packageManager.hasSystemFeature(api.Feature.bluetoothLowEnergy);
    if (hasBluetoothLowEnergy) {
      final isAuthorized = await _isAuthorized();
      if (isAuthorized) {
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
  Future<bool> shouldShowAuthorizeRationale() async {
    final activity = await _activity;
    for (var permission in _permissions) {
      final shouldShowRationale =
          await api.ActivityCompat.shouldShowRequestPermissionRationale(
              activity, permission);
      if (shouldShowRationale) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> authorize() async {
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
          activity, _permissions, _requestCode);
      final isGranted = await completer.future;
      return isGranted;
    } finally {
      await _instance.removeRequestPermissionsResultListener(listener);
    }
  }

  @override
  Future<void> turnOn() async {
    final bluetoothAdapter = await _bluetoothAdapter;
    final ok = await bluetoothAdapter.enable();
    if (!ok) {
      throw StateError('BluetoothAdapter#enable() returns false');
    }
  }

  @override
  Future<void> turnOff() async {
    final bluetoothAdapter = await _bluetoothAdapter;
    final ok = await bluetoothAdapter.disable();
    if (!ok) {
      throw StateError('BluetoothAdapter#disable() returns false');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed) {
      return;
    }
    _invokeStateChanged();
  }

  void _onListenStateChanged() async {
    final filter = api.IntentFilter.new3(
      action: api.Action.bluetoothAdapterStateChanged,
    );
    final flags = api.RegisterReceiverFlag.notExported;
    await api.ContextCompat.registerReceiver1(
        _context, _nameReceiver, filter, flags);
    WidgetsBinding.instance.addObserver(this);
  }

  void _onCancelStateChanged() async {
    await _context.unregisterReceiver(_stateReceiver);
    WidgetsBinding.instance.removeObserver(this);
  }

  void _onListenNameChanged() async {
    final filter = api.IntentFilter.new3(
      action: api.Action.bluetoothAdapterLocalNameChanged,
    );
    final flags = api.RegisterReceiverFlag.notExported;
    await api.ContextCompat.registerReceiver1(
        _context, _nameReceiver, filter, flags);
  }

  void _onCancelNameChanged() async {
    await _context.unregisterReceiver(_nameReceiver);
  }

  void _invokeStateChanged() async {
    final state = await getState();
    _onStateChanged(state);
  }

  void _onStateChanged(BluetoothLowEnergyState state) async {
    if (state == _state) {
      return;
    }
    final event = BluetoothLowEnergyStateChangedEvent(state);
    _stateChangedController.add(event);
  }

  void _onNameChanged(String name) {
    final event = NameChangedEvent(name);
    _nameChangedController.add(event);
  }

  Future<bool> _isAuthorized() async {
    for (var permission in _permissions) {
      final isGranted =
          await api.ContextCompat.checkSelfPermission(_context, permission);
      if (isGranted) {
        continue;
      }
      return false;
    }
    return true;
  }
}

final class CentralManagerImpl extends CentralManager
    with
        WidgetsBindingObserver,
        BluetoothLowEnergyManagerImpl,
        TypeLogger,
        LoggerController {
  @override
  final List<api.Permission> _permissions;
  @override
  final int _requestCode;

  late final StreamController<DiscoveredEvent> _discoveredController;
  late final StreamController<PeripheralConnectionStateChangedEvent>
      _connectionStateChangedController;
  late final StreamController<PeripheralMTUChangedEvent> _mtuChangedController;
  late final StreamController<GATTCharacteristicNotifiedEvent>
      _characteristicNotifiedController;

  late final api.ScanCallback _scanCallback;

  Future<api.BluetoothLeScanner> get _bluetoothLeScanner =>
      _bluetoothAdapter.then((e) => e.getBluetoothLeScanner());

  CentralManagerImpl()
      : _permissions = [
          api.Permission.bluetoothScan,
          api.Permission.bluetoothConnect,
        ],
        _requestCode = 443,
        super.impl() {
    _initialize();
  }

  @override
  void _initialize() {
    super._initialize();
    _discoveredController = StreamController.broadcast();
    _connectionStateChangedController = StreamController.broadcast();
    _mtuChangedController = StreamController.broadcast();
    _characteristicNotifiedController = StreamController.broadcast();

    _scanCallback = api.ScanCallback(
      onBatchScanResults: (_, results) {},
      onScanFailed: (_, errorCode) {},
      onScanResult: (_, result) {},
    );
  }

  @override
  Stream<DiscoveredEvent> get discovered => _discoveredController.stream;
  @override
  Stream<PeripheralConnectionStateChangedEvent> get connectionStateChanged =>
      _connectionStateChangedController.stream;
  @override
  Stream<PeripheralMTUChangedEvent> get mtuChanged =>
      _mtuChangedController.stream;
  @override
  Stream<GATTCharacteristicNotifiedEvent> get characteristicNotified =>
      _characteristicNotifiedController.stream;

  @override
  Future<void> startDiscovery({
    List<UUID>? serviceUUIDs,
  }) async {
    final bluetoothLeScanner = await _bluetoothLeScanner;
    final filters = <api.ScanFilter>[];
    if (serviceUUIDs != null) {
      for (var serviceUUID in serviceUUIDs) {
        final serviceUuid = await api.ParcelUuid.fromString('$serviceUUID');
        final filter = await api.ScanFilterBuilder()
            .setServiceUuid1(serviceUuid)
            .then((e) => e.build());
        filters.add(filter);
      }
    }
    final settings = await api.ScanSettingsBuilder()
        .setScanMode(api.ScanMode.lowLatency)
        .then((e) => e.build());
    await bluetoothLeScanner.startScan2(filters, settings, _scanCallback);
  }

  @override
  Future<void> stopDiscovery() async {
    final bluetoothAdapter = await _bluetoothAdapter;
    await bluetoothAdapter.stopLeScan(_scanCallback);
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() {
    // TODO: implement retrieveConnectedPeripherals
    throw UnimplementedError();
  }

  @override
  Future<void> connect(Peripheral peripheral) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect(Peripheral peripheral) {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<int> requestMTU(
    Peripheral peripheral, {
    required int mtu,
  }) {
    // TODO: implement requestMTU
    throw UnimplementedError();
  }

  @override
  Future<void> requestConnectionPriority(
    Peripheral peripheral, {
    required ConnectionPriority priority,
  }) {
    // TODO: implement requestConnectionPriority
    throw UnimplementedError();
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GATTCharacteristicWriteType type,
  }) {
    // TODO: implement getMaximumWriteLength
    throw UnimplementedError();
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) {
    // TODO: implement readRSSI
    throw UnimplementedError();
  }

  @override
  Future<List<GATTService>> discoverServices(Peripheral peripheral) {
    // TODO: implement discoverServices
    throw UnimplementedError();
  }

  @override
  Future<List<GATTCharacteristic>> discoverCharacteristics(
      GATTService service) {
    // TODO: implement discoverCharacteristics
    throw UnimplementedError();
  }

  @override
  Future<List<GATTDescriptor>> discoverDescriptors(
      GATTCharacteristic characteristic) {
    // TODO: implement discoverDescriptors
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readCharacteristic(GATTCharacteristic characteristic) {
    // TODO: implement readCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> writeCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  }) {
    // TODO: implement writeCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> setCharacteristicNotifyState(
    GATTCharacteristic characteristic, {
    required bool state,
  }) {
    // TODO: implement setCharacteristicNotifyState
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readDescriptor(GATTDescriptor descriptor) {
    // TODO: implement readDescriptor
    throw UnimplementedError();
  }

  @override
  Future<void> writeDescriptor(
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) {
    // TODO: implement writeDescriptor
    throw UnimplementedError();
  }
}

final class PeripheralManagerImpl extends PeripheralManager
    with
        WidgetsBindingObserver,
        BluetoothLowEnergyManagerImpl,
        TypeLogger,
        LoggerController {
  @override
  final List<api.Permission> _permissions;
  @override
  final int _requestCode;

  PeripheralManagerImpl()
      : _permissions = [
          api.Permission.bluetoothAdvertise,
          api.Permission.bluetoothConnect,
        ],
        _requestCode = 445,
        super.impl();

  @override
  // TODO: implement connectionStateChanged
  Stream<CentralConnectionStateChangedEvent> get connectionStateChanged =>
      throw UnimplementedError();
  @override
  // TODO: implement mtuChanged
  Stream<CentralMTUChangedEvent> get mtuChanged => throw UnimplementedError();
  @override
  // TODO: implement characteristicReadRequested
  Stream<GATTCharacteristicReadRequestedEvent>
      get characteristicReadRequested => throw UnimplementedError();
  @override
  // TODO: implement characteristicWriteRequested
  Stream<GATTCharacteristicWriteRequestedEvent>
      get characteristicWriteRequested => throw UnimplementedError();
  @override
  // TODO: implement characteristicNotifyStateChanged
  Stream<GATTCharacteristicNotifyStateChangedEvent>
      get characteristicNotifyStateChanged => throw UnimplementedError();
  @override
  // TODO: implement descriptorReadRequested
  Stream<GATTDescriptorReadRequestedEvent> get descriptorReadRequested =>
      throw UnimplementedError();
  @override
  // TODO: implement descriptorWriteRequested
  Stream<GATTDescriptorWriteRequestedEvent> get descriptorWriteRequested =>
      throw UnimplementedError();

  @override
  Future<void> addService(GATTService service) {
    // TODO: implement addService
    throw UnimplementedError();
  }

  @override
  Future<void> removeService(GATTService service) {
    // TODO: implement removeService
    throw UnimplementedError();
  }

  @override
  Future<void> removeAllServices() {
    // TODO: implement removeAllServices
    throw UnimplementedError();
  }

  @override
  Future<void> startAdvertising(
    Advertisement advertisement, {
    bool? includeDeviceName,
    bool? includeTXPowerLevel,
  }) {
    // TODO: implement startAdvertising
    throw UnimplementedError();
  }

  @override
  Future<void> stopAdvertising() {
    // TODO: implement stopAdvertising
    throw UnimplementedError();
  }

  @override
  Future<int> getMaximumNotifyLength(Central central) {
    // TODO: implement getMaximumNotifyLength
    throw UnimplementedError();
  }

  @override
  Future<void> respondReadRequestWithValue(
    GATTReadRequest request, {
    required Uint8List value,
  }) {
    // TODO: implement respondReadRequestWithValue
    throw UnimplementedError();
  }

  @override
  Future<void> respondReadRequestWithError(
    GATTReadRequest request, {
    required GATTError error,
  }) {
    // TODO: implement respondReadRequestWithError
    throw UnimplementedError();
  }

  @override
  Future<void> respondWriteRequest(GATTWriteRequest request) {
    // TODO: implement respondWriteRequest
    throw UnimplementedError();
  }

  @override
  Future<void> respondWriteRequestWithError(
    GATTWriteRequest request, {
    required GATTError error,
  }) {
    // TODO: implement respondWriteRequestWithError
    throw UnimplementedError();
  }

  @override
  Future<void> notifyCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    List<Central>? centrals,
  }) {
    // TODO: implement notifyCharacteristic
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

extension on UUID {
  Future<api.UUID> get args {
    return api.UUID.fromString('$this');
  }
}
