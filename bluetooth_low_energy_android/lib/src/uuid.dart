import 'dart:typed_data';

import 'api.dart';
import 'my_uuid.dart';

abstract class UUID {
  static Future<UUID> newInstance(int mostSigBits, int leastSigBits) async {
    final hashCode = await uuidApi.newInstance(mostSigBits, leastSigBits);
    return MyUUID(hashCode);
  }

  static Future<UUID> randomUUID() async {
    final hashCode = await uuidApi.randomUUID();
    return MyUUID(hashCode);
  }

  static Future<UUID> fromString(String name) async {
    final hashCode = await uuidApi.fromString(name);
    return MyUUID(hashCode);
  }

  static Future<UUID> nameUUIDFromBytes(Uint8List name) async {
    final hashCode = await uuidApi.nameUUIDFromBytes(name);
    return MyUUID(hashCode);
  }
}
