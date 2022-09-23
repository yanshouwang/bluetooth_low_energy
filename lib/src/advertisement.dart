import 'dart:typed_data';

import 'uuid.dart';

abstract class Advertisement {
  UUID get uuid;
  int get rssi;
  bool? get connectable;
  Uint8List get data;
  String? get localName;
  Uint8List get manufacturerSpecificData;
  Map<UUID, Uint8List> get serviceData;
  List<UUID> get serviceUUIDs;
  List<UUID> get solicitedServiceUUIDs;
  int? get txPowerLevel;
}
