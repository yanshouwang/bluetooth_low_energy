import 'mac.dart';

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
