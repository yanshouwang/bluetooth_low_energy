// Run with `dart run pigeon --input api.dart`.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/api.g.dart',
    kotlinOut:
        'android/src/main/kotlin/dev/hebei/bluetooth_low_energy_android/BluetoothLowEnergyApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.hebei.bluetooth_low_energy_android',
      errorClassName: 'BluetoothLowEnergyError',
    ),
  ),
)
@HostApi()
abstract class CentralManagerHostApi {
  void addStateChangedListener();
  void removeStateChangedListener();

  void addNameChangedListener();
  void removeNameChangedListener();

  void addDiscoveredListener();
  void removeDiscoveredListener();

  void addConnectionStateChangedListener();
  void removeConnectionStateChangedListener();

  void addMTUChanagedListener();
  void removeMTUChangedListener();

  void addCharacteristicNotifiedListener();
  void removeCharacteristicNotifiedListener();

  BluetoothLowEnergyStateApi getState();
  bool shouldShowAuthorizeRationale();
  @async
  bool authorize();
  void showAppSettings();

  @async
  void turnOn();
  @async
  void turnOff();

  String? getName();
  @async
  String? setName(String? name);

  @async
  void startDiscovery(List<String> serviceUUIDs);
  void stopDiscovery();

  List<PeripheralApi> retrieveConnectedPeripherals();

  @async
  void connect(String address);
  @async
  void disconnect(String address);
  @async
  int requestMTU(String address, int mtu);
  void requestConnectionPriority(
      String address, ConnectionPriorityApi priority);
  int getMaximumWriteLength(
      String address, GATTCharacteristicWriteTypeApi type);
  @async
  int readRSSI(String address);
  @async
  List<GATTServiceApi> discoverServices(String address);

  @async
  Uint8List readCharacteristic(int id);
  @async
  void writeCharacteristic(
      int id, Uint8List value, GATTCharacteristicWriteTypeApi type);
  @async
  void setCharacteristicNotifyState(int id, bool state);

  @async
  Uint8List readDescriptor(int id);
  @async
  void writeDescriptor(int id, Uint8List value);
}

@FlutterApi()
abstract class CentralManagerFlutterApi {
  void onStateChanged(BluetoothLowEnergyStateApi state);
  void onNameChanged(String? name);
  void onDiscovered(
      PeripheralApi peripheral, int rssi, AdvertisementApi advertisement);
  void onConnectionStateChanged(
      PeripheralApi peripheral, ConnectionStateApi state);
  void onMTUChanged(PeripheralApi peripheral, int mtu);
  void onCharacteristicNotified(
      GATTCharacteristicApi characteristic, Uint8List value);
}

@HostApi()
abstract class PeripheralManagerHostApi {}

@FlutterApi()
abstract class PeripheralManagerFlutterApi {}

class PeripheralApi {
  final String address;

  PeripheralApi(this.address);
}

class ManufacturerSpecificDataApi {
  final int id;
  final Uint8List data;

  ManufacturerSpecificDataApi(this.id, this.data);
}

class AdvertisementApi {
  final String? name;
  final List<String> serviceUUIDs;
  final Map<String, Uint8List> serviceData;
  final List<ManufacturerSpecificDataApi> manufacturerSpecificData;

  AdvertisementApi(this.name, this.serviceUUIDs, this.serviceData,
      this.manufacturerSpecificData);
}

class GATTDescriptorApi {
  final int id;
  final String uuid;

  GATTDescriptorApi(this.id, this.uuid);
}

class GATTCharacteristicApi {
  final int id;
  final String uuid;
  final List<GATTCharacteristicPropertyApi> properties;
  final List<GATTDescriptorApi> descriptors;

  GATTCharacteristicApi(this.id, this.uuid, this.properties, this.descriptors);
}

class GATTServiceApi {
  final int id;
  final String uuid;
  final bool isPrimary;
  final List<GATTServiceApi> includedServices;
  final List<GATTCharacteristicApi> characteristics;

  GATTServiceApi(this.id, this.uuid, this.isPrimary, this.includedServices,
      this.characteristics);
}

enum BluetoothLowEnergyStateApi {
  unknown,
  unsupported,
  unauthorized,
  off,
  turningOn,
  on,
  turningOff,
}

enum ConnectionStateApi {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

enum ConnectionPriorityApi {
  balanced,
  high,
  lowPower,
  dck,
}

enum GATTPermissionApi {
  read,
  readEncrypted,
  write,
  writeEncrypted,
}

enum GATTCharacteristicPropertyApi {
  read,
  write,
  writeWithoutResponse,
  notify,
  indicate,
}

enum GATTCharacteristicWriteTypeApi {
  withResponse,
  withoutResponse,
}
