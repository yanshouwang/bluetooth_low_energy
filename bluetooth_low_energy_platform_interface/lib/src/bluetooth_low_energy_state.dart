/// The state of the bluetooth low energy.
enum BluetoothLowEnergyState {
  /// The bluetooth low energy is unknown.
  unknown,

  /// The bluetooth low energy is unsupported.
  unsupported,

  /// The bluetooth low energy is unauthorized.
  unauthorized,

  /// The bluetooth low energy is off.
  off,

  /// The bluetooth low energy is turning off.
  turningOn,

  /// The bluetooth low energy is on.
  on,

  /// The bluetooth low energy is turning on.
  turningOff,
}
