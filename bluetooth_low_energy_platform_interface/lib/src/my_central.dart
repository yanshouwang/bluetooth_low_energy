import 'central.dart';
import 'my_object.dart';
import 'uuid.dart';

class MyCentral extends MyObject implements Central {
  @override
  final UUID uuid;

  MyCentral({
    required super.myHashCode,
    required this.uuid,
  });
}
