import 'gatt_descriptor.dart';

class GattCharacteristic {
  final String id;
  final bool canRead;
  final bool canWrite;
  final bool canWriteWithoutResponse;
  final bool canNotify;
  final List<GattDescriptor> descriptors;

  const GattCharacteristic({
    required this.id,
    required this.canRead,
    required this.canWrite,
    required this.canWriteWithoutResponse,
    required this.canNotify,
    required this.descriptors,
  });
}
