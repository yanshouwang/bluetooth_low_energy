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
  @ObjCSelector('startScan:')
  @async
  void startScan(List<Uint8List>? uuidBuffers);
  @ObjCSelector('stopScan')
  void stopScan();
}

@FlutterApi()
abstract class CentralManagerFlutterApi {
  @ObjCSelector('onStateChanged:')
  void onStateChanged(int stateNumber);
  @ObjCSelector('onScanned:')
  void onScanned(Uint8List broadcastBuffer);
}

@HostApi(dartHostTestHandler: 'TestPeripheralHostApi')
abstract class PeripheralHostApi {
  @ObjCSelector('free:')
  void free(String id);
  @ObjCSelector('connect:')
  @async
  void connect(String id);
  @ObjCSelector('disconnect:')
  @async
  void disconnect(String id);
  @ObjCSelector('requestMtu:')
  @async
  int requestMtu(String id);
  @ObjCSelector('discoverServices:')
  @async
  List<Uint8List> discoverServices(String id);
}

@FlutterApi()
abstract class PeripheralFlutterApi {
  @ObjCSelector('onConnectionLost:errorMessage:')
  void onConnectionLost(String id, String errorMessage);
}

@HostApi(dartHostTestHandler: 'TestGattServiceHostApi')
abstract class GattServiceHostApi {
  @ObjCSelector('free:')
  void free(String id);
  @ObjCSelector('discoverCharacteristics:')
  @async
  List<Uint8List> discoverCharacteristics(String id);
}

@HostApi(dartHostTestHandler: 'TestGattCharacteristicHostApi')
abstract class GattCharacteristicHostApi {
  @ObjCSelector('free:')
  void free(String id);
  @ObjCSelector('discoverDescriptors:')
  @async
  List<Uint8List> discoverDescriptors(String id);
  @ObjCSelector('read:')
  @async
  Uint8List read(String id);
  @ObjCSelector('write:value:withoutResponse:')
  @async
  void write(String id, Uint8List value, bool withoutResponse);
  @ObjCSelector('setNotify:value:')
  @async
  void setNotify(String id, bool value);
}

@FlutterApi()
abstract class GattCharacteristicFlutterApi {
  @ObjCSelector('onValueChanged:value:')
  void onValueChanged(String id, Uint8List value);
}

@HostApi(dartHostTestHandler: 'TestGattDescriptorHostApi')
abstract class GattDescriptorHostApi {
  @ObjCSelector('free:')
  void free(String id);
  @ObjCSelector('read:')
  @async
  Uint8List read(String id);
  @ObjCSelector('write:value:')
  @async
  void write(String id, Uint8List value);
}
