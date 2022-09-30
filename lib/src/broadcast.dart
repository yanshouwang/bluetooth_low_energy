import 'dart:typed_data';

import 'peripheral.dart';
import 'uuid.dart';

abstract class Broadcast {
  Peripheral get peripheral;
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
