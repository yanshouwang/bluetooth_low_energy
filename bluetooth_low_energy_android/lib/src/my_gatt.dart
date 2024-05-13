import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class MyGATTDescriptor extends GATTDescriptor {
  final String address;
  @override
  final int hashCode;

  MyGATTDescriptor({
    required this.address,
    required this.hashCode,
    required super.uuid,
  });

  @override
  bool operator ==(Object other) {
    return other is MyGATTDescriptor &&
        other.address == address &&
        other.hashCode == hashCode;
  }
}

final class MyGATTCharacteristic extends GATTCharacteristic {
  final String address;
  @override
  final int hashCode;

  MyGATTCharacteristic({
    required this.address,
    required this.hashCode,
    required super.uuid,
    required super.properties,
    required List<MyGATTDescriptor> descriptors,
  }) : super(
          descriptors: descriptors,
        );

  @override
  List<MyGATTDescriptor> get descriptors =>
      super.descriptors.cast<MyGATTDescriptor>();

  @override
  bool operator ==(Object other) {
    return other is MyGATTCharacteristic &&
        other.address == address &&
        other.hashCode == hashCode;
  }
}

final class MyGATTService extends GATTService {
  final String address;
  @override
  final int hashCode;

  MyGATTService({
    required this.address,
    required this.hashCode,
    required super.uuid,
    required List<MyGATTService> includedServices,
    required List<MyGATTCharacteristic> characteristics,
  }) : super(
          includedServices: includedServices,
          characteristics: characteristics,
        );

  @override
  List<MyGATTCharacteristic> get characteristics =>
      super.characteristics.cast<MyGATTCharacteristic>();

  @override
  bool operator ==(Object other) {
    return other is MyGATTService &&
        other.address == address &&
        other.hashCode == hashCode;
  }
}

final class MyGATTCharacteristicReadRequest
    extends GATTCharacteristicReadRequest {
  final int id;

  MyGATTCharacteristicReadRequest({
    required this.id,
    required super.characteristic,
    required super.offset,
  });
}

final class MyGATTCharacteristicWriteRequest
    extends GATTCharacteristicWriteRequest {
  final int id;

  MyGATTCharacteristicWriteRequest({
    required this.id,
    required super.characteristic,
    required super.offset,
    required super.value,
  });
}

final class MyGATTDescriptorReadRequest extends GATTDescriptorReadRequest {
  final int id;

  MyGATTDescriptorReadRequest({
    required this.id,
    required super.descriptor,
    required super.offset,
  });
}

final class MyGATTDescriptorWriteRequest extends GATTDescriptorWriteRequest {
  final int id;

  MyGATTDescriptorWriteRequest({
    required this.id,
    required super.descriptor,
    required super.offset,
    required super.value,
  });
}
