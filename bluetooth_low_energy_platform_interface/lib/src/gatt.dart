import 'dart:typed_data';

/// The GATT Unit8List extension.
extension GattUint8List on Uint8List {
  Uint8List trimGATT() {
    return length > 512 ? sublist(0, 512) : this;
  }
}
