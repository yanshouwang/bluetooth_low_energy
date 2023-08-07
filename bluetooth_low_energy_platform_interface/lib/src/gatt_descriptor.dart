import 'uuid.dart';

abstract class GattDescriptor {
  Future<UUID> getUUID();
}
