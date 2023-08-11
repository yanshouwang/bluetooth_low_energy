import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_peripheral.dart';

class MyCentralManager extends CentralController {
  MyCentralManager()
      : _client = BlueZClient(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _servicesResolvedController = StreamController.broadcast(),
        _devicePropertiesSubscriptions = {},
        _characteristicPropertiesSubscriptions = {},
        _state = CentralState.unknown;

  final BlueZClient _client;
  final StreamController<CentralStateChangedEventArgs> _stateChangedController;
  final StreamController<CentralDiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralStateChangedEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueChangedEventArgs>
      _characteristicValueChangedController;
  final StreamController<String> _servicesResolvedController;
  final Map<String, StreamSubscription<List<String>>>
      _devicePropertiesSubscriptions;
  final Map<String, StreamSubscription<List<String>>>
      _characteristicPropertiesSubscriptions;

  BlueZAdapter get _adapter => _client.adapters.first;
  CentralState _state;
  @override
  CentralState get state => _state;

  @override
  bool get isDiscovering =>
      state == CentralState.poweredOn ? _adapter.discovering : false;

  @override
  Stream<CentralStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<CentralDiscoveredEventArgs> get discovered =>
      _discoveredController.stream;
  @override
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;
  @override
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged =>
          _characteristicValueChangedController.stream;
  Stream<String> get _servicesResolved => _servicesResolvedController.stream;

  late StreamSubscription<List<String>> _adapterPropertiesChangedSubscription;
  late StreamSubscription<BlueZDevice> _deviceAddedSubscription;
  late StreamSubscription<BlueZDevice> _deviceRemovedSubscription;

  void _throwWithState(CentralState state) {
    if (this.state == state) {
      throw BluetoothLowEnergyError('$state is unexpected.');
    }
  }

  void _throwWithoutState(CentralState state) {
    if (this.state != state) {
      throw BluetoothLowEnergyError(
          '$state is expected, but current state is ${this.state}.',);
    }
  }

  @override
  Future<void> setUp() async {
    _throwWithoutState(CentralState.unknown);
    await _client.connect();
    _state = _client.adapters.isEmpty
        ? CentralState.unsupported
        : _adapter.state;
    _adapterPropertiesChangedSubscription =
        _adapter.propertiesChanged.listen(_onAdapterPropertiesChanged);
    for (var device in _client.devices) {
      _onDeviceAdded(device);
    }
    _deviceAddedSubscription = _client.deviceAdded.listen(_onDeviceAdded);
    _deviceRemovedSubscription = _client.deviceRemoved.listen(_onDeviceRemoved);
  }

  @override
  Future<void> tearDown() async {
    _throwWithState(CentralState.unknown);
    _adapterPropertiesChangedSubscription.cancel();
    _deviceAddedSubscription.cancel();
    _deviceRemovedSubscription.cancel();
    await _client.close();
    _state = CentralState.unknown;
  }

  @override
  Future<void> startDiscovery() async {
    _throwWithoutState(CentralState.poweredOn);
    await _adapter.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    _throwWithoutState(CentralState.poweredOn);
    await _adapter.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    _throwWithoutState(CentralState.poweredOn);
    final device =
        _client.devices.firstWhere((device) => device.address == peripheral);
    await device.connect();
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    _throwWithoutState(CentralState.poweredOn);
    final device = _client.devices.firstWhere((device) => device.address == id);
    await device.disconnect();
  }

  @override
  Future<void> discoverGATT(Peripheral peripheral) {
    _throwWithoutState(CentralState.poweredOn);
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
  }

  @override
  Future<List<GattService>> getServices(Peripheral peripheral) async {
    _throwWithoutState(CentralState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    final device = _client.devices.firstWhere((device) => device.hashCode == myPeripheral.hashCode);
    final services =
        device.gattServices.map((service) => service.myService).toList();
    return services;
  }

  @override
  Future<List<GattCharacteristic>> getCharacteristics(GattService service) {
    // TODO: implement getCharacteristics
    throw UnimplementedError();
  }

  @override
  Future<List<GattDescriptor>> getDescriptors(
    GattCharacteristic characteristic,
  ) {
    // TODO: implement getDescriptors
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readCharacteristic(
    GattCharacteristic characteristic,
  ) async {
    _throwWithoutState(CentralState.poweredOn);
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
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) async {
    _throwWithoutState(CentralState.poweredOn);
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
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) async {
    _throwWithoutState(CentralState.poweredOn);
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
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    _throwWithoutState(CentralState.poweredOn);
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
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) async {
    _throwWithoutState(CentralState.poweredOn);
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
    for (var property in properties) {
      switch (property) {
        case 'Powered':
          final state = _adapter.centralState;
          if (_state == state) {
            return;
          }
          _state = state;
          final eventArgs = CentralStateChangedEventArgs(state);
          _stateChangedController.add(eventArgs);
          break;
        default:
          break;
      }
    }
  }

  void _onDeviceAdded(BlueZDevice device) {
    final subscription = device.propertiesChanged.listen((properties) {
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
