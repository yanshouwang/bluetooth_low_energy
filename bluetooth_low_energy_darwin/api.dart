// Run with `dart run pigeon --input api.dart`.
import 'package:pigeon/pigeon.dart';

// TODO: Use `@ProxyApi` to manage instancs when this feature released:
// https://github.com/flutter/flutter/issues/147486
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/api.g.dart',
    dartOptions: DartOptions(),
    swiftOut:
        'darwin/bluetooth_low_energy_darwin/Sources/bluetooth_low_energy_darwin/BluetoothLowEnergyApi.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
enum BluetoothLowEnergyStateArgs {
  unknown,
  resetting,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
}

enum ConnectionStateArgs { disconnected, connected }

enum GATTCharacteristicPropertyArgs {
  read,
  write,
  writeWithoutResponse,
  notify,
  indicate,
}

enum GATTCharacteristicPermissionArgs {
  read,
  readEncrypted,
  write,
  writeEncrypted,
}

enum GATTCharacteristicWriteTypeArgs { withResponse, withoutResponse }

enum ATTErrorArgs {
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

class AdvertisementArgs {
  final String? nameArgs;
  final List<String> serviceUUIDsArgs;
  final Map<String, Uint8List> serviceDataArgs;
  final Uint8List? manufacturerSpecificDataArgs;

  AdvertisementArgs(
    this.nameArgs,
    this.serviceUUIDsArgs,
    this.serviceDataArgs,
    this.manufacturerSpecificDataArgs,
  );
}

class CentralArgs {
  final String uuidArgs;

  CentralArgs(this.uuidArgs);
}

class PeripheralArgs {
  final String uuidArgs;

  PeripheralArgs(this.uuidArgs);
}

class GATTDescriptorArgs {
  final int hashCodeArgs;
  final String uuidArgs;

  GATTDescriptorArgs(this.hashCodeArgs, this.uuidArgs);
}

class GATTCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<int> propertyNumbersArgs;
  final List<GATTDescriptorArgs> descriptorsArgs;

  GATTCharacteristicArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.propertyNumbersArgs,
    this.descriptorsArgs,
  );
}

class GATTServiceArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final bool isPrimaryArgs;
  final List<GATTServiceArgs> includedServicesArgs;
  final List<GATTCharacteristicArgs> characteristicsArgs;

  GATTServiceArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.isPrimaryArgs,
    this.includedServicesArgs,
    this.characteristicsArgs,
  );
}

class MutableGATTDescriptorArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final Uint8List? valueArgs;

  MutableGATTDescriptorArgs(this.hashCodeArgs, this.uuidArgs, this.valueArgs);
}

class MutableGATTCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<int> propertyNumbersArgs;
  final List<int> permissionNumbersArgs;
  final Uint8List? valueArgs;
  final List<MutableGATTDescriptorArgs> descriptorsArgs;

  MutableGATTCharacteristicArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.propertyNumbersArgs,
    this.permissionNumbersArgs,
    this.valueArgs,
    this.descriptorsArgs,
  );
}

class MutableGATTServiceArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final bool isPrimaryArgs;
  final List<MutableGATTServiceArgs> includedServicesArgs;
  final List<MutableGATTCharacteristicArgs> characteristicsArgs;

  MutableGATTServiceArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.isPrimaryArgs,
    this.includedServicesArgs,
    this.characteristicsArgs,
  );
}

class ATTRequestArgs {
  final int hashCodeArgs;
  final CentralArgs centralArgs;
  final int characteristicHashCodeArgs;
  final Uint8List? valueArgs;
  final int offsetArgs;

  ATTRequestArgs(
    this.hashCodeArgs,
    this.centralArgs,
    this.characteristicHashCodeArgs,
    this.valueArgs,
    this.offsetArgs,
  );
}

@HostApi()
abstract class CentralManagerHostApi {
  void initialize();
  BluetoothLowEnergyStateArgs getState();
  @async
  void showAppSettings();
  void startDiscovery(List<String> serviceUUIDsArgs);
  void stopDiscovery();
  List<PeripheralArgs> retrieveConnectedPeripherals();
  @async
  void connect(String uuidArgs);
  @async
  void disconnect(String uuidArgs);
  int getMaximumWriteLength(
    String uuidArgs,
    GATTCharacteristicWriteTypeArgs typeArgs,
  );
  @async
  int readRSSI(String uuidArgs);
  @async
  List<GATTServiceArgs> discoverServices(String uuidArgs);
  @async
  List<GATTServiceArgs> discoverIncludedServices(
    String uuidArgs,
    int hashCodeArgs,
  );
  @async
  List<GATTCharacteristicArgs> discoverCharacteristics(
    String uuidArgs,
    int hashCodeArgs,
  );
  @async
  List<GATTDescriptorArgs> discoverDescriptors(
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
    GATTCharacteristicWriteTypeArgs typeArgs,
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
abstract class CentralManagerFlutterApi {
  void onStateChanged(BluetoothLowEnergyStateArgs stateArgs);
  void onDiscovered(
    PeripheralArgs peripheralArgs,
    int rssiArgs,
    AdvertisementArgs advertisementArgs,
  );
  void onConnectionStateChanged(
    PeripheralArgs peripheralArgs,
    ConnectionStateArgs stateArgs,
  );
  void onCharacteristicNotified(
    PeripheralArgs peripheralArgs,
    GATTCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  );
}

@HostApi()
abstract class PeripheralManagerHostApi {
  void initialize();
  BluetoothLowEnergyStateArgs getState();
  @async
  void showAppSettings();
  @async
  void addService(MutableGATTServiceArgs serviceArgs);
  void removeService(int hashCodeArgs);
  void removeAllServices();
  @async
  void startAdvertising(AdvertisementArgs advertisementArgs);
  void stopAdvertising();
  int getMaximumNotifyLength(String uuidArgs);
  void respond(int hashCodeArgs, Uint8List? valueArgs, ATTErrorArgs errorArgs);
  bool updateValue(
    int hashCodeArgs,
    Uint8List valueArgs,
    List<String>? uuidsArgs,
  );
}

@FlutterApi()
abstract class PeripheralManagerFlutterApi {
  void onStateChanged(BluetoothLowEnergyStateArgs stateArgs);
  void didReceiveRead(ATTRequestArgs requestArgs);
  void didReceiveWrite(List<ATTRequestArgs> requestsArgs);
  void isReady();
  void onCharacteristicNotifyStateChanged(
    CentralArgs centralArgs,
    int hashCodeArgs,
    bool stateArgs,
  );
}
