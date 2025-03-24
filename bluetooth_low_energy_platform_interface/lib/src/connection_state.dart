/// The connection state of a remote device.
enum ConnectionState {
  /// The remote device is in disconnected state.
  disconnected,

  connecting,

  /// The remote device is in connected state.
  connected,

  disconnecting,
}
