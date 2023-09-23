import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_linux/src/my_event_args.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_gatt_characteristic.dart';
import 'my_gatt_descriptor.dart';
import 'my_gatt_service.dart';
import 'my_peripheral.dart';

class MyCentralController extends CentralController {
  MyCentralController()
      : _client = BlueZClient(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _myPeripheralDiscoveredController = StreamController.broadcast(),
        _devicePropertiesChangedSubscriptions = {},
        _characteristicPropertiesChangedSubscriptions = {},
        _myPeripherals = {},
        _myServices = {},
        _myCharacteristics = {},
        _myDescriptors = {},
        _state = CentralState.unknown;

  final BlueZClient _client;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralStateChangedEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueChangedEventArgs>
      _characteristicValueChangedController;
  final StreamController<MyPeripheralDiscoveredEventArgs>
      _myPeripheralDiscoveredController;
  final Map<int, StreamSubscription<List<String>>>
      _devicePropertiesChangedSubscriptions;
  final Map<int, StreamSubscription<List<String>>>
      _characteristicPropertiesChangedSubscriptions;
  final Map<int, MyPeripheral> _myPeripherals;
  final Map<int, Map<int, MyGattService>> _myServices;
  final Map<int, Map<int, MyGattCharacteristic>> _myCharacteristics;
  final Map<int, Map<int, MyGattDescriptor>> _myDescriptors;

  BlueZAdapter get _adapter => _client.adapters.first;
  CentralState _state;
  @override
  CentralState get state => _state;

  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<DiscoveredEventArgs> get discovered => _discoveredController.stream;
  @override
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;
  @override
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged =>
          _characteristicValueChangedController.stream;
  Stream<MyPeripheralDiscoveredEventArgs> get _myPeripheralDiscovered =>
      _myPeripheralDiscoveredController.stream;

  late StreamSubscription<List<String>> _adapterPropertiesChangedSubscription;
  late StreamSubscription<BlueZDevice> _deviceAddedSubscription;
  late StreamSubscription<BlueZDevice> _deviceRemovedSubscription;

  Future<void> _throwWithState(CentralState state) async {
    if (this.state == state) {
      throw BluetoothLowEnergyError('$state is unexpected.');
    }
  }

  Future<void> _throwWithoutState(CentralState state) async {
    if (this.state != state) {
      throw BluetoothLowEnergyError(
        '$state is expected, but current state is ${this.state}.',
      );
    }
  }

  @override
  Future<void> setUp() async {
    await _throwWithoutState(CentralState.unknown);
    await _client.connect();
    _state =
        _client.adapters.isEmpty ? CentralState.unsupported : _adapter.state;
    if (_state == CentralState.unsupported) {
      return;
    }
    for (var device in _client.devices) {
      if (device.adapter.address != _adapter.address) {
        continue;
      }
      _beginDevicePropertiesChangedListener(device);
    }
    _adapterPropertiesChangedSubscription = _adapter.propertiesChanged.listen(
      _onAdapterPropertiesChanged,
    );
    _deviceAddedSubscription = _client.deviceAdded.listen(_onDeviceAdded);
    _deviceRemovedSubscription = _client.deviceRemoved.listen(_onDeviceRemoved);
  }

  @override
  Future<void> tearDown() async {
    await _throwWithState(CentralState.unknown);
    if (_state != CentralState.unsupported && _adapter.discovering) {
      await _adapter.stopDiscovery();
    }
    for (var myPeripheral in _myPeripherals.values) {
      final device = myPeripheral.device;
      if (device.connected) {
        await device.disconnect();
      }
    }
    _myPeripherals.clear();
    _myServices.clear();
    _myCharacteristics.clear();
    _myDescriptors.clear();
    for (var device in _client.devices) {
      if (device.adapter.address != _adapter.address) {
        continue;
      }
      _endDevicePropertiesChangedListener(device);
    }
    _adapterPropertiesChangedSubscription.cancel();
    _deviceAddedSubscription.cancel();
    _deviceRemovedSubscription.cancel();
    await _client.close();
    _state = CentralState.unknown;
  }

  @override
  Future<void> startDiscovery() async {
    await _throwWithoutState(CentralState.poweredOn);
    await _adapter.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _throwWithoutState(CentralState.poweredOn);
    await _adapter.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    final device = myPeripheral.device;
    await device.connect();
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    final device = myPeripheral.device;
    await device.disconnect();
  }

  @override
  Future<int> getMaximumWriteLength(
    Peripheral peripheral, {
    required GattCharacteristicWriteType type,
  }) async {
    // TODO: 当前版本 `bluez` 插件不支持获取 MTU，返回最小值 20.
    return 20;
  }

  @override
  Future<void> discoverGATT(Peripheral peripheral) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    final device = myPeripheral.device;
    if (!device.connected) {
      throw BluetoothLowEnergyError('Peripheral is disconnected.');
    }
    if (device.servicesResolved) {
      return;
    }
    await _myPeripheralDiscovered.firstWhere(
      (eventArgs) => eventArgs.myPeripheral == myPeripheral,
    );
  }

  @override
  Future<List<GattService>> getServices(Peripheral peripheral) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral;
    final myServices = _myServices[myPeripheral.hashCode];
    if (myServices == null) {
      throw ArgumentError();
    }
    return myServices.values.toList();
  }

  @override
  Future<List<GattCharacteristic>> getCharacteristics(
    GattService service,
  ) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myService = service as MyGattService;
    final myCharacteristics = _myCharacteristics[myService.hashCode];
    if (myCharacteristics == null) {
      throw ArgumentError();
    }
    return myCharacteristics.values.toList();
  }

  @override
  Future<List<GattDescriptor>> getDescriptors(
    GattCharacteristic characteristic,
  ) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final myDescriptors = _myDescriptors[myCharacteristic.hashCode];
    if (myDescriptors == null) {
      throw ArgumentError();
    }
    return myDescriptors.values.toList();
  }

  @override
  Future<Uint8List> readCharacteristic(
    GattCharacteristic characteristic,
  ) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final blueZCharacteristic = myCharacteristic.characteristic;
    final blueZValue = await blueZCharacteristic.readValue();
    return Uint8List.fromList(blueZValue);
  }

  @override
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final blueZCharacteristic = myCharacteristic.characteristic;
    await blueZCharacteristic.writeValue(
      value,
      type: type.toBlueZ(),
    );
  }

  @override
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic;
    final blueZCharacteristic = myCharacteristic.characteristic;
    if (state) {
      await blueZCharacteristic.startNotify();
    } else {
      await blueZCharacteristic.stopNotify();
    }
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myDescriptor = descriptor as MyGattDescriptor;
    final blueZDescriptor = myDescriptor.descriptor;
    final blueZValue = await blueZDescriptor.readValue();
    return Uint8List.fromList(blueZValue);
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) async {
    await _throwWithoutState(CentralState.poweredOn);
    final myDescriptor = descriptor as MyGattDescriptor;
    final blueZDescriptor = myDescriptor.descriptor;
    await blueZDescriptor.writeValue(value);
  }

  void _onAdapterPropertiesChanged(List<String> properties) {
    for (var property in properties) {
      switch (property) {
        case 'Powered':
          final state = _adapter.state;
          if (_state == state) {
            return;
          }
          _state = state;
          final eventArgs = BluetoothLowEnergyStateChangedEventArgs(state);
          _stateChangedController.add(eventArgs);
          break;
        default:
          break;
      }
    }
  }

  void _onDeviceAdded(BlueZDevice device) {
    if (device.adapter.address != _adapter.address) {
      return;
    }
    _onDiscovered(device);
    _beginDevicePropertiesChangedListener(device);
  }

  void _onDeviceRemoved(BlueZDevice device) {
    if (device.adapter.address != _adapter.address) {
      return;
    }
    _endDevicePropertiesChangedListener(device);
  }

  void _onDiscovered(BlueZDevice device) {
    final myPeripheral = MyPeripheral(device);
    _myPeripherals[myPeripheral.hashCode] = myPeripheral;
    final rssi = device.rssi;
    final advertisement = device.advertisement;
    final eventArgs = DiscoveredEventArgs(
      myPeripheral,
      rssi,
      advertisement,
    );
    _discoveredController.add(eventArgs);
  }

  void _beginDevicePropertiesChangedListener(BlueZDevice device) {
    final subscription = device.propertiesChanged.listen((properties) {
      for (var property in properties) {
        switch (property) {
          case 'RSSI':
            _onDiscovered(device);
            break;
          case 'Connected':
            final myPeripheral =
                _myPeripherals[device.hashCode] as MyPeripheral;
            final state = device.connected;
            final eventArgs = PeripheralStateChangedEventArgs(
              myPeripheral,
              state,
            );
            _peripheralStateChangedController.add(eventArgs);
            break;
          case 'UUIDs':
            break;
          case 'ServicesResolved':
            if (device.servicesResolved) {
              final myPeripheral =
                  _myPeripherals[device.hashCode] as MyPeripheral;
              final myServices = <int, MyGattService>{};
              for (var service in device.gattServices) {
                final myService = MyGattService(service);
                myServices[myService.hashCode] = myService;
                final myCharacteristics = <int, MyGattCharacteristic>{};
                for (var characteristic in service.characteristics) {
                  final myCharacteristic = MyGattCharacteristic(characteristic);
                  myCharacteristics[myCharacteristic.hashCode] =
                      myCharacteristic;
                  _beginCharacteristicPropertiesChangedListener(
                    service,
                    characteristic,
                  );
                  final myDescriptors = <int, MyGattDescriptor>{};
                  for (var descriptor in characteristic.descriptors) {
                    final myDescriptor = MyGattDescriptor(descriptor);
                    myDescriptors[myDescriptor.hashCode] = myDescriptor;
                  }
                  _myDescriptors[myCharacteristic.hashCode] = myDescriptors;
                }
                _myCharacteristics[myService.hashCode] = myCharacteristics;
              }
              _myServices[myPeripheral.hashCode] = myServices;
              final eventArgs = MyPeripheralDiscoveredEventArgs(myPeripheral);
              _myPeripheralDiscoveredController.add(eventArgs);
            }
            break;
          default:
            break;
        }
      }
    });
    _devicePropertiesChangedSubscriptions[device.hashCode] = subscription;
  }

  void _endDevicePropertiesChangedListener(BlueZDevice device) {
    for (var service in device.gattServices) {
      for (var characteristic in service.characteristics) {
        _endCharacteristicPropertiesChangedListener(characteristic);
      }
    }
    final subscription = _devicePropertiesChangedSubscriptions.remove(
      device.address,
    );
    subscription?.cancel();
  }

  void _beginCharacteristicPropertiesChangedListener(
    BlueZGattService service,
    BlueZGattCharacteristic characteristic,
  ) {
    final subscription = characteristic.propertiesChanged.listen((properties) {
      for (var property in properties) {
        switch (property) {
          case 'Value':
            final myCharacteristics = _myCharacteristics[service.hashCode];
            if (myCharacteristics == null) {
              throw ArgumentError();
            }
            final myCharacteristic = myCharacteristics[characteristic.hashCode]
                as MyGattCharacteristic;
            final value = Uint8List.fromList(characteristic.value);
            final eventArgs = GattCharacteristicValueChangedEventArgs(
              myCharacteristic,
              value,
            );
            _characteristicValueChangedController.add(eventArgs);
            break;
          default:
            break;
        }
      }
    });
    _characteristicPropertiesChangedSubscriptions[characteristic.hashCode] =
        subscription;
  }

  void _endCharacteristicPropertiesChangedListener(
    BlueZGattCharacteristic characteristic,
  ) {
    final subscription = _characteristicPropertiesChangedSubscriptions.remove(
      characteristic.hashCode,
    );
    subscription?.cancel();
  }
}
