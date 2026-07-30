/// The bond (pairing) state of a remote device.
///
/// Mirrors Android's `BluetoothDevice.BOND_*` states. Only meaningful on
/// Android; other platforms never emit bond transitions (iOS bonds implicitly
/// and exposes no bond state via CoreBluetooth).
enum BondState {
  /// The device is not bonded — a pending bond was cancelled or rejected.
  none,

  /// Bonding is in progress (the system pairing dialog is shown).
  bonding,

  /// The device is bonded.
  bonded,
}
