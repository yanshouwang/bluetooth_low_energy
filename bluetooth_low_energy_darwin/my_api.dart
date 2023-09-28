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
  void connect(int myPeripheralHashCode);
  @async
  void disconnect(int myPeripheralHashCode);
  int getMaximumWriteLength(int myPeripheralHashCode, int myTypeNumber);
  @async
  int readRSSI(int myPeripheralHashCode);
  @async
  List<MyGattServiceArgs> discoverGATT(int myPeripheralHashCode);
  @async
  Uint8List readCharacteristic(
    int myPeripheralHashCode,
    int myCharacteristicHashCode,
  );
  @async
  void writeCharacteristic(
    int myPeripheralHashCode,
    int myCharacteristicHashCode,
    Uint8List myValue,
    int myTypeNumber,
  );
  @async
  void notifyCharacteristic(
    int myPeripheralHashCode,
    int myCharacteristicHashCode,
    bool myState,
  );
  @async
  Uint8List readDescriptor(
    int myPeripheralHashCode,
    int myDescriptorHashCode,
  );
  @async
  void writeDescriptor(
    int myPeripheralHashCode,
    int myDescriptorHashCode,
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
  final int myHashCode;
  final String myUUID;

  MyPeripheralArgs(this.myHashCode, this.myUUID);
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
  final int myHashCode;
  final String myUUID;
  final List<MyGattCharacteristicArgs?> myCharacteristicArgses;

  MyGattServiceArgs(
    this.myHashCode,
    this.myUUID,
    this.myCharacteristicArgses,
  );
}

class MyGattCharacteristicArgs {
  final int myHashCode;
  final String myUUID;
  final List<int?> myPropertyNumbers;
  final List<MyGattDescriptorArgs?> myDescriptorArgses;

  MyGattCharacteristicArgs(
    this.myHashCode,
    this.myUUID,
    this.myPropertyNumbers,
    this.myDescriptorArgses,
  );
}

class MyGattDescriptorArgs {
  final int myHashCode;
  final String myUUID;
  final Uint8List? myValue;

  MyGattDescriptorArgs(
    this.myHashCode,
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
