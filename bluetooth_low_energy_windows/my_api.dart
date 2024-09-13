// Run with `dart run pigeon --input my_api.dart`.
import 'package:pigeon/pigeon.dart';

// TODO: Use `@ProxyApi` to manage instancs when this feature released:
// https://github.com/flutter/flutter/issues/147486
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    cppHeaderOut: 'windows/my_api.g.h',
    cppSourceOut: 'windows/my_api.g.cpp',
    cppOptions: CppOptions(
      namespace: 'bluetooth_low_energy_windows',
    ),
  ),
)
enum MyBluetoothLowEnergyStateArgs {
  unknown,
  unsupported,
  disabled,
  off,
  on,
}

enum MyAdvertisementTypeArgs {
  connectableUndirected,
  connectableDirected,
  scannableUndirected,
  nonConnectableUndirected,
  scanResponse,
  extended,
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

enum MyGATTCharacteristicWriteTypeArgs {
  withResponse,
  withoutResponse,
}

enum MyGATTCharacteristicNotifyStateArgs {
  none,
  notify,
  indicate,
}

enum MyGATTProtectionLevelArgs {
  plain,
  authenticationRequired,
  entryptionRequired,
  encryptionAndAuthenticationRequired,
}

enum MyGATTProtocolErrorArgs {
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

enum MyCacheModeArgs {
  cached,
  uncached,
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
  final List<MyManufacturerSpecificDataArgs?> manufacturerSpecificDataArgs;

  MyAdvertisementArgs(
    this.nameArgs,
    this.serviceUUIDsArgs,
    this.serviceDataArgs,
    this.manufacturerSpecificDataArgs,
  );
}

class MyCentralArgs {
  final int addressArgs;

  MyCentralArgs(this.addressArgs);
}

class MyPeripheralArgs {
  final int addressArgs;

  MyPeripheralArgs(this.addressArgs);
}

class MyGATTDescriptorArgs {
  final int handleArgs;
  final String uuidArgs;

  MyGATTDescriptorArgs(
    this.handleArgs,
    this.uuidArgs,
  );
}

class MyGATTCharacteristicArgs {
  final int handleArgs;
  final String uuidArgs;
  final List<int?> propertyNumbersArgs;
  final List<MyGATTDescriptorArgs?> descriptorsArgs;

  MyGATTCharacteristicArgs(
    this.handleArgs,
    this.uuidArgs,
    this.propertyNumbersArgs,
    this.descriptorsArgs,
  );
}

class MyGATTServiceArgs {
  final int handleArgs;
  final String uuidArgs;
  final bool isPrimaryArgs;
  final List<MyGATTServiceArgs?> includedServicesArgs;
  final List<MyGATTCharacteristicArgs?> characteristicsArgs;

  MyGATTServiceArgs(
    this.handleArgs,
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
  final MyGATTProtectionLevelArgs? readProtectionLevelArgs;
  final MyGATTProtectionLevelArgs? writeProtectionLevelArgs;

  MyMutableGATTDescriptorArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.valueArgs,
    this.readProtectionLevelArgs,
    this.writeProtectionLevelArgs,
  );
}

class MyMutableGATTCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final Uint8List? valueArgs;
  final List<int?> propertyNumbersArgs;
  final MyGATTProtectionLevelArgs? readProtectionLevelArgs;
  final MyGATTProtectionLevelArgs? writeProtectionLevelArgs;
  final List<MyMutableGATTDescriptorArgs?> descriptorsArgs;

  MyMutableGATTCharacteristicArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.valueArgs,
    this.propertyNumbersArgs,
    this.readProtectionLevelArgs,
    this.writeProtectionLevelArgs,
    this.descriptorsArgs,
  );
}

class MyMutableGATTServiceArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final bool isPrimaryArgs;
  final List<MyMutableGATTServiceArgs?> includedServicesArgs;
  final List<MyMutableGATTCharacteristicArgs?> characteristicsArgs;

  MyMutableGATTServiceArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.isPrimaryArgs,
    this.includedServicesArgs,
    this.characteristicsArgs,
  );
}

class MyGATTReadRequestArgs {
  final int idArgs;
  final int offsetArgs;
  final int lengthArgs;

  MyGATTReadRequestArgs(
    this.idArgs,
    this.offsetArgs,
    this.lengthArgs,
  );
}

class MyGATTWriteRequestArgs {
  final int idArgs;
  final int offsetArgs;
  final Uint8List valueArgs;
  final MyGATTCharacteristicWriteTypeArgs typeArgs;

  MyGATTWriteRequestArgs(
    this.idArgs,
    this.offsetArgs,
    this.valueArgs,
    this.typeArgs,
  );
}

@HostApi()
abstract class MyCentralManagerHostAPI {
  @async
  void initialize();
  MyBluetoothLowEnergyStateArgs getState();
  void startDiscovery(List<String> serviceUUIDsArgs);
  void stopDiscovery();
  @async
  List<MyPeripheralArgs> retrieveConnectedPeripherals();
  @async
  void connect(int addressArgs);
  void disconnect(int addressArgs);
  int getMTU(int addressArgs);
  @async
  List<MyGATTServiceArgs> getServices(
    int addressArgs,
    MyCacheModeArgs modeArgs,
  );
  @async
  List<MyGATTServiceArgs> getIncludedServices(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  );
  @async
  List<MyGATTCharacteristicArgs> getCharacteristics(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  );
  @async
  List<MyGATTDescriptorArgs> getDescriptors(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  );
  @async
  Uint8List readCharacteristic(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  );
  @async
  void writeCharacteristic(
    int addressArgs,
    int handleArgs,
    Uint8List valueArgs,
    MyGATTCharacteristicWriteTypeArgs typeArgs,
  );
  @async
  void setCharacteristicNotifyState(
    int addressArgs,
    int handleArgs,
    MyGATTCharacteristicNotifyStateArgs stateArgs,
  );
  @async
  Uint8List readDescriptor(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  );
  @async
  void writeDescriptor(int addressArgs, int handleArgs, Uint8List valueArgs);
}

@FlutterApi()
abstract class MyCentralManagerFlutterAPI {
  void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs);
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssiArgs,
    int timestampArgs,
    MyAdvertisementTypeArgs typeArgs,
    MyAdvertisementArgs advertisementArgs,
  );
  void onConnectionStateChanged(
    MyPeripheralArgs peripheralArgs,
    MyConnectionStateArgs stateArgs,
  );
  void onMTUChanged(MyPeripheralArgs peripheralArgs, int mtuArgs);
  void onCharacteristicNotified(
    MyPeripheralArgs peripheralArgs,
    MyGATTCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  );
}

@HostApi()
abstract class MyPeripheralManagerHostAPI {
  @async
  void initialize();
  MyBluetoothLowEnergyStateArgs getState();
  @async
  void addService(MyMutableGATTServiceArgs serviceArgs);
  void removeService(int hashCodeArgs);
  void startAdvertising(MyAdvertisementArgs advertisementArgs);
  void stopAdvertising();
  int getMaxNotificationSize(int addressArgs);
  void respondReadRequestWithValue(int idArgs, Uint8List valueArgs);
  void respondReadRequestWithProtocolError(
    int idArgs,
    MyGATTProtocolErrorArgs errorArgs,
  );
  void respondWriteRequest(int idArgs);
  void respondWriteRequestWithProtocolError(
    int idArgs,
    MyGATTProtocolErrorArgs errorArgs,
  );
  @async
  void notifyValue(
    int hashCodeArgs,
    Uint8List valueArgs,
    int addressArgs,
  );
}

@FlutterApi()
abstract class MyPeripheralManagerFlutterAPI {
  void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs);
  void onMTUChanged(MyCentralArgs centralArgs, int mtuArgs);
  void onCharacteristicReadRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    MyGATTReadRequestArgs requestArgs,
  );
  void onCharacteristicWriteRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    MyGATTWriteRequestArgs requestArgs,
  );
  void onCharacteristicSubscribedClientsChanged(
    int hashCodeArgs,
    List<MyCentralArgs> centralsArgs,
  );
  void onDescriptorReadRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    MyGATTReadRequestArgs requestArgs,
  );
  void onDescriptorWriteRequest(
    MyCentralArgs centralArgs,
    int hashCodeArgs,
    MyGATTWriteRequestArgs requestArgs,
  );
}
