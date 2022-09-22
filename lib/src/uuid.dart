import 'impl.dart';

abstract class UUID {
  String get value;

  factory UUID(String value) {
    return MyUUID(value: value);
  }
}
