part of bluetooth_low_energy;

abstract class GATT {
  int get mtu;
  Stream<int> get connectionLost;
  List<GattService> get services;

  Future disconnect();
}

class _GATT implements GATT {
  _GATT(this.device, this.mtu, this.services);

  final MAC device;
  @override
  final int mtu;
  @override
  final List<GattService> services;

  @override
  Stream<int> get connectionLost => stream
      .map((event) => proto.Message.fromBuffer(event))
      .where((event) =>
          event.category == proto.MessageCategory.GATT_CONNECTION_LOST &&
          event.connectionLost.device.conversionOfMAC == device)
      .map((event) => event.connectionLost.errorCode);

  @override
  Future disconnect() => method.invokeMethod(
      proto.MessageCategory.GATT_DISCONNECT.name, device.name);
}
