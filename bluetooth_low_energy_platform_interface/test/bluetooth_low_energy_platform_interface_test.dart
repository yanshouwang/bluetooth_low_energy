import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface_platform_interface.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluetoothLowEnergyPlatformInterfacePlatform
    with MockPlatformInterfaceMixin
    implements BluetoothLowEnergyPlatformInterfacePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BluetoothLowEnergyPlatformInterfacePlatform initialPlatform = BluetoothLowEnergyPlatformInterfacePlatform.instance;

  test('$MethodChannelBluetoothLowEnergyPlatformInterface is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluetoothLowEnergyPlatformInterface>());
  });

  test('getPlatformVersion', () async {
    BluetoothLowEnergyPlatformInterface bluetoothLowEnergyPlatformInterfacePlugin = BluetoothLowEnergyPlatformInterface();
    MockBluetoothLowEnergyPlatformInterfacePlatform fakePlatform = MockBluetoothLowEnergyPlatformInterfacePlatform();
    BluetoothLowEnergyPlatformInterfacePlatform.instance = fakePlatform;

    expect(await bluetoothLowEnergyPlatformInterfacePlugin.getPlatformVersion(), '42');
  });
}
