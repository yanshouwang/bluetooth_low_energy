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
abstract class CentralControllerHostApi {
  void create(String id);
  int getState(String id);
  void addStateObserver(String id);
  void removeStateObserver(String id);
  void startDiscovery(String id, List<String>? uuids);
  void stopDiscovery(String id);
  void destroy(String id);
}

@FlutterApi()
abstract class CentralControllerFlutterApi {
  void notifyState(String id, int state);
  void notifyAdvertisement(String id, Uint8List advertisement);
}

@HostApi(dartHostTestHandler: 'TestPeripheralHostApi')
abstract class PeripheralHostApi {
  @async
  void connect(String id);
  @async
  void disconnect(String id);
  @async
  List<Uint8List> discoverServices(String id);
}

@FlutterApi()
abstract class PeripheralFlutterApi {
  void notifyConnectionLost(String id, String errorMessage);
}

@HostApi(dartHostTestHandler: 'TestGattServiceHostApi')
abstract class GattServiceHostApi {
  @async
  List<Uint8List> discoverCharacteristics(String id);
}

@HostApi(dartHostTestHandler: 'TestGattCharacteristicHostApi')
abstract class GattCharacteristicHostApi {
  @async
  List<Uint8List> discoverDescriptors(String id);
  @async
  Uint8List read(String id);
  @async
  void write(String id, Uint8List value);
  @async
  void setNotify(String id, bool value);
}

@FlutterApi()
abstract class GattCharacteristicFlutterApi {
  void notifyValue(String id, Uint8List value);
}

@HostApi(dartHostTestHandler: 'TestGattDescriptorHostApi')
abstract class GattDescriptorHostApi {
  @async
  Uint8List read(String id);
  @async
  void write(String id, Uint8List value);
}
