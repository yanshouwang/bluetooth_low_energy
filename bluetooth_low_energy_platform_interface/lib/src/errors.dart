/// The bluetooth low energy error.
class BluetoothLowEnergyError extends Error {
  /// The message of this error.
  final String message;

  /// Constructs a [BluetoothLowEnergyError].
  BluetoothLowEnergyError(this.message);

  @override
  String toString() {
    return 'BluetoothLowEnergyError: $message';
  }
}
