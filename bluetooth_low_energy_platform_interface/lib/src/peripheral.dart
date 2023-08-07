import 'uuid.dart';

abstract class Peripheral {
  Future<UUID> getUUID();
}
