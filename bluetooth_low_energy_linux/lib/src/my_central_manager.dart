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

  final Map<String, List<MyGATTService>> _services;
  final Map<int, StreamSubscription>
      _blueZCharacteristicPropertiesChangedSubscriptions;

  BluetoothLowEnergyState _state;
  bool _discovering;
  int _readCount;

  MyCentralManager()
      : _blueZClient = BlueZClient(),
        _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _connectionStateChangedController = StreamController.broadcast(),
        _characteristicNotifiedController = StreamController.broadcast(),
        _blueZServicesResolvedController = StreamController.broadcast(),
        _services = {},
        _blueZCharacteristicPropertiesChangedSubscriptions = {},
        _state = BluetoothLowEnergyState.unknown,
        _discovering = false,
        _readCount = 0;

  BlueZAdapter get _blueZAdapter => _blueZClient.adapters.first;

  @override
  BluetoothLowEnergyState get state => _state;
  set state(BluetoothLowEnergyState value) {
    if (_state == value) {
      return;
    }
    logger.info('onStateChagned: $value');
    _state = value;
    final eventArgs = BluetoothLowEnergyStateChangedEventArgs(value);
    _stateChangedController.add(eventArgs);
  }

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
    // Here we use `Future()` to make it possible to change the `logLevel` before `initialize()`.
    await Future(() async {
      try {
        logger.info('initialize');
        await _blueZClient.connect();
        if (_blueZClient.adapters.isEmpty) {
          state = BluetoothLowEnergyState.unsupported;
        } else {
          state = _blueZAdapter.myState;
          _blueZAdapter.propertiesChanged
              .listen(_onBlueZAdapterPropertiesChanged);
          for (var blueZDevice in _blueZClient.devices) {
            if (blueZDevice.adapter.address != _blueZAdapter.address) {
              continue;
            }
            _beginBlueZDevicePropertiesChangedListener(blueZDevice);
          }
          _blueZClient.deviceAdded.listen(_onBlueZClientDeviceAdded);
        }
      } catch (e) {
        logger.severe('initialize failed.', e);
      }
    });
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
    await _blueZAdapter.setDiscoveryFilter(
      uuids: serviceUUIDs?.map((uuid) => '$uuid').toList(),
    );
    await _blueZAdapter.startDiscovery();
    _discovering = true;
  }

  @override
  Future<void> stopDiscovery() async {
    logger.info('stopDiscovery');
    await _blueZAdapter.stopDiscovery();
    _discovering = false;
  }

  @override
  Future<List<Peripheral>> retrieveConnectedPeripherals() {
    logger.info('retrieveConnectedPeripherals');
    final peripherals = _blueZClient.devices
        .where((blueZDevice) =>
            blueZDevice.adapter.address == _blueZAdapter.address &&
            blueZDevice.connected)
        .map((blueZDevice) => MyPeripheral(blueZDevice))
        .toList();
    return Future.value(peripherals);
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
    if (peripheral is! MyPeripheral) {
      throw TypeError();
    }
    final blueZDevice = peripheral.blueZDevice;
    final blueZAddress = blueZDevice.address;
    logger.info('getMaximumWriteLength: $blueZAddress');
    final blueZMTU = blueZDevice.gattServices
        .firstWhere((service) => service.characteristics.isNotEmpty)
        .characteristics
        .first
        .mtu;
    if (blueZMTU == null) {
      throw ArgumentError.notNull();
    }
    final maximumWriteLength = (blueZMTU - 3).clamp(20, 512);
    return Future.value(maximumWriteLength);
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
    _readCount++;
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
    final blueZType = type.toBlueZWriteType();
    logger.info('writeCharacteristic: $blueZUUID - $value, $blueZType');
    await blueZCharacteristic.writeValue(
      value,
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
          state = _blueZAdapter.myState;
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
    if (_discovering) {
      _onBlueZDiscovered(blueZDevice);
    }
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
            if (_discovering) {
              _onBlueZDiscovered(blueZDevice);
            }
            break;
          case 'Connected':
            final connected = blueZDevice.connected;
            if (!connected) {
              _endBlueZCharacteristicPropertiesChangedListener(blueZDevice);
            }
            final peripheral = MyPeripheral(blueZDevice);
            final state = blueZDevice.connected
                ? ConnectionState.connected
                : ConnectionState.disconnected;
            final eventArgs = PeripheralConnectionStateChangedEventArgs(
              peripheral,
              state,
            );
            _connectionStateChangedController.add(eventArgs);
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
    final peripheral = MyPeripheral(blueZDevice);
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
                  if (_readCount > 0) {
                    _readCount--;
                    return;
                  }
                  final value = Uint8List.fromList(blueZCharacteristic.value);
                  final eventArgs = GATTCharacteristicNotifiedEventArgs(
                    peripheral,
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
