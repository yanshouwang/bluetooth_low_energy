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
  _GATT(this.address, this.id, this.mtu, this.services);

  final MAC address;
  final int id;
  @override
  final int mtu;
  @override
  final Map<UUID, GattService> services;

  @override
  Stream<int> get connectionLost => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((event) =>
          event.category == proto.MessageCategory.GATT_CONNECTION_LOST &&
          event.connectionLost.id == id)
      .map((event) => event.connectionLost.errorCode);

  @override
  Future disconnect() {
    final name = proto.MessageCategory.GATT_DISCONNECT.name;
    final arguments =
        proto.GattDisconnectArguments(address: address.name, id: id)
            .writeToBuffer();
    return method.invokeMethod(name, arguments);
  }
}
