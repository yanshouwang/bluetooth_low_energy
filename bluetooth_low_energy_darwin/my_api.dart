import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'darwin/Classes/MyApi.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
@HostApi()
abstract class MyCentralControllerHostApi {
  @async
  MyCentralControllerArgs setUp();
  void tearDown();
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
  Uint8List readCharacteristic(
    int myPeripheralKey,
    int myServiceKey,
    int myCharacteristicKey,
  );
  @async
  void writeCharacteristic(
    int myPeripheralKey,
    int myServiceKey,
    int myCharacteristicKey,
    Uint8List value,
    int myTypeNumber,
  );
  @async
  void notifyCharacteristic(
    int myPeripheralKey,
    int myServiceKey,
    int myCharacteristicKey,
    bool state,
  );
  @async
  Uint8List readDescriptor(
    int myPeripheralKey,
    int myCharacteristicKey,
    int myDescriptorKey,
  );
  @async
  void writeDescriptor(
    int myPeripheralKey,
    int myCharacteristicKey,
    int myDescriptorKey,
    Uint8List value,
  );
}

@FlutterApi()
abstract class MyCentralControllerFlutterApi {
  void onStateChanged(int myStateNumber);
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

  MyCentralControllerArgs(this.myStateNumber);
}

class MyPeripheralArgs {
  final int key;
  final String uuid;

  MyPeripheralArgs(this.key, this.uuid);
}

class MyAdvertisementArgs {
  final String? name;
  final Map<int?, Uint8List?> manufacturerSpecificData;
  final List<String?> serviceUUIDs;
  final Map<String?, Uint8List?> serviceData;

  MyAdvertisementArgs(
    this.name,
    this.manufacturerSpecificData,
    this.serviceUUIDs,
    this.serviceData,
  );
}

class MyGattServiceArgs {
  final int key;
  final String uuid;

  MyGattServiceArgs(this.key, this.uuid);
}

class MyGattCharacteristicArgs {
  final int key;
  final String uuid;
  final List<int?> myPropertyNumbers;

  MyGattCharacteristicArgs(
    this.key,
    this.uuid,
    this.myPropertyNumbers,
  );
}

class MyGattDescriptorArgs {
  final int key;
  final String uuid;

  MyGattDescriptorArgs(this.key, this.uuid);
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
