import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_android/bluetooth_low_energy_android.dart';
import 'package:bluetooth_low_energy_android/bluetooth_low_energy_android_platform_interface.dart';
import 'package:bluetooth_low_energy_android/bluetooth_low_energy_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluetoothLowEnergyAndroidPlatform
    with MockPlatformInterfaceMixin
    implements BluetoothLowEnergyAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BluetoothLowEnergyAndroidPlatform initialPlatform = BluetoothLowEnergyAndroidPlatform.instance;

  test('$MethodChannelBluetoothLowEnergyAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluetoothLowEnergyAndroid>());
  });

  test('getPlatformVersion', () async {
    BluetoothLowEnergyAndroid bluetoothLowEnergyAndroidPlugin = BluetoothLowEnergyAndroid();
    MockBluetoothLowEnergyAndroidPlatform fakePlatform = MockBluetoothLowEnergyAndroidPlatform();
    BluetoothLowEnergyAndroidPlatform.instance = fakePlatform;

    expect(await bluetoothLowEnergyAndroidPlugin.getPlatformVersion(), '42');
  });
}
