// Run with `dart run pigeon --input my_api.dart`.
// TODO: use `@ProxyApi` to manage instancs when this feature released:
// https://github.com/flutter/flutter/issues/147486
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

@HostApi()
abstract class MyCentralManagerHostAPI {
  @async
  void initialize();
  MyBluetoothLowEnergyStateArgs getState();
  void startDiscovery(List<String> serviceUUIDsArgs);
  void stopDiscovery();
  @async
  void connect(int addressArgs);
  void disconnect(int addressArgs);
  int getMTU(int addressArgs);
  @async
  List<MyGATTServiceArgs> getServicesAsync(
    int addressArgs,
    MyCacheModeArgs modeArgs,
  );
  @async
  List<MyGATTServiceArgs> getIncludedServicesAsync(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  );
  @async
  List<MyGATTCharacteristicArgs> getCharacteristicsAsync(
    int addressArgs,
    int handleArgs,
    MyCacheModeArgs modeArgs,
  );
  @async
  List<MyGATTDescriptorArgs> getDescriptorsAsync(
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
