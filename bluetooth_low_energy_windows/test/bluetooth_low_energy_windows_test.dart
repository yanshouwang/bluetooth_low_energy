import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_windows/bluetooth_low_energy_windows.dart';
import 'package:bluetooth_low_energy_windows/bluetooth_low_energy_windows_platform_interface.dart';
import 'package:bluetooth_low_energy_windows/bluetooth_low_energy_windows_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluetoothLowEnergyWindowsPlatform
    with MockPlatformInterfaceMixin
    implements BluetoothLowEnergyWindowsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BluetoothLowEnergyWindowsPlatform initialPlatform = BluetoothLowEnergyWindowsPlatform.instance;

  test('$MethodChannelBluetoothLowEnergyWindows is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluetoothLowEnergyWindows>());
  });

  test('getPlatformVersion', () async {
    BluetoothLowEnergyWindows bluetoothLowEnergyWindowsPlugin = BluetoothLowEnergyWindows();
    MockBluetoothLowEnergyWindowsPlatform fakePlatform = MockBluetoothLowEnergyWindowsPlatform();
    BluetoothLowEnergyWindowsPlatform.instance = fakePlatform;

    expect(await bluetoothLowEnergyWindowsPlugin.getPlatformVersion(), '42');
  });
}
