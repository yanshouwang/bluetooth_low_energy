/// The write type for a GATT characteristic.
enum GattCharacteristicWriteType {
  // Write with response
  withResponse,
  // Write without response
  withoutResponse,
  // Write with response and waiting for confirmation
  // reliable,
}
