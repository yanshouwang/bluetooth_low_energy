import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_ios/bluetooth_low_energy_ios.dart';
import 'package:bluetooth_low_energy_ios/bluetooth_low_energy_ios_platform_interface.dart';
import 'package:bluetooth_low_energy_ios/bluetooth_low_energy_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluetoothLowEnergyIosPlatform
    with MockPlatformInterfaceMixin
    implements BluetoothLowEnergyIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BluetoothLowEnergyIosPlatform initialPlatform = BluetoothLowEnergyIosPlatform.instance;

  test('$MethodChannelBluetoothLowEnergyIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluetoothLowEnergyIos>());
  });

  test('getPlatformVersion', () async {
    BluetoothLowEnergyIos bluetoothLowEnergyIosPlugin = BluetoothLowEnergyIos();
    MockBluetoothLowEnergyIosPlatform fakePlatform = MockBluetoothLowEnergyIosPlatform();
    BluetoothLowEnergyIosPlatform.instance = fakePlatform;

    expect(await bluetoothLowEnergyIosPlugin.getPlatformVersion(), '42');
  });
}
