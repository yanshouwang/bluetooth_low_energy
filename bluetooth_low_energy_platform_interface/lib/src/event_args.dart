import 'dart:typed_data';

import 'central_manager_state.dart';
import 'peripheral.dart';
import 'peripheral_state.dart';

class EventArgs {}

class CentralManagerStateEventArgs extends EventArgs {
  final CentralManagerState state;

  CentralManagerStateEventArgs(this.state);
}

class PeripheralEventArgs extends EventArgs {
  final Peripheral peripheral;

  PeripheralEventArgs(this.peripheral);
}

class PeripheralStateEventArgs extends EventArgs {
  final String id;
  final PeripheralState state;

  PeripheralStateEventArgs(this.id, this.state);
}

class CharacteristicValueEventArgs extends EventArgs {
  final String id;
  final String serviceId;
  final String characteristicId;
  final Uint8List value;

  CharacteristicValueEventArgs(
    this.id,
    this.serviceId,
    this.characteristicId,
    this.value,
  );
}
