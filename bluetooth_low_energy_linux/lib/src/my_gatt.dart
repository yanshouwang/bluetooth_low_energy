import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'my_bluez.dart';

final class MyGATTDescriptor extends GATTDescriptor {
  final BlueZGattDescriptor blueZDescriptor;

  MyGATTDescriptor(this.blueZDescriptor) : super(uuid: blueZDescriptor.myUUID);

  @override
  int get hashCode => blueZDescriptor.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyGATTDescriptor &&
        other.blueZDescriptor == blueZDescriptor;
  }
}

final class MyGATTCharacteristic extends GATTCharacteristic {
  final BlueZGattCharacteristic blueZCharacteristic;

  MyGATTCharacteristic(this.blueZCharacteristic)
    : super(
        uuid: blueZCharacteristic.myUUID,
        properties: blueZCharacteristic.myProperties,
        descriptors: blueZCharacteristic.myDescriptors,
      );

  @override
  List<MyGATTDescriptor> get descriptors =>
      super.descriptors.cast<MyGATTDescriptor>();

  @override
  int get hashCode => blueZCharacteristic.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyGATTCharacteristic &&
        other.blueZCharacteristic == blueZCharacteristic;
  }
}

final class MyGATTService extends GATTService {
  final BlueZGattService blueZService;

  MyGATTService(this.blueZService)
    : super(
        uuid: blueZService.myUUID,
        isPrimary: blueZService.primary,
        includedServices: [],
        characteristics: blueZService.myCharacteristics,
      );

  @override
  List<MyGATTService> get includedServices =>
      throw UnsupportedError('includedServices is not supported on Linux.');

  @override
  List<MyGATTCharacteristic> get characteristics =>
      super.characteristics.cast<MyGATTCharacteristic>();

  @override
  int get hashCode => blueZService.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyGATTService && other.blueZService == blueZService;
  }
}
