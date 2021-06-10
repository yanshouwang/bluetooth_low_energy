import 'bluetooth.dart';

abstract class Discovery {
  Peripheral get peripheral;
  int get rssi;
  Map<int, List<int>> get advertisements;
}
