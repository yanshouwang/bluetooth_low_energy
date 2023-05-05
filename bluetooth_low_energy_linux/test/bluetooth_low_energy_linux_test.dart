import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_linux/bluetooth_low_energy_linux.dart';
import 'package:bluetooth_low_energy_linux/bluetooth_low_energy_linux_platform_interface.dart';
import 'package:bluetooth_low_energy_linux/bluetooth_low_energy_linux_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluetoothLowEnergyLinuxPlatform
    with MockPlatformInterfaceMixin
    implements BluetoothLowEnergyLinuxPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BluetoothLowEnergyLinuxPlatform initialPlatform = BluetoothLowEnergyLinuxPlatform.instance;

  test('$MethodChannelBluetoothLowEnergyLinux is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluetoothLowEnergyLinux>());
  });

  test('getPlatformVersion', () async {
    BluetoothLowEnergyLinux bluetoothLowEnergyLinuxPlugin = BluetoothLowEnergyLinux();
    MockBluetoothLowEnergyLinuxPlatform fakePlatform = MockBluetoothLowEnergyLinuxPlatform();
    BluetoothLowEnergyLinuxPlatform.instance = fakePlatform;

    expect(await bluetoothLowEnergyLinuxPlugin.getPlatformVersion(), '42');
  });
}
