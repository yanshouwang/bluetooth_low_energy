import 'dart:async';
import 'dart:io';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:clover/clover.dart';
import 'package:hybrid_logging/hybrid_logging.dart';

import 'service_view_model.dart';

class PeripheralViewModel extends ViewModel with TypeLogger {
  final CentralManager _manager;
  final Peripheral _peripheral;
  final String? _name;
  bool _connected;
  List<ServiceViewModel> _serviceViewModels;

  late final StreamSubscription _connectionStateChangedSubscription;
  late final StreamSubscription _mtuChangedChangedSubscription;

  PeripheralViewModel(DiscoveredEventArgs eventArgs)
    : _manager = CentralManager(),
      _peripheral = eventArgs.peripheral,
      _name = eventArgs.advertisement.name,
      _connected = false,
      _serviceViewModels = [] {
    _connectionStateChangedSubscription = _manager.connectionStateChanged
        .listen((eventArgs) {
          if (eventArgs.peripheral != _peripheral) {
            return;
          }
          if (eventArgs.state == ConnectionState.connected) {
            _connected = true;
          } else {
            _connected = false;
            _serviceViewModels = [];
          }
          notifyListeners();
        });
    if (Platform.isAndroid || Platform.isWindows) {
      _mtuChangedChangedSubscription = _manager.mtuChanged.listen((eventArgs) {
        if (eventArgs.peripheral != _peripheral) {
          return;
        }
        logger.info('MTU chanaged: ${eventArgs.mtu}');
      });
    }
  }

  UUID get uuid => _peripheral.uuid;
  String? get name => _name;
  bool get connected => _connected;
  List<ServiceViewModel> get serviceViewModels => _serviceViewModels;

  Future<void> connect() async {
    await _manager.connect(_peripheral);
  }

  Future<void> disconnect() async {
    await _manager.disconnect(_peripheral);
  }

  Future<void> discoverGATT() async {
    final services = await _manager.discoverGATT(_peripheral);
    _serviceViewModels =
        services
            .map(
              (service) => ServiceViewModel(
                manager: _manager,
                peripheral: _peripheral,
                service: service,
              ),
            )
            .toList();
    notifyListeners();
  }

  @override
  void dispose() {
    if (connected) {
      disconnect();
    }
    _connectionStateChangedSubscription.cancel();
    if (Platform.isAndroid || Platform.isWindows) {
      _mtuChangedChangedSubscription.cancel();
    }
    for (var serviceViewModel in serviceViewModels) {
      serviceViewModel.dispose();
    }
    super.dispose();
  }
}
