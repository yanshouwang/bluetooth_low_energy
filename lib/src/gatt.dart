part of bluetooth_low_energy;

/// TO BE DONE.
abstract class GATT {
  /// TO BE DONE.
  int get maximumWriteLength;

  /// TO BE DONE.
  Stream<Exception> get connectionLost;

  /// TO BE DONE.
  Map<UUID, GattService> get services;

  /// TO BE DONE.
  Future disconnect();
}

class _GATT implements GATT {
  _GATT(this.key, this.maximumWriteLength, this.services);

  final String key;
  @override
  final int maximumWriteLength;
  @override
  final Map<UUID, GattService> services;

  @override
  Stream<Exception> get connectionLost => stream
      .where((message) =>
          message.category == proto.MessageCategory.GATT_CONNECTION_LOST &&
          message.connectionLost.key == key)
      .map((message) => message.connectionLost.error.exceptoin);

  @override
  Future disconnect() {
    final message = proto.Message(
      category: proto.MessageCategory.GATT_DISCONNECT,
      disconnectArguments: proto.GattDisconnectArguments(key: key),
    ).writeToBuffer();
    return method.invokeMethod('', message);
  }
}
