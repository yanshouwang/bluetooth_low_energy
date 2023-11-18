import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Create UUID form MAC address with colons.',
    () {
      const address = 'AA:BB:CC:DD:EE:FF';
      final actual = UUID.fromAddress(address);
      final matcher = UUID.fromString('00000000-0000-0000-0000-AABBCCDDEEFF');
      expect(actual, matcher);
    },
  );
  test(
    'Create UUID form MAC address without colons.',
    () {
      const address = 'AABBCCDDEEFF';
      final actual = UUID.fromAddress(address);
      final matcher = UUID.fromString('00000000-0000-0000-0000-AABBCCDDEEFF');
      expect(actual, matcher);
    },
  );
}
