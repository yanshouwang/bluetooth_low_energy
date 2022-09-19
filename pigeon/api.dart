import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeon/api.g.dart',
    dartTestOut: 'test/pigeon/test_api.g.dart',
    javaOut:
        'android/src/main/java/dev/yanshouwang/bluetooth_low_energy/pigeon/Api.java',
    javaOptions: JavaOptions(
      package: 'dev.yanshouwang.bluetooth_low_energy.pigeon',
    ),
    swiftOut: 'ios/Classes/pigeon/api.swift',
  ),
)
@HostApi(dartHostTestHandler: 'TestCentralControllerHostApi')
abstract class CentralManagerHostApi {
  @async
  bool authorize();
  Uint8List getState();
  void addStateObserver();
  void removeStateObserver();
  @async
  void startScan(List<String>? uuids);
  void stopScan();
  @async
  Uint8List connect(String uuid);
}

@FlutterApi()
abstract class CentralManagerFlutterApi {
  void notifyState(Uint8List state);
  void notifyAdvertisement(Uint8List advertisement);
}

@HostApi(dartHostTestHandler: 'TestPeripheralHostApi')
abstract class PeripheralHostApi {
  void allocate(String newId, String oldId);
  void free(String id);
  @async
  void disconnect(String id);
  @async
  List<Uint8List> discoverServices(String id);
}

@FlutterApi()
abstract class PeripheralFlutterApi {
  void notifyConnectionLost(String id, String error);
}

@HostApi(dartHostTestHandler: 'TestGattServiceHostApi')
abstract class GattServiceHostApi {
  void allocate(String newId, String oldId);
  void free(String id);
  @async
  List<Uint8List> discoverCharacteristics(String id);
}

@HostApi(dartHostTestHandler: 'TestGattCharacteristicHostApi')
abstract class GattCharacteristicHostApi {
  void allocate(String newId, String oldId);
  void free(String id);
  @async
  List<Uint8List> discoverDescriptors(String id);
  @async
  Uint8List read(String id);
  @async
  void write(String id, Uint8List value, bool withoutResponse);
  @async
  void setNotify(String id, bool value);
}

@FlutterApi()
abstract class GattCharacteristicFlutterApi {
  void notifyValue(String id, Uint8List value);
}

@HostApi(dartHostTestHandler: 'TestGattDescriptorHostApi')
abstract class GattDescriptorHostApi {
  void allocate(String newId, String oldId);
  void free(String id);
  @async
  Uint8List read(String id);
  @async
  void write(String id, Uint8List value);
}
