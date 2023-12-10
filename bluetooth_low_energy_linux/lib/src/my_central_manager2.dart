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

class MyCentralManager2 extends MyCentralManager {
  final BlueZClient _blueZClient;
  BluetoothLowEnergyState _state;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralStateChangedEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattCharacteristicValueChangedEventArgs>
      _characteristicValueChangedController;
  final StreamController<BlueZDeviceServicesResolvedEventArgs>
      _blueZServicesResolvedController;
  final Map<int, StreamSubscription>
      _blueZCharacteristicPropertiesChangedSubscriptions;
  final Map<String, List<MyGattService2>> _services;

  MyCentralManager2()
      : _blueZClient = BlueZClient(),
        _state = BluetoothLowEnergyState.unknown,
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _blueZServicesResolvedController = StreamController.broadcast(),
        _blueZCharacteristicPropertiesChangedSubscriptions = {},
        _services = {};

  BlueZAdapter get _blueZAdapter => _blueZClient.adapters.first;
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
  Stream<BlueZDeviceServicesResolvedEventArgs> get _blueZServicesResolved =>
      _blueZServicesResolvedController.stream;

  Future<void> _throwWithoutState(BluetoothLowEnergyState state) async {
    if (this.state != state) {
      throw StateError(
          '$state is expected, but current state is ${this.state}.');
    }
  }

  @override
  Future<void> setUp() async {
    await _blueZClient.connect();
    _state = _blueZClient.adapters.isEmpty
        ? BluetoothLowEnergyState.unsupported
        : _blueZAdapter.myState;
    if (_state == BluetoothLowEnergyState.unsupported) {
      return;
    }
    for (var blueZDevice in _blueZClient.devices) {
      if (blueZDevice.adapter.address != _blueZAdapter.address) {
        continue;
      }
      _beginBlueZDevicePropertiesChangedListener(blueZDevice);
    }
    _blueZAdapter.propertiesChanged.listen(_onBlueZAdapterPropertiesChanged);
    _blueZClient.deviceAdded.listen(_onBlueZClientDeviceAdded);
  }

  @override
  Future<void> startDiscovery() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _blueZAdapter.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    await _blueZAdapter.stopDiscovery();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final blueZDevice = peripheral.blueZDevice;
    await blueZDevice.connect();
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final blueZDevcie = peripheral.blueZDevice;
    await blueZDevcie.disconnect();
  }

  @override
  Future<int> readRSSI(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final blueZDevice = peripheral.blueZDevice;
    return blueZDevice.rssi;
  }

  @override
  Future<List<GattService>> discoverGATT(Peripheral peripheral) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (peripheral is! MyPeripheral2) {
      throw TypeError();
    }
    final blueZDevice = peripheral.blueZDevice;
    if (!blueZDevice.connected) {
      throw StateError('Peripheral is disconnected.');
    }
    if (!blueZDevice.servicesResolved) {
      await _blueZServicesResolved.firstWhere(
        (eventArgs) => eventArgs.device == blueZDevice,
      );
    }
    final services = _services[blueZDevice.address] ?? [];
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
    GattCharacteristic characteristic,
  ) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final blueZCharacteristic = characteristic.blueZCharacteristic;
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
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final blueZCharacteristic = characteristic.blueZCharacteristic;
    if (type == GattCharacteristicWriteType.withoutResponse) {
      // When write without response, fragments the value by 512 bytes.
      var start = 0;
      while (start < value.length) {
        final end = start + 512;
        final trimmedValue = end < value.length
            ? value.sublist(start, end)
            : value.sublist(start);
        await blueZCharacteristic.writeValue(
          trimmedValue,
          type: type.toBlueZWriteType(),
        );
        start = end;
      }
    } else {
      await blueZCharacteristic.writeValue(
        value,
        type: type.toBlueZWriteType(),
      );
    }
  }

  @override
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (characteristic is! MyGattCharacteristic2) {
      throw TypeError();
    }
    final blueZCharacteristic = characteristic.blueZCharacteristic;
    if (state) {
      await blueZCharacteristic.startNotify();
    } else {
      await blueZCharacteristic.stopNotify();
    }
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final blueZDescriptor = descriptor.blueZDescriptor;
    final blueZValue = await blueZDescriptor.readValue();
    return Uint8List.fromList(blueZValue);
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) async {
    await _throwWithoutState(BluetoothLowEnergyState.poweredOn);
    if (descriptor is! MyGattDescriptor2) {
      throw TypeError();
    }
    final blueZDescriptor = descriptor.blueZDescriptor;
    await blueZDescriptor.writeValue(value);
  }

  void _onBlueZAdapterPropertiesChanged(List<String> blueZAdapterProperties) {
    for (var blueZAdapterProperty in blueZAdapterProperties) {
      switch (blueZAdapterProperty) {
        case 'Powered':
          final state = _blueZAdapter.myState;
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

  void _onBlueZClientDeviceAdded(BlueZDevice blueZDevice) {
    if (blueZDevice.adapter.address != _blueZAdapter.address) {
      return;
    }
    _onBlueZDiscovered(blueZDevice);
    _beginBlueZDevicePropertiesChangedListener(blueZDevice);
  }

  void _onBlueZDiscovered(BlueZDevice blueZDevice) {
    final peripheral = MyPeripheral2(blueZDevice);
    final rssi = blueZDevice.rssi;
    final advertisement = blueZDevice.myAdvertisement;
    final eventArgs = DiscoveredEventArgs(
      peripheral,
      rssi,
      advertisement,
    );
    _discoveredController.add(eventArgs);
  }

  void _beginBlueZDevicePropertiesChangedListener(BlueZDevice blueZDevice) {
    blueZDevice.propertiesChanged.listen((blueZDeviceProperties) {
      for (var blueZDeviceProperty in blueZDeviceProperties) {
        switch (blueZDeviceProperty) {
          case 'RSSI':
            _onBlueZDiscovered(blueZDevice);
            break;
          case 'Connected':
            final peripheral = MyPeripheral2(blueZDevice);
            final state = blueZDevice.connected;
            final eventArgs = PeripheralStateChangedEventArgs(
              peripheral,
              state,
            );
            _peripheralStateChangedController.add(eventArgs);
            if (!state) {
              _endBlueZCharacteristicPropertiesChangedListener(blueZDevice);
            }
            break;
          case 'UUIDs':
            break;
          case 'ServicesResolved':
            if (blueZDevice.servicesResolved) {
              _endBlueZCharacteristicPropertiesChangedListener(blueZDevice);
              _services[blueZDevice.address] = blueZDevice.myServices;
              _beginBlueZCharacteristicPropertiesChangedListener(blueZDevice);
              final eventArgs =
                  BlueZDeviceServicesResolvedEventArgs(blueZDevice);
              _blueZServicesResolvedController.add(eventArgs);
            }
            break;
          default:
            break;
        }
      }
    });
  }

  void _beginBlueZCharacteristicPropertiesChangedListener(
    BlueZDevice blueZDevice,
  ) {
    final services = _services[blueZDevice.address];
    if (services == null) {
      return;
    }
    for (var service in services) {
      final characteristics = service.characteristics;
      for (var characteristic in characteristics) {
        final blueZCharacteristic = characteristic.blueZCharacteristic;
        final subscription = blueZCharacteristic.propertiesChanged.listen(
          (blueZCharacteristicProperties) {
            for (var blueZCharacteristicPropety
                in blueZCharacteristicProperties) {
              switch (blueZCharacteristicPropety) {
                case 'Value':
                  final value = Uint8List.fromList(blueZCharacteristic.value);
                  final eventArgs = GattCharacteristicValueChangedEventArgs(
                    characteristic,
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
        _blueZCharacteristicPropertiesChangedSubscriptions[
            blueZCharacteristic.hashCode] = subscription;
      }
    }
  }

  void _endBlueZCharacteristicPropertiesChangedListener(
    BlueZDevice blueZDevice,
  ) {
    final services = _services.remove(blueZDevice.address);
    if (services == null) {
      return;
    }
    for (var service in services) {
      final characteristics = service.characteristics;
      for (var characteristic in characteristics) {
        final blueZCharacteristic = characteristic.blueZCharacteristic;
        final subscription = _blueZCharacteristicPropertiesChangedSubscriptions
            .remove(blueZCharacteristic.hashCode);
        subscription?.cancel();
      }
    }
  }
}
