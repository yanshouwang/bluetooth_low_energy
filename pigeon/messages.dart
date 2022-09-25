import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeon/messages.g.dart',
    dartTestOut: 'test/pigeon/test_messages.g.dart',
    javaOut:
        'android/src/main/java/dev/yanshouwang/bluetooth_low_energy/pigeon/Messages.java',
    javaOptions: JavaOptions(
      package: 'dev.yanshouwang.bluetooth_low_energy.pigeon',
    ),
    objcHeaderOut: 'ios/Classes/pigeon/Messages.h',
    objcSourceOut: 'ios/Classes/pigeon/Messages.m',
    objcOptions: ObjcOptions(
      header: 'ios/Classes/pigeon/Messages.h',
      prefix: 'Pigeon',
    ),
  ),
)
@HostApi(dartHostTestHandler: 'TestCentralControllerHostApi')
abstract class CentralManagerHostApi {
  @ObjCSelector('authorize')
  @async
  bool authorize();
  @ObjCSelector('getState')
  int getState();
  @ObjCSelector('addStateObserver')
  void addStateObserver();
  @ObjCSelector('removeStateObserver')
  void removeStateObserver();
  @ObjCSelector('startScan:')
  @async
  void startScan(List<Uint8List>? uuidBuffers);
  @ObjCSelector('stopScan')
  void stopScan();
  @ObjCSelector('connect:')
  @async
  Uint8List connect(Uint8List uuidBuffer);
}

@FlutterApi()
abstract class CentralManagerFlutterApi {
  @ObjCSelector('notifyState:')
  void notifyState(int stateNumber);
  @ObjCSelector('notifyAdvertisement:')
  void notifyAdvertisement(Uint8List advertisementBuffer);
}

@HostApi(dartHostTestHandler: 'TestPeripheralHostApi')
abstract class PeripheralHostApi {
  @ObjCSelector('allocate:instanceId:')
  void allocate(int id, int instanceId);
  @ObjCSelector('free:')
  void free(int id);
  @ObjCSelector('disconnect:')
  @async
  void disconnect(int id);
  @ObjCSelector('requestMtu:')
  @async
  int requestMtu(int id);
  @ObjCSelector('discoverServices:')
  @async
  List<Uint8List> discoverServices(int id);
}

@FlutterApi()
abstract class PeripheralFlutterApi {
  @ObjCSelector('notifyConnectionLost:errorMessage:')
  void notifyConnectionLost(int id, String errorMessage);
}

@HostApi(dartHostTestHandler: 'TestGattServiceHostApi')
abstract class GattServiceHostApi {
  @ObjCSelector('allocate:instanceId:')
  void allocate(int id, int instanceId);
  @ObjCSelector('free:')
  void free(int id);
  @ObjCSelector('discoverCharacteristics:')
  @async
  List<Uint8List> discoverCharacteristics(int id);
}

@HostApi(dartHostTestHandler: 'TestGattCharacteristicHostApi')
abstract class GattCharacteristicHostApi {
  @ObjCSelector('allocate:instanceId:')
  void allocate(int id, int instanceId);
  @ObjCSelector('free:')
  void free(int id);
  @ObjCSelector('discoverDescriptors:')
  @async
  List<Uint8List> discoverDescriptors(int id);
  @ObjCSelector('read:')
  @async
  Uint8List read(int id);
  @ObjCSelector('write:value:withoutResponse:')
  @async
  void write(int id, Uint8List value, bool withoutResponse);
  @ObjCSelector('setNotify:value:')
  @async
  void setNotify(int id, bool value);
}

@FlutterApi()
abstract class GattCharacteristicFlutterApi {
  @ObjCSelector('notifyValue:value:')
  void notifyValue(int id, Uint8List value);
}

@HostApi(dartHostTestHandler: 'TestGattDescriptorHostApi')
abstract class GattDescriptorHostApi {
  @ObjCSelector('allocate:instanceId:')
  void allocate(int id, int instanceId);
  @ObjCSelector('free:')
  void free(int id);
  @ObjCSelector('read:')
  @async
  Uint8List read(int id);
  @ObjCSelector('write:value:')
  @async
  void write(int id, Uint8List value);
}
