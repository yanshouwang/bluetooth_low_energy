part of bluetooth_low_energy;

abstract class GATT {
  MAC get address;
  Stream<int> get connectionLost;

  Future disconnect();
}

class _GATT implements GATT {
  _GATT(this.address);

  @override
  final MAC address;

  @override
  Stream<int> get connectionLost => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((event) =>
          event.category == proto.MessageCategory.GATT_CONNECTION_LOST &&
          event.connectionLostArguments.address.conversionOfMAC == address)
      .map((event) => event.connectionLostArguments.errorCode);

  @override
  Future disconnect() => method.invokeMethod(
      proto.MessageCategory.GATT_DISCONNECT.name, address.name);
}
