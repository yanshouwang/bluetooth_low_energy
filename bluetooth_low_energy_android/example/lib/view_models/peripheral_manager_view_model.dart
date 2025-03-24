import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_android_example/models.dart';
import 'package:clover/clover.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:logging/logging.dart';

class PeripheralManagerViewModel extends ViewModel with TypeLogger {
  final PeripheralManager _peripheralManager;
  final List<Log> _logs;
  BluetoothLowEnergyState _state;
  bool _advertising;

  late final StreamSubscription _stateChangedSubscription;
  late final StreamSubscription _characteristicReadRequestedSubscription;
  late final StreamSubscription _characteristicWriteRequestedSubscription;
  late final StreamSubscription _characteristicNotifyStateChangedSubscription;

  PeripheralManagerViewModel()
    : _peripheralManager = PeripheralManager()..logLevel = Level.INFO,
      _logs = [],
      _state = BluetoothLowEnergyState.unknown,
      _advertising = false {
    _stateChangedSubscription = _peripheralManager.stateChanged.listen((
      event,
    ) async {
      _state = event.state;
      notifyListeners();
      if (state == BluetoothLowEnergyState.unauthorized) {
        final shouldShowRationale =
            await _peripheralManager.shouldShowAuthorizeRationale();
        logger.info('SHOULD SHOW RATIONALE: $shouldShowRationale');
        if (shouldShowRationale) {
          return;
        }
        await _peripheralManager.authorize();
      }
    });
    _characteristicReadRequestedSubscription = _peripheralManager
        .characteristicReadRequested
        .listen((event) async {
          final central = event.central;
          final characteristic = event.characteristic;
          final request = event.request;
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
          await _peripheralManager.respondReadRequestWithValue(
            request,
            value: trimmedValue,
          );
        });
    _characteristicWriteRequestedSubscription = _peripheralManager
        .characteristicWriteRequested
        .listen((event) async {
          final central = event.central;
          final characteristic = event.characteristic;
          final request = event.request;
          final offset = request.offset;
          final value = request.value;
          final log = Log(
            type: 'Characteristic write requested',
            message:
                '[${value.length}] ${central.uuid}, ${characteristic.uuid}, $offset, $value',
          );
          _logs.add(log);
          notifyListeners();
          await _peripheralManager.respondWriteRequest(request);
        });
    _characteristicNotifyStateChangedSubscription = _peripheralManager
        .characteristicNotifyStateChanged
        .listen((event) async {
          final central = event.central;
          final characteristic = event.characteristic;
          final state = event.state;
          final log = Log(
            type: 'Characteristic notify state changed',
            message: '${central.uuid}, ${characteristic.uuid}, $state',
          );
          _logs.add(log);
          notifyListeners();
          // Write someting to the central when notify started.
          if (state) {
            final maximumNotifyLength = await _peripheralManager
                .getMaximumNotifyLength(central);
            final elements = List.generate(maximumNotifyLength, (i) => i % 256);
            final value = Uint8List.fromList(elements);
            await _peripheralManager.notifyCharacteristic(
              characteristic,
              value: value,
            );
          }
        });
    _initialize();
  }

  void _initialize() async {
    _state = await _peripheralManager.getState();
    notifyListeners();
  }

  BluetoothLowEnergyState get state => _state;
  bool get advertising => _advertising;
  List<Log> get logs => _logs;

  Future<void> showAppSettings() async {
    await _peripheralManager.showAppSettings();
  }

  Future<void> turnOn() async {
    await _peripheralManager.turnOn();
  }

  Future<void> turnOff() async {
    await _peripheralManager.turnOff();
  }

  Future<void> startAdvertising() async {
    if (_advertising) {
      return;
    }
    await _peripheralManager.removeAllServices();
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
    await _peripheralManager.addService(service);
    final advertisement = Advertisement(
      manufacturerSpecificData: [
        ManufacturerSpecificData(
          id: 0x2e19,
          data: Uint8List.fromList([0x01, 0x02, 0x03]),
        ),
      ],
    );
    // await _manager.setName('BLE-12138');
    await _peripheralManager.startAdvertising(
      advertisement,
      includeDeviceName: true,
    );
    _advertising = true;
    notifyListeners();
  }

  Future<void> stopAdvertising() async {
    if (!_advertising) {
      return;
    }
    await _peripheralManager.stopAdvertising();
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
