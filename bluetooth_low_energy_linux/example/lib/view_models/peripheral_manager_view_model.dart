import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_linux_example/models.dart';
import 'package:clover/clover.dart';
import 'package:logging/logging.dart';

class PeripheralManagerViewModel extends ViewModel {
  final PeripheralManager _manager;
  final List<Log> _logs;
  bool _advertising;

  late final StreamSubscription _stateChangedSubscription;
  late final StreamSubscription _characteristicReadRequestedSubscription;
  late final StreamSubscription _characteristicWriteRequestedSubscription;
  late final StreamSubscription _characteristicNotifyStateChangedSubscription;

  PeripheralManagerViewModel()
    : _manager = PeripheralManager()..logLevel = Level.INFO,
      _logs = [],
      _advertising = false {
    _stateChangedSubscription = _manager.stateChanged.listen((eventArgs) {
      notifyListeners();
    });
    _characteristicReadRequestedSubscription = _manager
        .characteristicReadRequested
        .listen((eventArgs) async {
          final central = eventArgs.central;
          final characteristic = eventArgs.characteristic;
          final request = eventArgs.request;
          final offset = request.offset;
          final log = Log(
            type: 'Characteristic read requested',
            message: '${central.uuid}, ${characteristic.uuid}, $offset',
          );
          _logs.add(log);
          notifyListeners();
          final elements = List.generate(100, (i) => i % 256);
          final value = Uint8List.fromList(elements);
          final trimmedValue = value.sublist(offset);
          await _manager.respondReadRequestWithValue(
            request,
            value: trimmedValue,
          );
        });
    _characteristicWriteRequestedSubscription = _manager
        .characteristicWriteRequested
        .listen((eventArgs) async {
          final central = eventArgs.central;
          final characteristic = eventArgs.characteristic;
          final request = eventArgs.request;
          final offset = request.offset;
          final value = request.value;
          final log = Log(
            type: 'Characteristic write requested',
            message:
                '[${value.length}] ${central.uuid}, ${characteristic.uuid}, $offset, $value',
          );
          _logs.add(log);
          notifyListeners();
          await _manager.respondWriteRequest(request);
        });
    _characteristicNotifyStateChangedSubscription = _manager
        .characteristicNotifyStateChanged
        .listen((eventArgs) async {
          final central = eventArgs.central;
          final characteristic = eventArgs.characteristic;
          final state = eventArgs.state;
          final log = Log(
            type: 'Characteristic notify state changed',
            message: '${central.uuid}, ${characteristic.uuid}, $state',
          );
          _logs.add(log);
          notifyListeners();
          // Write someting to the central when notify started.
          if (state) {
            final maximumNotifyLength = await _manager.getMaximumNotifyLength(
              central,
            );
            final elements = List.generate(maximumNotifyLength, (i) => i % 256);
            final value = Uint8List.fromList(elements);
            await _manager.notifyCharacteristic(
              characteristic,
              value: value,
              central: central,
            );
          }
        });
  }

  BluetoothLowEnergyState get state => _manager.state;
  bool get advertising => _advertising;
  List<Log> get logs => _logs;

  Future<void> startAdvertising() async {
    if (_advertising) {
      return;
    }
    await _manager.removeAllServices();
    final elements = List.generate(100, (i) => i % 256);
    final value = Uint8List.fromList(elements);
    final service = GATTService(
      uuid: UUID.short(100),
      isPrimary: true,
      includedServices: [],
      characteristics: [
        GATTCharacteristic.immutable(
          uuid: UUID.short(200),
          value: value,
          descriptors: [],
        ),
        GATTCharacteristic.mutable(
          uuid: UUID.short(201),
          properties: [
            GATTCharacteristicProperty.read,
            GATTCharacteristicProperty.write,
            GATTCharacteristicProperty.writeWithoutResponse,
            GATTCharacteristicProperty.notify,
            GATTCharacteristicProperty.indicate,
          ],
          permissions: [GATTPermission.read, GATTPermission.write],
          descriptors: [],
        ),
      ],
    );
    await _manager.addService(service);
    final advertisement = Advertisement(
      manufacturerSpecificData: [
        ManufacturerSpecificData(
          id: 0x2e19,
          data: Uint8List.fromList([0x01, 0x02, 0x03]),
        ),
      ],
    );
    await _manager.startAdvertising(advertisement);
    _advertising = true;
    notifyListeners();
  }

  Future<void> stopAdvertising() async {
    if (!_advertising) {
      return;
    }
    await _manager.stopAdvertising();
    _advertising = false;
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _stateChangedSubscription.cancel();
    _characteristicReadRequestedSubscription.cancel();
    _characteristicWriteRequestedSubscription.cancel();
    _characteristicNotifyStateChangedSubscription.cancel();
    super.dispose();
  }
}
