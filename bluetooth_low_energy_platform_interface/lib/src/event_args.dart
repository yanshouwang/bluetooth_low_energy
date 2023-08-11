import 'dart:typed_data';

import 'advertisement.dart';
import 'central_state.dart';
import 'errors.dart';
import 'gatt_characteristic.dart';
import 'peripheral.dart';

abstract class EventArgs {}

class CentralStateChangedEventArgs extends EventArgs {
  final CentralState state;

  CentralStateChangedEventArgs(this.state);
}

class CentralDiscoveredEventArgs extends EventArgs {
  final Peripheral peripheral;
  final int rssi;
  final Advertisement advertisement;

  CentralDiscoveredEventArgs(
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
