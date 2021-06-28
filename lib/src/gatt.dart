part of bluetooth_low_energy;

abstract class GATT {
  int get mtu;
  Stream<int> get connectionLost;
  Map<UUID, GattService> get services;

  Future disconnect();
}

class _GATT implements GATT {
  _GATT(this.address, this.mtu, this.services);

  final MAC address;
  @override
  final int mtu;
  @override
  final Map<UUID, GattService> services;

  @override
  Stream<int> get connectionLost => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((event) =>
          event.category == proto.MessageCategory.GATT_CONNECTION_LOST &&
          event.connectionLost.address.conversionOfMAC == address)
      .map((event) => event.connectionLost.errorCode);

  @override
  Future disconnect() => method.invokeMethod(
      proto.MessageCategory.GATT_DISCONNECT.name, address.name);
}
