import 'dart:convert';

import 'package:pigeon/pigeon.dart';

import 'uuid.dart';

/// The following data type values are assigned by Bluetooth SIG.
///
/// For more details refer to Bluetooth 4.1 specification, Volume 3, Part C, Section 18.
abstract class AdvertisementType {
  static const flags = 0x01;
  static const serviceUUIDs16BitPartial = 0x02;
  static const serviceUUIDs16BitComplete = 0x03;
  static const serviceUUIDs32BitPartial = 0x04;
  static const serviceUUIDs32BitComplete = 0x05;
  static const serviceUUIDs128BitPartial = 0x06;
  static const serviceUUIDs128BitComplete = 0x07;
  static const localNameShort = 0x08;
  static const localNameComplete = 0x09;
  static const txPowerLevel = 0x0a;
  static const serviceData16Bit = 0x16;
  static const serviceData32Bit = 0x20;
  static const serviceData128Bit = 0x21;
  static const serviceSolicitationUUIDs16Bit = 0x14;
  static const serviceSolicitationUUIDs32Bit = 0x1f;
  static const serviceSolicitationUUIDs128Bit = 0x15;
  static const manufacturerSpecificData = 0xff;
}

abstract class Advertisement {
  UUID get uuid;
  Map<int, Uint8List> get data;
  int get rssi;
  bool get connectable;
}

extension AdvertisementProperties on Advertisement {
  String? get shortName {
    final value = data[AdvertisementType.localNameShort];
    if (value == null) {
      return null;
    } else {
      return utf8.decode(value);
    }
  }

  String? get completeName {
    final value = data[AdvertisementType.localNameComplete];
    if (value == null) {
      return null;
    } else {
      return utf8.decode(value);
    }
  }

  String? get name {
    return shortName ?? completeName;
  }

  Uint8List? get manufacturerSpecificData {
    return data[AdvertisementType.manufacturerSpecificData];
  }
}
