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
  withResponse,
  withoutResponse,
}

enum MyGattCharacteristicNotifyStateArgs {
  none,
  notify,
  indicate,
}

enum MyGattStatusArgs {
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
  final String addressArgs;

  MyCentralArgs(this.addressArgs);
}

class MyPeripheralArgs {
  final String addressArgs;

  MyPeripheralArgs(this.addressArgs);
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
  int getState();
  @async
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(String addressArgs);
  @async
  void disconnect(String addressArgs);
  @async
  int requestMTU(String addressArgs, int mtuArgs);
  @async
  int readRSSI(String addressArgs);
  @async
  List<MyGattServiceArgs> discoverGATT(String addressArgs);
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
abstract class MyCentralManagerFlutterApi {
  void onStateChanged(int stateNumberArgs);
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssiArgs,
    MyAdvertisementArgs advertisementArgs,
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
abstract class MyPeripheralManagerHostApi {
  void setUp();
  int getState();
  @async
  void addService(MyGattServiceArgs serviceArgs);
  void removeService(int hashCodeArgs);
  void clearServices();
  @async
  void startAdvertising(MyAdvertisementArgs advertisementArgs);
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
    String addressArgs,
    int hashCodeArgs,
    bool confirmArgs,
    Uint8List valueArgs,
  );
}

@FlutterApi()
abstract class MyPeripheralManagerFlutterApi {
  void onStateChanged(int stateNumberArgs);
  void onConnectionStateChanged(MyCentralArgs centralArgs, bool stateArgs);
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
  void onExecuteWrite(
    String addressArgs,
    int idArgs,
    bool executeArgs,
  );
  void onCharacteristicNotifyStateChanged(
    String addressArgs,
    int hashCodeArgs,
    int stateNumberArgs,
  );
}
