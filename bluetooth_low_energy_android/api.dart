import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/dev/yanshouwang/bluetooth_low_energy/Api.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.yanshouwang.bluetooth_low_energy',
    ),
  ),
)
@HostApi()
abstract class InstanceManagerHostApi {
  void free(int hashCode);
}

@HostApi()
abstract class IntentHostApi {
  String? getAction(int hashCode);
  int setAction(int hashCode, String? action);
  int? getData(int hashCode);
  int setData(int hashCode, int? dataHashCode);
  String? getPackage(int hashCode);
  int setPackage(int hashCode, String? packageName);
  List<String> getCategories(int hashCode);
  int? getClipData(int hashCode);
  void setClipData(int hashCode, int? clipDataHashCode);
  int? getComponent(int hashCode);
  int setComponent(int hashCode, int? componentHashCode);
  String? getDataString(int hashCode);
  int? getExtras(int hashCode);
  int getFlags(int hashCode);
  int setFlags(int hashCode, int flags);
  String? getIdentifier(int hashCode);
  int setIdentifier(int hashCode, String? identifier);
  String? getScheme(int hashCode);
  int? getSelector(int hashCode);
  void setSelector(int hashCode, int? selectorHashCode);
  int? getSourceBounds(int hashCode);
  void setSourceBounds(int hashCode, int? sourceBoundsHashCode);
  String? getType(int hashCode);
  int setType(int hashCode, String? type);
  int addCategory(int hashCode, String category);
  int addFlags(int hashCode, int flags);
  int cloneFilter(int hashCode);
  int fillIn(int hashCode, int otherHashCode, int flags);
  bool filterEquals(int hashCode, int otherHashCode);
  int filterHashCode(int hashCode);
  List<bool>? getBooleanArrayExtra(int hashCode, String name);
  int putBooleanArrayExtra(int hashCode, String name, List<bool>? value);
  bool getBooleanExtra(int hashCode, String name, bool defaultValue);
  int putBooleanExtra(int hashCode, String name, bool value);
  int? getBundleExtra(int hashCode, String name);
  int putBundleExtra(int hashCode, String name, int? valueHashCode);
  Uint8List? getByteArrayExtra(int hashCode, String name);
  int putByteArrayExtra(int hashCode, String name, Uint8List? value);
  List<double>? getDoubleArrayExtra(int hashCode, String name);
  int putDoubleArrayExtra(int hashCode, String name, List<double>? value);
  double getDoubleExtra(int hashCode, String name, double defaultValue);
  int putDoubleExtra(int hashCode, String name, double value);
  List<int>? getIntArrayExtra(int hashCode, String name);
  int putIntArrayExtra(int hashCode, String name, List<int>? value);
  int getIntExtra(int hashCode, String name, int defaultValue);
  int putIntExtra(int hashCode, String name, int value);
  List<int>? getLongArrayExtra(int hashCode, String name);
  int putLongArrayExtra(int hashCode, String name, List<int>? value);
  int getLongExtra(int hashCode, String name, int defaultValue);
  int putLongExtra(int hashCode, String name, int value);
  List<int>? getParcelableArrayExtra(int hashCode, String name);
  int putParcelableArrayExtra(
    int hashCode,
    String name,
    List<int>? valueHashCode,
  );
  int? getParcelableExtra(int hashCode, String name);
  int putParcelableExtra(int hashCode, String name, int? valueHashCode);
  int? getSerializableExtra(int hashCode, String name);
  int putSerializableExtra(int hashCode, String name, int? valueHashCode);
  List<String>? getStringArrayExtra(int hashCode, String name);
  int putStringArrayExtra(int hashCode, String name, List<String>? value);
  String? getStringExtra(int hashCode, String name);
  int putStringExtra(int hashCode, String name, String? value);
  int putExtras(int hashCode, int srcHashCode);
  int putExtras1(int hashCode, int extrasHashCode);
  bool hasCategory(int hashCode, String category);
  bool hasExtra(int hashCode, String name);
  bool hasFileDescriptors(int hashCode);
  void readFromParcel(int hashCode, int inHashCode);
  void removeCategory(int hashCode, String category);
  void removeExtra(int hashCode, String name);
  void removeFlags(int hashCode, int flags);
  int replaceExtras(int hashCode, int srcHashCode);
  int replaceExtras1(int hashCode, int? extrasHashCode);
  int resolveActivity(int hashCode, int pmHashCode);
  int resolveActivityInfo(int hashCode, int pmHashCode, int flags);
  String? resolveType(int hashCode);
  String? resolveType1(int hashCode, int resolverHashCode);
  String? resolveTypeIfNeeded(int hashCode, int resolverHashCode);
  int setClass(int hashCode, int clsHashCode);
  int setClassName(int hashCode, String packageName, String className);
  int setClassName1(int hashCode, String className);
  int setDataAndNormalize(int hashCode, int dataHashCode);
  int setDataAndType(int hashCode, int? dataHashCode, String? type);
  int setDataAndTypeAndNormalize(int hashCode, int dataHashCode, String? type);
  void setExtrasClassLoader(int hashCode, int? loaderHashCode);
  int setTypeAndNormalize(int hashCode, String? type);
  String toUri(int hashCode, int flags);
}

@HostApi()
abstract class PendingIntentHostApi {
  int getService(int requestCode, int intentHashCode, int flags);
  int getActivities(int requestCode, List<int> intentHashCodes, int flags);
  int getActivities1(
    int requestCode,
    List<int> intentHashCodes,
    int flags,
    int? optionsHashCode,
  );
  int getActivity(int requestCode, int intentHashCode, int flags);
  int getActivity1(
    int requestCode,
    int intentHashCode,
    int flags,
    int? optionsHashCode,
  );
  int getBroadcast(int requestCode, int intentHashCode, int flags);
  int getForegroundService(int requestCode, int intentHashCode, int flags);
}

@HostApi()
abstract class UuidHostApi {
  int newInstance(int mostSigBits, int leastSigBits);
  int randomUUID();
  int fromString(String name);
  int nameUUIDFromBytes(Uint8List name);
}

@HostApi()
abstract class ParcelUuidHostApi {
  int newInstance(int uuidHashCode);
  int fromString(String uuid);
}

@HostApi()
abstract class BroadcastReceiverHostApi {
  int newInstance();
}

@FlutterApi()
abstract class BroadcastReceiverFlutterApi {
  void onReceive(int hashCode, int intentHashCode);
}

@HostApi()
abstract class BluetoothManagerHostApi {
  int getInstance();
  int getAdapter(int hashCode);
  int getConnectionState(int hashCode, int deviceHashCode, int profile);
  List<int> getConnectedDevices(int hashCode, int profile);
  List<int> getDevicesMatchingConnectionStates(
    int hashCode,
    int profile,
    List<int> states,
  );
  int openGattServer(int hashCode, int callbackHashCode);
}

@HostApi()
abstract class BluetoothGattServerCallbackHostApi {
  int newInstance();
}

@FlutterApi()
abstract class BluetoothGattServerCallbackFlutterApi {
  void onConnectionStateChange(
    int hashCode,
    int deviceHashCode,
    int status,
    int newState,
  );
  void onServiceAdded(int hashCode, int status, int serviceHashCode);
  void onCharacteristicReadRequest(
    int hashCode,
    int deviceHashCode,
    int requestId,
    int offset,
    int characteristicHashCode,
  );
  void onCharacteristicWriteRequest(
    int hashCode,
    int deviceHashCode,
    int requestId,
    int characteristicHashCode,
    bool preparedWrite,
    bool responseNeeded,
    int offset,
    Uint8List value,
  );
  void onDescriptorReadRequest(
    int hashCode,
    int deviceHashCode,
    int requestId,
    int offset,
    int descriptorHashCode,
  );
  void onDescriptorWriteRequest(
    int hashCode,
    int deviceHashCode,
    int requestId,
    int descriptorHashCode,
    bool preparedWrite,
    bool responseNeeded,
    int offset,
    Uint8List value,
  );
  void onExecuteWrite(
    int hashCode,
    int deviceHashCode,
    int requestId,
    bool execute,
  );
  void onNotificationSent(int hashCode, int deviceHashCode, int status);
  void onMtuChanged(int hashCode, int deviceHashCode, int mtu);
  void onPhyUpdate(
    int hashCode,
    int deviceHashCode,
    int txPhy,
    int rxPhy,
    int status,
  );
  void onPhyRead(
    int hashCode,
    int deviceHashCode,
    int txPhy,
    int rxPhy,
    int status,
  );
}

@HostApi()
abstract class BluetoothAdapterHostApi {
  String getAddress(int hashCode);
  int getState(int hashCode);
  bool isEnabled(int hashCode);
  bool isDiscovering(int hashCode);
  String getName(int hashCode);
  bool setName(int hashCode, String name);
  int getScanMode(int hashCode);
  int getBluetoothLeScanner(int hashCode);
  int getBluetoothLeAdvertiser(int hashCode);
  List<int> getBondedDevices(int hashCode);
  bool isLe2MPhySupported(int hashCode);
  bool isLeCodedPhySupported(int hashCode);
  bool isLeExtendedAdvertisingSupported(int hashCode);
  bool isLePeriodicAdvertisingSupported(int hashCode);
  bool isMultipleAdvertisementSupported(int hashCode);
  bool isOffloadedFilteringSupported(int hashCode);
  bool isOffloadedScanBatchingSupported(int hashCode);
  int leMaximumAdvertisingDataLength(int hashCode);
  bool enable(int hashCode);
  bool disable(int hashCode);
  bool startDiscovery(int hashCode);
  bool cancelDiscovery(int hashCode);
  int getRemoteDevice(int hashCode, String address);
  int getRemoteDevice1(int hashCode, Uint8List address);
  bool getProfileProxy(int hashCode, int listenerHashCode, int profile);
  void closeProfileProxy(int hashCode, int profile, int proxyHashCode);
  int getProfileConnectionState(int hashCode, int profile);
  int listenUsingInsecureL2capChannel(int hashCode);
  int listenUsingInsecureRfcommWithServiceRecord(
    int hashCode,
    String name,
    int uuidHashCode,
  );
  int listenUsingL2capChannel(int hashCode);
  int listenUsingRfcommWithServiceRecord(
    int hashCode,
    String name,
    int uuidHashCode,
  );
}

@HostApi()
abstract class BluetoothProfileServiceListenerHostApi {
  int newInstance();
}

@FlutterApi()
abstract class BluetoothProfileServiceListenerFlutterApi {
  void onServiceConnected(int hashCode, int profile, int proxyHashCode);
  void onServiceDisconnected(int hashCode, int profile);
}

@HostApi()
abstract class BluetoothLeScannerHostApi {
  void startScan(int hashCode, int callbackHashCode);
  void startScan1(
    int hashCode,
    List<int> filterHashCodes,
    int settingsHashCode,
    int callbackHashCode,
  );
  void startScan2(
    int hashCode,
    List<int> filterHashCodes,
    int settingsHashCode,
    int callbackIntentHashCode,
  );
  void stopScan(int hashCode, int callbackHashCode);
  void stopScan1(int hashCode, int callbackIntentHashCode);
  void flushPendingScanResults(int hashCode, int callbackHashCode);
}

@HostApi()
abstract class ScanCallbackHostApi {
  int newInstance();
}

@FlutterApi()
abstract class ScanCallbackFlutterApi {
  void onScanResult(int hashCode, int callbackType, int resultHashCode);
  void onBatchScanResults(int hashCode, List<int> resultHashCodes);
  void onScanFailed(int hashCode, int errorCode);
}

@HostApi()
abstract class ScanResultHostApi {
  int getDevice(int hashCode);
  int getRSSI(int hashCode);
  int? getScanRecord(int hashCode);
  int getAdvertisingSId(int hashCode);
  int getDataStatus(int hashCode);
  int getPeriodicAdvertisingInterval(int hashCode);
  int getPrimaryPhy(int hashCode);
  int getSecondaryPhy(int hashCode);
  int getTimestampNanos(int hashCode);
  int getTxPower(int hashCode);
  bool getIsConnectable(int hashCode);
  bool getIsLegacy(int hashCode);
}

@HostApi()
abstract class ScanRecordHostApi {
  Map<int, Uint8List> getManufacturerSpecificData(int hashCode);
  Uint8List? getManufacturerSpecificDataWithId(
    int hashCode,
    int manufacturerId,
  );
  Uint8List getBytes(int hashCode);
  Map<int, Uint8List> getServiceData(int hashCode);
  Uint8List? getServiceDataWithUUID(int hashCode, int serviceDataUuidHashCode);
  int getAdvertiseFlags(int hashCode);
  String? getDeviceName(int hashCode);
  List<int> getServiceUUIDs(int hashCode);
  List<int> getServiceSolicitationUUIDs(int hashCode);
  int getTxPowerLevel(int hashCode);
}

@HostApi()
abstract class BluetoothDeviceHostApi {
  String getAddress(int hashCode);
  String getName(int hashCode);
  String? getAlias(int hashCode);
  int setAlias(int hashCode, String? alias);
  int getBluetoothClass(int hashCode);
  int getBondState(int hashCode);
  int getType(int hashCode);
  List<int> getUUIDs(int hashCode);
  bool fetchUuidsWithSdp(int hashCode);
  bool setPin(int hashCode, Uint8List pin);
  bool setPairingConfirmation(int hashCode, bool confirm);
  bool createBond(int hashCode);
  int createInsecureL2capChannel(int hashCode, int psm);
  int createL2capChannel(int hashCode, int psm);
  int createInsecureRfcommSocketToServiceRecord(int hashCode, int uuidHashCode);
  int createRfcommSocketToServiceRecord(int hashCode, int uuidHashCode);
  int connectGatt(int hashCode, bool autoConnect, int callbackHashCode);
  int connectGatt1(
    int hashCode,
    bool autoConnect,
    int callbackHashCode,
    int transport,
  );
  int connectGatt2(
    int hashCode,
    bool autoConnect,
    int callbackHashCode,
    int transport,
    int phy,
  );
  int connectGatt3(
    int hashCode,
    bool autoConnect,
    int callbackHashCode,
    int transport,
    int phy,
    int handlerHashCode,
  );
}

@HostApi()
abstract class BluetoothGattCallbackHostApi {
  int newInstance();
}

@FlutterApi()
abstract class BluetoothGattCallbackFlutterApi {
  void onPhyUpdate(
    int hashCode,
    int gattHashCode,
    int txPhy,
    int rxPhy,
    int status,
  );
  void onPhyRead(
    int hashCode,
    int gattHashCode,
    int txPhy,
    int rxPhy,
    int status,
  );
  void onConnectionStateChange(
    int hashCode,
    int gattHashCode,
    int status,
    int newState,
  );
  void onServicesDiscovered(int hashCode, int gattHashCode, int status);
  void onCharacteristicRead(
    int hashCode,
    int gattHashCode,
    int characteristicHashCode,
    int status,
  );
  void onCharacteristicWrite(
    int hashCode,
    int gattHashCode,
    int characteristicHashCode,
    int status,
  );
  void onCharacteristicChanged(
    int hashCode,
    int gattHashCode,
    int characteristicHashCode,
  );
  void onDescriptorRead(
    int hashCode,
    int gattHashCode,
    int descriptorHashCode,
    int status,
  );
  void onDescriptorWrite(
    int hashCode,
    int gattHashCode,
    int descriptorHashCode,
    int status,
  );
  void onReliableWriteCompleted(int hashCode, int gattHashCode, int status);
  void onReadRemoteRssi(int hashCode, int gattHashCode, int rssi, int status);
  void onMtuChanged(int hashCode, int gattHashCode, int mtu, int status);
  void onConnectionUpdated(
    int hashCode,
    int gattHashCode,
    int interval,
    int latency,
    int timeout,
    int status,
  );
  void onServiceChanged(int hashCode, int gattHashCode);
}

@HostApi()
abstract class BluetoothGattHostApi {
  int getDevice(int hashCode);
  List<int> getConnectedDevices(int hashCode);
  List<int> getServices(int hashCode);
  bool connect(int hashCode);
  bool discoverServices(int hashCode);
  int getService(int hashCode, int uuidHashCode);
  bool beginReliableWrite(int hashCode);
  bool executeReliableWrite(int hashCode);
  void abortReliableWrite(int hashCode);
  void disconnect(int hashCode);
  void close(int hashCode);
  bool readCharacteristic(int hashCode, int characteristicHashCode);
  bool writeCharacteristic(int hashCode, int characteristicHashCode);
  bool setCharacteristicNotification(
    int hashCode,
    int characteristicHashCode,
    bool enable,
  );
  bool readDescriptor(int hashCode, int descriptorHashCode);
  bool writeDescriptor(int hashCode, int descriptorHashCode);
  bool readRemoteRssi(int hashCode);
  void readPhy(int hashCode);
  bool requestMtu(int hashCode, int mtu);
  bool requestConnectionPriority(int hashCode, int connectionPriority);
  void setPreferredPhy(int hashCode, int txPhy, int rxPhy, int phyOptions);
  int getConnectionState(int hashCode, int deviceHashCode);
  List<int> getDevicesMatchingConnectionStates(int hashCode, List<int> states);
}

@HostApi()
abstract class BluetoothGattServiceHostApi {
  int getType(int hashCode);
  int getUUID(int hashCode);
  List<int> getIncludedServices(int hashCode);
  List<int> getCharacteristics(int hashCode);
  int getInstanceId(int hashCode);
  int getCharacteristic(int hashCode, int uuidHashCode);
  bool addService(int hashCode, int serviceHashCode);
  bool addCharacteristic(int hashCode, int characteristicHashCode);
}

@HostApi()
abstract class BluetoothGattCharacteristicHostApi {
  int getService(int hashCode);
  int getUUID(int hashCode);
  int getInstanceId(int hashCode);
  Uint8List getValue(int hashCode);
  bool setValue(int hashCode, Uint8List value);
  bool setValue1(int hashCode, String value);
  bool setValue2(int hashCode, int value, int formatType, int offset);
  bool setValue3(
    int hashCode,
    int mantissa,
    int exponent,
    int formatType,
    int offset,
  );
  List<int> getDescriptors(int hashCode);
  int getDescriptor(int hashCode, int uuidHashCode);
  int getPermissions(int hashCode);
  int getProperties(int hashCode);
  int getWriteType(int hashCode);
  void setWriteType(int hashCode, int writeType);
  double getFloatValue(int hashCode, int formatType, int offset);
  int getIntValue(int hashCode, int formatType, int offset);
  String getStringValue(int hashCode, int offset);
  bool addDescriptor(int hashCode, int descriptorHashCode);
}

@HostApi()
abstract class BluetoothGattDescriptorHostApi {
  int getCharacteristic(int hashCode);
  int getUUID(int hashCode);
  int getPermissions(int hashCode);
  Uint8List getValue(int hashCode);
  bool setValue(int hashCode, Uint8List value);
}
