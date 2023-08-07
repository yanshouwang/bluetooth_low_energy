import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/dev/yanshouwang/bluetooth_low_energy/MyApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.yanshouwang.bluetooth_low_energy',
    ),
  ),
)
@HostApi()
abstract class MyInstanceManagerHostApi {
  void free(int hashCode);
}

@HostApi()
abstract class MyCentralControllerHostApi {
  int getState();
  @async
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(int peripheralHashCode);
  void disconnect(int peripheralHashCode);
  @async
  List<int> discoverServices(int peripheralHashCode);
  @async
  List<int> discoverCharacteristics(int serviceHashCode);
  @async
  List<int> discoverDescriptors(int characteristicHashCode);
  @async
  Uint8List readCharacteristic(int characteristicHashCode);
  @async
  void writeCharacteristic(
    int characteristicHashCode,
    Uint8List value,
    int rawType,
  );
  @async
  void notifyCharacteristic(int characteristicHashCode, bool state);
  @async
  Uint8List readDescriptor(int descriptorHashCode);
  @async
  void writeDescriptor(int descriptorHashCode, Uint8List value);
}

@FlutterApi()
abstract class MyCentralControllerFlutterApi {
  void onStateChanged(int rawState);
  void onDiscovered(
    int peripheralHashCode,
    int rssi,
    int advertisementHashCode,
  );
  void onPeripheralStateChanged(int peripheralHashCode, int rawState);
  void onCharacteristicValueChanged(
    int characteristicHashCode,
    Uint8List value,
  );
}

@HostApi()
abstract class MyPeripheralHostApi {
  String getUUID(int hashCode);
}

@HostApi()
abstract class MyGattServiceHostApi {
  String getUUID(int hashCode);
}

@HostApi()
abstract class MyGattCharacteristicHostApi {
  String getUUID(int hashCode);
  List<int> getProperties(int hashCode);
}

@HostApi()
abstract class MyGattDescriptorHostApi {
  String getUUID(int hashCode);
}

@HostApi()
abstract class MyAdvertisementHostApi {
  String? getName(int hashCode);
  Uint8List? getManufacturerSpecificData(int hashCode);
}

enum MyCentralControllerState {
  off,
  on,
}

enum MyPeripheralState {
  disconnected,
  connecting,
  connected,
}

enum MyGattCharacteristicProperty {
  read,
  write,
  writeWithoutResponse,
  notify,
  indicate,
}

enum MyGattCharacteristicWriteType {
  // Write with response
  withResponse,
  // Write without response
  withoutResponse,
  // Write with response and waiting for confirmation
  // reliable,
}
