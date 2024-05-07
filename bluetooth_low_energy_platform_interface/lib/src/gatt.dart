import 'dart:typed_data';

import 'uuid.dart';

/// A representation of common aspects of services offered by a peripheral.
abstract interface class GATTAttribute {
  /// The Bluetooth-specific UUID of the attribute.
  UUID get uuid;
}

/// An object that provides further information about a remote peripheral’s characteristic.
abstract interface class GATTDescriptor implements GATTAttribute {
  /// Constructs a [GATTDescriptor].
  factory GATTDescriptor({
    required UUID uuid,
    Uint8List? value,
  }) =>
      MutableGATTDescriptor(
        uuid: uuid,
        value: value,
      );
}

/// A characteristic of a remote peripheral’s service.
abstract interface class GATTCharacteristic implements GATTAttribute {
  /// The properties of the characteristic.
  List<GATTCharacteristicProperty> get properties;

  /// A list of the descriptors discovered in this characteristic.
  List<GATTDescriptor> get descriptors;

  /// Constructs a [GATTCharacteristic].
  factory GATTCharacteristic({
    required UUID uuid,
    required List<GATTCharacteristicProperty> properties,
    Uint8List? value,
    required List<GATTDescriptor> descriptors,
  }) =>
      MutableGATTCharacteristic(
        uuid: uuid,
        properties: properties,
        value: value,
        descriptors: descriptors.cast<MutableGATTDescriptor>(),
      );
}

/// A collection of data and associated behaviors that accomplish a function or feature of a device.
abstract interface class GATTService implements GATTAttribute {
  /// A list of characteristics discovered in this service.
  List<GATTCharacteristic> get characteristics;

  /// Constructs a [GATTService].
  factory GATTService({
    required UUID uuid,
    required List<GATTCharacteristic> characteristics,
  }) =>
      MutableGATTService(
        uuid: uuid,
        characteristics: characteristics.cast<MutableGATTCharacteristic>(),
      );
}

abstract base class BaseGATTAttribute implements GATTAttribute {
  @override
  final UUID uuid;

  BaseGATTAttribute({
    required this.uuid,
  });
}

abstract base class BaseGATTDescriptor extends BaseGATTAttribute
    implements GATTDescriptor {
  BaseGATTDescriptor({
    required super.uuid,
  });
}

abstract base class BaseGATTCharacteristic extends BaseGATTAttribute
    implements GATTCharacteristic {
  @override
  final List<GATTCharacteristicProperty> properties;

  @override
  final List<GATTDescriptor> descriptors;

  BaseGATTCharacteristic({
    required super.uuid,
    required this.properties,
    required this.descriptors,
  });
}

abstract base class BaseGATTService extends BaseGATTAttribute
    implements GATTService {
  @override
  final List<GATTCharacteristic> characteristics;

  BaseGATTService({
    required super.uuid,
    required this.characteristics,
  });
}

final class MutableGATTDescriptor extends BaseGATTDescriptor {
  Uint8List? _value;

  MutableGATTDescriptor({
    required super.uuid,
    Uint8List? value,
  }) : _value = value?.trimGATT();

  Uint8List? get value => _value;
  set value(Uint8List? value) {
    _value = value?.trimGATT();
  }
}

final class MutableGATTCharacteristic extends BaseGATTCharacteristic {
  Uint8List? _value;

  MutableGATTCharacteristic({
    required super.uuid,
    required super.properties,
    Uint8List? value,
    required List<MutableGATTDescriptor> descriptors,
  })  : _value = value?.trimGATT(),
        super(
          descriptors: descriptors,
        );

  Uint8List? get value => _value;
  set value(Uint8List? value) {
    _value = value?.trimGATT();
  }

  @override
  List<MutableGATTDescriptor> get descriptors =>
      super.descriptors.cast<MutableGATTDescriptor>();
}

final class MutableGATTService extends BaseGATTService {
  MutableGATTService({
    required super.uuid,
    required List<MutableGATTCharacteristic> characteristics,
  }) : super(
          characteristics: characteristics,
        );

  @override
  List<MutableGATTCharacteristic> get characteristics =>
      super.characteristics.cast<MutableGATTCharacteristic>();
}

/// The properity for a GATT characteristic.
enum GATTCharacteristicProperty {
  /// The GATT characteristic is able to read.
  read,

  /// The GATT characteristic is able to write.
  write,

  /// The GATT characteristic is able to write without response.
  writeWithoutResponse,

  /// The GATT characteristic is able to notify.
  notify,

  /// The GATT characteristic is able to indicate.
  indicate,
}

/// The write type for a GATT characteristic.
enum GATTCharacteristicWriteType {
  // Write with response
  withResponse,
  // Write without response
  withoutResponse,
  // Write with response and waiting for confirmation
  // reliable,
}

/// The GATT Unit8List extension.
extension GATTUint8List on Uint8List {
  Uint8List trimGATT() {
    return length > 512 ? sublist(0, 512) : this;
  }
}
