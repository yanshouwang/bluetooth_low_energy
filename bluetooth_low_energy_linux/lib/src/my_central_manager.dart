import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_event_args.dart';
import 'my_gatt_characteristic2.dart';
import 'my_gatt_descriptor2.dart';
import 'my_gatt_service2.dart';
import 'my_peripheral2.dart';

class MyCentralManager extends CentralManager {
  MyCentralManager()
      : _client = BlueZClient(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _deviceServicesResolvedController = StreamController.broadcast(),
        _myServicesOfMyPeripherals = {},
        _characteristicPropertiesChangedSubscriptions = {},
        _state = BluetoothLowEnergyState.unknown;

  final BlueZClient _client;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralStateChangedEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueChangedEventArgs>
      _characteristicValueChangedController;
  final StreamController<BlueZDeviceServicesResolvedEventArgs>
      _deviceServicesResolvedController;

  final Map<int, List<MyGattService2>> _myServicesOfMyPeripherals;
  final Map<int, StreamSubscription>
      _characteristicPropertiesChangedSubscriptions;

  BlueZAdapter get _adapter => _client.adapters.first;
  BluetoothLowEnergyState _state;
  @override
  BluetoothLowEnergyState get state => _state;

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
  Stream<BlueZDeviceServicesResolvedEventArgs> get _servicesResolved =>
      _deviceServicesResolvedController.stream;

  Future<void> _throwWithoutState(BluetoothLowEnergyState state) async {
    if (this.state != state) {
      throw BluetoothLowEnergyError(
        '$state is expected, but current state is ${this.state}.',
      );
    }
  }

  @override
  Future<void> setUp() async {
    // TODO: hot restart is not handled.
    await _client.connect();
    _state = _client.adapters.isEmpty
        ? BluetoothLowEnergyState.unsupported
        : _adapter.myState;
    if (_state == BluetoothLowEnergyState.unsupported) {
      return;
    }
    for (var device in _client.devices) {
      if (device.adapter.address != _adapter.address) {
        continue;
      }
      _beginDevicePropertiesChangedListener(device);
    }
    _adapter.propertiesChanged.listen(_onAdapterPropertiesChanged);
    _client.deviceAdded.listen(_onDeviceAdded);
  }

  @override
  Future<void> startDiscovery() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _adapter.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _adapter.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral2;
    final device = myPeripheral.device;
    await device.connect();
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral2;
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
  Future<int> readRSSI(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral2;
    final device = myPeripheral.device;
    return device.rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myPeripheral = peripheral as MyPeripheral2;
    final device = myPeripheral.device;
    if (!device.connected) {
      throw BluetoothLowEnergyError('Peripheral is disconnected.');
    }
    if (!device.servicesResolved) {
      await _servicesResolved.firstWhere(
        (eventArgs) => eventArgs.device == device,
      );
    }
    final myServices = _myServicesOfMyPeripherals[myPeripheral.hashCode];
    if (myServices == null) {
      throw ArgumentError.notNull();
    }
    return myServices;
  }

  @override
  Future<Uint8List> readCharacteristic(
    GattCharacteristic characteristic,
  ) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic2;
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
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic2;
    final blueZCharacteristic = myCharacteristic.characteristic;
    await blueZCharacteristic.writeValue(
      value,
      type: type.toBlueZWriteType(),
    );
  }

  @override
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myCharacteristic = characteristic as MyGattCharacteristic2;
    final blueZCharacteristic = myCharacteristic.characteristic;
    if (state) {
      await blueZCharacteristic.startNotify();
    } else {
      await blueZCharacteristic.stopNotify();
    }
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myDescriptor = descriptor as MyGattDescriptor2;
    final blueZDescriptor = myDescriptor.descriptor;
    final blueZValue = await blueZDescriptor.readValue();
    return Uint8List.fromList(blueZValue);
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    final myDescriptor = descriptor as MyGattDescriptor2;
    final blueZDescriptor = myDescriptor.descriptor;
    await blueZDescriptor.writeValue(value);
  }

  void _onAdapterPropertiesChanged(List<String> properties) {
    for (var property in properties) {
      switch (property) {
        case 'Powered':
          final state = _adapter.myState;
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

  void _onDiscovered(BlueZDevice device) {
    final myPeripheral = MyPeripheral2(device);
    final rssi = device.rssi;
    final advertisement = device.myAdvertisement;
    final eventArgs = DiscoveredEventArgs(
      myPeripheral,
      rssi,
      advertisement,
    );
    _discoveredController.add(eventArgs);
  }

  void _beginDevicePropertiesChangedListener(BlueZDevice device) {
    device.propertiesChanged.listen((properties) {
      for (var property in properties) {
        switch (property) {
          case 'RSSI':
            _onDiscovered(device);
            break;
          case 'Connected':
            final myPeripheral = MyPeripheral2(device);
            final state = device.connected;
            final eventArgs = PeripheralStateChangedEventArgs(
              myPeripheral,
              state,
            );
            _peripheralStateChangedController.add(eventArgs);
            if (!state) {
              _endCharacteristicPropertiesChangedListener(myPeripheral);
            }
            break;
          case 'UUIDs':
            break;
          case 'ServicesResolved':
            if (device.servicesResolved) {
              final myPeripheral = MyPeripheral2(device);
              _endCharacteristicPropertiesChangedListener(myPeripheral);
              final myServices = device.myServices;
              _myServicesOfMyPeripherals[myPeripheral.hashCode] = myServices;
              _beginCharacteristicPropertiesChangedListener(myPeripheral);
              final eventArgs = BlueZDeviceServicesResolvedEventArgs(device);
              _deviceServicesResolvedController.add(eventArgs);
            }
            break;
          default:
            break;
        }
      }
    });
  }

  void _beginCharacteristicPropertiesChangedListener(
    MyPeripheral myPeripheral,
  ) {
    final myServices = _myServicesOfMyPeripherals[myPeripheral.hashCode];
    if (myServices == null) {
      throw ArgumentError.notNull();
    }
    for (var myService in myServices) {
      final myCharacteristics =
          myService.characteristics.cast<MyGattCharacteristic2>();
      for (var myCharacteristic in myCharacteristics) {
        final characteristic = myCharacteristic.characteristic;
        final subscription = characteristic.propertiesChanged.listen(
          (properties) {
            for (var property in properties) {
              switch (property) {
                case 'Value':
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
          },
        );
        _characteristicPropertiesChangedSubscriptions[
            myCharacteristic.hashCode] = subscription;
      }
    }
  }

  void _endCharacteristicPropertiesChangedListener(MyPeripheral myPeripheral) {
    final myServices = _myServicesOfMyPeripherals.remove(myPeripheral.hashCode);
    if (myServices == null) {
      return;
    }
    for (var myService in myServices) {
      final myCharacteristics = myService.characteristics;
      for (var myCharacteristic in myCharacteristics) {
        final subscription = _characteristicPropertiesChangedSubscriptions
            .remove(myCharacteristic.hashCode);
        subscription?.cancel();
      }
    }
  }
}
