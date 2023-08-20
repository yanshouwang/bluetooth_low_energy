/// The state of the central.
enum CentralState {
  /// The central is unknown.
  unknown,

  /// The central is unsupported.
  unsupported,

  /// The central is unauthorized.
  unauthorized,

  /// The central is powered off.
  poweredOff,

  /// The central is powered on.
  poweredOn,
}
