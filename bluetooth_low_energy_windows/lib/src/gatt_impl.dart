import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

final class GATTDescriptorImpl extends GATTAttributeImpl
    implements GATTDescriptor {
  final int handle;

  GATTDescriptorImpl({required this.handle, required super.uuid});

  @override
  int get hashCode => handle.hashCode;

  @override
  bool operator ==(Object other) {
    return other is GATTDescriptorImpl && other.handle == handle;
  }
}

final class GATTCharacteristicImpl extends GATTAttributeImpl
    implements GATTCharacteristic {
  final int handle;
  @override
  final List<GATTCharacteristicProperty> properties;
  @override
  final List<GATTDescriptorImpl> descriptors;

  GATTCharacteristicImpl({
    required this.handle,
    required super.uuid,
    required this.properties,
    required this.descriptors,
  });

  @override
  int get hashCode => handle.hashCode;

  @override
  bool operator ==(Object other) {
    return other is GATTCharacteristicImpl && other.handle == handle;
  }
}

final class GATTServiceImpl extends GATTAttributeImpl implements GATTService {
  final int handle;
  @override
  final bool isPrimary;
  @override
  final List<GATTServiceImpl> includedServices;
  @override
  final List<GATTCharacteristicImpl> characteristics;

  GATTServiceImpl({
    required this.handle,
    required super.uuid,
    required this.isPrimary,
    required this.includedServices,
    required this.characteristics,
  });

  @override
  int get hashCode => handle.hashCode;

  @override
  bool operator ==(Object other) {
    return other is GATTServiceImpl && other.handle == handle;
  }
}

final class GATTReadRequestImpl implements GATTReadRequest {
  final int id;
  @override
  final int offset;
  final int length;

  GATTReadRequestImpl({
    required this.id,
    required this.offset,
    required this.length,
  });
}

final class GATTWriteRequestImpl implements GATTWriteRequest {
  final int id;
  @override
  final int offset;
  @override
  final Uint8List value;
  final GATTCharacteristicWriteType type;

  GATTWriteRequestImpl({
    required this.id,
    required this.offset,
    required this.value,
    required this.type,
  });
}
