import 'peripheral.dart';
import 'uuid.dart';

abstract class GattService {
  Peripheral get peripehral;
  UUID get uuid;
}
