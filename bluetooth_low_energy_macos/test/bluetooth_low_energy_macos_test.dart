import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_macos/bluetooth_low_energy_macos.dart';
import 'package:bluetooth_low_energy_macos/bluetooth_low_energy_macos_platform_interface.dart';
import 'package:bluetooth_low_energy_macos/bluetooth_low_energy_macos_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluetoothLowEnergyMacosPlatform
    with MockPlatformInterfaceMixin
    implements BluetoothLowEnergyMacosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BluetoothLowEnergyMacosPlatform initialPlatform = BluetoothLowEnergyMacosPlatform.instance;

  test('$MethodChannelBluetoothLowEnergyMacos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluetoothLowEnergyMacos>());
  });

  test('getPlatformVersion', () async {
    BluetoothLowEnergyMacos bluetoothLowEnergyMacosPlugin = BluetoothLowEnergyMacos();
    MockBluetoothLowEnergyMacosPlatform fakePlatform = MockBluetoothLowEnergyMacosPlatform();
    BluetoothLowEnergyMacosPlatform.instance = fakePlatform;

    expect(await bluetoothLowEnergyMacosPlugin.getPlatformVersion(), '42');
  });
}
