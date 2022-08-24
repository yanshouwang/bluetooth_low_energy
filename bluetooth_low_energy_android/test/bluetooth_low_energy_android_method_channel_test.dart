import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_android/bluetooth_low_energy_android_method_channel.dart';

void main() {
  MethodChannelBluetoothLowEnergyAndroid platform = MethodChannelBluetoothLowEnergyAndroid();
  const MethodChannel channel = MethodChannel('bluetooth_low_energy_android');

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
