import 'mac.dart';

abstract class Bluetooth {
  MAC get address;
}

abstract class Central extends Bluetooth {}

abstract class Peripheral extends Bluetooth {}
