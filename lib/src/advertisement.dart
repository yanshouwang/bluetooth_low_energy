import 'package:pigeon/pigeon.dart';

import 'uuid.dart';

abstract class Advertisement {
  UUID get uuid;
  Map<int, Uint8List> get data;
  int get rssi;
  bool get connectable;
}
