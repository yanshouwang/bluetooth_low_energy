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
  Future<bool> get available => method
      .invokeMethod<bool>(proto.MessageCategory.BLUETOOTH_AVAILABLE.name)
      .then((value) => value!);

  @override
  Future<bool> get state => method
      .invokeMethod<bool>(proto.MessageCategory.BLUETOOTH_STATE.name)
      .then((value) => value!);

  @override
  Stream<bool> get stateChanged => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((message) =>
          message.category == proto.MessageCategory.BLUETOOTH_STATE)
      .map((message) => message.state);
}
