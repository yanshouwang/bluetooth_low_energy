part of bluetooth_low_energy;

/// TO BE DONE.
abstract class Discovery {
  /// TO BE DONE.
  UUID get uuid;

  /// TO BE DONE.
  int get rssi;

  /// TO BE DONE.
  Map<int, List<int>> get advertisements;
}

class _Discovery implements Discovery {
  @override
  final UUID uuid;
  @override
  final int rssi;
  @override
  final Map<int, List<int>> advertisements;

  _Discovery(this.uuid, this.rssi, this.advertisements);
}
