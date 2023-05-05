import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';
import 'package:flutter/foundation.dart';

class BlueZCentralManager extends CentralManager {
  final ValueNotifier<CentralManagerState> _state;
  final StreamController<PeripheralEventArgs> _scannedController;
  final BlueZClient _client;
  final Map<String, StreamSubscription<List<String>>>
      devicePropertiesSubscription;

  BlueZCentralManager()
      : _state = ValueNotifier(CentralManagerState.unsupported),
        _scannedController = StreamController.broadcast(),
        _client = BlueZClient(),
        devicePropertiesSubscription = {};

  BlueZAdapter get _adapter => _client.adapters.first;

  @override
  ValueListenable<CentralManagerState> get state => _state;

  @override
  Stream<PeripheralEventArgs> get scanned => _scannedController.stream;

  @override
  Stream<PeripheralStateEventArgs> get peripheralStateChanged =>
      throw UnimplementedError();

  @override
  Stream<CharacteristicValueEventArgs> get characteristicValueChanged =>
      throw UnimplementedError();

  @override
  Future<void> initialize() async {
    await _client.connect();
    _state.value = _client.adapters.isEmpty
        ? CentralManagerState.unsupported
        : _adapter.toNativeState();
    _adapter.propertiesChanged.listen(_onAdapterPropertiesChanged);
    for (var device in _client.devices) {
      _onDeviceAdded(device);
    }
    _client.deviceAdded.listen(_onDeviceAdded);
    _client.deviceRemoved.listen(_onDeviceRemoved);
  }

  @override
  Future<void> startScan() {
    return _adapter.startDiscovery();
  }

  @override
  Future<void> stopScan() {
    return _adapter.stopDiscovery();
  }

  @override
  Future<void> connect(String id) {
    final device = _client.devices.firstWhere((device) => device.address == id);
    return device.connect();
  }

  @override
  void disconnect(String id) {
    final device = _client.devices.firstWhere((device) => device.address == id);
    device.disconnect().ignore();
  }

  @override
  Future<Uint8List> read(String id, String serviceId, String characteristicId) {
    final serviceUUID = BlueZUUID.fromString(serviceId);
    final characterisitcUUID = BlueZUUID.fromString(characteristicId);
    final device = _client.devices.firstWhere((device) => device.address == id);
    final service = device.gattServices
        .firstWhere((service) => service.uuid == serviceUUID);
    final characteristic = service.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == characterisitcUUID);
    return characteristic
        .readValue()
        .then((value) => Uint8List.fromList(value));
  }

  @override
  Future<void> write(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value, {
    CharacteristicWriteType? type,
  }) {
    final serviceUUID = BlueZUUID.fromString(serviceId);
    final characterisitcUUID = BlueZUUID.fromString(characteristicId);
    final device = _client.devices.firstWhere((device) => device.address == id);
    final service = device.gattServices
        .firstWhere((service) => service.uuid == serviceUUID);
    final characteristic = service.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == characterisitcUUID);
    return characteristic.writeValue(
      value,
      type: type?.toApi(),
    );
  }

  @override
  Future<void> notify(
    String id,
    String serviceId,
    String characteristicId,
    bool value,
  ) {
    final serviceUUID = BlueZUUID.fromString(serviceId);
    final characterisitcUUID = BlueZUUID.fromString(characteristicId);
    final device = _client.devices.firstWhere((device) => device.address == id);
    final service = device.gattServices
        .firstWhere((service) => service.uuid == serviceUUID);
    final characteristic = service.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == characterisitcUUID);
    if (value) {
      return characteristic.startNotify();
    } else {
      return characteristic.stopNotify();
    }
  }

  void _onAdapterPropertiesChanged(List<String> properties) {
    log('Adapter Properties Changed: $properties');
    for (var property in properties) {
      switch (property) {
        case 'Powered':
          _state.value = _adapter.toNativeState();
          break;
        default:
          break;
      }
    }
  }

  void _onDeviceAdded(BlueZDevice device) {
    final subscription = device.propertiesChanged.listen((properties) {
      log('Device Properties Changed: $properties');
      for (var property in properties) {
        switch (property) {
          case 'RSSI':
            final eventArgs = PeripheralEventArgs(device.toNative());
            _scannedController.add(eventArgs);
            break;
          default:
        }
      }
    });
    devicePropertiesSubscription[device.address] = subscription;
    final eventArgs = PeripheralEventArgs(device.toNative());
    _scannedController.add(eventArgs);
  }

  void _onDeviceRemoved(BlueZDevice device) {
    final subscription = devicePropertiesSubscription.remove(device.address);
    subscription?.cancel();
  }
}

extension on BlueZAdapter {
  CentralManagerState toNativeState() {
    return powered
        ? CentralManagerState.poweredOn
        : CentralManagerState.poweredOff;
  }
}

extension on BlueZDevice {
  Peripheral toNative() {
    return Peripheral(
      id: address,
      name: name,
      rssi: rssi,
      manufacturerData: toNativeManufacturerData(),
    );
  }

  Uint8List toNativeManufacturerData() {
    if (manufacturerData.isEmpty) {
      return Uint8List(0);
    } else {
      final entry = manufacturerData.entries.first;
      final vid = Uint16List.fromList([entry.key.id]).buffer.asUint8List();
      return Uint8List.fromList([
        ...vid,
        ...entry.value,
      ]);
    }
  }
}

extension on CharacteristicWriteType {
  BlueZGattCharacteristicWriteType toApi() {
    switch (this) {
      case CharacteristicWriteType.withResponse:
        return BlueZGattCharacteristicWriteType.request;
      case CharacteristicWriteType.withoutResponse:
        return BlueZGattCharacteristicWriteType.command;
      default:
        throw UnimplementedError();
    }
  }
}
