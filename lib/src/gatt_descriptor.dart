import 'package:pigeon/pigeon.dart';

abstract class GattDescriptor {
  Future<Uint8List> read();
  Future<void> write(Uint8List value);
}
