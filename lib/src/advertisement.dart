import 'package:pigeon/pigeon.dart';

import 'peripheral.dart';

abstract class Advertisement {
  Peripheral get peripheral;
  Map<int, Uint8List> get data;
  int get rssi;
}
