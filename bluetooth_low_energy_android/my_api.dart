import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class MyCentralManagerHostApi {
  int getState();
  @async
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(String id);
  void disconnect(String id);
  @async
  List<MyGattService> discoverServices(String id);
  @async
  Uint8List readCharacteristic(
    String id,
    String serviceId,
    String characteristicId,
  );
  @async
  void writeCharacteristic(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value,
    int type,
  );
  @async
  void notifyCharacteristic(
    String id,
    String serviceId,
    String characteristicId,
    bool value,
  );
  @async
  Uint8List readDescriptor(
    String id,
    String serviceId,
    String characteristicId,
    String descriptorId,
  );
  @async
  void writeDescriptor(
    String id,
    String serviceId,
    String characteristicId,
    String descriptorId,
    Uint8List value,
  );
}

@FlutterApi()
abstract class MyCentralManagerFlutterApi {
  void onStateChanged(int state);
  void onDiscovered(MyPeripheral peripheral);
  void onPeripheralStateChanged(String id, int state);
  void onCharacteristicValueChanged(
    String id,
    String serviceId,
    String characteristicId,
    Uint8List value,
  );
}

class MyPeripheral {
  final String id;
  final String name;
  final int rssi;
  final Uint8List? manufacturerSpecificData;

  MyPeripheral({
    required this.id,
    required this.name,
    required this.rssi,
    required this.manufacturerSpecificData,
  });
}

class MyGattService {
  final String id;
  final List<MyGattCharacteristic?> characteristics;

  MyGattService({
    required this.id,
    required this.characteristics,
  });
}

class MyGattCharacteristic {
  final String id;
  final bool canRead;
  final bool canWrite;
  final bool canWriteWithoutResponse;
  final bool canNotify;
  final List<MyGattDescriptor?> descriptors;

  const MyGattCharacteristic({
    required this.id,
    required this.canRead,
    required this.canWrite,
    required this.canWriteWithoutResponse,
    required this.canNotify,
    required this.descriptors,
  });
}

class MyGattDescriptor {
  final String id;

  const MyGattDescriptor({
    required this.id,
  });
}

enum MyCentralManagerState {
  unknown,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
}

enum MyPeripheralState {
  disconnected,
  connecting,
  connected,
}

enum MyGattCharacteristicWriteType {
  // Write with response
  withResponse,
  // Write without response
  withoutResponse,
  // Write with response and waiting for confirmation
  // reliable,
}
