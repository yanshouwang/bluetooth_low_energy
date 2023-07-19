import 'dart:async';
import 'dart:typed_data';

import 'my_api.dart';

class MyCentralManagerApi extends MyCentralManagerHostApi
    implements MyCentralManagerFlutterApi {
  MyCentralManagerApi()
      : _stateChangedController = StreamController.broadcast(),
        _discoveredController = StreamController.broadcast(),
        _peripheralStateChangedController = StreamController.broadcast(),
        _characteristicValueChangedController = StreamController.broadcast();

  void setup() {
    MyCentralManagerFlutterApi.setup(this);
  }

  final StreamController<int> _stateChangedController;
  final StreamController<MyPeripheral> _discoveredController;
  final StreamController<(String, int)> _peripheralStateChangedController;
  final StreamController<(String, String, String, Uint8List)>
      _characteristicValueChangedController;

  Stream<int> get stateChanged => _stateChangedController.stream;
  Stream<MyPeripheral> get discovered => _discoveredController.stream;
  Stream<(String, int)> get peripheralStateChanged =>
      _peripheralStateChangedController.stream;
  Stream<(String, String, String, Uint8List)> get characteristicValueChanged =>
      _characteristicValueChangedController.stream;

  @override
  void onStateChanged(int state) {
    _stateChangedController.add(state);
  }

  @override
  void onDiscovered(MyPeripheral peripheral) {
    _discoveredController.add(peripheral);
  }

  @override
  void onPeripheralStateChanged(String id, int state) {
    final item = (id, state);
    _peripheralStateChangedController.add(item);
  }

  @override
  void onCharacteristicValueChanged(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value,
  ) {
    final item = (id, serviceId, characteristicId, value);
    _characteristicValueChangedController.add(item);
  }
}
