// Run with `dart run pigeon --input my_api.dart`.
import 'package:pigeon/pigeon.dart';

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
  disabled,
  off,
  on,
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

class MyCentralManagerArgs {
  final MyBluetoothLowEnergyStateArgs stateArgs;

  MyCentralManagerArgs(this.stateArgs);
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

class MyPeripheralArgs {
  final int addressArgs;

  MyPeripheralArgs(this.addressArgs);
}

class MyConnectionArgs {
  final int mtuArgs;

  MyConnectionArgs(this.mtuArgs);
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
  final List<MyGATTCharacteristicArgs?> characteristicsArgs;

  MyGATTServiceArgs(
    this.handleArgs,
    this.uuidArgs,
    this.characteristicsArgs,
  );
}

@HostApi()
abstract class MyCentralManagerHostAPI {
  @async
  MyCentralManagerArgs initialize();
  void startDiscovery(List<String> serviceUUIDsArgs);
  void stopDiscovery();
  @async
  MyConnectionArgs connect(int addressArgs);
  void disconnect(int addressArgs);
  @async
  List<MyGATTServiceArgs> discoverServices(int addressArgs);
  @async
  List<MyGATTCharacteristicArgs> discoverCharacteristics(
    int addressArgs,
    int handleArgs,
  );
  @async
  List<MyGATTDescriptorArgs> discoverDescriptors(
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
    MyGATTCharacteristicWriteTypeArgs typeArgs,
  );
  @async
  void setCharacteristicNotifyState(
    int addressArgs,
    int handleArgs,
    MyGATTCharacteristicNotifyStateArgs stateArgs,
  );
  @async
  Uint8List readDescriptor(int addressArgs, int handleArgs);
  @async
  void writeDescriptor(int addressArgs, int handleArgs, Uint8List valueArgs);
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
    int addressArgs,
    MyConnectionStateArgs stateArgs,
  );
  void onMTUChanged(int addressArgs, int mtuArgs);
  void onCharacteristicNotified(
    int addressArgs,
    int handleArgs,
    Uint8List valueArgs,
  );
}
