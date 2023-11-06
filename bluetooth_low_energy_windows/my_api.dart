// TODO: 由于此文件中的类型定义顺序会影响生成的 C++ 文件中的类型顺序，需要将依赖类型放在前面，
// 参见：https://github.com/flutter/flutter/issues/128330
// 当此问题解决时恢复之前的顺序。
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
  // Write with response
  withResponse,
  // Write without response
  withoutResponse,
  // Write with response and waiting for confirmation
  // reliable,
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
  @async
  MyCentralManagerArgs setUp();
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(int peripheralHashCodeArgs);
  void disconnect(int peripheralHashCodeArgs);
  int getMaximumWriteLength(int peripheralHashCodeArgs, int typeNumberArgs);
  @async
  int readRSSI(int peripheralHashCodeArgs);
  @async
  List<MyGattServiceArgs> discoverServices(int peripheralHashCodeArgs);
  @async
  List<MyGattCharacteristicArgs> discoverCharacteristics(
    int serviceHashCodeArgs,
  );
  @async
  List<MyGattDescriptorArgs> discoverDescriptors(characteristicHashCodeArgs);
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
