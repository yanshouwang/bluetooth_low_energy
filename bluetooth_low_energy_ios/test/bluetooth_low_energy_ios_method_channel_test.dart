import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_ios/bluetooth_low_energy_ios_method_channel.dart';

void main() {
  MethodChannelBluetoothLowEnergyIos platform = MethodChannelBluetoothLowEnergyIos();
  const MethodChannel channel = MethodChannel('bluetooth_low_energy_ios');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
