/// 128 bit universally unique identifier used in Bluetooth.
class UUID {
  /// The value of the UUID in 16 bytes.
  final List<int> value;

  /// True if the UUID is a short (16 or 32 bit) encoded UUID.
  bool get isShort =>
      value[4] == 0x00 &&
      value[5] == 0x00 &&
      value[6] == 0x10 &&
      value[7] == 0x00 &&
      value[8] == 0x80 &&
      value[9] == 0x00 &&
      value[10] == 0x00 &&
      value[11] == 0x80 &&
      value[12] == 0x5f &&
      value[13] == 0x9b &&
      value[14] == 0x34 &&
      value[15] == 0xfb;

  /// Creates a new UUID from 16 bytes.
  UUID(Iterable<int> value) : value = value.toList() {
    if (value.length != 16) {
      throw const FormatException('Invalid length UUID');
    }
  }

  // Creates a new Bluetooth UUID from the short (16 or 32 bit) encoding.
  UUID.short(int shortValue)
      : value = [
          (shortValue >> 24) & 0xff,
          (shortValue >> 16) & 0xff,
          (shortValue >> 8) & 0xff,
          (shortValue >> 0) & 0xff,
          0x00,
          0x00,
          0x10,
          0x00,
          0x80,
          0x00,
          0x00,
          0x80,
          0x5f,
          0x9b,
          0x34,
          0xfb
        ];

  /// Creates a new UUID from the string format encoding (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx where xx is a hexadecimal number).
  factory UUID.fromString(String value) {
    var groups = value.split('-');
    if (groups.length != 5 ||
        groups[0].length != 8 ||
        groups[1].length != 4 ||
        groups[2].length != 4 ||
        groups[3].length != 4 ||
        groups[4].length != 12) {
      throw const FormatException('Invalid UUID string');
    }
    int group0, group1, group2, group3, group4;
    try {
      group0 = int.parse(groups[0], radix: 16);
      group1 = int.parse(groups[1], radix: 16);
      group2 = int.parse(groups[2], radix: 16);
      group3 = int.parse(groups[3], radix: 16);
      group4 = int.parse(groups[4], radix: 16);
    } catch (e) {
      throw const FormatException('Invalid UUID string');
    }
    return UUID([
      (group0 >> 24) & 0xff,
      (group0 >> 16) & 0xff,
      (group0 >> 8) & 0xff,
      (group0 >> 0) & 0xff,
      (group1 >> 8) & 0xff,
      (group1 >> 0) & 0xff,
      (group2 >> 8) & 0xff,
      (group2 >> 0) & 0xff,
      (group3 >> 8) & 0xff,
      (group3 >> 0) & 0xff,
      (group4 >> 40) & 0xff,
      (group4 >> 32) & 0xff,
      (group4 >> 24) & 0xff,
      (group4 >> 16) & 0xff,
      (group4 >> 8) & 0xff,
      (group4 >> 0) & 0xff
    ]);
  }

  @override
  String toString() {
    var v0 = value[0].toRadixString(16).padLeft(2, '0');
    var v1 = value[1].toRadixString(16).padLeft(2, '0');
    var v2 = value[2].toRadixString(16).padLeft(2, '0');
    var v3 = value[3].toRadixString(16).padLeft(2, '0');
    var v4 = value[4].toRadixString(16).padLeft(2, '0');
    var v5 = value[5].toRadixString(16).padLeft(2, '0');
    var v6 = value[6].toRadixString(16).padLeft(2, '0');
    var v7 = value[7].toRadixString(16).padLeft(2, '0');
    var v8 = value[8].toRadixString(16).padLeft(2, '0');
    var v9 = value[9].toRadixString(16).padLeft(2, '0');
    var v10 = value[10].toRadixString(16).padLeft(2, '0');
    var v11 = value[11].toRadixString(16).padLeft(2, '0');
    var v12 = value[12].toRadixString(16).padLeft(2, '0');
    var v13 = value[13].toRadixString(16).padLeft(2, '0');
    var v14 = value[14].toRadixString(16).padLeft(2, '0');
    var v15 = value[15].toRadixString(16).padLeft(2, '0');
    return '$v0$v1$v2$v3-$v4$v5-$v6$v7-$v8$v9-$v10$v11$v12$v13$v14$v15';
  }

  @override
  bool operator ==(other) =>
      other is UUID &&
      other.value[0] == value[0] &&
      other.value[1] == value[1] &&
      other.value[2] == value[2] &&
      other.value[3] == value[3] &&
      other.value[4] == value[4] &&
      other.value[5] == value[5] &&
      other.value[6] == value[6] &&
      other.value[7] == value[7] &&
      other.value[8] == value[8] &&
      other.value[9] == value[9] &&
      other.value[10] == value[10] &&
      other.value[11] == value[11] &&
      other.value[12] == value[12] &&
      other.value[13] == value[13] &&
      other.value[14] == value[14] &&
      other.value[15] == value[15];

  @override
  int get hashCode => value.fold(17, (prev, value) => 37 * prev + value);
}
