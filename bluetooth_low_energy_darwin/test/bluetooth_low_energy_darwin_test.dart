import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_darwin/bluetooth_low_energy_darwin.dart';
import 'package:bluetooth_low_energy_darwin/bluetooth_low_energy_darwin_platform_interface.dart';
import 'package:bluetooth_low_energy_darwin/bluetooth_low_energy_darwin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluetoothLowEnergyDarwinPlatform
    with MockPlatformInterfaceMixin
    implements BluetoothLowEnergyDarwinPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BluetoothLowEnergyDarwinPlatform initialPlatform = BluetoothLowEnergyDarwinPlatform.instance;

  test('$MethodChannelBluetoothLowEnergyDarwin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluetoothLowEnergyDarwin>());
  });

  test('getPlatformVersion', () async {
    BluetoothLowEnergyDarwin bluetoothLowEnergyDarwinPlugin = BluetoothLowEnergyDarwin();
    MockBluetoothLowEnergyDarwinPlatform fakePlatform = MockBluetoothLowEnergyDarwinPlatform();
    BluetoothLowEnergyDarwinPlatform.instance = fakePlatform;

    expect(await bluetoothLowEnergyDarwinPlugin.getPlatformVersion(), '42');
  });
}
