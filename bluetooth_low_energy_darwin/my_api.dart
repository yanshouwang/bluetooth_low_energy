import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'darwin/Classes/MyApi.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
enum MyBluetoothLowEnergyStateArgs {
  unknown,
  resetting,
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
  withResponse,
  withoutResponse,
}

enum MyGattErrorArgs {
  success,
  invalidHandle,
  readNotPermitted,
  writeNotPermitted,
  invalidPDU,
  insufficientAuthentication,
  requestNotSupported,
  invalidOffset,
  insufficientAuthorization,
  prepareQueueFull,
  attributeNotFound,
  attributeNotLong,
  insufficientEncryptionKeySize,
  invalidAttributeValueLength,
  unlikelyError,
  insufficientEncryption,
  unsupportedGroupType,
  insufficientResources,
}

class MyManufacturerSpecificDataArgs {
  final int idArgs;
  final Uint8List dataArgs;

  MyManufacturerSpecificDataArgs(this.idArgs, this.dataArgs);
}

class MyAdvertisementArgs {
  final String? nameArgs;
  final List<String?> serviceUUIDsArgs;
  final Map<String?, Uint8List?> serviceDataArgs;
  final MyManufacturerSpecificDataArgs? manufacturerSpecificDataArgs;

  MyAdvertisementArgs(
    this.nameArgs,
    this.serviceUUIDsArgs,
    this.serviceDataArgs,
    this.manufacturerSpecificDataArgs,
  );
}

class MyCentralArgs {
  final String uuidArgs;

  MyCentralArgs(this.uuidArgs);
}

class MyPeripheralArgs {
  final String uuidArgs;

  MyPeripheralArgs(this.uuidArgs);
}

class MyGattDescriptorArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final Uint8List? valueArgs;

  MyGattDescriptorArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.valueArgs,
  );
}

class MyGattCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<int?> propertyNumbersArgs;
  final List<MyGattDescriptorArgs?> descriptorsArgs;

  MyGattCharacteristicArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.propertyNumbersArgs,
    this.descriptorsArgs,
  );
}

class MyGattServiceArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<MyGattCharacteristicArgs?> characteristicsArgs;

  MyGattServiceArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.characteristicsArgs,
  );
}

@HostApi()
abstract class MyCentralManagerHostApi {
  void setUp();
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(String uuidArgs);
  @async
  void disconnect(String uuidArgs);
  int getMaximumWriteValueLength(String uuidArgs, int typeNumberArgs);
  @async
  int readRSSI(String uuidArgs);
  @async
  List<MyGattServiceArgs> discoverServices(String uuidArgs);
  @async
  List<MyGattCharacteristicArgs> discoverCharacteristics(
    String uuidArgs,
    int hashCodeArgs,
  );
  @async
  List<MyGattDescriptorArgs> discoverDescriptors(
    String uuidArgs,
    int hashCodeArgs,
  );
  @async
  Uint8List readCharacteristic(String uuidArgs, int hashCodeArgs);
  @async
  void writeCharacteristic(
    String uuidArgs,
    int hashCodeArgs,
    Uint8List valueArgs,
    int typeNumberArgs,
  );
  @async
  void setCharacteristicNotifyState(
    String uuidArgs,
    int hashCodeArgs,
    bool stateArgs,
  );
  @async
  Uint8List readDescriptor(String uuidArgs, int hashCodeArgs);
  @async
  void writeDescriptor(String uuidArgs, int hashCodeArgs, Uint8List valueArgs);
}

@FlutterApi()
abstract class MyCentralManagerFlutterApi {
  void onStateChanged(int stateNumberArgs);
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssiArgs,
    MyAdvertisementArgs advertisementArgs,
  );
  void onConnectionStateChanged(String uuidArgs, bool stateArgs);
  void onCharacteristicNotified(
    String uuidArgs,
    int hashCodeArgs,
    Uint8List valueArgs,
  );
}

@HostApi()
abstract class MyPeripheralManagerHostApi {
  void setUp();
  @async
  void addService(MyGattServiceArgs serviceArgs);
  void removeService(int hashCodeArgs);
  void clearServices();
  @async
  void startAdvertising(MyAdvertisementArgs advertisementArgs);
  void stopAdvertising();
  int getMaximumUpdateValueLength(String uuidArgs);
  void respond(int idArgs, int errorNumberArgs, Uint8List? valueArgs);
  @async
  void updateCharacteristic(
    int hashCodeArgs,
    Uint8List valueArgs,
    List<String>? uuidsArgs,
  );
}

@FlutterApi()
abstract class MyPeripheralManagerFlutterApi {
  void onStateChanged(int stateNumberArgs);
  void onCharacteristicReadRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
  );
  void onCharacteristicWriteRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
  );
  void onCharacteristicNotifyStateChanged(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    bool stateArgs,
  );
}
