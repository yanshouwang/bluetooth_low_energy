part of bluetooth_low_energy;

abstract class Discovery {
  MAC get address;
  int get rssi;
  Map<int, List<int>> get advertisements;

  factory Discovery(
          MAC address, int rssi, Map<int, List<int>> advertisements) =>
      _Discovery(address, rssi, advertisements);
}

class _Discovery implements Discovery {
  @override
  final MAC address;
  @override
  final int rssi;
  @override
  final Map<int, List<int>> advertisements;

  _Discovery(this.address, this.rssi, this.advertisements);
}

extension DiscoveryX on Discovery {
  String? get name {
    if (advertisements.containsKey(0x08)) {
      return utf8.decode(advertisements[0x08]!);
    } else if (advertisements.containsKey(0x09)) {
      return utf8.decode(advertisements[0x09]!);
    } else {
      return null;
    }
  }
}
