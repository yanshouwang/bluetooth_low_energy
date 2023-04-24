import 'dart:typed_data';

import 'connection_state.dart';
import 'peripheral.dart';

class EventArgs {}

class PeripheralEventArgs extends EventArgs {
  final Peripheral peripheral;

  PeripheralEventArgs(this.peripheral);
}

class ConnectionStateEventArgs extends EventArgs {
  final String id;
  final ConnectionState state;

  ConnectionStateEventArgs(this.id, this.state);
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
