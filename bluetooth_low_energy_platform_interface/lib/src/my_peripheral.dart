import 'peripheral.dart';
import 'uuid.dart';

class MyPeripheral extends Peripheral {
  @override
  final UUID uuid;

  MyPeripheral({
    required this.uuid,
  });
}
