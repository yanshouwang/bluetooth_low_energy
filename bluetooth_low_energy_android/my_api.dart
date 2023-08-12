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
abstract class MyCentralControllerHostApi {
  MyCentralControllerArgs setUp();
  void tearDown();
  @async
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(int myPeripheralKey);
  @async
  void disconnect(int myPeripheralKey);
  @async
  void discoverGATT(int myPeripheralKey);
  List<MyGattServiceArgs> getServices(int myPeripheralKey);
  List<MyGattCharacteristicArgs> getCharacteristics(int myServiceKey);
  List<MyGattDescriptorArgs> getDescriptors(int myCharacteristicKey);
  @async
  Uint8List readCharacteristic(int myPeripheralKey, int myCharacteristicKey);
  @async
  void writeCharacteristic(
    int myPeripheralKey,
    int myCharacteristicKey,
    Uint8List value,
    int myTypeNumber,
  );
  @async
  void notifyCharacteristic(
    int myPeripheralKey,
    int myCharacteristicKey,
    bool state,
  );
  @async
  Uint8List readDescriptor(int myPeripheralKey, int myDescriptorKey);
  @async
  void writeDescriptor(
    int myPeripheralKey,
    int myDescriptorKey,
    Uint8List value,
  );
}

@FlutterApi()
abstract class MyCentralControllerFlutterApi {
  void onStateChanged(int myStateNumber);
  void onDiscoveryStateChanged(bool isDiscovering);
  void onDiscovered(
    MyPeripheralArgs myPeripheralArgs,
    int rssi,
    MyAdvertisementArgs myAdvertisementArgs,
  );
  void onPeripheralStateChanged(int myPeripheralKey, bool state);
  void onCharacteristicValueChanged(int myCharacteristicKey, Uint8List value);
}

class MyCentralControllerArgs {
  final int myStateNumber;
  final bool isDiscovering;

  MyCentralControllerArgs(this.myStateNumber, this.isDiscovering);
}

class MyPeripheralArgs {
  final int key;
  final String uuidString;

  MyPeripheralArgs(this.key, this.uuidString);
}

class MyAdvertisementArgs {
  final String? name;
  final Map<int?, Uint8List?> manufacturerSpecificData;

  MyAdvertisementArgs(
    this.name,
    this.manufacturerSpecificData,
  );
}

class MyGattServiceArgs {
  final int key;
  final String uuidString;

  MyGattServiceArgs(this.key, this.uuidString);
}

class MyGattCharacteristicArgs {
  final int key;
  final String uuidString;
  final List<int?> myPropertyNumbers;

  MyGattCharacteristicArgs(
    this.key,
    this.uuidString,
    this.myPropertyNumbers,
  );
}

class MyGattDescriptorArgs {
  final int key;
  final String uuidString;

  MyGattDescriptorArgs(this.key, this.uuidString);
}

enum MyCentralStateArgs {
  unknown,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
}

enum MyGattCharacteristicPropertyArgs {
  read,
  write,
  writeWithoutResponse,
  notify,
  indicate,
}

enum MyGattCharacteristicWriteTypeArgs {
  // Write with response
  withResponse,
  // Write without response
  withoutResponse,
  // Write with response and waiting for confirmation
  // reliable,
}
