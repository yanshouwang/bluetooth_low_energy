import 'base_gatt_service.dart';
import 'mutable_gatt_characteristic.dart';

base class MutableGattService extends BaseGattService {
  MutableGattService({
    required super.uuid,
    required List<MutableGattCharacteristic> characteristics,
  }) : super(
          characteristics: characteristics,
        );

  @override
  List<MutableGattCharacteristic> get characteristics =>
      super.characteristics.cast<MutableGattCharacteristic>();
}
