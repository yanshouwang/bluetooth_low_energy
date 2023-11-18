import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

class MyGattDescriptor2 extends MyGattDescriptor {
  final MyPeripheral peripheral;
  final int handle;

  MyGattDescriptor2({
    required this.peripheral,
    required this.handle,
    required super.uuid,
  });

  @override
  int get hashCode => Object.hash(peripheral, handle);

  @override
  bool operator ==(Object other) {
    return other is MyGattDescriptor2 &&
        other.peripheral == peripheral &&
        other.handle == handle;
  }
}
