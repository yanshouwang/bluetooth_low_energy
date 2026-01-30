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
    String address,
    ConnectionPriorityApi priority,
  );
  int getMaximumWriteLength(
    String address,
    GATTCharacteristicWriteTypeApi type,
  );
  @async
  int readRSSI(String address);
  @async
  List<GATTServiceApi> discoverServices(String address);

  @async
  Uint8List readCharacteristic(int id);
  @async
  void writeCharacteristic(
    int id,
    Uint8List value,
    GATTCharacteristicWriteTypeApi type,
  );
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
    PeripheralApi peripheral,
    int rssi,
    AdvertisementApi advertisement,
  );
  void onConnectionStateChanged(
    PeripheralApi peripheral,
    ConnectionStateApi state,
  );
  void onMTUChanged(PeripheralApi peripheral, int mtu);
  void onCharacteristicNotified(
    GATTCharacteristicApi characteristic,
    Uint8List value,
  );
}

@HostApi()
abstract class PeripheralManagerHostApi {
  void addStateChangedListener();
  void removeStateChangedListener();

  void addNameChangedListener();
  void removeNameChangedListener();

  void addConnectionStateChangedListener();
  void removeConnectionStateChangedListener();

  void addMTUChangedListener();
  void removeMTUChangedListener();

  void addCharacteristicReadRequestedListener();
  void removeCharacteristicReadRequestedListener();

  void addCharacteristicWriteRequestedListener();
  void removeCharacteristicWriteRequestedListener();

  void addCharacteristicNotifyStateChangedListener();
  void removeCharacteristicNotifyStateChangedListener();

  void addDescriptorReadRequestedListener();
  void removeDescriptorReadRequestedListener();

  void addDescriptorWriteRequestedListener();
  void removeDescriptorWriteRequestedListener();

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

  void addService(MutableGATTServiceApi service);
  void removeService(int id);
  void removeAllServices();
  @async
  void startAdvertising(AdvertisementApi advertisement);
  void stopAdvertising();
  int getMaximumNotifyLength(String address);
  void respondReadRequestWithValue(int id, Uint8List value);
  void respondReadRequestWithError(int id, GATTErrorApi error);
  void respondWriteRequest(int id);
  void respondWriteRequestWithError(int id, GATTErrorApi error);
  @async
  void notifyCharacteristic(int id, Uint8List value, List<String>? addresses);
}

@FlutterApi()
abstract class PeripheralManagerFlutterApi {
  void onStateChanged(BluetoothLowEnergyStateApi state);
  void onNameChanged(String? name);
  void onConnectionStateChanged(CentralApi central, ConnectionStateApi state);
  void onMTUChanged(CentralApi central, int mtu);
  void onCharacteristicReadRequested(
    int id,
    CentralApi central,
    GATTReadRequestApi request,
  );
  void onCharacteristicWriteRequested(
    int id,
    CentralApi central,
    GATTWriteRequestApi request,
  );
  void onCharacteristicNotifyStateChanged(
    int id,
    CentralApi central,
    bool state,
  );
  void onDescriptorReadRequested(
    int id,
    CentralApi central,
    GATTReadRequestApi request,
  );
  void onDescriptorWriteRequested(
    int id,
    CentralApi central,
    GATTWriteRequestApi request,
  );
}

class PeripheralApi {
  final String address;

  PeripheralApi(this.address);
}

class CentralApi {
  final String address;

  CentralApi(this.address);
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

  AdvertisementApi(
    this.name,
    this.serviceUUIDs,
    this.serviceData,
    this.manufacturerSpecificData,
  );
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

  GATTServiceApi(
    this.id,
    this.uuid,
    this.isPrimary,
    this.includedServices,
    this.characteristics,
  );
}

class MutableGATTDescriptorApi {
  final int id;
  final String uuid;
  final List<GATTPermissionApi> permissions;

  MutableGATTDescriptorApi(this.id, this.uuid, this.permissions);
}

class MutableGATTCharacteristicApi {
  final int id;
  final String uuid;
  final List<GATTPermissionApi> permissions;
  final List<GATTCharacteristicPropertyApi> properties;
  final List<GATTDescriptorApi> descriptors;

  MutableGATTCharacteristicApi(
    this.id,
    this.uuid,
    this.permissions,
    this.properties,
    this.descriptors,
  );
}

class MutableGATTServiceApi {
  final int id;
  final String uuid;
  final bool isPrimary;
  final List<MutableGATTServiceApi> includedServices;
  final List<MutableGATTCharacteristicApi> characteristics;

  MutableGATTServiceApi(
    this.id,
    this.uuid,
    this.isPrimary,
    this.includedServices,
    this.characteristics,
  );
}

class GATTReadRequestApi {
  final int id;
  final int offset;
  final int length;

  GATTReadRequestApi(this.id, this.offset, this.length);
}

class GATTWriteRequestApi {
  final int id;
  final int offset;
  final Uint8List value;

  GATTWriteRequestApi(this.id, this.offset, this.value);
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

enum ConnectionStateApi { disconnected, connecting, connected, disconnecting }

enum ConnectionPriorityApi { balanced, high, lowPower, dck }

enum GATTPermissionApi { read, readEncrypted, write, writeEncrypted }

enum GATTCharacteristicPropertyApi {
  read,
  write,
  writeWithoutResponse,
  notify,
  indicate,
}

enum GATTCharacteristicWriteTypeApi { withResponse, withoutResponse }

enum GATTErrorApi {
  success,
  readNotPermitted,
  writeNotPermitted,
  insufficientAuthentication,
  requestNotSupported,
  insufficientEncryption,
  invalidOffset,
  insufficientAuthorization,
  invalidAttributeLength,
  connectionCongested,
  failure,
}
