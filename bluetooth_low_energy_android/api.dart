import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/native/api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/dev/yanshouwang/bluetooth_low_energy/Api.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.yanshouwang.bluetooth_low_energy',
    ),
  ),
)
@HostApi()
abstract class CollectorHostApi {
  void free(int hashCode);
}

@HostApi()
abstract class IntentHostApi {
  String getAction();
  int setAction(String action);
  int getData();
  int setData(int dataHashCode);
  String getPackage();
  int setPackage(String packageName);
  List<String> getCategories();
  int getClipData();
  void setClipData(int clipHashCode);
  int getComponent();
  int setComponent(int componentHashCode);
  String getDataString();
  int getExtras();
  int getFlags();
  int setFlags(int flags);
  String getIdentifier();
  int setIdentifier(String identifier);
  String getScheme();
  int getSelector();
  void setSelector(int selectorHashCode);
  int getSourceBounds();
  void setSourceBounds(int rHashCode);
  String getType();
  int setType(String type);
  int addCategory(String category);
  int addFlags(int flags);
  int cloneFilter();
  int fillIn(int otherHashCode, int flags);
  bool filterEquals(int otherHashCode);
  int filterHashCode();
  List<bool> getBooleanArrayExtra(String name);
  int putBooleanArrayExtra(String name, List<bool> value);
  bool getBooleanExtra(String name, bool defaultValue);
  int putBooleanExtra(String name, bool value);
  int getBundleExtra(String name);
  int putBundleExtra(String name, int valueHashCode);
  Uint8List getByteArrayExtra(String name);
  int putByteArrayExtra(String name, Uint8List value);
  List<double> getDoubleArrayExtra(String name);
  int putDoubleArrayExtra(String name, List<double> value);
  double getDoubleExtra(String name, double defaultValue);
  int putDoubleExtra(String name, double value);
  List<int> getIntArrayExtra(String name);
  int putIntArrayExtra(String name, List<int> value);
  int getIntExtra(String name, int defaultValue);
  int putIntExtra(String name, int value);
  List<int> getParcelableArrayExtra(String name);
  int putParcelableArrayExtra(String name, List<int> valueHashCode);
  int getParcelableExtra(String name);
  int putParcelableExtra(String name, int valueHashCode);
  int getSerializableExtra(String name);
  int putSerializableExtra(String name, int valueHashCode);
  List<String> getStringArrayExtra(String name);
  int putStringArrayExtra(String name, List<String> value);
  String getStringExtra(String name);
  int putStringExtra(String name, String value);
  int putExtras(int srcHashCode);
  int putExtras1(int extrasHashCode);
  bool hasCategory(String category);
  bool hasExtra(String name);
  bool hasFileDescriptors();
  void readFromParcel(int inHashCode);
  void removeCategory(String category);
  void removeExtra(String name);
  void removeFlags(int flags);
  int replaceExtras(int srcHashCode);
  int replaceExtras1(int extrasHashCode);
  int resolveActivity(int pmHashCode);
  int resolveActivityInfo(int pmHashCode, int flags);
  String resolveType();
  String resolveType1(int resolverHashCode);
  String resolveTypeIfNeeded(int resolverHashCode);
  int setClass(int clsHashCode);
  int setClassName(String packageName, String className);
  int setClassName1(String className);
  int setDataAndNormalize(int dataHashCode);
  int setDataAndType(int dataHashCode, String type);
  int setDataAndTypeAndNormalize(int dataHashCode, String type);
  void setExtrasClassLoader(int loaderHashCode);
  int setTypeAndNormalize(String type);
  String toUri(int flags);
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
  void onReceive(int intentHashCode);
}

@HostApi()
abstract class BluetoothManagerHostApi {
  int getInstance();
  int getAdapter();
  int getConnectionState(int hashCode, int profile);
  List<int> getConnectedDevices(int profile);
  List<int> getDevicesMatchingConnectionStates(int profile, List<int> states);
  int openGattServer(int callbackHashCode);
}

@HostApi()
abstract class BluetoothGattServerCallbackHostApi {
  int newInstance();
}

@FlutterApi()
abstract class BluetoothGattServerCallbackFlutterApi {
  void onConnectionStateChange(int deviceHashCode, int status, int newState);
  void onServiceAdded(int status, int serviceHashCode);
  void onCharacteristicReadRequest(
    int deviceHashCode,
    int requestId,
    int offset,
    int characteristicHashCode,
  );
  void onCharacteristicWriteRequest(
    int deviceHashCode,
    int requestId,
    int characteristicHashCode,
    bool preparedWrite,
    bool responseNeeded,
    int offset,
    Uint8List value,
  );
  void onDescriptorReadRequest(
    int deviceHashCode,
    int requestId,
    int offset,
    int descriptorHashCode,
  );
  void onDescriptorWriteRequest(
    int deviceHashCode,
    int requestId,
    int descriptorHashCode,
    bool preparedWrite,
    bool responseNeeded,
    int offset,
    Uint8List value,
  );
  void onExecuteWrite(int deviceHashCode, int requestId, bool execute);
  void onNotificationSent(int deviceHashCode, int status);
  void onMtuChanged(int deviceHashCode, int mtu);
  void onPhyUpdate(int deviceHashCode, int txPhy, int rxPhy, int status);
  void onPhyRead(int deviceHashCode, int txPhy, int rxPhy, int status);
  void onConnectionUpdated(
    int deviceHashCode,
    int interval,
    int latency,
    int timeout,
    int status,
  );
}

@HostApi()
abstract class BluetoothAdapterHostApi {
  String getAddress();
  int getState();
  bool isEnabled();
  bool isDiscovering();
  String getName();
  bool setName();
  int getScanMode();
  int getBluetoothLeScanner();
  int getBluetoothLeAdvertiser();
  List<int> getBondedDevices();
  bool isLe2MPhySupported();
  bool isLeCodedPhySupported();
  bool isLeExtendedAdvertisingSupported();
  bool isLePeriodicAdvertisingSupported();
  bool isMultipleAdvertisementSupported();
  bool isOffloadedFilteringSupported();
  bool isOffloadedScanBatchingSupported();
  bool leMaximumAdvertisingDataLength();
  bool enable();
  bool disable();
  bool startDiscovery();
  bool cancelDiscovery();
  int getRemoteDevice(String address);
  int getRemoteDevice1(Uint8List address);
  bool getProfileProxy(int listenerHashCode, int profile);
  bool closeProfileProxy(int profile, int proxyHashCode);
  int getProfileConnectionState(int profile);
  int listenUsingInsecureL2capChannel();
  int listenUsingInsecureRfcommWithServiceRecord(String name, int uuidHashCode);
  int listenUsingL2capChannel();
  int listenUsingRfcommWithServiceRecord(String name, int uuidHashCode);
}

@HostApi()
abstract class BluetoothProfileServiceListenerHostApi {
  int newInstance();
}

@FlutterApi()
abstract class BluetoothProfileServiceListenerFlutterApi {
  void onServiceConnected(int profile, int proxyHashCode);
  void onServiceDisconnected(int profile);
}

@HostApi()
abstract class BluetoothLeScannerHostApi {
  void startScan(int callbackHashCode);
  void startScan1(
    List<int> filterHashCodes,
    int settingsHashCode,
    int callbackHashCode,
  );
  void startScan2(
    List<int> filterHashCodes,
    int settingsHashCode,
    int callbackIntentHashCode,
  );
  void stopScan(int callbackHashCode);
  void stopScan1(int callbackIntentHashCode);
  void flushPendingScanResults(int callbackHashCode);
}

@HostApi()
abstract class ScanCallbackHostApi {
  int newInstance();
}

@FlutterApi()
abstract class ScanCallbackFlutterApi {
  void onScanResult(int callbackType, int resultHashCode);
  void onBatchScanResults(List<int> resultHashCodes);
  void onScanFailed(int errorCode);
}

@HostApi()
abstract class ScanResultHostApi {
  int getDevice();
  int getRssi();
  int? getScanRecord();
  int getAdvertisingSid();
  int getDataStatus();
  int getPeriodicAdvertisingInterval();
  int getPrimaryPhy();
  int getSecondaryPhy();
  int getTimestampNanos();
  int getTxPower();
  bool getIsConnectable();
  bool getIsLegacy();
}

@HostApi()
abstract class ScanRecordHostApi {
  Map<int, Uint8List> getManufacturerSpecificData();
  Uint8List getManufacturerSpecificDataWithId(int manufacturerId);
  Uint8List getBytes();
  Map<int, Uint8List> getServiceData();
  Uint8List getServiceDataWithUUID(int serviceDataUuidHashCode);
  int getAdvertiseFlags();
  String getDeviceName();
  List<int> getServiceUuids();
  List<int> getServiceSolicitationUuids();
  int getTxPowerLevel();
}

@HostApi()
abstract class BluetoothDeviceHostApi {
  String getAddress();
  String getName();
  String getAlias();
  String setAlias(String alias);
  int getBluetoothClass();
  int getBondState();
  int getType();
  List<int> getUuids();
  bool fetchUuidsWithSdp();
  bool setPin(Uint8List pin);
  bool setPairingConfirmation(bool confirm);
  bool createBond();
  int createInsecureL2capChannel(int psm);
  int createL2capChannel(int psm);
  int createInsecureRfcommSocketToServiceRecord(int uuidHashCode);
  int createRfcommSocketToServiceRecord(int uuidHashCode);
  int connectGatt(bool autoConnect, int callbackHashCode);
  int connectGatt1(bool autoConnect, int callbackHashCode, int transport);
  int connectGatt2(
    bool autoConnect,
    int callbackHashCode,
    int transport,
    int phy,
  );
  int connectGatt3(
    bool autoConnect,
    int callbackHashCode,
    int transport,
    int phy,
    int handlerHashCode,
  );
}

@HostApi()
abstract class BluetoothGattHostApi {
  int getDevice();
  List<int> getConnectedDevices();
  List<int> getServices();
  bool connect();
  bool discoverServices();
  int getService(int uuidHashCode);
  bool beginReliableWrite();
  bool executeReliableWrite();
  void abortReliableWrite();
  void disconnect();
  void close();
  bool readCharacteristic(int characteristicHashCode);
  bool writeCharacteristic(int characteristicHashCode);
  bool setCharacteristicNotification(int characteristicHashCode, bool enable);
  bool readDescriptor(int descriptorHashCode);
  bool writeDescriptor(int descriptorHashCode);
  bool readRemoteRssi();
  void readPhy();
  bool requestMtu(int mtu);
  bool requestConnectionPriority(int connectionPriority);
  void setPreferredPhy(int txPhy, int rxPhy, int phyOptions);
  int getConnectionState(int deviceHashCode);
  List<int> getDevicesMatchingConnectionStates(List<int> states);
}

@HostApi()
abstract class BluetoothGattServiceHostApi {
  int getType();
  int getUuid();
  List<int> getIncludedServices();
  List<int> getCharacteristics();
  int getInstanceId();
  int getCharacteristic(int uuidHashCode);
  bool addService(int serviceHashCode);
  bool addCharacteristic(int characteristicHashCode);
}

@HostApi()
abstract class BluetoothGattCharacteristicHostApi {
  int getService();
  int getUuid();
  int getInstanceId();
  Uint8List getValue();
  bool setValue(Uint8List value);
  bool setValue1(String value);
  bool setValue2(int value, int formatType, int offset);
  bool setValue3(int mantissa, int exponent, int formatType, int offset);
  List<int> getDescriptors();
  int getDescriptor(int uuidHashCode);
  int getPermissions();
  int getProperties();
  int getWriteType();
  void setWriteType(int writeType);
  double getFloatValue(int formatType, int offset);
  int getIntValue(int formatType, int offset);
  String getStringValue(int offset);
  bool addDescriptor(int descriptorHashCode);
}

@HostApi()
abstract class BluetoothGattDescriptorHostApi {
  int getCharacteristic();
  int getUuid();
  int getPermissions();
  Uint8List getValue();
  bool setValue(Uint8List value);
}

@HostApi()
abstract class BluetoothGattCallbackHostApi {
  int newInstance();
}

@FlutterApi()
abstract class BluetoothGattCallbackFlutterApi {
  void onPhyUpdate(int gattHashCode, int txPhy, int rxPhy, int status);
  void onPhyRead(int gattHashCode, int txPhy, int rxPhy, int status);
  void onConnectionStateChange(int gattHashCode, int status, int newState);
  void onServicesDiscovered(int gattHashCode, int status);
  void onCharacteristicRead(
    int gattHashCode,
    int characteristicHashCode,
    int status,
  );
  void onCharacteristicWrite(
    int gattHashCode,
    int characteristicHashCode,
    int status,
  );
  void onCharacteristicChanged(int gattHashCode, int characteristicHashCode);
  void onDescriptorRead(int gattHashCode, int descriptorHashCode, int status);
  void onDescriptorWrite(int gattHashCode, int descriptorHashCode, int status);
  void onReliableWriteCompleted(int gattHashCode, int status);
  void onReadRemoteRssi(int gattHashCode, int rssi, int status);
  void onMtuChanged(int gattHashCode, int mtu, int status);
  void onConnectionUpdated(
    int gattHashCode,
    int interval,
    int latency,
    int timeout,
    int status,
  );
  void onServiceChanged(int gattHashCode);
}
