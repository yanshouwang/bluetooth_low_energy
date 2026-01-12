import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class GATTDescriptorImpl extends GATTAttributeImpl
    implements GATTDescriptor {
  @override
  final int hashCode;

  GATTDescriptorImpl({required this.hashCode, required super.uuid});

  @override
  bool operator ==(Object other) {
    return other is GATTDescriptorImpl && other.hashCode == hashCode;
  }
}

final class GATTCharacteristicImpl extends GATTAttributeImpl
    implements GATTCharacteristic {
  @override
  final int hashCode;
  @override
  final List<GATTCharacteristicProperty> properties;
  @override
  final List<GATTDescriptorImpl> descriptors;

  GATTCharacteristicImpl({
    required this.hashCode,
    required super.uuid,
    required this.properties,
    required this.descriptors,
  });

  @override
  bool operator ==(Object other) {
    return other is GATTCharacteristicImpl && other.hashCode == hashCode;
  }
}

final class GATTServiceImpl extends GATTAttributeImpl implements GATTService {
  @override
  final int hashCode;
  @override
  final bool isPrimary;
  @override
  final List<GATTServiceImpl> includedServices;
  @override
  final List<GATTCharacteristicImpl> characteristics;

  GATTServiceImpl({
    required this.hashCode,
    required super.uuid,
    required this.isPrimary,
    required this.includedServices,
    required this.characteristics,
  });

  @override
  bool operator ==(Object other) {
    return other is GATTServiceImpl && other.hashCode == hashCode;
  }
}

final class GATTReadRequestImpl implements GATTReadRequest {
  final String address;
  final int id;
  @override
  final int offset;

  GATTReadRequestImpl({
    required this.address,
    required this.id,
    required this.offset,
  });
}

final class GATTWriteRequestImpl implements GATTWriteRequest {
  final String address;
  final int id;
  @override
  final int offset;
  @override
  final Uint8List value;
  final bool responseNeeded;

  GATTWriteRequestImpl({
    required this.address,
    required this.id,
    required this.offset,
    required this.value,
    required this.responseNeeded,
  });
}
