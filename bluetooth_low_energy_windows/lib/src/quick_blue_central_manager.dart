import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:quick_blue/quick_blue.dart';

import 'event_args.dart';

class QuickBlueCentralManager extends CentralManager {
  final ValueNotifier<CentralManagerState> _state;
  final StreamController<PeripheralStateEventArgs>
      _peripheralStateChangedController;
  final StreamController<GattServiceEventArgs> _serviceDiscoveredController;
  final StreamController<GattCharacteristicValueEventArgs>
      _characteristicValueChangedController;
  final Map<String, String> _serviceIds;

  QuickBlueCentralManager()
      : _state = ValueNotifier(CentralManagerState.unknown),
        _peripheralStateChangedController = StreamController.broadcast(),
        _serviceDiscoveredController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast(),
        _serviceIds = {} {
    QuickBlue.setConnectionHandler((deviceId, state) {
      final eventArgs = PeripheralStateEventArgs(deviceId, state.toFlutter());
      _peripheralStateChangedController.add(eventArgs);
    });
    QuickBlue.setServiceHandler((deviceId, serviceId, characteristicIds) {
      for (var characteristicId in characteristicIds) {
        _serviceIds['$deviceId->$characteristicId'] = serviceId;
      }
      final characteristics = characteristicIds.map((characteristicId) {
        return GattCharacteristic(
          id: characteristicId,
          canRead: false,
          canWrite: false,
          canWriteWithoutResponse: false,
          canNotify: false,
          descriptors: [],
        );
      }).toList();
      final service = GattService(
        id: serviceId,
        characteristics: characteristics,
      );
      final eventArgs = GattServiceEventArgs(deviceId, service);
      _serviceDiscoveredController.add(eventArgs);
    });
    QuickBlue.setValueHandler((deviceId, characteristicId, value) {
      final serviceId = _serviceIds['$deviceId->$characteristicId']!;
      final eventArgs = GattCharacteristicValueEventArgs(
        deviceId,
        serviceId,
        characteristicId,
        value,
      );
      _characteristicValueChangedController.add(eventArgs);
    });
  }

  @override
  ValueListenable<CentralManagerState> get state => _state;

  @override
  Stream<PeripheralEventArgs> get scanned =>
      QuickBlue.scanResultStream.map((r) {
        final peripheral = Peripheral(
          id: r.deviceId,
          name: r.name,
          rssi: r.rssi,
          manufacturerData: r.manufacturerData,
        );
        return PeripheralEventArgs(peripheral);
      });

  @override
  Stream<PeripheralStateEventArgs> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;

  Stream<GattServiceEventArgs> get _serviceDiscovered =>
      _serviceDiscoveredController.stream;

  @override
  Stream<GattCharacteristicValueEventArgs> get characteristicValueChanged =>
      _characteristicValueChangedController.stream;

  @override
  Future<void> initialize() async {
    final isBluetoothAvailable = await QuickBlue.isBluetoothAvailable();
    _state.value = isBluetoothAvailable
        ? CentralManagerState.poweredOn
        : CentralManagerState.unsupported;
  }

  @override
  Future<void> startScan() {
    return Future.sync(() => QuickBlue.startScan());
  }

  @override
  Future<void> stopScan() {
    return Future.sync(() => QuickBlue.stopScan());
  }

  @override
  Future<void> connect(String id) {
    final completer = Completer<void>();
    final subscription = peripheralStateChanged.listen((eventArgs) {
      if (eventArgs.id != id) {
        return;
      }
      if (eventArgs.state == PeripheralState.connected) {
        completer.complete();
      } else {
        final error = BluetoothLowEnergyError('Connect failed: $eventArgs');
        completer.completeError(error);
      }
    });
    QuickBlue.connect(id);
    return completer.future.whenComplete(() => subscription.cancel());
  }

  @override
  void disconnect(String id) {
    QuickBlue.disconnect(id);
  }

  @override
  Future<GattService> discoverService(String id, String serviceId) {
    final completer = Completer<GattService>();
    final subscription = _serviceDiscovered.listen((eventArgs) {
      if (id != eventArgs.id || serviceId != eventArgs.service.id) {
        return;
      }
      completer.complete(eventArgs.service);
    });
    QuickBlue.discoverServices(id);
    return completer.future.whenComplete(() => subscription.cancel());
  }

  @override
  Future<Uint8List> read(
    String id,
    String serviceId,
    String characteristicId,
  ) {
    final completer = Completer<Uint8List>();
    final subscription = characteristicValueChanged.listen((eventArgs) {
      if (eventArgs.id != id ||
          eventArgs.serviceId != serviceId ||
          eventArgs.characteristicId != characteristicId) {
        return;
      }
      completer.complete(eventArgs.value);
    });
    QuickBlue.readValue(id, serviceId, characteristicId).onError(
      (error, _) {
        final error1 = BluetoothLowEnergyError('$error');
        completer.completeError(error1);
      },
    );
    return completer.future.whenComplete(() => subscription.cancel());
  }

  @override
  Future<void> write(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value, {
    GattCharacteristicWriteType? type,
  }) {
    if (type == null) {
      throw UnimplementedError();
    }
    return QuickBlue.writeValue(
      id,
      serviceId,
      characteristicId,
      value,
      type.toHost(),
    ).onError(
      (error, _) => throw BluetoothLowEnergyError('$error'),
    );
  }

  @override
  Future<void> notify(
    String id,
    String serviceId,
    String characteristicId,
    bool value,
  ) {
    final bleInputProperty =
        value ? BleInputProperty.notification : BleInputProperty.disabled;
    return QuickBlue.setNotifiable(
      id,
      serviceId,
      characteristicId,
      bleInputProperty,
    ).onError(
      (error, _) => throw BluetoothLowEnergyError('$error'),
    );
  }
}

extension on BlueConnectionState {
  PeripheralState toFlutter() {
    switch (this) {
      case BlueConnectionState.disconnected:
        return PeripheralState.disconnected;
      case BlueConnectionState.connected:
        return PeripheralState.connected;
      default:
        throw UnimplementedError();
    }
  }
}

extension on GattCharacteristicWriteType {
  BleOutputProperty toHost() {
    switch (this) {
      case GattCharacteristicWriteType.withResponse:
        return BleOutputProperty.withResponse;
      case GattCharacteristicWriteType.withoutResponse:
        return BleOutputProperty.withoutResponse;
      default:
        throw UnimplementedError();
    }
  }
}
