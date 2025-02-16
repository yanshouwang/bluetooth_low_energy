import 'package:pigeon/pigeon.dart';

/// High level manager used to obtain an instance of an BluetoothAdapter and to
/// conduct overall Bluetooth Management.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothManager',
    minAndroidApi: 18,
  ),
)
abstract class BluetoothManager {
  /// Get the BluetoothAdapter for this device.
  BluetoothAdapter getAdapter();

  /// Get connected devices for the specified profile.
  ///
  /// Return the set of devices which are in state BluetoothProfile.STATE_CONNECTED
  ///
  /// This is not specific to any application configuration but represents the
  /// connection state of Bluetooth for this profile. This can be used by applications
  /// like status bar which would just like to know the state of Bluetooth.
  List<BluetoothDevice> getConnectedDevices(int profile);

  /// Get the current connection state of the profile to the remote device.
  ///
  /// This is not specific to any application configuration but represents the
  /// connection state of the local Bluetooth adapter for certain profile. This
  /// can be used by applications like status bar which would just like to know
  /// the state of Bluetooth.
  int getConnectionState(BluetoothDevice device, int profile);

  /// Get a list of devices that match any of the given connection states.
  ///
  /// If none of the devices match any of the given states, an empty list will be
  /// returned.
  ///
  /// This is not specific to any application configuration but represents the
  /// connection state of the local Bluetooth adapter for this profile. This can
  /// be used by applications like status bar which would just like to know the
  /// state of the local adapter.
  List<BluetoothDevice> getDevicesMatchingConnectionStates(
      int profile, List<int> states);

  /// Open a GATT Server The callback is used to deliver results to Caller, such
  /// as connection status as well as the results of any other GATT server
  /// operations. The method returns a BluetoothGattServer instance. You can use
  /// BluetoothGattServer to conduct GATT server operations.
  BluetoothGattServer openGattServer(BluetoothGattServerCallback callback);
}

/// Represents the local device Bluetooth adapter. The BluetoothAdapter lets you
/// perform fundamental Bluetooth tasks, such as initiate device discovery, query
/// a list of bonded (paired) devices, instantiate a BluetoothDevice using a known
/// MAC address, and create a BluetoothServerSocket to listen for connection
/// requests from other devices, and start a scan for Bluetooth LE devices.
///
/// To get a BluetoothAdapter representing the local Bluetooth adapter, call the
/// android.bluetooth.BluetoothManager#getAdapter function on BluetoothManager.
/// On JELLY_BEAN_MR1 and below you will need to use the static getDefaultAdapter
/// method instead.
///
/// Fundamentally, this is your starting point for all Bluetooth actions. Once
/// you have the local adapter, you can get a set of BluetoothDevice objects
/// representing all paired devices with getBondedDevices(); start device discovery
/// with startDiscovery(); or create a BluetoothServerSocket to listen for incoming
/// RFComm connection requests with listenUsingRfcommWithServiceRecord(java.lang.String,java.util.UUID);
/// listen for incoming L2CAP Connection-oriented Channels (CoC) connection requests
/// with listenUsingL2capChannel(); or start a scan for Bluetooth LE devices with
/// BluetoothLeScanner.startScan(ScanCallback) using the scanner from
/// getBluetoothLeScanner().
///
/// This class is thread safe.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothAdapter',
    minAndroidApi: 5,
  ),
)
abstract class BluetoothAdapter {
  /// Cancel the current device discovery process.
  ///
  /// Because discovery is a heavyweight procedure for the Bluetooth adapter, this
  /// method should always be called before attempting to connect to a remote
  /// device with android.bluetooth.BluetoothSocket#connect(). Discovery is not
  /// managed by the Activity, but is run as a system service, so an application
  /// should always call cancel discovery even if it did not directly request a
  /// discovery, just to be sure.
  ///
  /// If Bluetooth state is not STATE_ON, this API will return false. After turning
  /// on Bluetooth, wait for ACTION_STATE_CHANGED with STATE_ON to get the updated
  /// value.
  bool cancelDiscovery();

  /// Validate a String Bluetooth address, such as "00:43:A8:23:10:F0"
  ///
  /// Alphabetic characters must be uppercase to be valid.
  @static
  bool checkBluetoothAddress(String address);

  /// Close the connection of the profile proxy to the Service.
  ///
  /// Clients should call this when they are no longer using the proxy obtained
  /// from getProfileProxy. Profile can be one of BluetoothProfile.HEADSET or
  /// android.bluetooth.BluetoothProfile#A2DP
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 11,
    ),
  )
  void closeProfileProxy(int unusedProfile, BluetoothProfile proxy);

  /// Turn off the local Bluetooth adapter—do not use without explicit user action
  /// to turn off Bluetooth.
  ///
  /// This gracefully shuts down all Bluetooth connections, stops Bluetooth system
  /// services, and powers down the underlying Bluetooth hardware.
  ///
  /// Bluetooth should never be disabled without direct user consent. The disable()
  /// method is provided only for applications that include a user interface for
  /// changing system settings, such as a "power manager" app.
  ///
  /// This is an asynchronous call: it will return immediately, and clients should
  /// listen for ACTION_STATE_CHANGED to be notified of subsequent adapter state
  /// changes. If this call returns true, then the adapter state will immediately
  /// transition from STATE_ON to STATE_TURNING_OFF, and some time later transition
  /// to either STATE_OFF or STATE_ON. If this call returns false then there was
  /// an immediate problem that will prevent the adapter from being turned off -
  /// such as the adapter already being turned off.
  @Deprecated(
      'Starting with android.os.Build.VERSION_CODES#TIRAMISU, applications are not allowed to enable/disable Bluetooth. Compatibility Note: For applications targeting android.os.Build.VERSION_CODES#TIRAMISU or above, this API will always fail and return false. If apps are targeting an older SDK (android.os.Build.VERSION_CODES#S or below), they can continue to use this API.')
  bool disable();

  /// Turn on the local Bluetooth adapter—do not use without explicit user action
  /// to turn on Bluetooth.
  ///
  /// This powers on the underlying Bluetooth hardware, and starts all Bluetooth
  /// system services.
  ///
  /// Bluetooth should never be enabled without direct user consent. If you want
  /// to turn on Bluetooth in order to create a wireless connection, you should
  /// use the ACTION_REQUEST_ENABLE Intent, which will raise a dialog that requests
  /// user permission to turn on Bluetooth. The enable() method is provided only
  /// for applications that include a user interface for changing system settings,
  /// such as a "power manager" app.
  ///
  /// This is an asynchronous call: it will return immediately, and clients should
  /// listen for ACTION_STATE_CHANGED to be notified of subsequent adapter state
  /// changes. If this call returns true, then the adapter state will immediately
  /// transition from STATE_OFF to STATE_TURNING_ON, and some time later transition
  /// to either STATE_OFF or STATE_ON. If this call returns false then there was
  /// an immediate problem that will prevent the adapter from being turned on -
  /// such as Airplane mode, or the adapter is already turned on.
  @Deprecated(
      'Starting with android.os.Build.VERSION_CODES#TIRAMISU, applications are not allowed to enable/disable Bluetooth. Compatibility Note: For applications targeting android.os.Build.VERSION_CODES#TIRAMISU or above, this API will always fail and return false. If apps are targeting an older SDK (android.os.Build.VERSION_CODES#S or below), they can continue to use this API.')
  bool enable();

  /// Returns the hardware address of the local Bluetooth adapter.
  ///
  /// For example, "00:11:22:AA:BB:CC".
  String getAddress();

  /// Returns a BluetoothLeAdvertiser object for Bluetooth LE Advertising operations.
  /// Will return null if Bluetooth is turned off or if Bluetooth LE Advertising
  /// is not supported on this device.
  ///
  /// Use isMultipleAdvertisementSupported() to check whether LE Advertising is
  /// supported on this device before calling this method.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 21,
    ),
  )
  BluetoothLeAdvertiser getBluetoothLeAdvertiser();

  /// Returns a BluetoothLeScanner object for Bluetooth LE scan operations.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 21,
    ),
  )
  BluetoothLeScanner getBluetoothLeScanner();

  /// Return the set of BluetoothDevice objects that are bonded (paired) to the
  /// local adapter.
  ///
  /// If Bluetooth state is not STATE_ON, this API will return an empty set. After
  /// turning on Bluetooth, wait for ACTION_STATE_CHANGED with STATE_ON to get
  /// the updated value.
  List<BluetoothDevice> getBondedDevices();

  /// Get a handle to the default local Bluetooth adapter.
  ///
  /// Currently Android only supports one Bluetooth adapter, but the API could be
  /// extended to support more. This will always return the default adapter.
  @Deprecated(
      'this method will continue to work, but developers are strongly encouraged to migrate to using BluetoothManager.getAdapter(), since that approach enables support for Context.createAttributionContext.')
  @static
  BluetoothAdapter getDefaultAdapter();

  /// Get the timeout duration of the SCAN_MODE_CONNECTABLE_DISCOVERABLE.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 33,
    ),
  )
  int? getDiscoverableTimeout();

  /// Return the maximum LE advertising data length in bytes, if LE Extended
  /// Advertising feature is supported, 0 otherwise.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 26,
    ),
  )
  int getLeMaximumAdvertisingDataLength();

  /// Get the maximum number of connected devices per audio profile for this
  /// device.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 33,
    ),
  )
  int getMaxConnectedAudioDevices();

  /// Get the friendly Bluetooth name of the local Bluetooth adapter.
  ///
  /// This name is visible to remote Bluetooth devices.
  String getName();

  /// Get the current connection state of a profile. This function can be used to
  /// check whether the local Bluetooth adapter is connected to any remote device
  /// for a specific profile. Profile can be one of BluetoothProfile.HEADSET,
  /// BluetoothProfile.A2DP.
  ///
  /// Return the profile connection state
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 14,
    ),
  )
  int getProfileConnectionState(BluetoothProfile profile);

  /// Get the profile proxy object associated with the profile.
  ///
  /// The ServiceListener's methods will be invoked on the application's main
  /// looper
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 11,
    ),
  )
  bool getProfileProxy(BluetoothProfileServiceListener listener, int profile);

  /// Get a BluetoothDevice object for the given Bluetooth hardware address.
  ///
  /// Valid Bluetooth hardware addresses must be 6 bytes. This method expects the
  /// address in network byte order (MSB first).
  ///
  /// A BluetoothDevice will always be returned for a valid hardware address, even
  /// if this adapter has never seen that device.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 16,
    ),
  )
  BluetoothDevice getRemoteDevice2(Uint8List address);

  /// Get a BluetoothDevice object for the given Bluetooth hardware address.
  ///
  /// Valid Bluetooth hardware addresses must be upper case, in big endian byte
  /// order, and in a format such as "00:11:22:33:AA:BB". The helper checkBluetoothAddress
  /// is available to validate a Bluetooth address.
  ///
  /// A BluetoothDevice will always be returned for a valid hardware address, even
  /// if this adapter has never seen that device.
  BluetoothDevice getRemoteDevice1(String address);

  /// Get a BluetoothDevice object for the given Bluetooth hardware address and
  /// addressType.
  ///
  /// Valid Bluetooth hardware addresses must be upper case, in big endian byte
  /// order, and in a format such as "00:11:22:33:AA:BB". The helper checkBluetoothAddress
  /// is available to validate a Bluetooth address.
  ///
  /// A BluetoothDevice will always be returned for a valid hardware address and
  /// type, even if this adapter has never seen that device.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 33,
    ),
  )
  BluetoothDevice getRemoteLeDevice(String address, int addressType);

  /// Get the current Bluetooth scan mode of the local Bluetooth adapter.
  ///
  /// The Bluetooth scan mode determines if the local adapter is connectable
  /// and/or discoverable from remote Bluetooth devices.
  ///
  /// Possible values are: SCAN_MODE_NONE, SCAN_MODE_CONNECTABLE,
  /// SCAN_MODE_CONNECTABLE_DISCOVERABLE.
  ///
  /// If Bluetooth state is not STATE_ON, this API will return SCAN_MODE_NONE.
  /// After turning on Bluetooth, wait for ACTION_STATE_CHANGED with STATE_ON to
  /// get the updated value.
  int getScanMode();

  /// Get the current state of the local Bluetooth adapter.
  ///
  /// Possible return values are STATE_OFF, STATE_TURNING_ON, STATE_ON,
  /// STATE_TURNING_OFF.
  int getState();

  /// Return true if the local Bluetooth adapter is currently in the device
  /// discovery process.
  ///
  /// Device discovery is a heavyweight procedure. New connections to remote
  /// Bluetooth devices should not be attempted while discovery is in progress,
  /// and existing connections will experience limited bandwidth and high latency.
  /// Use cancelDiscovery() to cancel an ongoing discovery.
  ///
  /// Applications can also register for ACTION_DISCOVERY_STARTED or
  /// ACTION_DISCOVERY_FINISHED to be notified when discovery starts or completes.
  ///
  /// If Bluetooth state is not STATE_ON, this API will return false. After turning
  /// on Bluetooth, wait for ACTION_STATE_CHANGED with STATE_ON to get the updated
  /// value.
  bool isDiscovering();

  /// Return true if Bluetooth is currently enabled and ready for use.
  ///
  /// Equivalent to: getBluetoothState() == STATE_ON
  bool isEnabled();

  /// Return true if LE 2M PHY feature is supported.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 26,
    ),
  )
  bool isLe2MPhySupported();

  /// Returns BluetoothStatusCodes.FEATURE_SUPPORTED if the LE audio broadcast
  /// assistant feature is supported, BluetoothStatusCodes.FEATURE_NOT_SUPPORTED
  /// if the feature is not supported, or an error code.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 33,
    ),
  )
  int isLeAudioBroadcastAssistantSupported();

  /// Returns BluetoothStatusCodes.FEATURE_SUPPORTED if the LE audio broadcast
  /// source feature is supported, BluetoothStatusCodes.FEATURE_NOT_SUPPORTED if
  /// the feature is not supported, or an error code.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 33,
    ),
  )
  int isLeAudioBroadcastSourceSupported();

  /// Returns BluetoothStatusCodes.FEATURE_SUPPORTED if the LE audio feature is
  /// supported, BluetoothStatusCodes.FEATURE_NOT_SUPPORTED if the feature is not
  /// supported, or an error code.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 33,
    ),
  )
  int isLeAudioSupported();

  /// Return true if LE Coded PHY feature is supported.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 26,
    ),
  )
  bool isLeCodedPhySupported();

  /// Return true if LE Extended Advertising feature is supported.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 26,
    ),
  )
  bool isLeExtendedAdvertisingSupported();

  /// Return true if LE Periodic Advertising feature is supported.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 26,
    ),
  )
  bool isLePeriodicAdvertisingSupported();

  /// Return true if the multi advertisement is supported by the chipset
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 21,
    ),
  )
  bool isMultipleAdvertisementSupported();

  /// Return true if offloaded filters are supported
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 21,
    ),
  )
  bool isOffloadedFilteringSupported();

  /// Return true if offloaded scan batching is supported
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 21,
    ),
  )
  bool isOffloadedScanBatchingSupported();

  /// Create an insecure L2CAP Connection-oriented Channel (CoC) BluetoothServerSocket
  /// and assign a dynamic PSM value. This socket can be used to listen for
  /// incoming connections. The supported Bluetooth transport is LE only.
  ///
  /// The link key is not required to be authenticated, i.e. the communication
  /// may be vulnerable to person-in-the-middle attacks. Use listenUsingL2capChannel,
  /// if an encrypted and authenticated communication channel is desired.
  ///
  /// Use android.bluetooth.BluetoothServerSocket#accept to retrieve incoming
  /// connections from a listening BluetoothServerSocket.
  ///
  /// The system will assign a dynamic protocol/service multiplexer (PSM) value.
  /// This PSM value can be read from the BluetoothServerSocket.getPsm() and this
  /// value will be released when this server socket is closed, Bluetooth is turned
  /// off, or the application exits unexpectedly.
  ///
  /// The mechanism of disclosing the assigned dynamic PSM value to the initiating
  /// peer is defined and performed by the application.
  ///
  /// Use BluetoothDevice.createInsecureL2capChannel(int) to connect to this server
  /// socket from another Android device that is given the PSM value.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 29,
    ),
  )
  BluetoothServerSocket listenUsingInsecureL2capChannel();

  /// Create a listening, insecure RFCOMM Bluetooth socket with Service Record.
  ///
  /// The link key is not required to be authenticated, i.e. the communication may be vulnerable to Person In the Middle attacks. For Bluetooth 2.1 devices, the link will be encrypted, as encryption is mandatory. For legacy devices (pre Bluetooth 2.1 devices) the link will not be encrypted. Use listenUsingRfcommWithServiceRecord, if an encrypted and authenticated communication channel is desired.
  ///
  /// Use android.bluetooth.BluetoothServerSocket#accept to retrieve incoming connections from a listening BluetoothServerSocket.
  ///
  /// The system will assign an unused RFCOMM channel to listen on.
  ///
  /// The system will also register a Service Discovery Protocol (SDP) record with the local SDP server containing the specified UUID, service name, and auto-assigned channel. Remote Bluetooth devices can use the same UUID to query our SDP server and discover which channel to connect to. This SDP record will be removed when this socket is closed, or if this application closes unexpectedly.
  ///
  /// Use BluetoothDevice.createInsecureRfcommSocketToServiceRecord to connect to this socket from another device using the same UUID.
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 10,
    ),
  )
  BluetoothServerSocket listenUsingInsecureRfcommWithServiceRecord(
      String name, UUID uuid);

  /// Added in API level 29
  @ProxyApi(
    kotlinOptions: KotlinProxyApiOptions(
      minAndroidApi: 29,
    ),
  )
  BluetoothServerSocket listenUsingL2capChannel();
  BluetoothServerSocket listenUsingRfcommWithServiceRecord(
      String name, UUID uuid);
  bool setName(String name);
  bool startDiscovery();

  @Deprecated(
      'use BluetoothLeScanner.startScan(List, ScanSettings, ScanCallback) instead.')
  bool startLeScan1(LeScanCallback callback);

  @Deprecated(
      'use BluetoothLeScanner.startScan(List, ScanSettings, ScanCallback) instead.')
  bool startLeScan2(List<UUID> serviceUuids, LeScanCallback callback);

  @Deprecated('Use BluetoothLeScanner.stopScan(ScanCallback) instead.')
  void stopLeScan(LeScanCallback callback);
}

abstract class BluetoothLeAdvertiser {}

abstract class BluetoothLeScanner {}

abstract class BluetoothGattServer {}

abstract class BluetoothDevice {}

abstract class LeScanCallback {
  LeScanCallback();

  late final void Function(
      BluetoothDevice device, int rssi, Uint8List scanRecord) onLeScan;
}

abstract class BluetoothGattServerCallback {}

abstract class BluetoothProfileServiceListener {}

abstract class BluetoothProfile {
  List<BluetoothDevice> getConnectedDevices();
  int getConnectionState(BluetoothDevice device);
  List<BluetoothDevice> getDevicesMatchingConnectionStates(List<int> states);
}

abstract class UUID {}

abstract class BluetoothServerSocket {}
