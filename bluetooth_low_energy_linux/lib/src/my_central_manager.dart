import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';
import 'my_gatt.dart';
import 'my_peripheral.dart';

final class BlueZDeviceServicesResolvedEventArgs extends EventArgs {
  final BlueZDevice device;

  BlueZDeviceServicesResolvedEventArgs(this.device);
}

final class MyCentralManager extends PlatformCentralManager {
  final BlueZClient _blueZClient;
  final StreamController<BluetoothLowEnergyStateChangedEventArgs>
      _stateChangedController;
  final StreamController<DiscoveredEventArgs> _discoveredController;
  final StreamController<PeripheralConnectionStateChangedEventArgs>
      _connectionStateChangedController;
  final StreamController<GATTCharacteristicNotifiedEventArgs>
      _characteristicNotifiedController;
  final StreamController<BlueZDeviceServicesResolvedEventArgs>
      _blueZServicesResolvedController;

  final Map<int, StreamSubscription>
      _blueZCharacteristicPropertiesChangedSubscriptions;
  final Map<String, List<MyGATTService>> _services;

  BluetoothLowEnergyState _state;

  MyCentralManager()
      : _blueZClient = BlueZClient(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _characteristicNotifiedController = StreamController.broadcast(),
        _blueZServicesResolvedController = StreamController.broadcast(),
        _blueZCharacteristicPropertiesChangedSubscriptions = {},
        _services = {},
        _state = BluetoothLowEnergyState.unknown;

  BlueZAdapter get _blueZAdapter => _blueZClient.adapters.first;

  @override
  BluetoothLowEnergyState get state => _state;
  @override
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged =>
      _stateChangedController.stream;
  @override
  Stream<DiscoveredEventArgs> get discovered => _discoveredController.stream;
  @override
  Stream<PeripheralConnectionStateChangedEventArgs>
      get connectionStateChanged => _connectionStateChangedController.stream;
  @override
  Stream<PeripheralMTUChangedEventArgs> get mtuChanged =>
      throw UnsupportedError('mtuChanged is not supported on Linux.');
  @override
  Stream<GATTCharacteristicNotifiedEventArgs> get characteristicNotified =>
      _characteristicNotifiedController.stream;
  Stream<BlueZDeviceServicesResolvedEventArgs> get _blueZServicesResolved =>
      _blueZServicesResolvedController.stream;

  @override
  void initialize() async {
    logger.info('initialize');
    await _blueZClient.connect();
    if (_blueZClient.adapters.isEmpty) {
      _state = BluetoothLowEnergyState.unsupported;
      return;
    }
    _state = _blueZAdapter.myState;
    _blueZAdapter.propertiesChanged.listen(_onBlueZAdapterPropertiesChanged);
    for (var blueZDevice in _blueZClient.devices) {
      if (blueZDevice.adapter.address != _blueZAdapter.address) {
        continue;
      }
      _beginBlueZDevicePropertiesChangedListener(blueZDevice);
    }
    _blueZClient.deviceAdded.listen(_onBlueZClientDeviceAdded);
  }

  @override
  Future<bool> authorize() {
    throw UnsupportedError('authorize is not supported on Linux.');
  }

  @override
  Future<void> showAppSettings() {
    throw UnsupportedError('showAppSettings is not supported on Linux.');
  }

  @override
  Future<void> startDiscovery({
    List<UUID>? serviceUUIDs,
  }) async {
    logger.info('startDiscovery');
    await _blueZAdapter.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    logger.info('stopDiscovery');
    await _blueZAdapter.stopDiscovery();
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() {
    // TODO: implement retrieveConnectedPeripherals
    throw UnimplementedError();
  }

  @override
  Future<void> connect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final blueZDevice = peripheral.blueZDevice;
    final blueZAddress = blueZDevice.address;
    logger.info('connect: $blueZAddress');
    await blueZDevice.connect();
  }

  @override
  Future<void> disconnect(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final blueZDevice = peripheral.blueZDevice;
    final blueZAddress = blueZDevice.address;
    logger.info('disconnect: $blueZAddress');
    await blueZDevice.disconnect();
  }

  @override
  Future<int> requestMTU(
    Peripheral peripheral, {
    required int mtu,
  }) {
    throw UnsupportedError('requestMTU is not supported on Linux.');
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
  Future<int> readRSSI(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final blueZDevice = peripheral.blueZDevice;
    final blueZAddress = blueZDevice.address;
    logger.info('readRSSI: $blueZAddress');
    return blueZDevice.rssi;
  }

  @override
  Future<List<GATTService>> discoverGATT(Peripheral peripheral) async {
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final blueZDevice = peripheral.blueZDevice;
    final blueZAddress = blueZDevice.address;
    logger.info('discoverGATT: $blueZAddress');
    if (!blueZDevice.connected) {
      throw StateError('Peripheral is disconnected.');
    }
    if (!blueZDevice.servicesResolved) {
      await _blueZServicesResolved.firstWhere(
        (eventArgs) => eventArgs.device == blueZDevice,
      );
    }
    final services = _services[blueZAddress] ?? [];
    return services;
  }

  @override
  Future<Uint8List> readCharacteristic(
    Peripheral peripheral,
    GATTCharacteristic characteristic,
  ) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final blueZCharacteristic = characteristic.blueZCharacteristic;
    final blueZUUID = blueZCharacteristic.uuid;
    logger.info('readCharacteristic: $blueZUUID');
    final blueZValue = await blueZCharacteristic.readValue();
    return Uint8List.fromList(blueZValue);
  }

  @override
  Future<void> writeCharacteristic(
    Peripheral peripheral,
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  }) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final blueZCharacteristic = characteristic.blueZCharacteristic;
    final blueZUUID = blueZCharacteristic.uuid;
    final trimmedValue = value.trimGATT();
    final blueZType = type.toBlueZWriteType();
    logger.info('writeCharacteristic: $blueZUUID - $trimmedValue, $blueZType');
    await blueZCharacteristic.writeValue(
      trimmedValue,
      type: blueZType,
    );
  }

  @override
  Future<void> setCharacteristicNotifyState(
    Peripheral peripheral,
    GATTCharacteristic characteristic, {
    required bool state,
  }) async {
    if (characteristic is! MyGATTCharacteristic) {
      throw TypeError();
    }
    final blueZCharacteristic = characteristic.blueZCharacteristic;
    final blueZUUID = blueZCharacteristic.uuid;
    if (state) {
      logger.info('startNotify: $blueZUUID');
      await blueZCharacteristic.startNotify();
    } else {
      logger.info('stopNotify: $blueZUUID');
      await blueZCharacteristic.stopNotify();
    }
  }

  @override
  Future<Uint8List> readDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor,
  ) async {
    if (descriptor is! MyGATTDescriptor) {
      throw TypeError();
    }
    final blueZDescriptor = descriptor.blueZDescriptor;
    final blueZUUID = blueZDescriptor.uuid;
    logger.info('readDescriptor: $blueZUUID');
    final blueZValue = await blueZDescriptor.readValue();
    return Uint8List.fromList(blueZValue);
  }

  @override
  Future<void> writeDescriptor(
    Peripheral peripheral,
    GATTDescriptor descriptor, {
    required Uint8List value,
  }) async {
    if (descriptor is! MyGATTDescriptor) {
      throw TypeError();
    }
    final blueZDescriptor = descriptor.blueZDescriptor;
    final blueZUUID = blueZDescriptor.uuid;
    final trimmedValue = value.trimGATT();
    logger.info('writeDescriptor: $blueZUUID - $trimmedValue');
    await blueZDescriptor.writeValue(trimmedValue);
  }

  void _onBlueZAdapterPropertiesChanged(List<String> blueZAdapterProperties) {
    logger.info('onBlueZAdapterPropertiesChanged: $blueZAdapterProperties');
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
    logger.info('onBlueZClientDeviceAdded: ${blueZDevice.address}');
    if (blueZDevice.adapter.address != _blueZAdapter.address) {
      return;
    }
    _onBlueZDiscovered(blueZDevice);
    _beginBlueZDevicePropertiesChangedListener(blueZDevice);
  }

  void _onBlueZDiscovered(BlueZDevice blueZDevice) {
    final peripheral = MyPeripheral(blueZDevice);
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
      logger.info(
          'onBlueZDevicePropertiesChanged: ${blueZDevice.address}, $blueZDeviceProperties');
      for (var blueZDeviceProperty in blueZDeviceProperties) {
        switch (blueZDeviceProperty) {
          case 'RSSI':
            _onBlueZDiscovered(blueZDevice);
            break;
          case 'Connected':
            final peripheral = MyPeripheral(blueZDevice);
            final state = blueZDevice.connected;
            final eventArgs = ConnectionStateChangedEventArgs(
              peripheral,
              state,
            );
            _connectionStateChangedController.add(eventArgs);
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
            logger.info(
                'onBlueZCharacteristicPropertiesChanged: ${blueZDevice.address}.${blueZCharacteristic.uuid}, $blueZCharacteristicProperties');
            for (var blueZCharacteristicPropety
                in blueZCharacteristicProperties) {
              switch (blueZCharacteristicPropety) {
                case 'Value':
                  final value = Uint8List.fromList(blueZCharacteristic.value);
                  final eventArgs = GattCharacteristicNotifiedEventArgs(
                    characteristic,
                    value,
                  );
                  _characteristicNotifiedController.add(eventArgs);
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
