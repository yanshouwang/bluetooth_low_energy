// import 'package:flutter_test/flutter_test.dart';
// import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
// import 'package:bluetooth_low_energy/bluetooth_low_energy_platform_interface.dart';
// import 'package:bluetooth_low_energy/bluetooth_low_energy_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockBluetoothLowEnergyPlatform
//     with MockPlatformInterfaceMixin
//     implements BluetoothLowEnergyPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final BluetoothLowEnergyPlatform initialPlatform = BluetoothLowEnergyPlatform.instance;

//   test('$MethodChannelBluetoothLowEnergy is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelBluetoothLowEnergy>());
//   });

//   test('getPlatformVersion', () async {
//     BluetoothLowEnergy bluetoothLowEnergyPlugin = BluetoothLowEnergy();
//     MockBluetoothLowEnergyPlatform fakePlatform = MockBluetoothLowEnergyPlatform();
//     BluetoothLowEnergyPlatform.instance = fakePlatform;

//     expect(await bluetoothLowEnergyPlugin.getPlatformVersion(), '42');
//   });
// }
