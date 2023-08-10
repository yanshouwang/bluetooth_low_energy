import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/my_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/dev/yanshouwang/bluetooth_low_energy/MyApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.yanshouwang.bluetooth_low_energy',
    ),
  ),
)
@HostApi()
abstract class MyCentralControllerHostApi {
  @async
  void initialize();
  void free(int hashCode);
  int getState();
  @async
  void startDiscovery();
  void stopDiscovery();
  @async
  void connect(int peripheralHashCode);
  @async
  void disconnect(int peripheralHashCode);
  @async
  void discoverGATT(int peripheralHashCode);
  List<MyGattServiceArgs> getServices(int peripheralHashCode);
  List<MyGattCharacteristicArgs> getCharacteristics(int serviceHashCode);
  List<MyGattDescriptorArgs> getDescriptors(int characteristicHashCode);
  @async
  Uint8List readCharacteristic(int characteristicHashCode);
  @async
  void writeCharacteristic(
    int characteristicHashCode,
    Uint8List value,
    int typeNumber,
  );
  @async
  void notifyCharacteristic(int characteristicHashCode, bool state);
  @async
  Uint8List readDescriptor(int descriptorHashCode);
  @async
  void writeDescriptor(int descriptorHashCode, Uint8List value);
}

@FlutterApi()
abstract class MyCentralControllerFlutterApi {
  void onStateChanged(int stateNumber);
  void onDiscovered(
    MyPeripheralArgs peripheralArgs,
    int rssi,
    MyAdvertisementArgs advertisementArgs,
  );
  void onPeripheralStateChanged(
    MyPeripheralArgs peripheralArgs,
    bool state,
    String? errorMessage,
  );
  void onCharacteristicValueChanged(
    MyGattCharacteristicArgs characteristicArgs,
    Uint8List value,
  );
}

class MyPeripheralArgs {
  final int hashCode;
  final String uuidValue;

  MyPeripheralArgs(this.hashCode, this.uuidValue);
}

class MyAdvertisementArgs {
  final String? name;
  final Uint8List? manufacturerSpecificData;

  MyAdvertisementArgs(
    this.name,
    this.manufacturerSpecificData,
  );
}

class MyGattServiceArgs {
  final int hashCode;
  final String uuidValue;

  MyGattServiceArgs(this.hashCode, this.uuidValue);
}

class MyGattCharacteristicArgs {
  final int hashCode;
  final String uuidValue;
  final List<int?> propertyNumbers;

  MyGattCharacteristicArgs(
    this.hashCode,
    this.uuidValue,
    this.propertyNumbers,
  );
}

class MyGattDescriptorArgs {
  final int hashCode;
  final String uuidValue;

  MyGattDescriptorArgs(this.hashCode, this.uuidValue);
}

enum MyCentralControllerStateArgs {
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
