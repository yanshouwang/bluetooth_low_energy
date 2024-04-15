import 'dart:typed_data';

import 'package:hybrid_core/hybrid_core.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The abstract base impl class that manages central and peripheral objects.
abstract base class BluetoothLowEnergyManagerImpl extends PlatformInterface
    with LoggerProvider, LoggerController
    implements BluetoothLowEnergyManager {
  /// Constructs a [BluetoothLowEnergyManagerImpl].
  BluetoothLowEnergyManagerImpl({
    required super.token,
  });

  /// Initializes the [BluetoothLowEnergyManagerImpl].
  void initialize();
}

/// The abstract base class that manages central and peripheral objects.
abstract interface class BluetoothLowEnergyManager implements LogController {
  /// Tells the manager's state updated.
  Stream<BluetoothLowEnergyStateChangedEventArgs> get stateChanged;

  /// Gets the manager's state.
  Future<BluetoothLowEnergyState> getState();
}

/// An object that represents a remote device.
abstract interface class BluetoothLowEnergyPeer {
  /// The UUID associated with the peer.
  UUID get uuid;
}

abstract base class BluetoothLowEnergyPeerImpl
    implements BluetoothLowEnergyPeer {
  @override
  final UUID uuid;

  BluetoothLowEnergyPeerImpl({
    required this.uuid,
  });
}

/// The manufacturer specific data of the peripheral
class ManufacturerSpecificData {
  /// The manufacturer id.
  final int id;

  /// The manufacturer data.
  final Uint8List data;

  /// Constructs an [ManufacturerSpecificData].
  ManufacturerSpecificData({
    required this.id,
    required this.data,
  });
}

/// The advertisement of the peripheral.
class Advertisement {
  /// The name of the peripheral.
  final String? name;

  /// The GATT service uuids of the peripheral.
  final List<UUID> serviceUUIDs;

  /// The GATT service data of the peripheral.
  final Map<UUID, Uint8List> serviceData;

  /// The manufacturer specific data of the peripheral.
  final ManufacturerSpecificData? manufacturerSpecificData;

  /// Constructs an [Advertisement].
  Advertisement({
    this.name,
    this.serviceUUIDs = const [],
    this.serviceData = const {},
    this.manufacturerSpecificData,
  });
}

/// A representation of common aspects of services offered by a peripheral.
abstract class GattAttribute {
  /// The Bluetooth-specific UUID of the attribute.
  UUID get uuid;
}

/// An object that provides further information about a remote peripheral’s characteristic.
abstract class GattDescriptor extends GattAttribute {
  /// Constructs a [GattDescriptor].
  factory GattDescriptor({
    required UUID uuid,
    Uint8List? value,
  }) =>
      GattDescriptorImpl(
        uuid: uuid,
        value: value,
      );
}

/// A characteristic of a remote peripheral’s service.
abstract class GattCharacteristic extends GattAttribute {
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
      GattCharacteristicImpl(
        uuid: uuid,
        properties: properties,
        value: value,
        descriptors: descriptors.cast<GattDescriptorImpl>(),
      );
}

/// A collection of data and associated behaviors that accomplish a function or feature of a device.
abstract class GattService extends GattAttribute {
  /// A list of characteristics discovered in this service.
  List<GattCharacteristic> get characteristics;

  /// Constructs a [GattService].
  factory GattService({
    required UUID uuid,
    required List<GattCharacteristic> characteristics,
  }) =>
      GattServiceImpl(
        uuid: uuid,
        characteristics: characteristics.cast<GattCharacteristicImpl>(),
      );
}

abstract base class GattAttributeImpl implements GattAttribute {
  @override
  final UUID uuid;

  GattAttributeImpl({
    required this.uuid,
  });
}

base class GattDescriptorImpl extends GattAttributeImpl
    implements GattDescriptor {
  Uint8List _value;

  GattDescriptorImpl({
    required super.uuid,
    Uint8List? value,
  }) : _value = value?.trimGATT() ?? Uint8List(0);

  Uint8List get value => _value;
  set value(Uint8List value) {
    _value = value.trimGATT();
  }
}

base class GattCharacteristicImpl extends GattAttributeImpl
    implements GattCharacteristic {
  Uint8List _value;
  @override
  final List<GattCharacteristicProperty> properties;
  @override
  final List<GattDescriptorImpl> descriptors;

  GattCharacteristicImpl({
    required super.uuid,
    required this.properties,
    Uint8List? value,
    required this.descriptors,
  }) : _value = value?.trimGATT() ?? Uint8List(0);

  Uint8List get value => _value;
  set value(Uint8List value) {
    _value = value.trimGATT();
  }
}

base class GattServiceImpl extends GattAttributeImpl implements GattService {
  @override
  final List<GattCharacteristicImpl> characteristics;

  GattServiceImpl({
    required super.uuid,
    required this.characteristics,
  });
}

/// 128 bit universally unique identifier used in Bluetooth.
class UUID {
  /// The value of the UUID in 16 bytes.
  final List<int> value;

  /// True if the UUID is a short (16 or 32 bit) encoded UUID.
  bool get isShort =>
      value[4] == 0x00 &&
      value[5] == 0x00 &&
      value[6] == 0x10 &&
      value[7] == 0x00 &&
      value[8] == 0x80 &&
      value[9] == 0x00 &&
      value[10] == 0x00 &&
      value[11] == 0x80 &&
      value[12] == 0x5f &&
      value[13] == 0x9b &&
      value[14] == 0x34 &&
      value[15] == 0xfb;

  /// Creates a new UUID from 16 bytes.
  UUID(Iterable<int> value) : value = value.toList() {
    if (value.length != 16) {
      throw const FormatException('Invalid length UUID');
    }
  }

  // Creates a new Bluetooth UUID from the short (16 or 32 bit) encoding.
  UUID.short(int shortValue)
      : value = [
          (shortValue >> 24) & 0xff,
          (shortValue >> 16) & 0xff,
          (shortValue >> 8) & 0xff,
          (shortValue >> 0) & 0xff,
          0x00,
          0x00,
          0x10,
          0x00,
          0x80,
          0x00,
          0x00,
          0x80,
          0x5f,
          0x9b,
          0x34,
          0xfb
        ];

  /// Creates a new UUID from the string format encoding (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx where xx is a hexadecimal number).
  factory UUID.fromString(String value) {
    // 16 or 32 bits UUID.
    if (value.length == 4 || value.length == 8) {
      final shortValue = int.tryParse(value, radix: 16);
      if (shortValue == null) {
        throw const FormatException('Invalid UUID string');
      }
      return UUID.short(shortValue);
    }
    var groups = value.split('-');
    if (groups.length != 5 ||
        groups[0].length != 8 ||
        groups[1].length != 4 ||
        groups[2].length != 4 ||
        groups[3].length != 4 ||
        groups[4].length != 12) {
      throw const FormatException('Invalid UUID string');
    }
    int group0, group1, group2, group3, group4;
    try {
      group0 = int.parse(groups[0], radix: 16);
      group1 = int.parse(groups[1], radix: 16);
      group2 = int.parse(groups[2], radix: 16);
      group3 = int.parse(groups[3], radix: 16);
      group4 = int.parse(groups[4], radix: 16);
    } catch (e) {
      throw const FormatException('Invalid UUID string');
    }
    return UUID([
      (group0 >> 24) & 0xff,
      (group0 >> 16) & 0xff,
      (group0 >> 8) & 0xff,
      (group0 >> 0) & 0xff,
      (group1 >> 8) & 0xff,
      (group1 >> 0) & 0xff,
      (group2 >> 8) & 0xff,
      (group2 >> 0) & 0xff,
      (group3 >> 8) & 0xff,
      (group3 >> 0) & 0xff,
      (group4 >> 40) & 0xff,
      (group4 >> 32) & 0xff,
      (group4 >> 24) & 0xff,
      (group4 >> 16) & 0xff,
      (group4 >> 8) & 0xff,
      (group4 >> 0) & 0xff,
    ]);
  }

  /// Creates a new UUID form MAC address.
  factory UUID.fromAddress(String address) {
    final node = address.splitMapJoin(
      ':',
      onMatch: (m) => '',
    );
    // We don't know the timestamp of the bluetooth device, use nil UUID as prefix.
    return UUID.fromString("00000000-0000-0000-0000-$node");
  }

  @override
  String toString() {
    var v0 = value[0].toRadixString(16).padLeft(2, '0');
    var v1 = value[1].toRadixString(16).padLeft(2, '0');
    var v2 = value[2].toRadixString(16).padLeft(2, '0');
    var v3 = value[3].toRadixString(16).padLeft(2, '0');
    var v4 = value[4].toRadixString(16).padLeft(2, '0');
    var v5 = value[5].toRadixString(16).padLeft(2, '0');
    var v6 = value[6].toRadixString(16).padLeft(2, '0');
    var v7 = value[7].toRadixString(16).padLeft(2, '0');
    var v8 = value[8].toRadixString(16).padLeft(2, '0');
    var v9 = value[9].toRadixString(16).padLeft(2, '0');
    var v10 = value[10].toRadixString(16).padLeft(2, '0');
    var v11 = value[11].toRadixString(16).padLeft(2, '0');
    var v12 = value[12].toRadixString(16).padLeft(2, '0');
    var v13 = value[13].toRadixString(16).padLeft(2, '0');
    var v14 = value[14].toRadixString(16).padLeft(2, '0');
    var v15 = value[15].toRadixString(16).padLeft(2, '0');
    return '$v0$v1$v2$v3-$v4$v5-$v6$v7-$v8$v9-$v10$v11$v12$v13$v14$v15';
  }

  @override
  bool operator ==(other) =>
      other is UUID &&
      other.value[0] == value[0] &&
      other.value[1] == value[1] &&
      other.value[2] == value[2] &&
      other.value[3] == value[3] &&
      other.value[4] == value[4] &&
      other.value[5] == value[5] &&
      other.value[6] == value[6] &&
      other.value[7] == value[7] &&
      other.value[8] == value[8] &&
      other.value[9] == value[9] &&
      other.value[10] == value[10] &&
      other.value[11] == value[11] &&
      other.value[12] == value[12] &&
      other.value[13] == value[13] &&
      other.value[14] == value[14] &&
      other.value[15] == value[15];

  @override
  int get hashCode => value.fold(17, (prev, value) => 37 * prev + value);
}

/// The base event arguments.
abstract base class EventArgs {}

/// The bluetooth low energy state changed event arguments.
base class BluetoothLowEnergyStateChangedEventArgs extends EventArgs {
  /// The new state of the bluetooth low energy.
  final BluetoothLowEnergyState state;

  /// Constructs a [BluetoothLowEnergyStateChangedEventArgs].
  BluetoothLowEnergyStateChangedEventArgs(this.state);
}

/// The state of the bluetooth low energy.
enum BluetoothLowEnergyState {
  /// The bluetooth low energy is unknown.
  unknown,

  /// The bluetooth low energy is unsupported.
  unsupported,

  /// The bluetooth low energy is unauthorized.
  unauthorized,

  /// The bluetooth low energy is powered off.
  poweredOff,

  /// The bluetooth low energy is powered on.
  poweredOn,
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

extension GattUint8List on Uint8List {
  Uint8List trimGATT() {
    return length > 512 ? sublist(0, 512) : this;
  }
}
