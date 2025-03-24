import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:clover/clover.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:logging/logging.dart';

class CentralManagerViewModel extends ViewModel with TypeLogger {
  final CentralManager _centralManager;
  final List<DiscoveredEvent> _discoveries;
  BluetoothLowEnergyState _state;
  bool _discovering;

  late final StreamSubscription _stateChangedSubscription;
  late final StreamSubscription _discoveredSubscription;

  CentralManagerViewModel()
    : _centralManager = CentralManager()..logLevel = Level.INFO,
      _discoveries = [],
      _state = BluetoothLowEnergyState.unknown,
      _discovering = false {
    _stateChangedSubscription = _centralManager.stateChanged.listen((
      event,
    ) async {
      if (event.state == BluetoothLowEnergyState.unauthorized) {
        final shouldShowRationale =
            await _centralManager.shouldShowAuthorizeRationale();
        logger.info('SHOUD SHOW RATIONALE: $shouldShowRationale');
        if (shouldShowRationale) {
          return;
        }
        await _centralManager.authorize();
      }
      _state = await _centralManager.getState();
      notifyListeners();
    });
    _discoveredSubscription = _centralManager.discovered.listen((event) {
      final peripheral = event.peripheral;
      final index = _discoveries.indexWhere((i) => i.peripheral == peripheral);
      if (index < 0) {
        _discoveries.add(event);
      } else {
        _discoveries[index] = event;
      }
      notifyListeners();
    });
  }

  BluetoothLowEnergyState get state => _state;
  bool get discovering => _discovering;
  List<DiscoveredEvent> get discoveries => _discoveries;

  Future<void> showAppSettings() async {
    await _centralManager.showAppSettings();
  }

  Future<void> startDiscovery({List<UUID> serviceUUIDs = const []}) async {
    if (_discovering) {
      return;
    }
    _discoveries.clear();
    await _centralManager.startDiscovery(serviceUUIDs: serviceUUIDs);
    _discovering = true;
    notifyListeners();
  }

  Future<void> stopDiscovery() async {
    if (!_discovering) {
      return;
    }
    await _centralManager.stopDiscovery();
    _discovering = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _stateChangedSubscription.cancel();
    _discoveredSubscription.cancel();
    super.dispose();
  }
}
