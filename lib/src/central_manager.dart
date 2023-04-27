import 'dart:async';

import 'package:bluetooth_low_energy/src/characteristic_write_type.dart';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:quick_blue/quick_blue.dart';

import 'central_manager_state.dart';
import 'peripheral_state.dart';
import 'errors.dart';
import 'event_args.dart';
import 'peripheral.dart';

abstract class CentralManager extends PlatformInterface {
  /// Constructs a CentralManager.
  CentralManager() : super(token: _token);

  static final Object _token = Object();

  static CentralManager _instance = _CentralManager();

  /// The default instance of [CentralManager] to use.
  static CentralManager get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CentralManager] when
  /// they register themselves.
  static set instance(CentralManager instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ValueListenable<CentralManagerState> get state;

  Stream<PeripheralEventArgs> get scanned;
  Stream<PeripheralStateEventArgs> get peripheralStateChanged;
  Stream<CharacteristicValueEventArgs> get characteristicValueChanged;

  Future<void> initialize();
  Future<void> startScan();
  Future<void> stopScan();
  Future<void> connect(String id);
  void disconnect(String id);
  Future<Uint8List> read(
    String id,
    String serviceId,
    String characteristicId,
  );
  Future<void> write(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value, {
    CharacteristicWriteType? type,
  });
  Future<void> notify(
    String id,
    String serviceId,
    String characteristicId,
    bool value,
  );
}

class _CentralManager extends CentralManager {
  final ValueNotifier<CentralManagerState> _state;
  final StreamController<PeripheralStateEventArgs>
      _peripheralStateChangedController;
  final StreamController<CharacteristicValueEventArgs>
      _characteristicValueChangedController;

  _CentralManager()
      : _state = ValueNotifier(CentralManagerState.unknown),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast() {
    QuickBlue.setConnectionHandler((deviceId, state) {
      final eventArgs = PeripheralStateEventArgs(deviceId, state.toNative());
      _peripheralStateChangedController.add(eventArgs);
    });
    QuickBlue.setValueHandler((deviceId, characteristicId, value) {
      final eventArgs = CharacteristicValueEventArgs(
        deviceId,
        '',
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

  @override
  Stream<CharacteristicValueEventArgs> get characteristicValueChanged =>
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
    CharacteristicWriteType? type,
  }) {
    if (type == null) {
      throw UnimplementedError();
    }
    return QuickBlue.writeValue(
      id,
      serviceId,
      characteristicId,
      value,
      type.toApi(),
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
  PeripheralState toNative() {
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

extension on CharacteristicWriteType {
  BleOutputProperty toApi() {
    switch (this) {
      case CharacteristicWriteType.withResponse:
        return BleOutputProperty.withResponse;
      case CharacteristicWriteType.withoutResponse:
        return BleOutputProperty.withoutResponse;
      default:
        throw UnimplementedError();
    }
  }
}
