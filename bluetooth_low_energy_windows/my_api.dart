import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    dartPackageName: 'bluetooth_low_energy_windows',
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
  final int addressArgs;

  MyCentralArgs(this.addressArgs);
}

class MyPeripheralArgs {
  final int addressArgs;

  MyPeripheralArgs(this.addressArgs);
}

class MyGattDescriptorArgs {
  final int handleArgs;
  final String uuidArgs;
  final Uint8List? valueArgs;

  MyGattDescriptorArgs(
    this.handleArgs,
    this.uuidArgs,
    this.valueArgs,
  );
}

class MyGattCharacteristicArgs {
  final int handleArgs;
  final String uuidArgs;
  final List<int?> propertyNumbersArgs;
  final List<MyGattDescriptorArgs?> descriptorsArgs;

  MyGattCharacteristicArgs(
    this.handleArgs,
    this.uuidArgs,
    this.propertyNumbersArgs,
    this.descriptorsArgs,
  );
}

class MyGattServiceArgs {
  final int handleArgs;
  final String uuidArgs;
  final List<MyGattCharacteristicArgs?> characteristicsArgs;

  MyGattServiceArgs(
    this.handleArgs,
    this.uuidArgs,
    this.characteristicsArgs,
  );
}

@HostApi()
abstract class MyCentralManagerHostApi {
  @async
  void setUp();
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(int addressArgs);
  void disconnect(int addressArgs);
  @async
  List<MyGattServiceArgs> discoverServices(int addressArgs);
  @async
  List<MyGattCharacteristicArgs> discoverCharacteristics(
    int addressArgs,
    int handleArgs,
  );
  @async
  List<MyGattDescriptorArgs> discoverDescriptors(
    int addressArgs,
    int handleArgs,
  );
  @async
  Uint8List readCharacteristic(int addressArgs, int handleArgs);
  @async
  void writeCharacteristic(
    int addressArgs,
    int handleArgs,
    Uint8List valueArgs,
    int typeNumberArgs,
  );
  @async
  void setCharacteristicNotifyState(
    int addressArgs,
    int handleArgs,
    int stateNumberArgs,
  );
  @async
  Uint8List readDescriptor(int addressArgs, int handleArgs);
  @async
  void writeDescriptor(int addressArgs, int handleArgs, Uint8List valueArgs);
}

@FlutterApi()
abstract class MyCentralManagerFlutterApi {
  void onStateChanged(int stateNumberArgs);
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssiArgs,
    MyAdvertisementArgs advertisementArgs,
  );
  void onConnectionStateChanged(
    int addressArgs,
    bool stateArgs,
  );
  void onCharacteristicNotified(
    int addressArgs,
    int handleArgs,
    Uint8List valueArgs,
  );
}

@HostApi()
abstract class MyPeripheralManagerHostApi {
  @async
  void setUp();
  @async
  void addService(MyGattServiceArgs serviceArgs);
  void removeService(int handleArgs);
  void clearServices();
  @async
  void startAdvertising(MyAdvertisementArgs advertisementArgs);
  void stopAdvertising();
  void sendReadCharacteristicReply(
    int addressArgs,
    int handleArgs,
    bool statusArgs,
    Uint8List valueArgs,
  );
  void sendWriteCharacteristicReply(
    int addressArgs,
    int handleArgs,
    bool statusArgs,
  );
  @async
  void notifyCharacteristic(
    int addressArgs,
    int handleArgs,
    Uint8List valueArgs,
  );
}

@FlutterApi()
abstract class MyPeripheralManagerFlutterApi {
  void onStateChanged(int stateNumberArgs);
  void onReadCharacteristicCommandReceived(
    MyCentralArgs centralArgs,
    int handleArgs,
  );
  void onWriteCharacteristicCommandReceived(
    MyCentralArgs centralArgs,
    int handleArgs,
    Uint8List valueArgs,
  );
  void onCharacteristicNotifyStateChanged(
    MyCentralArgs centralArgs,
    int handleArgs,
    bool stateArgs,
  );
}
