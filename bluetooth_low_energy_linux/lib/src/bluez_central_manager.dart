import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

class BlueZCentralManager extends CentralController {
  final BlueZClient _client;
  final StreamController<BluetoothState> _stateController;
  final StreamController<Peripheral> _discoveredController;
  final StreamController<(String, PeripheralState)>
      _peripheralStateChangedController;
  final StreamController<String> _servicesResolvedController;
  final StreamController<(String, String, String, Uint8List)>
      _characteristicValueChangedController;
  final Map<String, StreamSubscription<List<String>>>
      _devicePropertiesSubscriptions;
  final Map<String, StreamSubscription<List<String>>>
      _characteristicPropertiesSubscriptions;

  late final Future<void> _ini;

  BlueZCentralManager()
      : _client = BlueZClient(),
        _stateController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _servicesResolvedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _devicePropertiesSubscriptions = {},
        _characteristicPropertiesSubscriptions = {} {
    _ini = _initialize();
  }

  BlueZAdapter get _adapter => _client.adapters.first;

  @override
  Stream<BluetoothState> get stateChanged => _stateController.stream;

  @override
  Stream<Peripheral> get discovered => _discoveredController.stream;

  @override
  Stream<(String, PeripheralState)> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;

  Stream<String> get _servicesResolved => _servicesResolvedController.stream;

  @override
  Stream<(String, String, String, Uint8List)> get characteristicValueChanged =>
      _characteristicValueChangedController.stream;

  Future<void> _initialize() async {
    await _client.connect();
    _adapter.propertiesChanged.listen(_onAdapterPropertiesChanged);
    for (var device in _client.devices) {
      _onDeviceAdded(device);
    }
    _client.deviceAdded.listen(_onDeviceAdded);
    _client.deviceRemoved.listen(_onDeviceRemoved);
  }

  @override
  Future<BluetoothState> getState() async {
    await _ini;
    final state = _client.adapters.isEmpty
        ? BluetoothState.unsupported
        : _adapter.myState;
    return state;
  }

  @override
  Future<void> startDiscovery() async {
    await _ini;
    await _adapter.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _ini;
    await _adapter.stopDiscovery();
  }

  @override
  Future<void> connect(String id) async {
    await _ini;
    final device = _client.devices.firstWhere((device) => device.address == id);
    await device.connect();
  }

  @override
  void disconnect(String id) async {
    await _ini;
    final device = _client.devices.firstWhere((device) => device.address == id);
    await device.disconnect();
  }

  @override
  Future<List<GattService>> discoverServices(String id) async {
    await _ini;
    final device = _client.devices.firstWhere((device) => device.address == id);
    if (device.connected && !device.servicesResolved) {
      final completer = Completer<void>();
      final subscription0 = peripheralStateChanged.listen((event) {
        final (id1, state) = event;
        if (id1 != id ||
            state == PeripheralState.connected ||
            completer.isCompleted) {
          return;
        }
        completer.complete();
      });
      final subscription1 = _servicesResolved.listen((id1) {
        if (id1 != id || completer.isCompleted) {
          return;
        }
        completer.complete();
      });
      await completer.future.whenComplete(() {
        subscription0.cancel();
        subscription1.cancel();
      });
    }
    final services =
        device.gattServices.map((service) => service.myService).toList();
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
  }) async {
    await _ini;
    final serviceUUID = BlueZUUID.fromString(serviceId);
    final characterisitcUUID = BlueZUUID.fromString(characteristicId);
    final device = _client.devices.firstWhere((device) => device.address == id);
    final service = device.gattServices
        .firstWhere((service) => service.uuid == serviceUUID);
    final characteristic = service.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == characterisitcUUID);
    final value = await characteristic
        .readValue()
        .then((value) => Uint8List.fromList(value));
    return value;
  }

  @override
  Future<void> writeCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) async {
    await _ini;
    final serviceUUID = BlueZUUID.fromString(serviceId);
    final characterisitcUUID = BlueZUUID.fromString(characteristicId);
    final device = _client.devices.firstWhere((device) => device.address == id);
    final service = device.gattServices
        .firstWhere((service) => service.uuid == serviceUUID);
    final characteristic = service.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == characterisitcUUID);
    await characteristic.writeValue(
      value,
      type: type.nativeType,
    );
  }

  @override
  Future<void> notifyCharacteristic({
    required String id,
    required String serviceId,
    required String characteristicId,
    required bool value,
  }) async {
    await _ini;
    final serviceUUID = BlueZUUID.fromString(serviceId);
    final characterisitcUUID = BlueZUUID.fromString(characteristicId);
    final device = _client.devices.firstWhere((device) => device.address == id);
    final service = device.gattServices
        .firstWhere((service) => service.uuid == serviceUUID);
    final characteristic = service.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == characterisitcUUID);
    if (value) {
      await characteristic.startNotify();
    } else {
      await characteristic.stopNotify();
    }
  }

  @override
  Future<Uint8List> readDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
  }) async {
    await _ini;
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
    final value =
        await descriptor.readValue().then((value) => Uint8List.fromList(value));
    return value;
  }

  @override
  Future<void> writeDescriptor({
    required String id,
    required String serviceId,
    required String characteristicId,
    required String descriptorId,
    required Uint8List value,
  }) async {
    await _ini;
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
    await descriptor.writeValue(value);
  }

  void _onAdapterPropertiesChanged(List<String> properties) {
    log('Adapter Properties Changed: $properties');
    for (var property in properties) {
      switch (property) {
        case 'Powered':
          _stateController.add(_adapter.myState);
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
            _discoveredController.add(device.myPeripheral);
            break;
          case 'Connected':
            final event = (device.address, device.myState);
            _peripheralStateChangedController.add(event);
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
                          final event = (
                            device.address,
                            service.uuid.toString(),
                            characteristic.uuid.toString(),
                            Uint8List.fromList(characteristic.value),
                          );
                          _characteristicValueChangedController.add(event);
                          break;
                        default:
                          break;
                      }
                    }
                  });
                  _characteristicPropertiesSubscriptions[key] = subscription;
                }
              }
              _servicesResolvedController.add(device.address);
            }
            break;
          default:
            break;
        }
      }
    });
    _devicePropertiesSubscriptions[device.address] = subscription;
    _discoveredController.add(device.myPeripheral);
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
  BluetoothState get myState {
    return powered ? BluetoothState.poweredOn : BluetoothState.poweredOff;
  }
}

extension on BlueZDevice {
  Peripheral get myPeripheral {
    return Peripheral(
      id: address,
      name: name,
      rssi: rssi,
      manufacturerSpecificData: myManufacturerSpecificData,
    );
  }

  Uint8List? get myManufacturerSpecificData {
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

  PeripheralState get myState {
    return connected ? PeripheralState.connected : PeripheralState.disconnected;
  }
}

extension on BlueZGattService {
  GattService get myService {
    final characteristics = this
        .characteristics
        .map((characteristic) => characteristic.myCharacteristic)
        .toList();
    return GattService(
      id: uuid.toString(),
      characteristics: characteristics,
    );
  }
}

extension on BlueZGattCharacteristic {
  GattCharacteristic get myCharacteristic {
    final canRead = flags.contains(BlueZGattCharacteristicFlag.read);
    final canWrite = flags.contains(BlueZGattCharacteristicFlag.write);
    final canWriteWithoutResponse =
        flags.contains(BlueZGattCharacteristicFlag.writeWithoutResponse);
    final canNotify = flags.contains(BlueZGattCharacteristicFlag.notify);
    final descriptors =
        this.descriptors.map((descriptor) => descriptor.myDescriptor).toList();
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
  GattDescriptor get myDescriptor {
    return GattDescriptor(
      id: uuid.toString(),
    );
  }
}

extension on GattCharacteristicWriteType {
  BlueZGattCharacteristicWriteType get nativeType {
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
