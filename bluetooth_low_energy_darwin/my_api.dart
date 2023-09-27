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
abstract class MyCentralManagerHostApi {
  @async
  MyCentralManagerArgs setUp();
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(int myPeripheralKey);
  @async
  void disconnect(int myPeripheralKey);
  int getMaximumWriteLength(int myPeripheralKey, int myTypeNumber);
  @async
  int readRSSI(int myPeripheralKey);
  @async
  List<MyGattServiceArgs> discoverGATT(int myPeripheralKey);
  @async
  Uint8List readCharacteristic(
    int myPeripheralKey,
    int myCharacteristicKey,
  );
  @async
  void writeCharacteristic(
    int myPeripheralKey,
    int myCharacteristicKey,
    Uint8List myValue,
    int myTypeNumber,
  );
  @async
  void notifyCharacteristic(
    int myPeripheralKey,
    int myCharacteristicKey,
    bool myState,
  );
  @async
  Uint8List readDescriptor(
    int myPeripheralKey,
    int myDescriptorKey,
  );
  @async
  void writeDescriptor(
    int myPeripheralKey,
    int myDescriptorKey,
    Uint8List myValue,
  );
}

@FlutterApi()
abstract class MyCentralManagerFlutterApi {
  void onStateChanged(int myStateNumber);
  void onDiscovered(
    MyPeripheralArgs myPeripheralArgs,
    int myRSSI,
    MyAdvertisementArgs myAdvertisementArgs,
  );
  void onPeripheralStateChanged(
    MyPeripheralArgs myPeripheralArgs,
    bool myState,
  );
  void onCharacteristicValueChanged(
    MyGattCharacteristicArgs myCharacteristicArgs,
    Uint8List myValue,
  );
}

class MyCentralManagerArgs {
  final int myStateNumber;

  MyCentralManagerArgs(this.myStateNumber);
}

class MyPeripheralArgs {
  final int myKey;
  final String myUUID;

  MyPeripheralArgs(this.myKey, this.myUUID);
}

class MyAdvertisementArgs {
  final String? myName;
  final Map<int?, Uint8List?> myManufacturerSpecificData;
  final List<String?> myServiceUUIDs;
  final Map<String?, Uint8List?> myServiceData;

  MyAdvertisementArgs(
    this.myName,
    this.myManufacturerSpecificData,
    this.myServiceUUIDs,
    this.myServiceData,
  );
}

class MyGattServiceArgs {
  final int myKey;
  final String myUUID;
  final List<MyGattCharacteristicArgs?> myCharacteristicArgses;

  MyGattServiceArgs(
    this.myKey,
    this.myUUID,
    this.myCharacteristicArgses,
  );
}

class MyGattCharacteristicArgs {
  final int myKey;
  final String myUUID;
  final List<int?> myPropertyNumbers;
  final List<MyGattDescriptorArgs?> myDescriptorArgses;

  MyGattCharacteristicArgs(
    this.myKey,
    this.myUUID,
    this.myPropertyNumbers,
    this.myDescriptorArgses,
  );
}

class MyGattDescriptorArgs {
  final int myKey;
  final String myUUID;
  final Uint8List myValue;

  MyGattDescriptorArgs(
    this.myKey,
    this.myUUID,
    this.myValue,
  );
}

enum MyBluetoothLowEnergyStateArgs {
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
