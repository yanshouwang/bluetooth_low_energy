import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'uuid.dart';

/// A representation of common aspects of services offered by a peripheral.
abstract base class GATTAttribute {
  /// The Bluetooth-specific UUID of the attribute.
  final UUID uuid;

  /// Constructs a [GATTAttribute].
  GATTAttribute({
    required this.uuid,
  });
}

/// An object that provides further information about a remote peripheral’s
/// characteristic.
abstract base class GATTDescriptor extends GATTAttribute {
  /// Constructs a [GATTDescriptor].
  GATTDescriptor({
    required super.uuid,
  });

  /// Creates a mutable descriptor.
  ///
  /// [uuid] A 128-bit UUID that identifies the characteristic. You must use only
  /// one of the two currently supported descriptor types:
  /// CBUUIDCharacteristicUserDescriptionString or CBUUIDCharacteristicFormatString.
  /// For more details about these descriptor types, see CBUUID.
  factory GATTDescriptor.mutable({
    required UUID uuid,
    required List<GATTCharacteristicPermission> permissions,
  }) =>
      MutableGATTDescriptor(
        uuid: uuid,
        permissions: permissions,
      );

  /// Creates a immutable descriptor with a specified value.
  ///
  /// [uuid] A 128-bit UUID that identifies the characteristic. You must use only
  /// one of the two currently supported descriptor types:
  /// CBUUIDCharacteristicUserDescriptionString or CBUUIDCharacteristicFormatString.
  /// For more details about these descriptor types, see CBUUID.
  ///
  /// [value] The descriptor value to cache. You must provide a non-nil value.
  /// Once published, you can’t update the value dynamically.
  factory GATTDescriptor.immutable({
    required UUID uuid,
    required Uint8List value,
  }) =>
      ImmutableGATTDescriptor(
        uuid: uuid,
        value: value,
      );
}

/// A characteristic of a remote peripheral’s service.
abstract base class GATTCharacteristic extends GATTAttribute {
  /// The properties of the characteristic.
  final List<GATTCharacteristicProperty> properties;

  /// A list of the descriptors discovered in this characteristic.
  final List<GATTDescriptor> descriptors;

  /// Constructs a [GATTCharacteristic].
  GATTCharacteristic({
    required super.uuid,
    required this.properties,
    required this.descriptors,
  });

  /// Creates a mutable characteristic with specified permissions, properties.
  ///
  /// [uuid] A 128-bit UUID that identifies the characteristic.
  ///
  /// [properties] The properties of the characteristic.
  ///
  /// [permissions] The permissions of the characteristic value.
  factory GATTCharacteristic.mutable({
    required UUID uuid,
    required List<GATTCharacteristicProperty> properties,
    required List<GATTCharacteristicPermission> permissions,
    required List<GATTDescriptor> descriptors,
  }) =>
      MutableGATTCharacteristic(
        uuid: uuid,
        properties: properties,
        permissions: permissions,
        descriptors: descriptors,
      );

  /// Creates a immutable characteristic with a specified value.
  ///
  /// [uuid] A 128-bit UUID that identifies the characteristic.
  ///
  /// [value] The characteristic value to cache. You must provide a non-nil value.
  /// Once published, you can’t update the value dynamically.
  factory GATTCharacteristic.immutable({
    required UUID uuid,
    required Uint8List value,
    required List<GATTDescriptor> descriptors,
  }) =>
      ImmutableGATTCharacteristic(
        uuid: uuid,
        value: value,
        descriptors: descriptors,
      );
}

/// A collection of data and associated behaviors that accomplish a function or
/// feature of a device.
abstract base class GATTService extends GATTAttribute {
  /// A Boolean value that indicates whether the type of service is primary or
  /// secondary.
  final bool isPrimary;

  /// A list of included services discovered in this service.
  final List<GATTService> includedServices;

  /// A list of characteristics discovered in this service.
  final List<GATTCharacteristic> characteristics;

  /// Creates a newly initialized mutable service specified by UUID and service
  /// type.
  GATTService({
    required super.uuid,
    required this.isPrimary,
    required this.includedServices,
    required this.characteristics,
  });
}

/// An object that provides additional information about a local peripheral’s
/// characteristic.
final class MutableGATTDescriptor extends GATTDescriptor {
  /// The permissions of the descriptor value.
  final List<GATTCharacteristicPermission> permissions;

  /// Creates a mutable descriptor with a specified value.
  ///
  /// [uuid] A 128-bit UUID that identifies the characteristic. You must use only
  /// one of the two currently supported descriptor types:
  /// CBUUIDCharacteristicUserDescriptionString or CBUUIDCharacteristicFormatString.
  /// For more details about these descriptor types, see CBUUID.
  ///
  /// [permissions] The permissions of the descriptor value.
  MutableGATTDescriptor({
    required super.uuid,
    required this.permissions,
  });
}

/// An object that provides additional information about a local peripheral’s
/// characteristic.
final class ImmutableGATTDescriptor extends MutableGATTDescriptor {
  /// The value of the descriptor.
  final Uint8List value;

  /// Creates an immutable descriptor with a specified value.
  ///
  /// [uuid] A 128-bit UUID that identifies the characteristic. You must use only
  /// one of the two currently supported descriptor types:
  /// CBUUIDCharacteristicUserDescriptionString or CBUUIDCharacteristicFormatString.
  /// For more details about these descriptor types, see CBUUID.
  ///
  /// [value] The descriptor value to cache. You must provide a non-nil value.
  /// Once published, you can’t update the value dynamically.
  ImmutableGATTDescriptor({
    required super.uuid,
    required this.value,
  }) : super(
          permissions: [
            GATTCharacteristicPermission.read,
          ],
        );
}

/// A mutable characteristic of a local peripheral’s service.
final class MutableGATTCharacteristic extends GATTCharacteristic {
  /// The permissions of the characteristic value.
  final List<GATTCharacteristicPermission> permissions;

  /// Creates a mutable characteristic with specified permissions, properties.
  ///
  /// [uuid] A 128-bit UUID that identifies the characteristic.
  ///
  /// [properties] The properties of the characteristic.
  ///
  /// [permissions] The permissions of the characteristic value.
  MutableGATTCharacteristic({
    required super.uuid,
    required super.properties,
    required this.permissions,
    required super.descriptors,
  });
}

/// An immutable characteristic of a local peripheral’s service.
final class ImmutableGATTCharacteristic extends MutableGATTCharacteristic {
  /// The value of the characteristic.
  final Uint8List value;

  /// Creates an immutable characteristic with a specified value.
  ///
  /// [uuid] A 128-bit UUID that identifies the characteristic.
  ///
  /// [value] The characteristic value to cache. You must provide a non-nil value.
  /// Once published, you can’t update the value dynamically.
  ImmutableGATTCharacteristic({
    required super.uuid,
    required this.value,
    required super.descriptors,
  }) : super(
          properties: [
            GATTCharacteristicProperty.read,
          ],
          permissions: [
            GATTCharacteristicPermission.read,
          ],
        );
}

/// A read request that uses the Attribute Protocol (ATT).
abstract base class GATTReadRequest {
  /// The zero-based index of the first byte for the read request.
  final int offset;

  /// Constructs a [GATTReadRequest].
  GATTReadRequest({
    required this.offset,
  });
}

/// A write request that uses the Attribute Protocol (ATT).
abstract base class GATTWriteRequest {
  /// The zero-based index of the first byte for the write request.
  final int offset;

  /// The data that the central writes to the peripheral.
  final Uint8List value;

  /// Constructs a [GATTWriteRequest].
  GATTWriteRequest({
    required this.offset,
    required this.value,
  });
}

/// Values that represent the possible properties of a characteristic.
enum GATTCharacteristicProperty {
  /// A property that indicates a peripheral can read the characteristic’s value.
  read,

  /// A property that indicates a peripheral can write the characteristic’s value,
  /// with a response to indicate that the write succeeded.
  write,

  /// A property that indicates a peripheral can write the characteristic’s value,
  /// without a response to indicate that the write succeeded.
  writeWithoutResponse,

  /// A property that indicates the peripheral permits notifications of the
  /// characteristic’s value, without a response from the central to indicate
  /// receipt of the notification.
  notify,

  /// A property that indicates the peripheral permits notifications of the
  /// characteristic’s value, with a response from the central to indicate receipt
  /// of the notification.
  indicate,
}

/// Values that represent the read, write, and encryption permissions for a
/// characteristic’s value.
enum GATTCharacteristicPermission {
  /// A permission that indicates a peripheral can read the attribute’s value.
  read,

  /// A permission that indicates only trusted devices can read the attribute’s
  /// value.
  readEncrypted,

  /// A permission that indicates a peripheral can write the attribute’s value.
  write,

  /// A permission that indicates only trusted devices can write the attribute’s
  /// value.
  writeEncrypted,
}

/// Values representing the possible write types to a characteristic’s value.
enum GATTCharacteristicWriteType {
  /// Write a characteristic value, with a response from the peripheral to indicate
  /// whether the write was successful.
  withResponse,

  /// Write a characteristic value, without any response from the peripheral to
  /// indicate whether the write was successful.
  withoutResponse,
}

/// The possible errors returned by a GATT server (a remote peripheral) during
/// Bluetooth low energy ATT transactions.
enum GATTError {
  /// The attribute handle is invalid on this peripheral.
  invalidHandle,

  /// The permissions prohibit reading the attribute’s value.
  readNotPermitted,

  /// The permissions prohibit writing the attribute’s value.
  writeNotPermitted,

  /// The attribute Protocol Data Unit (PDU) is invalid.
  invalidPDU,

  /// Reading or writing the attribute’s value failed for lack of authentication.
  insufficientAuthentication,

  /// The attribute server doesn’t support the request received from the client.
  requestNotSupported,

  /// The specified offset value was past the end of the attribute’s value.
  invalidOffset,

  /// Reading or writing the attribute’s value failed for lack of authorization.
  insufficientAuthorization,

  /// The prepare queue is full, as a result of there being too many write requests
  /// in the queue.
  prepareQueueFull,

  /// The attribute wasn’t found within the specified attribute handle range.
  attributeNotFound,

  /// The ATT read blob request can’t read or write the attribute.
  attributeNotLong,

  /// The encryption key size used for encrypting this link is insufficient.
  insufficientEncryptionKeySize,

  /// The length of the attribute’s value is invalid for the intended operation.
  invalidAttributeValueLength,

  /// The ATT request encountered an unlikely error and wasn’t completed.
  unlikelyError,

  /// Reading or writing the attribute’s value failed for lack of encryption.
  insufficientEncryption,

  /// The attribute type isn’t a supported grouping attribute as defined by a
  /// higher-layer specification.
  unsupportedGroupType,

  /// Resources are insufficient to complete the ATT request.
  insufficientResources,
}
