import 'package:pigeon/pigeon.dart';

@HostApi(dartHostTestHandler: 'TestCentralControllerHostApi')
abstract class CentralControllerHostApi {
  void create(String id);
  int getState(String id);
  void subscribeState(String id);
  void unsubscribeState(String id);
  void startScan(String id, List<String> uuids);
  void stopScan(String id);
  void destroy(String id);
}

@FlutterApi()
abstract class CentralControllerFlutterApi {
  void invokeStateChanged(String id, int state);
  void invokeScanned(
    String id,
    Uint8List peripheral,
    Map<int, Uint8List> advertisements,
    int rssi,
  );
}

@HostApi(dartHostTestHandler: 'TestPeripheralHostApi')
abstract class PeripheralHostApi {
  @async
  void connect(String id);
  @async
  void disconnect(String id);
  @async
  void discoverServices(String id);
}

@FlutterApi()
abstract class PeripheralFlutterApi {
  void invokeConnectionLost(String id, String errorMessage);
}

@HostApi(dartHostTestHandler: 'TestGattServiceHostApi')
abstract class GattServiceHostApi {
  @async
  void discoverCharacteristics(String id);
}

@HostApi(dartHostTestHandler: 'TestGattCharacteristicHostApi')
abstract class GattCharacteristicHostApi {
  @async
  void discoverDescriptors(String id);
  @async
  Uint8List read(String id);
  @async
  void write(String id, Uint8List value);
  @async
  void setNotify(String id, bool value);
}

@FlutterApi()
abstract class GattCharacteristicFlutterApi {
  void invokeValueChanged(String id, Uint8List value);
}

@HostApi(dartHostTestHandler: 'TestGattDescriptorHostApi')
abstract class GattDescriptorHostApi {
  @async
  Uint8List read(String id);
  @async
  void write(String id, Uint8List value);
}
