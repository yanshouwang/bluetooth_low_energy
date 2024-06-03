import 'dart:async';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:logging/logging.dart';

import 'view_model.dart';

class CentralManagerViewModel extends ViewModel {
  final CentralManager _manager;
  final List<DiscoveredEventArgs> _discoveries;
  bool _discovering;

  late final StreamSubscription _stateChangedSubscription;
  late final StreamSubscription _discoveredSubscription;

  CentralManagerViewModel()
      : _manager = CentralManager()..logLevel = Level.INFO,
        _discoveries = [],
        _discovering = false {
    _stateChangedSubscription = _manager.stateChanged.listen((eventArgs) async {
      if (eventArgs.state == BluetoothLowEnergyState.unauthorized) {
        await _manager.authorize();
      }
      notifyListeners();
    });
    _discoveredSubscription = _manager.discovered.listen((eventArgs) {
      final peripheral = eventArgs.peripheral;
      final index = _discoveries.indexWhere((i) => i.peripheral == peripheral);
      if (index < 0) {
        _discoveries.add(eventArgs);
      } else {
        _discoveries[index] = eventArgs;
      }
      notifyListeners();
    });
  }

  BluetoothLowEnergyState get state => _manager.state;
  bool get discovering => _discovering;
  List<DiscoveredEventArgs> get discoveries => _discoveries;

  Future<void> showAppSettings() async {
    await _manager.showAppSettings();
  }

  Future<void> startDiscovery({
    List<UUID>? serviceUUIDs,
  }) async {
    if (_discovering) {
      return;
    }
    _discoveries.clear();
    await _manager.startDiscovery(
      serviceUUIDs: serviceUUIDs,
    );
    _discovering = true;
    notifyListeners();
  }

  Future<void> stopDiscovery() async {
    if (!_discovering) {
      return;
    }
    await _manager.stopDiscovery();
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
