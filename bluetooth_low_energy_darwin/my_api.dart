// Run with `dart run pigeon --input my_api.dart`.
import 'package:pigeon/pigeon.dart';

// TODO: use `@ProxyApi` to manage instancs when this feature released:
// https://github.com/flutter/flutter/issues/147486
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'darwin/Classes/MyAPI.g.swift',
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

enum MyConnectionStateArgs {
  disconnected,
  connected,
}

enum MyGATTCharacteristicPropertyArgs {
  read,
  write,
  writeWithoutResponse,
  notify,
  indicate,
}

enum MyGATTCharacteristicPermissionArgs {
  read,
  readEncrypted,
  write,
  writeEncrypted,
}

enum MyGATTCharacteristicWriteTypeArgs {
  withResponse,
  withoutResponse,
}

enum MyATTErrorArgs {
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

class MyGATTDescriptorArgs {
  final int hashCodeArgs;
  final String uuidArgs;

  MyGATTDescriptorArgs(
    this.hashCodeArgs,
    this.uuidArgs,
  );
}

class MyGATTCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<int?> propertyNumbersArgs;
  final List<MyGATTDescriptorArgs?> descriptorsArgs;

  MyGATTCharacteristicArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.propertyNumbersArgs,
    this.descriptorsArgs,
  );
}

class MyGATTServiceArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final bool isPrimaryArgs;
  final List<MyGATTServiceArgs?> includedServicesArgs;
  final List<MyGATTCharacteristicArgs?> characteristicsArgs;

  MyGATTServiceArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.isPrimaryArgs,
    this.includedServicesArgs,
    this.characteristicsArgs,
  );
}

class MyMutableGATTDescriptorArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final Uint8List? valueArgs;

  MyMutableGATTDescriptorArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.valueArgs,
  );
}

class MyMutableGATTCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<int?> propertyNumbersArgs;
  final List<int?> permissionNumbersArgs;
  final Uint8List? valueArgs;
  final List<MyMutableGATTDescriptorArgs?> descriptorsArgs;

  MyMutableGATTCharacteristicArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.propertyNumbersArgs,
    this.permissionNumbersArgs,
    this.valueArgs,
    this.descriptorsArgs,
  );
}

class MyMutableGATTServiceArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final bool isPrimaryArgs;
  final List<MyMutableGATTServiceArgs?> includedServices;
  final List<MyMutableGATTCharacteristicArgs?> characteristicsArgs;

  MyMutableGATTServiceArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.isPrimaryArgs,
    this.includedServices,
    this.characteristicsArgs,
  );
}

class MyATTRequestArgs {
  final int hashCodeArgs;
  final MyCentralArgs centralArgs;
  final int characteristicHashCodeArgs;
  final Uint8List? valueArgs;
  final int offsetArgs;

  MyATTRequestArgs(
    this.hashCodeArgs,
    this.centralArgs,
    this.characteristicHashCodeArgs,
    this.valueArgs,
    this.offsetArgs,
  );
}

@HostApi()
abstract class MyCentralManagerHostAPI {
  void initialize();
  void startDiscovery(List<String> serviceUUIDsArgs);
  void stopDiscovery();
  List<MyPeripheralArgs> retrieveConnectedPeripherals();
  @async
  void connect(String uuidArgs);
  @async
  void disconnect(String uuidArgs);
  int getMaximumWriteLength(
    String uuidArgs,
    MyGATTCharacteristicWriteTypeArgs typeArgs,
  );
  @async
  int readRSSI(String uuidArgs);
  @async
  List<MyGATTServiceArgs> discoverServices(String uuidArgs);
  @async
  List<MyGATTServiceArgs> discoverIncludedServices(
    String uuidArgs,
    int hashCodeArgs,
  );
  @async
  List<MyGATTCharacteristicArgs> discoverCharacteristics(
    String uuidArgs,
    int hashCodeArgs,
  );
  @async
  List<MyGATTDescriptorArgs> discoverDescriptors(
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
    MyGATTCharacteristicWriteTypeArgs typeArgs,
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
abstract class MyCentralManagerFlutterAPI {
  void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs);
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssiArgs,
    MyAdvertisementArgs advertisementArgs,
  );
  void onConnectionStateChanged(
    MyPeripheralArgs peripheralArgs,
    MyConnectionStateArgs stateArgs,
  );
  void onCharacteristicNotified(
    MyPeripheralArgs peripheralArgs,
    MyGATTCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  );
}

@HostApi()
abstract class MyPeripheralManagerHostAPI {
  void initialize();
  @async
  void addService(MyMutableGATTServiceArgs serviceArgs);
  void removeService(int hashCodeArgs);
  void removeAllServices();
  @async
  void startAdvertising(MyAdvertisementArgs advertisementArgs);
  void stopAdvertising();
  int getMaximumNotifyLength(String uuidArgs);
  void respond(
    int hashCodeArgs,
    Uint8List? valueArgs,
    MyATTErrorArgs errorArgs,
  );
  bool updateValue(
    int hashCodeArgs,
    Uint8List valueArgs,
    List<String>? uuidsArgs,
  );
}

@FlutterApi()
abstract class MyPeripheralManagerFlutterAPI {
  void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs);
  void didReceiveRead(MyATTRequestArgs requestArgs);
  void didReceiveWrite(List<MyATTRequestArgs> requestsArgs);
  void isReady();
  void onCharacteristicNotifyStateChanged(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    bool stateArgs,
  );
}
