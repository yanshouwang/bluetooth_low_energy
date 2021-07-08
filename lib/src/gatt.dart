part of bluetooth_low_energy;

/// TO BE DONE.
abstract class GATT {
  /// TO BE DONE.
  int get mtu;

  /// TO BE DONE.
  Stream<int> get connectionLost;

  /// TO BE DONE.
  Map<UUID, GattService> get services;

  /// TO BE DONE.
  Future disconnect();
}

class _GATT implements GATT {
  _GATT(this.uuid, this.id, this.mtu, this.services);

  final UUID uuid;
  final int id;
  @override
  final int mtu;
  @override
  final Map<UUID, GattService> services;

  @override
  Stream<int> get connectionLost => stream
      .where((message) =>
          message.category == proto.MessageCategory.GATT_CONNECTION_LOST &&
          message.connectionLost.id == id)
      .map((message) => message.connectionLost.errorCode);

  @override
  Future disconnect() {
    final message = proto.Message(
      category: proto.MessageCategory.GATT_DISCONNECT,
      disconnectArguments:
          proto.GattDisconnectArguments(uuid: uuid.name, id: id),
    ).writeToBuffer();
    return method.invokeMethod('', message);
  }
}
