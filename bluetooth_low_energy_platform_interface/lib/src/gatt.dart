import 'dart:typed_data';

import 'uuid.dart';

/// A representation of common aspects of services offered by a peripheral.
abstract interface class GattAttribute {
  /// The Bluetooth-specific UUID of the attribute.
  UUID get uuid;
}

/// An object that provides further information about a remote peripheral’s characteristic.
abstract interface class GattDescriptor implements GattAttribute {
  /// Constructs a [GattDescriptor].
  factory GattDescriptor({
    required UUID uuid,
    Uint8List? value,
  }) =>
      MutableGattDescriptor(
        uuid: uuid,
        value: value,
      );
}

/// A characteristic of a remote peripheral’s service.
abstract interface class GattCharacteristic implements GattAttribute {
  /// The properties of the characteristic.
  List<GattCharacteristicProperty> get properties;

  /// A list of the descriptors discovered in this characteristic.
  List<GattDescriptor> get descriptors;

  /// Constructs a [GattCharacteristic].
  factory GattCharacteristic({
    required UUID uuid,
    required List<GattCharacteristicProperty> properties,
    Uint8List? value,
    required List<GattDescriptor> descriptors,
  }) =>
      MutableGattCharacteristic(
        uuid: uuid,
        properties: properties,
        value: value,
        descriptors: descriptors.cast<MutableGattDescriptor>(),
      );
}

/// A collection of data and associated behaviors that accomplish a function or feature of a device.
abstract interface class GattService implements GattAttribute {
  /// A list of characteristics discovered in this service.
  List<GattCharacteristic> get characteristics;

  /// Constructs a [GattService].
  factory GattService({
    required UUID uuid,
    required List<GattCharacteristic> characteristics,
  }) =>
      MutableGattService(
        uuid: uuid,
        characteristics: characteristics.cast<MutableGattCharacteristic>(),
      );
}

abstract base class BaseGattAttribute implements GattAttribute {
  @override
  final UUID uuid;

  BaseGattAttribute({
    required this.uuid,
  });
}

abstract base class BaseGattDescriptor extends BaseGattAttribute
    implements GattDescriptor {
  BaseGattDescriptor({
    required super.uuid,
  });
}

abstract base class BaseGattCharacteristic extends BaseGattAttribute
    implements GattCharacteristic {
  @override
  final List<GattCharacteristicProperty> properties;

  @override
  final List<GattDescriptor> descriptors;

  BaseGattCharacteristic({
    required super.uuid,
    required this.properties,
    required this.descriptors,
  });
}

abstract base class BaseGattService extends BaseGattAttribute
    implements GattService {
  @override
  final List<GattCharacteristic> characteristics;

  BaseGattService({
    required super.uuid,
    required this.characteristics,
  });
}

base class MutableGattDescriptor extends BaseGattDescriptor {
  Uint8List _value;

  MutableGattDescriptor({
    required super.uuid,
    Uint8List? value,
  }) : _value = value?.trimGATT() ?? Uint8List(0);

  Uint8List get value => _value;
  set value(Uint8List value) {
    _value = value.trimGATT();
  }
}

base class MutableGattCharacteristic extends BaseGattCharacteristic {
  Uint8List _value;

  MutableGattCharacteristic({
    required super.uuid,
    required super.properties,
    Uint8List? value,
    required List<MutableGattDescriptor> descriptors,
  })  : _value = value?.trimGATT() ?? Uint8List(0),
        super(
          descriptors: descriptors,
        );

  Uint8List get value => _value;
  set value(Uint8List value) {
    _value = value.trimGATT();
  }

  @override
  List<MutableGattDescriptor> get descriptors =>
      super.descriptors.cast<MutableGattDescriptor>();
}

base class MutableGattService extends BaseGattService {
  MutableGattService({
    required super.uuid,
    required List<MutableGattCharacteristic> characteristics,
  }) : super(
          characteristics: characteristics,
        );

  @override
  List<MutableGattCharacteristic> get characteristics =>
      super.characteristics.cast<MutableGattCharacteristic>();
}

/// The properity for a GATT characteristic.
enum GattCharacteristicProperty {
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
enum GattCharacteristicWriteType {
  // Write with response
  withResponse,
  // Write without response
  withoutResponse,
  // Write with response and waiting for confirmation
  // reliable,
}

/// The GATT Unit8List extension.
extension GattUint8List on Uint8List {
  Uint8List trimGATT() {
    return length > 512 ? sublist(0, 512) : this;
  }
}
