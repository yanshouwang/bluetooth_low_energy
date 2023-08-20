/// The properity for a GATT characteristic.
enum GattCharacteristicProperty {
  /// The GATT characteristic is able to read.
  read,

  /// The GATT characteristic is able to write.
  write,

  /// The GATT characteristic is able to write without response.
  writeWithoutResponse,

  /// The GATT characteristic is able to notify.
  notify,

  /// The GATT characteristic is able to indicate.
  indicate,
}
