import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_advertisement.dart';
import 'my_api.g.dart';
import 'my_central_controller.dart';
import 'my_event_args.dart';
import 'my_gatt_characteristic.dart';
import 'my_peripheral.dart';

class MyCentralControllerApi extends MyCentralControllerHostApi
    implements MyCentralControllerFlutterApi {
  final StreamController<MyCentralControllerStateChangedEventArgs>
      stateChangedController;
  final StreamController<MyCentralControllerDiscoveredEventArgs>
      discoveredController;
  final StreamController<MyPeripheralStateChangedEventArgs>
      peripheralStateChangedController;
  final StreamController<MyGattCharacteristicValueChangedEventArgs>
      characteristicValueChangedController;

  MyCentralControllerApi()
      : stateChangedController = StreamController.broadcast(),
        discoveredController = StreamController.broadcast(),
        peripheralStateChangedController = StreamController.broadcast(),
        characteristicValueChangedController = StreamController.broadcast();

  Stream<MyCentralControllerStateChangedEventArgs> get stateChanged =>
      stateChangedController.stream;
  Stream<MyCentralControllerDiscoveredEventArgs> get discovered =>
      discoveredController.stream;
  Stream<MyPeripheralStateChangedEventArgs> get peripheralStateChanged =>
      peripheralStateChangedController.stream;
  Stream<MyGattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged =>
          characteristicValueChangedController.stream;

  @override
  void onStateChanged(int hashCode, int rawState) {
    final controller = MyCentralController(hashCode);
    final state = CentralControllerState.values[rawState];
    final eventArgs = MyCentralControllerStateChangedEventArgs(
      controller,
      state,
    );
    stateChangedController.add(eventArgs);
  }

  @override
  void onDiscovered(
    int hashCode,
    int peripheralHashCode,
    int rssi,
    int advertisementHashCode,
  ) {
    final controller = MyCentralController(hashCode);
    final peripheral = MyPeripheral(peripheralHashCode);
    final advertisement = MyAdvertisement(advertisementHashCode);
    final eventArgs = MyCentralControllerDiscoveredEventArgs(
      controller,
      peripheral,
      rssi,
      advertisement,
    );
    discoveredController.add(eventArgs);
  }

  @override
  void onPeripheralStateChanged(
    int hashCode,
    int peripheralHashCode,
    int rawState,
  ) {
    final controller = MyCentralController(hashCode);
    final peripheral = MyPeripheral(peripheralHashCode);
    final state = PeripheralState.values[rawState];
    final eventArgs = MyPeripheralStateChangedEventArgs(
      controller,
      peripheral,
      state,
    );
    peripheralStateChangedController.add(eventArgs);
  }

  @override
  void onCharacteristicValueChanged(
    int hashCode,
    int characteristicHashCode,
    Uint8List value,
  ) {
    final controller = MyCentralController(hashCode);
    final characteristic = MyGattCharacteristic(characteristicHashCode);
    final eventArgs = MyGattCharacteristicValueChangedEventArgs(
      controller,
      characteristic,
      value,
    );
    characteristicValueChangedController.add(eventArgs);
  }
}
