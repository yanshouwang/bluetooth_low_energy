// Run with `dart run pigeon --input api.dart`.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/api.g.dart',
    kotlinOut:
        'android/src/main/kotlin/dev/hebei/bluetooth_low_energy_android/BluetoothLowEnergyAndroidApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.hebei.bluetooth_low_energy_android',
      errorClassName: 'BluetoothLowEnergyAndroidError',
    ),
  ),
)
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'dev.hebei.bluetooth_low_energy_android.BluetoothLowEnergyManager',
  ),
)
abstract class BluetoothLowEnergyManagerApi {
  void addStateChangedListener(StateChangedListenerApi listener);
  void removeStateChangedListener(StateChangedListenerApi listener);

  void addNameChangedListener(NameChangedListenerApi listener);
  void removeNameChangedListener(NameChangedListenerApi listener);

  BluetoothLowEnergyStateApi getState();
  @async
  void turnOn();
  @async
  void turnOff();

  String? getName();
  @async
  String? setName(String? name);

  bool shouldShowAuthorizeRationale();
  @async
  bool authorize();
  void showAppSettings();
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'dev.hebei.bluetooth_low_energy_android.BluetoothLowEnergyManager.StateChangedListener',
  ),
)
abstract class StateChangedListenerApi {
  StateChangedListenerApi();

  late final void Function(BluetoothLowEnergyStateApi state) onChanged;
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'dev.hebei.bluetooth_low_energy_android.BluetoothLowEnergyManager.NameChangedListener',
  ),
)
abstract class NameChangedListenerApi {
  NameChangedListenerApi();

  late final void Function(String? name) onChanged;
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.bluetooth_low_energy_android.CentralManager',
  ),
)
abstract class CentralManagerApi extends BluetoothLowEnergyManagerApi {
  CentralManagerApi();

  void addDiscoveredListener(DiscoveredListenerApi listener);
  void removeDiscoveredListener(DiscoveredListenerApi listener);

  void addConnectionStateChangedListener(
      ConnectionStateChangedListenerApi listener);
  void removeConnectionStateChangedListener(
      ConnectionStateChangedListenerApi listener);

  void addMTUChanagedListener(MTUChangedListenerApi listener);
  void removeMTUChangedListener(MTUChangedListenerApi listener);

  void addCharacteristicNotifiedListener(
      CharacteristicNotifiedListenerApi listener);
  void removeCharacteristicNotifiedListener(
      CharacteristicNotifiedListenerApi listener);

  @async
  void startDiscovery(List<String> serviceUUIDs);
  void stopDiscovery();

  List<PeripheralApi> retrieveConnectedPeripherals();

  @async
  void connect(PeripheralApi peripheral);
  @async
  void disconnect(PeripheralApi peripheral);
  @async
  int requestMTU(PeripheralApi peripheral, int mtu);
  void requestConnectionPriority(
      PeripheralApi peripheral, ConnectionPriorityApi priority);
  int getMaximumWriteLength(
      PeripheralApi peripheral, GATTCharacteristicWriteTypeApi type);
  @async
  int readRSSI(PeripheralApi peripheral);
  @async
  List<GATTServiceApi> discoverServices(PeripheralApi peripheral);

  @async
  Uint8List readCharacteristic(GATTCharacteristicApi characterisic);
  @async
  void writeCharacteristic(GATTCharacteristicApi characterisic, Uint8List value,
      GATTCharacteristicWriteTypeApi type);
  @async
  void setCharacteristicNotifyState(
      GATTCharacteristicApi characterisic, bool state);

  @async
  Uint8List readDescriptor(GATTDescriptorApi descriptor);
  @async
  void writeDescriptor(GATTDescriptorApi descriptor, Uint8List value);
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'dev.hebei.bluetooth_low_energy_android.CentralManager.DiscoveredListener',
  ),
)
abstract class DiscoveredListenerApi {
  DiscoveredListenerApi();

  late final void Function(
      PeripheralApi peripheral, int rssi, Uint8List advertisement) onDiscovered;
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'dev.hebei.bluetooth_low_energy_android.CentralManager.ConnectionStateChangedListener',
  ),
)
abstract class ConnectionStateChangedListenerApi {
  ConnectionStateChangedListenerApi();

  late final void Function(PeripheralApi peripheral, ConnectionStateApi state)
      onChanged;
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'dev.hebei.bluetooth_low_energy_android.CentralManager.MTUChangedListener',
  ),
)
abstract class MTUChangedListenerApi {
  MTUChangedListenerApi();

  late final void Function(PeripheralApi peripheral, int mtu) onChanged;
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'dev.hebei.bluetooth_low_energy_android.CentralManager.CharacteristicNotifiedListener',
  ),
)
abstract class CharacteristicNotifiedListenerApi {
  CharacteristicNotifiedListenerApi();

  late final void Function(
      GATTCharacteristicApi characteristic, Uint8List value) onNotified;
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'dev.hebei.bluetooth_low_energy_android.BluetoothLowEnergyPeer',
  ),
)
abstract class BluetoothLowEnergyPeerApi {
  String getAddress();
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.bluetooth_low_energy_android.Peripheral',
  ),
)
abstract class PeripheralApi extends BluetoothLowEnergyPeerApi {}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.bluetooth_low_energy_android.GATTAttribute',
  ),
)
abstract class GATTAttributeApi {
  String getUUID();
  int getInstanceId();
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.bluetooth_low_energy_android.GATTDescriptor',
  ),
)
abstract class GATTDescriptorApi extends GATTAttributeApi {}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.bluetooth_low_energy_android.GATTCharacteristic',
  ),
)
abstract class GATTCharacteristicApi extends GATTAttributeApi {
  List<GATTCharacteristicPropertyApi> getProperties();
  List<GATTDescriptorApi> getDescriptors();
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.bluetooth_low_energy_android.GATTService',
  ),
)
abstract class GATTServiceApi extends GATTAttributeApi {
  bool getIsPrimary();
  List<GATTServiceApi> getIncludedServices();
  List<GATTCharacteristicApi> getCharacteristics();
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
