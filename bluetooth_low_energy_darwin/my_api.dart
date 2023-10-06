import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'darwin/Classes/MyApi.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
@HostApi()
abstract class MyCentralManagerHostApi {
  @async
  MyCentralManagerArgs setUp();
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

class MyCentralManagerArgs {
  final int stateNumberArgs;

  MyCentralManagerArgs(this.stateNumberArgs);
}

class MyAdvertisementArgs {
  final String? nameArgs;
  final Map<int?, Uint8List?> manufacturerSpecificDataArgs;
  final List<String?> serviceUUIDsArgs;
  final Map<String?, Uint8List?> serviceDataArgs;

  MyAdvertisementArgs(
    this.nameArgs,
    this.manufacturerSpecificDataArgs,
    this.serviceUUIDsArgs,
    this.serviceDataArgs,
  );
}

class MyPeripheralArgs {
  final int hashCodeArgs;
  final String uuidArgs;

  MyPeripheralArgs(this.hashCodeArgs, this.uuidArgs);
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
