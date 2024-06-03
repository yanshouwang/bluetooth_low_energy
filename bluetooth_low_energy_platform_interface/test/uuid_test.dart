import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'UUID#fromAddress by String with colons.',
    () {
      const address = 'AA:BB:CC:DD:EE:FF';
      final actual = UUID.fromAddress(address);
      final matcher = UUID.fromString('00000000-0000-0000-0000-AABBCCDDEEFF');
      expect(actual, matcher);
    },
  );
  test(
    'UUID#fromAddress by String without colons.',
    () {
      const address = 'AABBCCDDEEFF';
      final actual = UUID.fromAddress(address);
      final matcher = UUID.fromString('00000000-0000-0000-0000-AABBCCDDEEFF');
      expect(actual, matcher);
    },
  );
  test(
    'UUID#fromAddress by int.',
    () {
      const address = 0xAABBCCDDEEFF;
      final actual = UUID.fromAddress(address);
      final matcher = UUID.fromString('00000000-0000-0000-0000-AABBCCDDEEFF');
      expect(actual, matcher);
    },
  );
}
