class BluetoothLowEnergyError extends Error {
  final String message;

  BluetoothLowEnergyError(this.message);

  @override
  String toString() {
    return 'BluetoothLowEnergyError: $message';
  }
}
