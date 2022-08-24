import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_low_energy_core/bluetooth_low_energy_core.dart';
import 'package:bluetooth_low_energy_core/bluetooth_low_energy_core_platform_interface.dart';
import 'package:bluetooth_low_energy_core/bluetooth_low_energy_core_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluetoothLowEnergyCorePlatform 
    with MockPlatformInterfaceMixin
    implements BluetoothLowEnergyCorePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BluetoothLowEnergyCorePlatform initialPlatform = BluetoothLowEnergyCorePlatform.instance;

  test('$MethodChannelBluetoothLowEnergyCore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluetoothLowEnergyCore>());
  });

  test('getPlatformVersion', () async {
    BluetoothLowEnergyCore bluetoothLowEnergyCorePlugin = BluetoothLowEnergyCore();
    MockBluetoothLowEnergyCorePlatform fakePlatform = MockBluetoothLowEnergyCorePlatform();
    BluetoothLowEnergyCorePlatform.instance = fakePlatform;
  
    expect(await bluetoothLowEnergyCorePlugin.getPlatformVersion(), '42');
  });
}
