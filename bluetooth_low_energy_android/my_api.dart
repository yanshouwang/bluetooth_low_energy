import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/dev/yanshouwang/bluetooth_low_energy_android/MyApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.yanshouwang.bluetooth_low_energy_android',
    ),
  ),
)
@HostApi()
abstract class MyCentralManagerHostApi {
  @async
  MyCentralManagerArgs setUp();
  @async
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(int myPeripheralHashCode);
  @async
  void disconnect(int myPeripheralHashCode);
  @async
  int getMaximumWriteLength(int myPeripheralHashCode);
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

@HostApi()
abstract class MyPeripheralManagerHostApi {
  @async
  MyPeripheralManagerArgs setUp();
  @async
  void addService(MyGattServiceArgs myServiceArgs);
  void removeService(int myServiceHashCode);
  void clearServices();
  @async
  void startAdvertising(MyAdvertisementArgs myAdvertisementArgs);
  void stopAdvertising();
  int getMaximumWriteLength(int myCentralHashCode);
  void sendReadCharacteristicReply(
    int myCentralHashCode,
    int myCharacteristicHashCode,
    int myId,
    int myOffset,
    bool myStatus,
    Uint8List myValue,
  );
  void sendWriteCharacteristicReply(
    int myCentralHashCode,
    int myCharacteristicHashCode,
    int myId,
    int myOffset,
    bool myStatus,
  );
  @async
  void notifyCharacteristicValueChanged(
    int myCentralHashCode,
    int myCharacteristicHashCode,
    Uint8List myValue,
  );
}

@FlutterApi()
abstract class MyPeripheralManagerFlutterApi {
  void onStateChanged(int myStateNumber);
  void onReadCharacteristicCommandReceived(
    MyCentralArgs myCentralArgs,
    MyGattCharacteristicArgs myCharacteristicArgs,
    int myId,
    int myOffset,
  );
  void onWriteCharacteristicCommandReceived(
    MyCentralArgs myCentralArgs,
    MyGattCharacteristicArgs myCharacteristicArgs,
    int myId,
    int myOffset,
    Uint8List myValue,
  );
  void onNotifyCharacteristicCommandReceived(
    MyCentralArgs myCentralArgs,
    MyGattCharacteristicArgs myCharacteristicArgs,
    bool myState,
  );
}

class MyCentralManagerArgs {
  final int myStateNumber;

  MyCentralManagerArgs(this.myStateNumber);
}

class MyPeripheralManagerArgs {
  final int myStateNumber;

  MyPeripheralManagerArgs(this.myStateNumber);
}

class MyPeripheralArgs {
  final int myHashCode;
  final String myUUID;

  MyPeripheralArgs(this.myHashCode, this.myUUID);
}

class MyCentralArgs {
  final int myHashCode;
  final String myUUID;

  MyCentralArgs(this.myHashCode, this.myUUID);
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
