import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluez/bluez.dart';

import 'bluez.dart';

final class GATTDescriptorImpl implements GATTDescriptor {
  final BlueZGattDescriptor blueZDescriptor;

  GATTDescriptorImpl(this.blueZDescriptor);

  @override
  UUID get uuid => blueZDescriptor.uuid.toUUID();

  @override
  int get hashCode => blueZDescriptor.hashCode;

  @override
  bool operator ==(Object other) {
    return other is GATTDescriptorImpl &&
        other.blueZDescriptor == blueZDescriptor;
  }
}

final class GATTCharacteristicImpl implements GATTCharacteristic {
  final BlueZGattCharacteristic blueZCharacteristic;

  GATTCharacteristicImpl(this.blueZCharacteristic);

  @override
  UUID get uuid => blueZCharacteristic.uuid.toUUID();

  @override
  List<GATTCharacteristicProperty> get properties => blueZCharacteristic.flags
      .map((e) => e.toProperty())
      .whereType<GATTCharacteristicProperty>()
      .toList();

  @override
  List<GATTDescriptorImpl> get descriptors => blueZCharacteristic.descriptors
      .map((descriptor) => GATTDescriptorImpl(descriptor))
      .toList();

  @override
  int get hashCode => blueZCharacteristic.hashCode;

  @override
  bool operator ==(Object other) {
    return other is GATTCharacteristicImpl &&
        other.blueZCharacteristic == blueZCharacteristic;
  }
}

final class GATTServiceImpl implements GATTService {
  final BlueZGattService blueZService;

  GATTServiceImpl(this.blueZService);

  @override
  UUID get uuid => blueZService.uuid.toUUID();

  @override
  bool get isPrimary => blueZService.primary;

  @override
  // TODO: implement includedServices
  List<GATTServiceImpl> get includedServices => throw UnimplementedError();

  @override
  List<GATTCharacteristicImpl> get characteristics => blueZService
      .characteristics
      .map((characteristic) => GATTCharacteristicImpl(characteristic))
      .toList();

  @override
  int get hashCode => blueZService.hashCode;

  @override
  bool operator ==(Object other) {
    return other is GATTServiceImpl && other.blueZService == blueZService;
  }
}
