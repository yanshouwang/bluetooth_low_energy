import 'mac.dart';

abstract class GATT {
  MAC get address;
  Stream<Exception> get connectionLost;

  Future disconnect();
}
