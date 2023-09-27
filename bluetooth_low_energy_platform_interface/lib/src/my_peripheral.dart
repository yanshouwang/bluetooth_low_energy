import 'my_object.dart';
import 'peripheral.dart';
import 'uuid.dart';

class MyPeripheral extends MyObject implements Peripheral {
  @override
  final UUID uuid;

  MyPeripheral({
    required super.myHashCode,
    required this.uuid,
  });
}
