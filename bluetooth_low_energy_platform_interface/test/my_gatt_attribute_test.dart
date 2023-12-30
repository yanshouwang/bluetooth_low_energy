import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Trim when value is empty.',
    () {
      final value = Uint8List.fromList([]);
      final actual = value.trimGATT();
      final matcher = value;
      expect(actual, matcher);
    },
  );
  test(
    'Trim when value is 100 bytes.',
    () {
      final elements = List.generate(100, (i) => i % 0xff);
      final value = Uint8List.fromList(elements);
      final actual = value.trimGATT();
      final matcher = value;
      expect(actual, matcher);
    },
  );
  test(
    'Trim when value is 512 bytes.',
    () {
      final elements = List.generate(512, (i) => i % 0xff);
      final value = Uint8List.fromList(elements);
      final actual = value.trimGATT();
      final matcher = value;
      expect(actual, matcher);
    },
  );
  test(
    'Trim when value is 1000 bytes.',
    () {
      final elements = List.generate(1000, (i) => i % 0xff);
      final value = Uint8List.fromList(elements);
      final actual = value.trimGATT();
      final matcher = Uint8List.fromList(elements.take(512).toList());
      expect(actual, matcher);
    },
  );
}
