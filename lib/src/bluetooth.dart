part of bluetooth_low_energy;

/// The abstract base class that manages central and peripheral objects.
abstract class Bluetooth {
  /// The current state of the bluetooth.
  Future<BluetoothState> get state;

  /// The bluetooth’s state changed.
  Stream<BluetoothState> get stateChanged;
}

class _Bluetooth implements Bluetooth {
  @override
  Future<BluetoothState> get state {
    final message = proto.Message(
      category: proto.MessageCategory.BLUETOOTH_STATE,
    ).writeToBuffer();
    return method
        .invokeMethod<int>('', message)
        .then((value) => BluetoothState.values[value!]);
  }

  @override
  Stream<BluetoothState> get stateChanged => stream
      .where((message) =>
          message.category == proto.MessageCategory.BLUETOOTH_STATE)
      .map((message) => message.state.toState());
}

/// TO BE DONE.
enum BluetoothState {
  /// TO BE DONE.
  unsupported,

  /// TO BE DONE.
  poweredOff,

  /// TO BE DONE.
  poweredOn,
}
