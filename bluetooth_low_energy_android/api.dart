// Run with `dart run pigeon --input api.dart`.
import 'package:pigeon/pigeon.dart';

// TODO: Use `@ProxyApi` to manage instancs when this feature released:
// https://github.com/flutter/flutter/issues/147486
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/dev/zeekr/bluetooth_low_energy_android/BluetoothLowEnergyApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.zeekr.bluetooth_low_energy_android',
    ),
  ),
)
enum BluetoothLowEnergyStateArgs {
  unknown,
  unsupported,
  unauthorized,
  off,
  turningOn,
  on,
  turningOff,
}

enum AdvertiseModeArgs { lowPower, balanced, lowLatency }

enum TXPowerLevelArgs { ultraLow, low, medium, high }

enum ConnectionStateArgs { disconnected, connecting, connected, disconnecting }

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

enum GATTStatusArgs {
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

class CentralManagerArgs {
  final Uint8List enableNotificationValue;
  final Uint8List enableIndicationValue;
  final Uint8List disableNotificationValue;

  CentralManagerArgs(
    this.enableNotificationValue,
    this.enableIndicationValue,
    this.disableNotificationValue,
  );
}

class PeripheralManagerArgs {
  final Uint8List enableNotificationValue;
  final Uint8List enableIndicationValue;
  final Uint8List disableNotificationValue;

  PeripheralManagerArgs(
    this.enableNotificationValue,
    this.enableIndicationValue,
    this.disableNotificationValue,
  );
}

class ManufacturerSpecificDataArgs {
  final int idArgs;
  final Uint8List dataArgs;

  ManufacturerSpecificDataArgs(this.idArgs, this.dataArgs);
}

class AdvertisementArgs {
  final String? nameArgs;
  final List<String?> serviceUUIDsArgs;
  final Map<String?, Uint8List?> serviceDataArgs;
  final List<ManufacturerSpecificDataArgs?> manufacturerSpecificDataArgs;

  AdvertisementArgs(
    this.nameArgs,
    this.serviceUUIDsArgs,
    this.serviceDataArgs,
    this.manufacturerSpecificDataArgs,
  );
}

class AdvertiseSettingsArgs {
  final AdvertiseModeArgs? modeArgs;
  final bool? connectableArgs;
  final int? timeoutArgs;
  final TXPowerLevelArgs? txPowerLevelArgs;

  AdvertiseSettingsArgs(
    this.modeArgs,
    this.connectableArgs,
    this.timeoutArgs,
    this.txPowerLevelArgs,
  );
}

class AdvertiseDataArgs {
  final bool? includeDeviceNameArgs;
  final bool? includeTXPowerLevelArgs;
  final List<String?> serviceUUIDsArgs;
  final Map<String?, Uint8List?> serviceDataArgs;
  final List<ManufacturerSpecificDataArgs?> manufacturerSpecificDataArgs;

  AdvertiseDataArgs(
    this.includeDeviceNameArgs,
    this.includeTXPowerLevelArgs,
    this.serviceUUIDsArgs,
    this.serviceDataArgs,
    this.manufacturerSpecificDataArgs,
  );
}

class CentralArgs {
  final String addressArgs;

  CentralArgs(this.addressArgs);
}

class PeripheralArgs {
  final String addressArgs;

  PeripheralArgs(this.addressArgs);
}

class GATTDescriptorArgs {
  final int hashCodeArgs;
  final String uuidArgs;

  GATTDescriptorArgs(this.hashCodeArgs, this.uuidArgs);
}

class GATTCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<int?> propertyNumbersArgs;
  final List<GATTDescriptorArgs?> descriptorsArgs;

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
  final List<GATTServiceArgs?> includedServicesArgs;
  final List<GATTCharacteristicArgs?> characteristicsArgs;

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
  final List<int?> permissionNumbersArgs;

  MutableGATTDescriptorArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.permissionNumbersArgs,
  );
}

class MutableGATTCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<int?> permissionNumbersArgs;
  final List<int?> propertyNumbersArgs;
  final List<MutableGATTDescriptorArgs?> descriptorsArgs;

  MutableGATTCharacteristicArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.permissionNumbersArgs,
    this.propertyNumbersArgs,
    this.descriptorsArgs,
  );
}

class MutableGATTServiceArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final bool isPrimaryArgs;
  final List<MutableGATTServiceArgs?> includedServicesArgs;
  final List<MutableGATTCharacteristicArgs?> characteristicsArgs;

  MutableGATTServiceArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.isPrimaryArgs,
    this.includedServicesArgs,
    this.characteristicsArgs,
  );
}

@HostApi()
abstract class CentralManagerHostApi {
  CentralManagerArgs initialize();
  BluetoothLowEnergyStateArgs getState();
  @async
  bool authorize();
  void showAppSettings();
  @async
  void startDiscovery(List<String> serviceUUIDsArgs);
  void stopDiscovery();
  @async
  void connect(String addressArgs);
  @async
  void disconnect(String addressArgs);
  List<PeripheralArgs> retrieveConnectedPeripherals();
  @async
  int requestMTU(String addressArgs, int mtuArgs);
  @async
  int readRSSI(String addressArgs);
  @async
  List<GATTServiceArgs> discoverGATT(String addressArgs);
  @async
  Uint8List readCharacteristic(String addressArgs, int hashCodeArgs);
  @async
  void writeCharacteristic(
    String addressArgs,
    int hashCodeArgs,
    Uint8List valueArgs,
    GATTCharacteristicWriteTypeArgs typeArgs,
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
  void onMTUChanged(PeripheralArgs peripheralArgs, int mtuArgs);
  void onCharacteristicNotified(
    PeripheralArgs peripheralArgs,
    GATTCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  );
}

@HostApi()
abstract class PeripheralManagerHostApi {
  PeripheralManagerArgs initialize();
  BluetoothLowEnergyStateArgs getState();
  @async
  bool authorize();
  void showAppSettings();
  @async
  String? setName(String nameArgs);
  void openGATTServer();
  void closeGATTServer();
  @async
  void addService(MutableGATTServiceArgs serviceArgs);
  void removeService(int hashCodeArgs);
  void removeAllServices();
  @async
  void startAdvertising(
    AdvertiseSettingsArgs settingsArgs,
    AdvertiseDataArgs advertiseDataArgs,
    AdvertiseDataArgs scanResponseArgs,
  );
  void stopAdvertising();
  void sendResponse(
    String addressArgs,
    int idArgs,
    GATTStatusArgs statusArgs,
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
  @async
  void disconnect(String addressArgs);
}

@FlutterApi()
abstract class PeripheralManagerFlutterApi {
  void onStateChanged(BluetoothLowEnergyStateArgs stateArgs);
  void onConnectionStateChanged(
    CentralArgs centralArgs,
    int statusArgs,
    ConnectionStateArgs stateArgs,
  );
  void onMTUChanged(CentralArgs centralArgs, int mtuArgs);
  void onCharacteristicReadRequest(
    CentralArgs centralArgs,
    int idArgs,
    int offsetArgs,
    int hashCodeArgs,
  );
  void onCharacteristicWriteRequest(
    CentralArgs centralArgs,
    int idArgs,
    int hashCodeArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
    int offsetArgs,
    Uint8List valueArgs,
  );
  void onDescriptorReadRequest(
    CentralArgs centralArgs,
    int idArgs,
    int offsetArgs,
    int hashCodeArgs,
  );
  void onDescriptorWriteRequest(
    CentralArgs centralArgs,
    int idArgs,
    int hashCodeArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
    int offsetArgs,
    Uint8List valueArgs,
  );
  void onExecuteWrite(CentralArgs centralArgs, int idArgs, bool executeArgs);
}
