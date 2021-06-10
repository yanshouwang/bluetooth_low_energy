import 'bluetooth.dart';

abstract class Discovery {
  Peripheral get peripheral;
  int get rssi;
  Map<int, List<int>> get advertisements;

  factory Discovery(Peripheral peripheral, int rssi,
          Map<int, List<int>> advertisements) =>
      _Discovery(peripheral, rssi, advertisements);
}

class _Discovery implements Discovery {
  @override
  final Peripheral peripheral;
  @override
  final int rssi;
  @override
  final Map<int, List<int>> advertisements;

  _Discovery(this.peripheral, this.rssi, this.advertisements);
}
