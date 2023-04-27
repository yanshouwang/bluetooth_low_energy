import 'dart:async';
import 'dart:typed_data';

import 'package:bluez/bluez.dart';
import 'package:flutter/foundation.dart';

import 'central_manager.dart';
import 'central_manager_state.dart';
import 'characteristic_write_type.dart';
import 'event_args.dart';
import 'peripheral.dart';

class BluezCentralManager extends CentralManager {
  final ValueNotifier<CentralManagerState> _state;
  final StreamController<PeripheralEventArgs> _scannedController;
  final BlueZClient _client;

  BluezCentralManager()
      : _state = ValueNotifier(CentralManagerState.unsupported),
        _scannedController = StreamController.broadcast(),
        _client = BlueZClient();

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
        : _adapter.powered
            ? CentralManagerState.poweredOn
            : CentralManagerState.poweredOff;
    _adapter.propertiesChanged.listen((properties) {
      for (var property in properties) {
        switch (property) {
          case 'Powered':
            _state.value = _adapter.powered
                ? CentralManagerState.poweredOn
                : CentralManagerState.poweredOff;
            break;
          default:
            break;
        }
      }
    });
    for (var device in _client.devices) {
      final eventArgs = PeripheralEventArgs(device.toNative());
      _scannedController.add(eventArgs);
    }
    _client.deviceAdded.listen((device) {
      final eventArgs = PeripheralEventArgs(device.toNative());
      _scannedController.add(eventArgs);
    });
    _client.deviceRemoved.listen((device) {});
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
