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
  void connect(int peripheralHashCodeArgs);
  @async
  void disconnect(int peripheralHashCodeArgs);
  int getMaximumWriteLength(int peripheralHashCodeArgs, int typeNumberArgs);
  @async
  int readRSSI(int peripheralHashCodeArgs);
  @async
  List<MyGattServiceArgs> discoverGATT(int peripheralHashCodeArgs);
  @async
  int requestMTU(int peripheralHashCodeArgs, int mtuArgs);
  @async
  Uint8List readCharacteristic(
    int peripheralHashCodeArgs,
    int characteristicHashCodeArgs,
  );
  @async
  void writeCharacteristic(
    int peripheralHashCodeArgs,
    int characteristicHashCodeArgs,
    Uint8List valueArgs,
    int typeNumberArgs,
  );
  @async
  void notifyCharacteristic(
    int peripheralHashCodeArgs,
    int characteristicHashCodeArgs,
    bool stateArgs,
  );
  @async
  Uint8List readDescriptor(
    int peripheralHashCodeArgs,
    int descriptorHashCodeArgs,
  );
  @async
  void writeDescriptor(
    int peripheralHashCodeArgs,
    int descriptorHashCodeArgs,
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
  void onPeripheralStateChanged(
    MyPeripheralArgs peripheralArgs,
    bool stateArgs,
  );
  void onCharacteristicValueChanged(
    MyGattCharacteristicArgs characteristicArgs,
    Uint8List valueArgs,
  );
}

@HostApi()
abstract class MyPeripheralManagerHostApi {
  @async
  MyPeripheralManagerArgs setUp();
  @async
  void addService(MyGattServiceArgs serviceArgs);
  void removeService(int serviceHashCodeArgs);
  void clearServices();
  @async
  void startAdvertising(MyAdvertisementArgs advertisementArgs);
  void stopAdvertising();
  int getMaximumWriteLength(int centralHashCodeArgs);
  void sendReadCharacteristicReply(
    int centralHashCodeArgs,
    int characteristicHashCodeArgs,
    int idArgs,
    int offsetArgs,
    bool statusArgs,
    Uint8List valueArgs,
  );
  void sendWriteCharacteristicReply(
    int centralHashCodeArgs,
    int characteristicHashCodeArgs,
    int idArgs,
    int offsetArgs,
    bool statusArgs,
  );
  @async
  void notifyCharacteristicValueChanged(
    int centralHashCodeArgs,
    int characteristicHashCodeArgs,
    Uint8List valueArgs,
  );
}

@FlutterApi()
abstract class MyPeripheralManagerFlutterApi {
  void onStateChanged(int stateNumberArgs);
  void onReadCharacteristicCommandReceived(
    MyCentralArgs centralArgs,
    MyGattCharacteristicArgs characteristicArgs,
    int idArgs,
    int offsetArgs,
  );
  void onWriteCharacteristicCommandReceived(
    MyCentralArgs centralArgs,
    MyGattCharacteristicArgs characteristicArgs,
    int idArgs,
    int offsetArgs,
    Uint8List valueArgs,
  );
  void onNotifyCharacteristicCommandReceived(
    MyCentralArgs centralArgs,
    MyGattCharacteristicArgs characteristicArgs,
    bool stateArgs,
  );
}

class MyCentralManagerArgs {
  final int stateNumberArgs;

  MyCentralManagerArgs(this.stateNumberArgs);
}

class MyPeripheralManagerArgs {
  final int stateNumberArgs;

  MyPeripheralManagerArgs(this.stateNumberArgs);
}

class MyCentralArgs {
  final int hashCodeArgs;
  final String uuidArgs;

  MyCentralArgs(this.hashCodeArgs, this.uuidArgs);
}

class MyPeripheralArgs {
  final int hashCodeArgs;
  final String uuidArgs;

  MyPeripheralArgs(this.hashCodeArgs, this.uuidArgs);
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

class MyManufacturerSpecificDataArgs {
  final int idArgs;
  final Uint8List dataArgs;

  MyManufacturerSpecificDataArgs(this.idArgs, this.dataArgs);
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
