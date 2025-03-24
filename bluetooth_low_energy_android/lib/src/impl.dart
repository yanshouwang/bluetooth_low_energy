import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:meta/meta.dart';

import 'api.g.dart';
import 'api.pb.dart';

base mixin BluetoothLowEnergyManagerImpl on BluetoothLowEnergyManager {
  late final StreamController<BluetoothLowEnergyStateChangedEvent>
      _stateChangedController;
  late final StreamController<NameChangedEvent> _nameChangedController;

  late final StateChangedListenerApi _stateChangedListenerApi;
  late final NameChangedListenerApi _nameChangedListenerApi;

  BluetoothLowEnergyManagerApi get _api;

  @override
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
      _stateChangedController.stream;

  @override
  Stream<NameChangedEvent> get nameChanged => _nameChangedController.stream;

  @mustCallSuper
  void _initialize() async {
    _stateChangedController = StreamController.broadcast(
      onListen: _onListenStateChanged,
      onCancel: _onCancelStateChanged,
    );
    _nameChangedController = StreamController.broadcast(
      onListen: _onListenNameChanged,
      onCancel: _onCancelNameChanged,
    );
    _stateChangedListenerApi = StateChangedListenerApi(
      onChanged: (_, state) {
        final event = BluetoothLowEnergyStateChangedEvent(state.obj);
        _stateChangedController.add(event);
      },
    );
    _nameChangedListenerApi = NameChangedListenerApi(
      onChanged: (_, name) {
        final event = NameChangedEvent(name);
        _nameChangedController.add(event);
      },
    );
  }

  @override
  Future<bool> shouldShowAuthorizeRationale() async {
    final shouldShowRationale = await _api.shouldShowAuthorizeRationale();
    return shouldShowRationale;
  }

  @override
  Future<bool> authorize() async {
    final isAuthorized = await _api.authorize();
    return isAuthorized;
  }

  @override
  Future<void> showAppSettings() async {
    await _api.showAppSettings();
  }

  @override
  Future<BluetoothLowEnergyState> getState() async {
    final stateApi = await _api.getState();
    final state = stateApi.obj;
    return state;
  }

  @override
  Future<void> turnOn() async {
    await _api.turnOn();
  }

  @override
  Future<void> turnOff() async {
    await _api.turnOff();
  }

  @override
  Future<String?> getName() async {
    final name = await _api.getName();
    return name;
  }

  @override
  Future<void> setName(String? name) async {
    await _api.setName(name);
  }

  void _onListenStateChanged() async {
    await _api.addStateChangedListener(_stateChangedListenerApi);
  }

  void _onCancelStateChanged() async {
    await _api.removeStateChangedListener(_stateChangedListenerApi);
  }

  void _onListenNameChanged() async {
    await _api.addNameChangedListener(_nameChangedListenerApi);
  }

  void _onCancelNameChanged() async {
    await _api.removeNameChangedListener(_nameChangedListenerApi);
  }
}

final class CentralManagerImpl extends CentralManager
    with BluetoothLowEnergyManagerImpl, TypeLogger, LoggerController {
  @override
  final CentralManagerApi _api;

  late final StreamController<DiscoveredEvent> _discoveredController;
  late final StreamController<PeripheralConnectionStateChangedEvent>
      _connectionStateChangedController;
  late final StreamController<PeripheralMTUChangedEvent> _mtuChangedController;
  late final StreamController<GATTCharacteristicNotifiedEvent>
      _characteristicNotifiedController;

  late final DiscoveredListenerApi _discoveredListenerApi;
  late final ConnectionStateChangedListenerApi
      _connectionStateChangedListenerApi;
  late final MTUChangedListenerApi _mtuChangedListenerApi;
  late final CharacteristicNotifiedListenerApi
      _characteristicNotifiedListenerApi;

  CentralManagerImpl()
      : _api = CentralManagerApi(),
        super.impl() {
    _initialize();
  }

  @override
  void _initialize() {
    super._initialize();
    _discoveredController = StreamController.broadcast(
      onListen: _onListenDiscovered,
      onCancel: _onCancelDiscovered,
    );
    _connectionStateChangedController = StreamController.broadcast(
      onListen: _onListenConnectionStateChanged,
      onCancel: _onCancelConnectionStateChanged,
    );
    _mtuChangedController = StreamController.broadcast(
      onListen: _onListenMTUChanged,
      onCancel: _onCancelMTUChanged,
    );
    _characteristicNotifiedController = StreamController.broadcast(
      onListen: _onListenCharacteristicNotified,
      onCancel: _onCancelCharacteristicNotified,
    );

    _discoveredListenerApi = DiscoveredListenerApi(
      onDiscovered: (_, peripheralApi, rssi, advertisementApiValue) async {
        final peripheral = await peripheralApi.obj;
        final advertisementApi =
            AdvertisementApi.fromBuffer(advertisementApiValue);
        final advertisement = advertisementApi.obj;
        final event = DiscoveredEvent(peripheral, rssi, advertisement);
        _discoveredController.add(event);
      },
    );
    _connectionStateChangedListenerApi = ConnectionStateChangedListenerApi(
      onChanged: (_, peripheralApi, stateApi) async {
        final peripheral = await peripheralApi.obj;
        final state = stateApi.obj;
        final event = PeripheralConnectionStateChangedEvent(peripheral, state);
        _connectionStateChangedController.add(event);
      },
    );
    _mtuChangedListenerApi = MTUChangedListenerApi(
      onChanged: (_, peripheralApi, mtu) async {
        final peripheral = await peripheralApi.obj;
        final event = PeripheralMTUChangedEvent(peripheral, mtu);
        _mtuChangedController.add(event);
      },
    );
    _characteristicNotifiedListenerApi = CharacteristicNotifiedListenerApi(
      onNotified: (_, characteristicApi, value) async {
        final characteristic = await characteristicApi.obj;
        final event = GATTCharacteristicNotifiedEvent(characteristic, value);
        _characteristicNotifiedController.add(event);
      },
    );
  }

  void _onListenDiscovered() async {
    await _api.addDiscoveredListener(_discoveredListenerApi);
  }

  void _onCancelDiscovered() async {
    await _api.removeDiscoveredListener(_discoveredListenerApi);
  }

  void _onListenConnectionStateChanged() async {
    await _api
        .addConnectionStateChangedListener(_connectionStateChangedListenerApi);
  }

  void _onCancelConnectionStateChanged() async {
    await _api.removeConnectionStateChangedListener(
        _connectionStateChangedListenerApi);
  }

  void _onListenMTUChanged() async {
    await _api.addMTUChanagedListener(_mtuChangedListenerApi);
  }

  void _onCancelMTUChanged() async {
    await _api.removeMTUChangedListener(_mtuChangedListenerApi);
  }

  void _onListenCharacteristicNotified() async {
    await _api
        .addCharacteristicNotifiedListener(_characteristicNotifiedListenerApi);
  }

  void _onCancelCharacteristicNotified() async {
    await _api.removeCharacteristicNotifiedListener(
        _characteristicNotifiedListenerApi);
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
    List<UUID> serviceUUIDs = const [],
  }) async {
    final serviceUUIDApis = serviceUUIDs.map((e) => e.toString()).toList();
    await _api.startDiscovery(serviceUUIDApis);
  }

  @override
  Future<void> stopDiscovery() async {
    await _api.stopDiscovery();
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() async {
    final peripheralApis = await _api.retrieveConnectedPeripherals();
    final peripherals = await Stream.fromIterable(peripheralApis)
        .asyncMap((e) => e.obj)
        .toList();
    return peripherals;
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    await _api.connect(peripheral._api);
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    await _api.disconnect(peripheral._api);
  }

  @override
  Future<int> requestMTU(
    Peripheral peripheral, {
    required int mtu,
  }) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final mtu1 = await _api.requestMTU(peripheral._api, mtu);
    return mtu1;
  }

  @override
  Future<void> requestConnectionPriority(
    Peripheral peripheral, {
    required ConnectionPriority priority,
  }) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    await _api.requestConnectionPriority(peripheral._api, priority.api);
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GATTCharacteristicWriteType type,
  }) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final maximumWriteLength =
        await _api.getMaximumWriteLength(peripheral._api, type.api);
    return maximumWriteLength;
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final rssi = await _api.readRSSI(peripheral._api);
    return rssi;
  }

  @override
  Future<List<GATTService>> discoverServices(Peripheral peripheral) async {
    if (peripheral is! PeripheralImpl) {
      throw TypeError();
    }
    final serviceApis = await _api.discoverServices(peripheral._api);
    final services =
        await Stream.fromIterable(serviceApis).asyncMap((e) => e.obj).toList();
    return services;
  }

  @override
  Future<List<GATTCharacteristic>> discoverCharacteristics(
      GATTService service) async {
    return service.characteristics;
  }

  @override
  Future<List<GATTDescriptor>> discoverDescriptors(
      GATTCharacteristic characteristic) async {
    return characteristic.descriptors;
  }

  @override
  Future<Uint8List> readCharacteristic(
      GATTCharacteristic characteristic) async {
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    final value = await _api.readCharacteristic(characteristic._api);
    return value;
  }

  @override
  Future<void> writeCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  }) async {
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    await _api.writeCharacteristic(characteristic._api, value, type.api);
  }

  @override
  Future<void> setCharacteristicNotifyState(
    GATTCharacteristic characteristic, {
    required bool state,
  }) async {
    if (characteristic is! GATTCharacteristicImpl) {
      throw TypeError();
    }
    await _api.setCharacteristicNotifyState(characteristic._api, state);
  }

  @override
  Future<Uint8List> readDescriptor(GATTDescriptor descriptor) async {
    if (descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    final value = await _api.readDescriptor(descriptor._api);
    return value;
  }

  @override
  Future<void> writeDescriptor(
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (descriptor is! GATTDescriptorImpl) {
      throw TypeError();
    }
    await _api.writeDescriptor(descriptor._api, value);
  }
}

final class PeripheralManagerImpl extends PeripheralManager
    with BluetoothLowEnergyManagerImpl, TypeLogger, LoggerController {
  @override
  // TODO: implement _api
  BluetoothLowEnergyManagerApi get _api => throw UnimplementedError();

  PeripheralManagerImpl() : super.impl();

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

base mixin BluetoothLowEnergyPeerImpl on BluetoothLowEnergyPeer {}

final class PeripheralImpl extends Peripheral with BluetoothLowEnergyPeerImpl {
  final PeripheralApi _api;

  PeripheralImpl.impl(
    this._api, {
    required super.uuid,
  }) : super.impl();
}

base mixin GATTAttributeImpl on GATTAttribute {
  int get instanceId;

  @override
  bool operator ==(Object other) {
    return other is GATTAttributeImpl && other.instanceId == instanceId;
  }

  @override
  int get hashCode => instanceId.hashCode;
}

final class GATTDescriptorImpl extends GATTDescriptor with GATTAttributeImpl {
  final GATTDescriptorApi _api;
  @override
  final int instanceId;

  GATTDescriptorImpl.impl(
    this._api, {
    required this.instanceId,
    required super.uuid,
  }) : super.impl();
}

final class GATTCharacteristicImpl extends GATTCharacteristic
    with GATTAttributeImpl {
  final GATTCharacteristicApi _api;
  @override
  final int instanceId;

  GATTCharacteristicImpl.impl(
    this._api, {
    required this.instanceId,
    required super.uuid,
    required super.properties,
    required super.descriptors,
  }) : super.impl();
}

final class GATTServiceImpl extends GATTService with GATTAttributeImpl {
  final GATTServiceApi _api;
  @override
  final int instanceId;

  GATTServiceImpl(
    this._api, {
    required this.instanceId,
    required super.uuid,
    required super.isPrimary,
    required super.includedServices,
    required super.characteristics,
  });
}

extension on ConnectionPriority {
  ConnectionPriorityApi get api {
    switch (this) {
      case ConnectionPriority.balanced:
        return ConnectionPriorityApi.balanced;
      case ConnectionPriority.high:
        return ConnectionPriorityApi.high;
      case ConnectionPriority.lowPower:
        return ConnectionPriorityApi.lowPower;
      case ConnectionPriority.dck:
        return ConnectionPriorityApi.dck;
    }
  }
}

extension on GATTCharacteristicWriteType {
  GATTCharacteristicWriteTypeApi get api {
    switch (this) {
      case GATTCharacteristicWriteType.withResponse:
        return GATTCharacteristicWriteTypeApi.withResponse;
      case GATTCharacteristicWriteType.withoutResponse:
        return GATTCharacteristicWriteTypeApi.withoutResponse;
    }
  }
}

extension on BluetoothLowEnergyStateApi {
  BluetoothLowEnergyState get obj {
    switch (this) {
      case BluetoothLowEnergyStateApi.unknown:
        return BluetoothLowEnergyState.unknown;
      case BluetoothLowEnergyStateApi.unsupported:
        return BluetoothLowEnergyState.unsupported;
      case BluetoothLowEnergyStateApi.unauthorized:
        return BluetoothLowEnergyState.unauthorized;
      case BluetoothLowEnergyStateApi.off:
        return BluetoothLowEnergyState.off;
      case BluetoothLowEnergyStateApi.turningOn:
        return BluetoothLowEnergyState.turningOn;
      case BluetoothLowEnergyStateApi.on:
        return BluetoothLowEnergyState.on;
      case BluetoothLowEnergyStateApi.turningOff:
        return BluetoothLowEnergyState.turningOff;
    }
  }
}

extension on AdvertisementApi {
  Advertisement get obj {
    return Advertisement(
      name: hasName() ? name : null,
      serviceUUIDs: serviceUuids.map((e) => UUID.fromString(e)).toList(),
      serviceData: {
        for (var entry in serviceData.entries)
          UUID.fromString(entry.key): Uint8List.fromList(entry.value)
      },
      manufacturerSpecificData:
          manufacturerSpecificData.map((e) => e.obj).toList(),
    );
  }
}

extension on ManufacturerSpecificDataApi {
  ManufacturerSpecificData get obj {
    return ManufacturerSpecificData(
      id: id,
      data: Uint8List.fromList(data),
    );
  }
}

extension on ConnectionStateApi {
  ConnectionState get obj {
    switch (this) {
      case ConnectionStateApi.disconnected:
        return ConnectionState.disconnected;
      case ConnectionStateApi.connecting:
        return ConnectionState.connecting;
      case ConnectionStateApi.connected:
        return ConnectionState.connected;
      case ConnectionStateApi.disconnecting:
        return ConnectionState.disconnecting;
    }
  }
}

extension on PeripheralApi {
  Future<PeripheralImpl> get obj async {
    final address = await getAddress();
    final uuid = UUID.fromAddress(address);
    return PeripheralImpl.impl(
      this,
      uuid: uuid,
    );
  }
}

extension on GATTDescriptorApi {
  Future<GATTDescriptorImpl> get obj async {
    final instanceId = await getInstanceId();
    final uuidValue = await getUUID();
    final uuid = UUID.fromString(uuidValue);
    return GATTDescriptorImpl.impl(
      this,
      instanceId: instanceId,
      uuid: uuid,
    );
  }
}

extension on GATTCharacteristicApi {
  Future<GATTCharacteristicImpl> get obj async {
    final instanceId = await getInstanceId();
    final uuidValue = await getUUID();
    final uuid = UUID.fromString(uuidValue);
    final propertyApis = await getProperties();
    final properties = propertyApis.map((e) => e.obj).toList();
    final descriptorApis = await getDescriptors();
    final descriptors = await Stream.fromIterable(descriptorApis)
        .asyncMap((e) => e.obj)
        .toList();
    return GATTCharacteristicImpl.impl(
      this,
      instanceId: instanceId,
      uuid: uuid,
      properties: properties,
      descriptors: descriptors,
    );
  }
}

extension on GATTServiceApi {
  Future<GATTServiceImpl> get obj async {
    final instanceId = await getInstanceId();
    final uuidValue = await getUUID();
    final uuid = UUID.fromString(uuidValue);
    final isPrimary = await getIsPrimary();
    final includedServiceApis = await getIncludedServices();
    final includedServices = await Stream.fromIterable(includedServiceApis)
        .asyncMap((e) => e.obj)
        .toList();
    final characteristicApis = await getCharacteristics();
    final characteristics = await Stream.fromIterable(characteristicApis)
        .asyncMap((e) => e.obj)
        .toList();
    return GATTServiceImpl(
      this,
      instanceId: instanceId,
      uuid: uuid,
      isPrimary: isPrimary,
      includedServices: includedServices,
      characteristics: characteristics,
    );
  }
}

extension on GATTCharacteristicPropertyApi {
  GATTCharacteristicProperty get obj {
    switch (this) {
      case GATTCharacteristicPropertyApi.read:
        return GATTCharacteristicProperty.read;
      case GATTCharacteristicPropertyApi.write:
        return GATTCharacteristicProperty.write;
      case GATTCharacteristicPropertyApi.writeWithoutResponse:
        return GATTCharacteristicProperty.writeWithoutResponse;
      case GATTCharacteristicPropertyApi.notify:
        return GATTCharacteristicProperty.notify;
      case GATTCharacteristicPropertyApi.indicate:
        return GATTCharacteristicProperty.indicate;
    }
  }
}
