import 'dart:typed_data';

import 'advertisement.dart';
import 'central_controller_state.dart';
import 'errors.dart';
import 'gatt_characteristic.dart';
import 'peripheral.dart';

abstract class EventArgs {}

class CentralControllerStateChangedEventArgs extends EventArgs {
  final CentralControllerState state;

  CentralControllerStateChangedEventArgs(this.state);
}

class CentralControllerDiscoveredEventArgs extends EventArgs {
  final Peripheral peripheral;
  final int rssi;
  final Advertisement advertisement;

  CentralControllerDiscoveredEventArgs(
    this.peripheral,
    this.rssi,
    this.advertisement,
  );
}

class PeripheralStateChangedEventArgs extends EventArgs {
  final Peripheral peripheral;
  final bool state;
  final BluetoothLowEnergyError? error;

  PeripheralStateChangedEventArgs(
    this.peripheral,
    this.state,
    this.error,
  );
}

class GattCharacteristicValueChangedEventArgs extends EventArgs {
  final GattCharacteristic characteristic;
  final Uint8List value;

  GattCharacteristicValueChangedEventArgs(this.characteristic, this.value);
}
