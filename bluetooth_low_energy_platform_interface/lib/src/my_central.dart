import 'central.dart';
import 'uuid.dart';

class MyCentral implements Central {
  @override
  final UUID uuid;

  MyCentral({
    required this.uuid,
  });
}
