// Run with `dart run pigeon --input pigeon.dart`.
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeon.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/dev/yanshouwang/bluetooth_low_energy_android/Pigeon.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.yanshouwang.bluetooth_low_energy_android',
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

enum GattCharacteristicPropertyArgs {
  read,
  write,
  writeWithoutResponse,
  notify,
  indicate,
}

enum GattCharacteristicWriteTypeArgs {
  withResponse,
  withoutResponse,
}

enum GattCharacteristicNotifyStateArgs {
  none,
  notify,
  indicate,
}

enum GattStatusArgs {
  success,
  readNotPermitted,
  writeNotPermitted,
  requestNotSupported,
  invalidOffset,
  insufficientAuthentication,
  insufficientEncryption,
  invalidAttributeLength,
  connectionCongested,
  failure,
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
  final ManufacturerSpecificDataArgs? manufacturerSpecificDataArgs;

  AdvertisementArgs(
    this.nameArgs,
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

class GattDescriptorArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final Uint8List? valueArgs;

  GattDescriptorArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.valueArgs,
  );
}

class GattCharacteristicArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<int?> propertyNumbersArgs;
  final List<GattDescriptorArgs?> descriptorsArgs;

  GattCharacteristicArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.propertyNumbersArgs,
    this.descriptorsArgs,
  );
}

class GattServiceArgs {
  final int hashCodeArgs;
  final String uuidArgs;
  final List<GattCharacteristicArgs?> characteristicsArgs;

  GattServiceArgs(
    this.hashCodeArgs,
    this.uuidArgs,
    this.characteristicsArgs,
  );
}

@HostApi()
abstract class CentralManagerCommandChannel {
  @async
  void initialize();
  @async
  bool requestPermission();
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
  List<GattServiceArgs> discoverServices(String addressArgs);
  @async
  Uint8List readCharacteristic(String addressArgs, int hashCodeArgs);
  @async
  void writeCharacteristic(
    String addressArgs,
    int hashCodeArgs,
    Uint8List valueArgs,
    int typeNumberArgs,
  );
  @async
  void setCharacteristicNotifyState(
    String addressArgs,
    int hashCodeArgs,
    int stateNumberArgs,
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
abstract class CentralManagerEventChannel {
  void onStateChanged(int stateNumberArgs);
  void onDiscovered(
    PeripheralArgs peripheralArgs,
    int rssiArgs,
    AdvertisementArgs advertisementArgs,
  );
  void onConnectionStateChanged(String addressArgs, bool stateArgs);
  void onMtuChanged(String addressArgs, int mtuArgs);
  void onCharacteristicNotified(
    String addressArgs,
    int hashCodeArgs,
    Uint8List valueArgs,
  );
}

@HostApi()
abstract class PeripheralManagerCommandChannel {
  @async
  void initialize();
  @async
  void addService(GattServiceArgs serviceArgs);
  void removeService(int hashCodeArgs);
  void clearServices();
  @async
  void startAdvertising(AdvertisementArgs advertisementArgs);
  void stopAdvertising();
  void sendResponse(
    String addressArgs,
    int idArgs,
    int statusNumberArgs,
    int offsetArgs,
    Uint8List? valueArgs,
  );
  @async
  void notifyCharacteristicChanged(
    int hashCodeArgs,
    Uint8List valueArgs,
    bool confirmArgs,
    String addressArgs,
  );
}

@FlutterApi()
abstract class PeripheralManagerEventChannel {
  void onStateChanged(int stateNumberArgs);
  void onConnectionStateChanged(CentralArgs centralArgs, bool stateArgs);
  void onMtuChanged(String addressArgs, int mtuArgs);
  void onCharacteristicReadRequest(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
  );
  void onCharacteristicWriteRequest(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
  );
  void onCharacteristicNotifyStateChanged(
    String addressArgs,
    int hashCodeArgs,
    int stateNumberArgs,
  );
  void onDescriptorReadRequest(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
  );
  void onDescriptorWriteRequest(
    String addressArgs,
    int hashCodeArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
    bool preparedWriteArgs,
    bool responseNeededArgs,
  );
  void onExecuteWrite(
    String addressArgs,
    int idArgs,
    bool executeArgs,
  );
}
