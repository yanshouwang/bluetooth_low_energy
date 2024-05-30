import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_windows_example/models.dart';

import 'view_model.dart';

class PeripheralViewModel extends ViewModel {
  final CentralManager _manager;
  final Peripheral _peripheral;
  final String? _name;
  bool _connected;
  List<GATTService> _services;
  final List<Log> _logs;

  late final StreamSubscription _connectionStateChangedSubscription;
  late final StreamSubscription _mtuChangedChangedSubscription;
  late final StreamSubscription _characteristicNotifiedChangedSubscription;

  PeripheralViewModel(DiscoveredEventArgs eventArgs)
      : _manager = CentralManager(),
        _peripheral = eventArgs.peripheral,
        _name = eventArgs.advertisement.name,
        _connected = false,
        _services = [],
        _logs = [] {
    _connectionStateChangedSubscription =
        _manager.connectionStateChanged.listen((eventArgs) {
      if (eventArgs.peripheral.uuid != uuid) {
        return;
      }
      final connected = eventArgs.state == ConnectionState.connected;
      _setConnected(connected);
    });
    _mtuChangedChangedSubscription = _manager.mtuChanged.listen((eventArgs) {
      if (eventArgs.peripheral.uuid != uuid) {
        return;
      }
      final log = Log('MTU chanaged: ${eventArgs.mtu}');
      _addLog(log);
    });
    _characteristicNotifiedChangedSubscription =
        _manager.characteristicNotified.listen((eventArgs) {
      if (eventArgs.peripheral.uuid != uuid) {
        return;
      }
      final log =
          Log('Notified: ${eventArgs.characteristic.uuid}, ${eventArgs.value}');
      _addLog(log);
    });
  }

  UUID get uuid => _peripheral.uuid;
  String? get name => _name;
  bool get connected => _connected;
  List<GATTService> get services => _services;
  List<Log> get logs => _logs;

  Future<void> connect() async {
    await _manager.connect(_peripheral);
  }

  Future<void> disconnect() async {
    await _manager.disconnect(_peripheral);
  }

  Future<void> discoverGATT() async {
    _services = await _manager.discoverGATT(_peripheral);
    notifyListeners();
  }

  Future<void> readCharacteristic(GATTCharacteristic characteristic) async {
    final value = await _manager.readCharacteristic(
      _peripheral,
      characteristic,
    );
    final log = Log('readCharacteristic: ${characteristic.uuid}, $value');
    _addLog(log);
  }

  Future<void> writeCharacteristic(
    GATTCharacteristic characteristic, {
    required Uint8List value,
    required GATTCharacteristicWriteType type,
  }) async {
    // Fragments the value by maximumWriteLength.
    final fragmentSize = await _manager.getMaximumWriteLength(
      _peripheral,
      type: type,
    );
    var start = 0;
    while (start < value.length) {
      final end = start + fragmentSize;
      final fragmentedValue =
          end < value.length ? value.sublist(start, end) : value.sublist(start);
      await _manager.writeCharacteristic(
        _peripheral,
        characteristic,
        value: fragmentedValue,
        type: type,
      );
      final log = Log('writeCharacteristic: ${characteristic.uuid}, $value');
      _addLog(log);
      start = end;
    }
  }

  Future<void> setCharacteristicNotifyState(
    GATTCharacteristic characteristic, {
    required bool state,
  }) async {
    await _manager.setCharacteristicNotifyState(
      _peripheral,
      characteristic,
      state: state,
    );
    final log =
        Log('setCharacteristicNotifyState: ${characteristic.uuid}, $state');
    _addLog(log);
  }

  void _setConnected(bool value) {
    if (value == _connected) {
      return;
    }
    _connected = value;
    notifyListeners();
  }

  void _addLog(Log log) {
    _logs.add(log);
    notifyListeners();
  }

  @override
  void dispose() {
    _connectionStateChangedSubscription.cancel();
    _mtuChangedChangedSubscription.cancel();
    _characteristicNotifiedChangedSubscription.cancel();
    super.dispose();
  }
}
