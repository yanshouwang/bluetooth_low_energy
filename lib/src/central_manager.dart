import 'dart:async';
import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:quick_blue/quick_blue.dart';

import 'connection_state.dart';
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

  Stream<PeripheralEventArgs> get scanned;
  Stream<ConnectionStateEventArgs> get stateChanged;
  Stream<CharacteristicValueEventArgs> get valueChanged;

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
    bool withoutResponse = false,
  });
  Future<void> notify(
    String id,
    String serviceId,
    String characteristicId,
    bool value,
  );
}

class _CentralManager extends CentralManager {
  final StreamController<ConnectionStateEventArgs> _stateChangedController;
  final StreamController<CharacteristicValueEventArgs> _valueChangedController;

  _CentralManager()
      : _stateChangedController = StreamController.broadcast(),
        _valueChangedController = StreamController.broadcast() {
    QuickBlue.setConnectionHandler((deviceId, state) {
      final eventArgs = ConnectionStateEventArgs(deviceId, state.toNative());
      _stateChangedController.add(eventArgs);
    });
    QuickBlue.setValueHandler((deviceId, characteristicId, value) {
      final eventArgs = CharacteristicValueEventArgs(
        deviceId,
        '',
        characteristicId,
        value,
      );
      _valueChangedController.add(eventArgs);
    });
  }

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
  Stream<ConnectionStateEventArgs> get stateChanged =>
      _stateChangedController.stream;

  @override
  Stream<CharacteristicValueEventArgs> get valueChanged =>
      _valueChangedController.stream;

  @override
  Future<void> connect(String id) {
    final completer = Completer<void>();
    final subscription = stateChanged.listen((eventArgs) {
      if (eventArgs.id != id) {
        return;
      }
      if (eventArgs.state == ConnectionState.connected) {
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

  @override
  Future<Uint8List> read(
    String id,
    String serviceId,
    String characteristicId,
  ) {
    final completer = Completer<Uint8List>();
    final subscription = valueChanged.listen((eventArgs) {
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
  Future<void> startScan() {
    return Future.sync(() => QuickBlue.startScan());
  }

  @override
  Future<void> stopScan() {
    return Future.sync(() => QuickBlue.stopScan());
  }

  @override
  Future<void> write(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value, {
    bool withoutResponse = false,
  }) {
    final bleOutputProperty = withoutResponse
        ? BleOutputProperty.withoutResponse
        : BleOutputProperty.withResponse;
    return QuickBlue.writeValue(
      id,
      serviceId,
      characteristicId,
      value,
      bleOutputProperty,
    ).onError(
      (error, _) => throw BluetoothLowEnergyError('$error'),
    );
  }
}

extension on BlueConnectionState {
  ConnectionState toNative() {
    switch (this) {
      case BlueConnectionState.disconnected:
        return ConnectionState.disconnected;
      case BlueConnectionState.connected:
        return ConnectionState.connected;
      default:
        throw ArgumentError.value(this);
    }
  }
}
