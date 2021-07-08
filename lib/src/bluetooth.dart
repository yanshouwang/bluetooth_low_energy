part of bluetooth_low_energy;

/// The abstract base class that manages central and peripheral objects.
abstract class Bluetooth {
  /// The availability of the bluetooth.
  Future<bool> get available;

  /// The current state of the bluetooth.
  Future<bool> get state;

  /// The bluetooth’s state changed.
  Stream<bool> get stateChanged;
}

class _Bluetooth implements Bluetooth {
  @override
  Future<bool> get available {
    final message = proto.Message(
      category: proto.MessageCategory.BLUETOOTH_AVAILABLE,
    ).writeToBuffer();
    return method.invokeMethod<bool>('', message).then((value) => value!);
  }

  @override
  Future<bool> get state {
    final message = proto.Message(
      category: proto.MessageCategory.BLUETOOTH_STATE,
    ).writeToBuffer();
    return method.invokeMethod<bool>('', message).then((value) => value!);
  }

  @override
  Stream<bool> get stateChanged => stream
      .where((message) =>
          message.category == proto.MessageCategory.BLUETOOTH_STATE)
      .map((message) => message.state);
}
