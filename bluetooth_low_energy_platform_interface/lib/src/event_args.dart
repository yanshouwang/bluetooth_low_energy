import 'dart:typed_data';

import 'advertisement.dart';
import 'central_manager_state.dart';
import 'gatt_characteristic.dart';
import 'peripheral.dart';
import 'peripheral_state.dart';

abstract class EventArgs {}

class CentralManagerStateChangedEventArgs extends EventArgs {
  final CentralManagerState state;

  CentralManagerStateChangedEventArgs(this.state);
}

class DiscoveredEventArgs extends EventArgs {
  final Peripheral peripheral;
  final int rssi;
  final Advertisement advertisement;

  DiscoveredEventArgs(this.peripheral, this.rssi, this.advertisement);
}

class PeripheralStateChangedEventArgs extends EventArgs {
  final Peripheral peripheral;
  final PeripheralState state;

  PeripheralStateChangedEventArgs(this.peripheral, this.state);
}

class GattCharacteristicValueChangedEventArgs extends EventArgs {
  final GattCharacteristic characteristic;
  final Uint8List value;

  GattCharacteristicValueChangedEventArgs(this.characteristic, this.value);
}
