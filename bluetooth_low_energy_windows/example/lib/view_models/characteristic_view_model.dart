import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_windows_example/models.dart';

import 'descriptor_view_model.dart';
import 'view_model.dart';

class CharacteristicViewModel extends ViewModel {
  final CentralManager _manager;
  final Peripheral _peripheral;
  final GATTCharacteristic _characteristic;
  final List<DescriptorViewModel> _descriptorViewModels;
  final List<Log> _logs;

  GATTCharacteristicWriteType _writeType;
  bool _notifyState;

  late final StreamSubscription _characteristicNotifiedSubscription;

  CharacteristicViewModel({
    required CentralManager manager,
    required Peripheral peripheral,
    required GATTCharacteristic characteristic,
  })  : _manager = manager,
        _peripheral = peripheral,
        _characteristic = characteristic,
        _descriptorViewModels = characteristic.descriptors
            .map((descriptor) => DescriptorViewModel(descriptor))
            .toList(),
        _logs = [],
        _writeType = GATTCharacteristicWriteType.withResponse,
        _notifyState = false {
    if (!canWrite && canWriteWithoutResponse) {
      _writeType = GATTCharacteristicWriteType.withoutResponse;
    }
    _characteristicNotifiedSubscription =
        _manager.characteristicNotified.listen((eventArgs) {
      if (eventArgs.characteristic != _characteristic) {
        return;
      }
      final log = Log(
        type: 'Notified',
        message: '[${eventArgs.value.length}] ${eventArgs.value}',
      );
      _logs.add(log);
      notifyListeners();
    });
  }

  UUID get uuid => _characteristic.uuid;
  bool get canRead =>
      _characteristic.properties.contains(GATTCharacteristicProperty.read);
  bool get canWrite =>
      _characteristic.properties.contains(GATTCharacteristicProperty.write);
  bool get canWriteWithoutResponse => _characteristic.properties
      .contains(GATTCharacteristicProperty.writeWithoutResponse);
  bool get canNotify =>
      _characteristic.properties.contains(GATTCharacteristicProperty.notify) ||
      _characteristic.properties.contains(GATTCharacteristicProperty.indicate);
  List<DescriptorViewModel> get descriptorViewModels => _descriptorViewModels;
  List<Log> get logs => _logs;
  GATTCharacteristicWriteType get writeType => _writeType;
  bool get notifyState => _notifyState;

  Future<void> read() async {
    final value = await _manager.readCharacteristic(
      _peripheral,
      _characteristic,
    );
    final log = Log(
      type: 'Read',
      message: '[${value.length}] $value',
    );
    _logs.add(log);
    notifyListeners();
  }

  void setWriteType(GATTCharacteristicWriteType type) {
    if (type == GATTCharacteristicWriteType.withResponse && !canWrite) {
      throw ArgumentError.value(type);
    }
    if (type == GATTCharacteristicWriteType.withoutResponse &&
        !canWriteWithoutResponse) {
      throw ArgumentError.value(type);
    }
    _writeType = type;
    notifyListeners();
  }

  Future<void> write(Uint8List value) async {
    // Fragments the value by maximumWriteLength.
    final fragmentSize = await _manager.getMaximumWriteLength(
      _peripheral,
      type: writeType,
    );
    var start = 0;
    while (start < value.length) {
      final end = start + fragmentSize;
      final fragmentedValue =
          end < value.length ? value.sublist(start, end) : value.sublist(start);
      final type = writeType;
      await _manager.writeCharacteristic(
        _peripheral,
        _characteristic,
        value: fragmentedValue,
        type: type,
      );
      final log = Log(
        type: type == GATTCharacteristicWriteType.withResponse
            ? 'Write'
            : 'Write without response',
        message: '[${value.length}] $value',
      );
      _logs.add(log);
      notifyListeners();
      start = end;
    }
  }

  Future<void> setNotifyState(bool state) async {
    await _manager.setCharacteristicNotifyState(
      _peripheral,
      _characteristic,
      state: state,
    );
    _notifyState = state;
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _characteristicNotifiedSubscription.cancel();
    for (var descriptorViewModel in descriptorViewModels) {
      descriptorViewModel.dispose();
    }
    super.dispose();
  }
}
