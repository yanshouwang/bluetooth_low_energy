import 'dart:typed_data';

import 'peripheral.dart';
import 'peripheral_state.dart';

class Event {}

class PeripheralEvent extends Event {
  final Peripheral peripheral;

  PeripheralEvent(this.peripheral);
}

class PeripheralStateEvent extends Event {
  final String id;
  final PeripheralState state;

  PeripheralStateEvent(this.id, this.state);
}

class GattCharacteristicValueEvent extends Event {
  final String id;
  final String serviceId;
  final String characteristicId;
  final Uint8List value;

  GattCharacteristicValueEvent(
    this.id,
    this.serviceId,
    this.characteristicId,
    this.value,
  );
}
