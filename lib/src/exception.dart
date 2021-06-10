import 'bluetooth.dart';

abstract class Exception {
  String get message;
}

abstract class ConnectionLostException extends Exception {
  Peripheral get peripheral;
}
