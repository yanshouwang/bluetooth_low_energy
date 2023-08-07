import 'uuid.dart';

abstract class GattService {
  Future<UUID> getUUID();
}
