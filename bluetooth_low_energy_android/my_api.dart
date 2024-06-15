// Run with `dart run pigeon --input my_api.dart`.
import 'package:pigeon/pigeon.dart';

// TODO: Use `@ProxyApi` to manage instancs when this feature released:
// https://github.com/flutter/flutter/issues/147486
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/dev/hebei/bluetooth_low_energy_android/MyAPI.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.hebei.bluetooth_low_energy_android',
    ),
  ),
)
enum MyBluetoothLowEnergyStateArgs {
  unknown,
  unsupported,
  unauthorized,
  off,
  turningOn,
  on,
  turningOff,
}

enum MyAdvertiseModeArgs {
  lowPower,
  balanced,
  lowLatency,
}

enum MyTXPowerLevelArgs {
  ultraLow,
  low,
  medium,
  high,
}

enum MyConnectionStateArgs {
  disconnected,
  connecting,
  connected,
  disconnecting,
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

enum MyGATTStatusArgs {
  success,
  readNotPermitted,
  writeNotPermitted,
  insufficientAuthentication,
  requestNotSupported,
  insufficientEncryption,
  invalidOffset,
  insufficientAuthorization,
  invalidAttributeLength,
  connectionCongested,
  failure,
}

class MyCentralManagerArgs {
  final Uint8List enableNotificationValue;
  final Uint8List enableIndicationValue;
  final Uint8List disableNotificationValue;

  MyCentralManagerArgs(
    this.enableNotificationValue,
    this.enableIndicationValue,
    this.disableNotificationValue,
  );
}

class MyPeripheralManagerArgs {
  final Uint8List enableNotificationValue;
  final Uint8List enableIndicationValue;
  final Uint8List disableNotificationValue;

  MyPeripheralManagerArgs(
    this.enableNotificationValue,
    this.enableIndicationValue,
    this.disableNotificationValue,
  );
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

class MyAdvertiseSettingsArgs {
  final MyAdvertiseModeArgs? modeArgs;
  final bool? connectableArgs;
  final int? timeoutArgs;
  final MyTXPowerLevelArgs? txPowerLevelArgs;

  MyAdvertiseSettingsArgs(
    this.modeArgs,
    this.connectableArgs,
    this.timeoutArgs,
    this.txPowerLevelArgs,
  );
}

class MyAdvertiseDataArgs {
  final bool? includeDeviceNameArgs;
  final bool? includeTXPowerLevelArgs;
  final List<String?> serviceUUIDsArgs;
  final Map<String?, Uint8List?> serviceDataArgs;
  final List<MyManufacturerSpecificDataArgs?> manufacturerSpecificDataArgs;

  MyAdvertiseDataArgs(
    this.includeDeviceNameArgs,
    this.includeTXPowerLevelArgs,
    this.serviceUUIDsArgs,
    this.serviceDataArgs,
    this.manufacturerSpecificDataArgs,
  );
}

class MyCentralArgs {
  final String addressArgs;

  MyCentralArgs(this.addressArgs);
}

class MyPeripheralArgs {
  final String addressArgs;

  MyPeripheralArgs(this.addressArgs);
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
  final List<int?> permissionNumbersArgs;

  MyMutableGATTDescriptorArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.permissionNumbersArgs,
  );
}

class MyMutableGATTCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<int?> permissionNumbersArgs;
  final List<int?> propertyNumbersArgs;
  final List<MyMutableGATTDescriptorArgs?> descriptorsArgs;

  MyMutableGATTCharacteristicArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.permissionNumbersArgs,
    this.propertyNumbersArgs,
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

@HostApi()
abstract class MyCentralManagerHostAPI {
  MyCentralManagerArgs initialize();
  MyBluetoothLowEnergyStateArgs getState();
  @async
  bool authorize();
  void showAppSettings();
  String getName();
  void setName(String nameArgs);
  @async
  void startDiscovery(List<String> serviceUUIDsArgs);
  void stopDiscovery();
  @async
  void connect(String addressArgs);
  @async
  void disconnect(String addressArgs);
  List<MyPeripheralArgs> retrieveConnectedPeripherals();
  @async
  int requestMTU(String addressArgs, int mtuArgs);
  @async
  int readRSSI(String addressArgs);
  @async
  List<MyGATTServiceArgs> discoverGATT(String addressArgs);
  @async
  Uint8List readCharacteristic(String addressArgs, int hashCodeArgs);
  @async
  void writeCharacteristic(
    String addressArgs,
    int hashCodeArgs,
    Uint8List valueArgs,
    MyGATTCharacteristicWriteTypeArgs typeArgs,
  );
  void setCharacteristicNotification(
    String addressArgs,
    int hashCodeArgs,
    bool enableArgs,
  );
  @async
  Uint8List readDescriptor(String addressArgs, int hashCodeArgs);
  @async
  void writeDescriptor(
    String addressArgs,
    int hashCodeArgs,
    Uint8List valueArgs,
  );
}

@FlutterApi()
abstract class MyCentralManagerFlutterAPI {
  void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs);
  void onNameChanged(String? nameArgs);
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssiArgs,
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
  MyPeripheralManagerArgs initialize();
  MyBluetoothLowEnergyStateArgs getState();
  @async
  bool authorize();
  void showAppSettings();
  String getName();
  void setName(String nameArgs);
  void openGATTServer();
  void closeGATTServer();
  @async
  void addService(MyMutableGATTServiceArgs serviceArgs);
  void removeService(int hashCodeArgs);
  void removeAllServices();
  @async
  void startAdvertising(
    MyAdvertiseSettingsArgs settingsArgs,
    MyAdvertiseDataArgs advertiseDataArgs,
    MyAdvertiseDataArgs scanResponseArgs,
  );
  void stopAdvertising();
  void sendResponse(
    String addressArgs,
    int idArgs,
    MyGATTStatusArgs statusArgs,
    int offsetArgs,
    Uint8List? valueArgs,
  );
  @async
  void notifyCharacteristicChanged(
    String addressArgs,
    int hashCodeArgs,
    bool confirmArgs,
    Uint8List valueArgs,
  );
}

@FlutterApi()
abstract class MyPeripheralManagerFlutterAPI {
  void onStateChanged(MyBluetoothLowEnergyStateArgs stateArgs);
  void onNameChanged(String? nameArgs);
  void onConnectionStateChanged(
    MyCentralArgs centralArgs,
    int statusArgs,
    MyConnectionStateArgs stateArgs,
  );
  void onMTUChanged(MyCentralArgs centralArgs, int mtuArgs);
  void onCharacteristicReadRequest(
    MyCentralArgs centralArgs,
    int idArgs,
    int offsetArgs,
    int hashCodeArgs,
  );
  void onCharacteristicWriteRequest(
    MyCentralArgs centralArgs,
    int idArgs,
    int hashCodeArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
    int offsetArgs,
    Uint8List valueArgs,
  );
  void onDescriptorReadRequest(
    MyCentralArgs centralArgs,
    int idArgs,
    int offsetArgs,
    int hashCodeArgs,
  );
  void onDescriptorWriteRequest(
    MyCentralArgs centralArgs,
    int idArgs,
    int hashCodeArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
    int offsetArgs,
    Uint8List valueArgs,
  );
  void onExecuteWrite(
    MyCentralArgs centralArgs,
    int idArgs,
    bool executeArgs,
  );
}
