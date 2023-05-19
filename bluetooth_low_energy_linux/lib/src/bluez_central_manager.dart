import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';
import 'package:flutter/foundation.dart';

import 'event_args.dart';

class BlueZCentralManager extends CentralManager {
  final BlueZClient _client;
  final ValueNotifier<CentralManagerState> _state;
  final StreamController<PeripheralEvent> _scannedController;
  final StreamController<PeripheralStateEvent>
      _peripheralStateChangedController;
  final StreamController<IdEventArgs> _servicesResolvedController;
  final StreamController<GattCharacteristicValueEvent>
      _characteristicValueChangedController;
  final Map<String, StreamSubscription<List<String>>>
      _devicePropertiesSubscriptions;
  final Map<String, StreamSubscription<List<String>>>
      _characteristicPropertiesSubscriptions;

  BlueZCentralManager()
      : _client = BlueZClient(),
        _state = ValueNotifier(CentralManagerState.unknown),
        _scannedController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _servicesResolvedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _devicePropertiesSubscriptions = {},
        _characteristicPropertiesSubscriptions = {};

  BlueZAdapter get _adapter => _client.adapters.first;

  @override
  ValueListenable<CentralManagerState> get state => _state;

  @override
  Stream<PeripheralEvent> get scanned => _scannedController.stream;

  @override
  Stream<PeripheralStateEvent> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;

  Stream<IdEventArgs> get _servicesResolved =>
      _servicesResolvedController.stream;

  @override
  Stream<GattCharacteristicValueEvent> get characteristicValueChanged =>
      _characteristicValueChangedController.stream;

  @override
  Future<void> initialize() async {
    await _client.connect();
    _state.value = _client.adapters.isEmpty
        ? CentralManagerState.unsupported
        : _adapter.getCentralManagerState();
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
  Future<List<GattService>> discoverServices(String id) async {
    final device = _client.devices.firstWhere((device) => device.address == id);
    if (device.connected && !device.servicesResolved) {
      final completer = Completer<void>();
      final subscription0 = peripheralStateChanged.listen((eventArgs) {
        if (eventArgs.id != id ||
            eventArgs.state == PeripheralState.connected ||
            completer.isCompleted) {
          return;
        }
        completer.complete();
      });
      final subscription1 = _servicesResolved.listen((eventArgs) {
        if (eventArgs.id != id || completer.isCompleted) {
          return;
        }
        completer.complete();
      });
      await completer.future.whenComplete(() {
        subscription0.cancel();
        subscription1.cancel();
      });
    }
    return device.gattServices
        .map((service) => service.toGattService())
        .toList();
  }

  @override
  Future<Uint8List> readCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
  }) {
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
  Future<void> writeCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required Uint8List value,
    required GattCharacteristicWriteType type,
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
      type: type.toBlueZBlueZGattCharacteristicWriteType(),
    );
  }

  @override
  Future<void> notifyCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required bool value,
  }) {
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

  @override
  Future<Uint8List> readDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
  }) {
    final serviceUUID = BlueZUUID.fromString(serviceId);
    final characterisitcUUID = BlueZUUID.fromString(characteristicId);
    final descriptorUUID = BlueZUUID.fromString(descriptorId);
    final device = _client.devices.firstWhere((device) => device.address == id);
    final service = device.gattServices
        .firstWhere((service) => service.uuid == serviceUUID);
    final characteristic = service.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == characterisitcUUID);
    final descriptor = characteristic.descriptors
        .firstWhere((element) => element.uuid == descriptorUUID);
    return descriptor.readValue().then((value) => Uint8List.fromList(value));
  }

  @override
  Future<void> writeDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
    required Uint8List value,
  }) {
    final serviceUUID = BlueZUUID.fromString(serviceId);
    final characterisitcUUID = BlueZUUID.fromString(characteristicId);
    final descriptorUUID = BlueZUUID.fromString(descriptorId);
    final device = _client.devices.firstWhere((device) => device.address == id);
    final service = device.gattServices
        .firstWhere((service) => service.uuid == serviceUUID);
    final characteristic = service.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == characterisitcUUID);
    final descriptor = characteristic.descriptors
        .firstWhere((element) => element.uuid == descriptorUUID);
    return descriptor.writeValue(value);
  }

  void _onAdapterPropertiesChanged(List<String> properties) {
    log('Adapter Properties Changed: $properties');
    for (var property in properties) {
      switch (property) {
        case 'Powered':
          _state.value = _adapter.getCentralManagerState();
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
            final eventArgs = PeripheralEvent(device.toPeripheral());
            _scannedController.add(eventArgs);
            break;
          case 'Connected':
            final eventArgs = PeripheralStateEvent(
              device.address,
              device.flutterState,
            );
            _peripheralStateChangedController.add(eventArgs);
            break;
          case 'UUIDs':
            break;
          case 'ServicesResolved':
            if (device.servicesResolved) {
              for (var service in device.gattServices) {
                for (var characteristic in service.characteristics) {
                  final key =
                      '${device.address}->${service.uuid}->${characteristic.uuid}';
                  final subscription =
                      characteristic.propertiesChanged.listen((properties) {
                    for (var property in properties) {
                      switch (property) {
                        case 'Value':
                          final eventArgs = GattCharacteristicValueEvent(
                            device.address,
                            service.uuid.toString(),
                            characteristic.uuid.toString(),
                            Uint8List.fromList(characteristic.value),
                          );
                          _characteristicValueChangedController.add(eventArgs);
                          break;
                        default:
                          break;
                      }
                    }
                  });
                  _characteristicPropertiesSubscriptions[key] = subscription;
                }
              }
              final eventArgs = IdEventArgs(device.address);
              _servicesResolvedController.add(eventArgs);
            }
            break;
          default:
            break;
        }
      }
    });
    _devicePropertiesSubscriptions[device.address] = subscription;
    final eventArgs = PeripheralEvent(device.toPeripheral());
    _scannedController.add(eventArgs);
  }

  void _onDeviceRemoved(BlueZDevice device) {
    for (var service in device.gattServices) {
      for (var characteristic in service.characteristics) {
        final key =
            '${device.address}->${service.uuid}->${characteristic.uuid}';
        final subscription = _characteristicPropertiesSubscriptions.remove(key);
        subscription?.cancel();
      }
    }
    final subscription = _devicePropertiesSubscriptions.remove(device.address);
    subscription?.cancel();
  }
}

extension on BlueZAdapter {
  CentralManagerState getCentralManagerState() {
    return powered
        ? CentralManagerState.poweredOn
        : CentralManagerState.poweredOff;
  }
}

extension on BlueZDevice {
  Peripheral toPeripheral() {
    return Peripheral(
      id: address,
      name: name,
      rssi: rssi,
      manufacturerSpecificData: getManufacturerSpecificData(),
    );
  }

  Uint8List? getManufacturerSpecificData() {
    if (manufacturerData.isEmpty) {
      return null;
    } else {
      final entry = manufacturerData.entries.first;
      final vid = Uint16List.fromList([entry.key.id]).buffer.asUint8List();
      return Uint8List.fromList([
        ...vid,
        ...entry.value,
      ]);
    }
  }

  PeripheralState get flutterState {
    return connected ? PeripheralState.connected : PeripheralState.disconnected;
  }
}

extension on BlueZGattService {
  GattService toGattService() {
    final characteristics = this
        .characteristics
        .map((characteristic) => characteristic.toGattCharacteristic())
        .toList();
    return GattService(
      id: uuid.toString(),
      characteristics: characteristics,
    );
  }
}

extension on BlueZGattCharacteristic {
  GattCharacteristic toGattCharacteristic() {
    final canRead = flags.contains(BlueZGattCharacteristicFlag.read);
    final canWrite = flags.contains(BlueZGattCharacteristicFlag.write);
    final canWriteWithoutResponse =
        flags.contains(BlueZGattCharacteristicFlag.writeWithoutResponse);
    final canNotify = flags.contains(BlueZGattCharacteristicFlag.notify);
    final descriptors = this
        .descriptors
        .map((descriptor) => descriptor.toGattDescriptor())
        .toList();
    return GattCharacteristic(
      id: uuid.toString(),
      canRead: canRead,
      canWrite: canWrite,
      canWriteWithoutResponse: canWriteWithoutResponse,
      canNotify: canNotify,
      descriptors: descriptors,
    );
  }
}

extension on BlueZGattDescriptor {
  GattDescriptor toGattDescriptor() {
    return GattDescriptor(
      id: uuid.toString(),
    );
  }
}

extension on GattCharacteristicWriteType {
  BlueZGattCharacteristicWriteType toBlueZBlueZGattCharacteristicWriteType() {
    switch (this) {
      case GattCharacteristicWriteType.withResponse:
        return BlueZGattCharacteristicWriteType.request;
      case GattCharacteristicWriteType.withoutResponse:
        return BlueZGattCharacteristicWriteType.command;
      default:
        throw UnimplementedError();
    }
  }
}
