import 'package:pigeon/pigeon.dart';

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
  BluetoothLeAdvertiser getBluetoothLeAdvertiser();

  /// Returns a BluetoothLeScanner object for Bluetooth LE scan operations.
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
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  int? getDiscoverableTimeout();

  /// Return the maximum LE advertising data length in bytes, if LE Extended
  /// Advertising feature is supported, 0 otherwise.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  int getLeMaximumAdvertisingDataLength();

  /// Get the maximum number of connected devices per audio profile for this
  /// device.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
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
  int getProfileConnectionState(BluetoothProfile profile);

  /// Get the profile proxy object associated with the profile.
  ///
  /// The ServiceListener's methods will be invoked on the application's main
  /// looper
  bool getProfileProxy(BluetoothProfileServiceListener listener, int profile);

  /// Get a BluetoothDevice object for the given Bluetooth hardware address.
  ///
  /// Valid Bluetooth hardware addresses must be 6 bytes. This method expects the
  /// address in network byte order (MSB first).
  ///
  /// A BluetoothDevice will always be returned for a valid hardware address, even
  /// if this adapter has never seen that device.
  BluetoothDevice getRemoteDevice1(Uint8List address);

  /// Get a BluetoothDevice object for the given Bluetooth hardware address.
  ///
  /// Valid Bluetooth hardware addresses must be upper case, in big endian byte
  /// order, and in a format such as "00:11:22:33:AA:BB". The helper checkBluetoothAddress
  /// is available to validate a Bluetooth address.
  ///
  /// A BluetoothDevice will always be returned for a valid hardware address, even
  /// if this adapter has never seen that device.
  BluetoothDevice getRemoteDevice2(String address);

  /// Get a BluetoothDevice object for the given Bluetooth hardware address and
  /// addressType.
  ///
  /// Valid Bluetooth hardware addresses must be upper case, in big endian byte
  /// order, and in a format such as "00:11:22:33:AA:BB". The helper checkBluetoothAddress
  /// is available to validate a Bluetooth address.
  ///
  /// A BluetoothDevice will always be returned for a valid hardware address and
  /// type, even if this adapter has never seen that device.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
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
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  bool isLe2MPhySupported();

  /// Returns BluetoothStatusCodes.FEATURE_SUPPORTED if the LE audio broadcast
  /// assistant feature is supported, BluetoothStatusCodes.FEATURE_NOT_SUPPORTED
  /// if the feature is not supported, or an error code.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  int isLeAudioBroadcastAssistantSupported();

  /// Returns BluetoothStatusCodes.FEATURE_SUPPORTED if the LE audio broadcast
  /// source feature is supported, BluetoothStatusCodes.FEATURE_NOT_SUPPORTED if
  /// the feature is not supported, or an error code.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  int isLeAudioBroadcastSourceSupported();

  /// Returns BluetoothStatusCodes.FEATURE_SUPPORTED if the LE audio feature is
  /// supported, BluetoothStatusCodes.FEATURE_NOT_SUPPORTED if the feature is not
  /// supported, or an error code.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  int isLeAudioSupported();

  /// Return true if LE Coded PHY feature is supported.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  bool isLeCodedPhySupported();

  /// Return true if LE Extended Advertising feature is supported.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  bool isLeExtendedAdvertisingSupported();

  /// Return true if LE Periodic Advertising feature is supported.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  bool isLePeriodicAdvertisingSupported();

  /// Return true if the multi advertisement is supported by the chipset
  bool isMultipleAdvertisementSupported();

  /// Return true if offloaded filters are supported
  bool isOffloadedFilteringSupported();

  /// Return true if offloaded scan batching is supported
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
  @KotlinProxyApiOptions(
    minAndroidApi: 29,
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
  BluetoothServerSocket listenUsingInsecureRfcommWithServiceRecord(
      String name, UUID uuid);

  /// Create a secure L2CAP Connection-oriented Channel (CoC) BluetoothServerSocket
  /// and assign a dynamic protocol/service multiplexer (PSM) value. This socket
  /// can be used to listen for incoming connections. The supported Bluetooth
  /// transport is LE only.
  ///
  /// A remote device connecting to this socket will be authenticated and
  /// communication on this socket will be encrypted.
  ///
  /// Use BluetoothServerSocket.accept to retrieve incoming connections from a
  /// listening BluetoothServerSocket.
  ///
  /// The system will assign a dynamic PSM value. This PSM value can be read from
  /// the BluetoothServerSocket.getPsm() and this value will be released when this
  /// server socket is closed, Bluetooth is turned off, or the application exits
  /// unexpectedly.
  ///
  /// The mechanism of disclosing the assigned dynamic PSM value to the initiating
  /// peer is defined and performed by the application.
  ///
  /// Use BluetoothDevice.createL2capChannel(int) to connect to this server socket
  /// from another Android device that is given the PSM value.
  @KotlinProxyApiOptions(
    minAndroidApi: 29,
  )
  BluetoothServerSocket listenUsingL2capChannel();

  /// Create a listening, secure RFCOMM Bluetooth socket with Service Record.
  ///
  /// A remote device connecting to this socket will be authenticated and
  /// communication on this socket will be encrypted.
  ///
  /// Use BluetoothServerSocket.accept to retrieve incoming connections from a
  /// listening BluetoothServerSocket.
  ///
  /// The system will assign an unused RFCOMM channel to listen on.
  ///
  /// The system will also register a Service Discovery Protocol (SDP) record with
  /// the local SDP server containing the specified UUID, service name, and
  /// auto-assigned channel. Remote Bluetooth devices can use the same UUID to
  /// query our SDP server and discover which channel to connect to. This SDP
  /// record will be removed when this socket is closed, or if this application
  /// closes unexpectedly.
  ///
  /// Use BluetoothDevice.createRfcommSocketToServiceRecord to connect to this
  /// socket from another device using the same UUID.
  BluetoothServerSocket listenUsingRfcommWithServiceRecord(
      String name, UUID uuid);

  /// Set the friendly Bluetooth name of the local Bluetooth adapter.
  ///
  /// This name is visible to remote Bluetooth devices.
  ///
  /// Valid Bluetooth names are a maximum of 248 bytes using UTF-8 encoding,
  /// although many remote devices can only display the first 40 characters, and
  /// some may be limited to just 20.
  ///
  /// If Bluetooth state is not STATE_ON, this API will return false. After turning
  /// on Bluetooth, wait for ACTION_STATE_CHANGED with STATE_ON to get the updated
  /// value.
  bool setName(String name);

  /// Start the remote device discovery process.
  ///
  /// The discovery process usually involves an inquiry scan of about 12 seconds,
  /// followed by a page scan of each new device to retrieve its Bluetooth name.
  ///
  /// This is an asynchronous call, it will return immediately. Register for
  /// ACTION_DISCOVERY_STARTED and ACTION_DISCOVERY_FINISHED intents to determine
  /// exactly when the discovery starts and completes. Register for
  /// BluetoothDevice.ACTION_FOUND to be notified as remote Bluetooth devices are
  /// found.
  ///
  /// Device discovery is a heavyweight procedure. New connections to remote
  /// Bluetooth devices should not be attempted while discovery is in progress,
  /// and existing connections will experience limited bandwidth and high latency.
  /// Use cancelDiscovery() to cancel an ongoing discovery. Discovery is not
  /// managed by the Activity, but is run as a system service, so an application
  /// should always call BluetoothAdapter.cancelDiscovery() even if it did not
  /// directly request a discovery, just to be sure.
  ///
  /// Device discovery will only find remote devices that are currently discoverable
  /// (inquiry scan enabled). Many Bluetooth devices are not discoverable by
  /// default, and need to be entered into a special mode.
  ///
  /// If Bluetooth state is not STATE_ON, this API will return false. After turning
  /// on Bluetooth, wait for ACTION_STATE_CHANGED with STATE_ON to get the updated
  /// value.
  ///
  /// If a device is currently bonding, this request will be queued and executed
  /// once that device has finished bonding. If a request is already queued, this
  /// request will be ignored.
  bool startDiscovery();

  /// Starts a scan for Bluetooth LE devices, looking for devices that advertise
  /// given services.
  ///
  /// Devices which advertise all specified services are reported using the
  /// BluetoothAdapter.LeScanCallback.onLeScan(BluetoothDevice, int, byte) callback.
  @Deprecated(
      'use BluetoothLeScanner.startScan(List, ScanSettings, ScanCallback) instead.')
  bool startLeScan1(List<UUID> serviceUuids, LeScanCallback callback);

  /// Starts a scan for Bluetooth LE devices.
  ///
  /// Results of the scan are reported using the LeScanCallback.onLeScan callback.
  @Deprecated(
      'use BluetoothLeScanner.startScan(List, ScanSettings, ScanCallback) instead.')
  bool startLeScan2(LeScanCallback callback);

  /// Stops an ongoing Bluetooth LE device scan.
  @Deprecated('Use BluetoothLeScanner.stopScan(ScanCallback) instead.')
  void stopLeScan(LeScanCallback callback);
}

/// Represents a Bluetooth class, which describes general characteristics and
/// capabilities of a device. For example, a Bluetooth class will specify the
/// general device type such as a phone, a computer, or headset, and whether it's
/// capable of services such as audio or telephony.
///
/// Every Bluetooth class is composed of zero or more service classes, and exactly
/// one device class. The device class is further broken down into major and minor
/// device class components.
///
/// BluetoothClass is useful as a hint to roughly describe a device (for example
/// to show an icon in the UI), but does not reliably describe which Bluetooth
/// profiles or services are actually supported by a device. Accurate service
/// discovery is done through SDP requests, which are automatically performed when
/// creating an RFCOMM socket with android.bluetooth.BluetoothDevice#createRfcommSocketToServiceRecord
/// and android.bluetooth.BluetoothAdapter#listenUsingRfcommWithServiceRecord
///
/// Use BluetoothDevice.getBluetoothClass to retrieve the class for a remote device.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothClass',
  ),
)
abstract class BluetoothClass {
  /// Check class bits for possible bluetooth profile support. This is a simple
  /// heuristic that tries to guess if a device with the given class bits might
  /// support specified profile. It is not accurate for all devices. It tries to
  /// err on the side of false positives.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  bool doesClassMatch(int profile);

  /// Return the (major and minor) device class component of this BluetoothClass.
  ///
  /// Values returned from this function can be compared with the public constants
  /// in BluetoothClass.Device to determine which device class is encoded in this
  /// Bluetooth class.
  int getDeviceClass();

  /// Return the major device class component of this BluetoothClass.
  ///
  /// Values returned from this function can be compared with the public constants
  /// in BluetoothClass.Device.Major to determine which major class is encoded in
  /// this Bluetooth class.
  int getMajorDeviceClass();

  /// Return true if the specified service class is supported by this BluetoothClass.
  ///
  /// Valid service classes are the public constants in BluetoothClass.Service.
  /// For example, BluetoothClass.Service.AUDIO.
  bool hasService(int service);
}

/// Represents a remote Bluetooth device. A BluetoothDevice lets you create a
/// connection with the respective device or query information about it, such as
/// the name, address, class, and bonding state.
///
/// This class is really just a thin wrapper for a Bluetooth hardware address.
/// Objects of this class are immutable. Operations on this class are performed
/// on the remote Bluetooth hardware address, using the BluetoothAdapter that was
/// used to create this BluetoothDevice.
///
/// To get a BluetoothDevice, use BluetoothAdapter.getRemoteDevice(String) to
/// create one representing a device of a known MAC address (which you can get
/// through device discovery with BluetoothAdapter) or get one from the set of
/// bonded devices returned by BluetoothAdapter.getBondedDevices(). You can then
/// open a BluetoothSocket for communication with the remote device, using
/// createRfcommSocketToServiceRecord(java.util.UUID) over Bluetooth BR/EDR or
/// using createL2capChannel(int) over Bluetooth LE.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothDevice',
  ),
)
abstract class BluetoothDevice {
  /// Connect to GATT Server hosted by this device. Caller acts as GATT client.
  /// The callback is used to deliver results to Caller, such as connection status
  /// as well as any further GATT client operations. The method returns a
  /// BluetoothGatt instance. You can use BluetoothGatt to conduct GATT client
  /// operations.
  BluetoothGatt connectGatt1(bool autoConnect, BluetoothGattCallback callback);

  /// Connect to GATT Server hosted by this device. Caller acts as GATT client.
  /// The callback is used to deliver results to Caller, such as connection status
  /// as well as any further GATT client operations. The method returns a
  /// BluetoothGatt instance. You can use BluetoothGatt to conduct GATT client
  /// operations.
  @KotlinProxyApiOptions(
    minAndroidApi: 23,
  )
  BluetoothGatt connectGatt2(
      bool autoConnect, BluetoothGattCallback callback, int transport);

  /// Connect to GATT Server hosted by this device. Caller acts as GATT client.
  /// The callback is used to deliver results to Caller, such as connection status
  /// as well as any further GATT client operations. The method returns a
  /// BluetoothGatt instance. You can use BluetoothGatt to conduct GATT client
  /// operations.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  BluetoothGatt connectGatt3(
      bool autoConnect, BluetoothGattCallback callback, int transport, int phy);

  /// Start the bonding (pairing) process with the remote device.
  ///
  /// This is an asynchronous call, it will return immediately. Register for
  /// ACTION_BOND_STATE_CHANGED intents to be notified when the bonding process
  /// completes, and its result.
  ///
  /// Android system services will handle the necessary user interactions to
  /// confirm and complete the bonding process.
  bool createBond();

  /// Create a Bluetooth L2CAP Connection-oriented Channel (CoC) BluetoothSocket
  /// that can be used to start a secure outgoing connection to the remote device
  /// with the same dynamic protocol/service multiplexer (PSM) value. The supported
  /// Bluetooth transport is LE only.
  ///
  /// This is designed to be used with android.bluetooth.BluetoothAdapter#listenUsingInsecureL2capChannel()
  /// for peer-peer Bluetooth applications.
  ///
  /// Use BluetoothSocket.connect to initiate the outgoing connection.
  ///
  /// Application using this API is responsible for obtaining PSM value from remote
  /// device.
  ///
  /// The communication channel may not have an authenticated link key, i.e. it
  /// may be subject to person-in-the-middle attacks. Use createL2capChannel(int)
  /// if an encrypted and authenticated communication channel is possible.
  @KotlinProxyApiOptions(
    minAndroidApi: 29,
  )
  BluetoothSocket createInsecureL2capChannel(int psm);

  /// Create an RFCOMM BluetoothSocket socket ready to start an insecure outgoing
  /// connection to this remote device using SDP lookup of uuid.
  ///
  /// The communication channel will not have an authenticated link key i.e. it
  /// will be subject to person-in-the-middle attacks. For Bluetooth 2.1 devices,
  /// the link key will be encrypted, as encryption is mandatory. For legacy
  /// devices (pre Bluetooth 2.1 devices) the link key will be not be encrypted.
  /// Use createRfcommSocketToServiceRecord if an encrypted and authenticated
  /// communication channel is desired.
  ///
  /// This is designed to be used with android.bluetooth.BluetoothAdapter#listenUsingInsecureRfcommWithServiceRecord
  /// for peer-peer Bluetooth applications.
  ///
  /// Use BluetoothSocket.connect to initiate the outgoing connection. This will
  /// also perform an SDP lookup of the given uuid to determine which channel to
  /// connect to.
  ///
  /// The remote device will be authenticated and communication on this socket
  /// will be encrypted.
  ///
  /// Hint: If you are connecting to a Bluetooth serial board then try using the
  /// well-known SPP UUID 00001101-0000-1000-8000-00805F9B34FB. However if you
  /// are connecting to an Android peer then please generate your own unique UUID.
  BluetoothSocket createInsecureRfcommSocketToServiceRecord(UUID uuid);

  /// Create a Bluetooth L2CAP Connection-oriented Channel (CoC) BluetoothSocket
  /// that can be used to start a secure outgoing connection to the remote device
  /// with the same dynamic protocol/service multiplexer (PSM) value. The supported
  /// Bluetooth transport is LE only.
  ///
  /// This is designed to be used with BluetoothAdapter.listenUsingL2capChannel()
  /// for peer-peer Bluetooth applications.
  ///
  /// Use BluetoothSocket.connect to initiate the outgoing connection.
  ///
  /// Application using this API is responsible for obtaining PSM value from remote
  /// device.
  ///
  /// The remote device will be authenticated and communication on this socket
  /// will be encrypted.
  ///
  /// Use this socket if an authenticated socket link is possible. Authentication
  /// refers to the authentication of the link key to prevent person-in-the-middle
  /// type of attacks.
  @KotlinProxyApiOptions(
    minAndroidApi: 29,
  )
  BluetoothSocket createL2capChannel(int psm);

  /// Create an RFCOMM BluetoothSocket ready to start a secure outgoing connection
  /// to this remote device using SDP lookup of uuid.
  ///
  /// This is designed to be used with android.bluetooth.BluetoothAdapter#listenUsingRfcommWithServiceRecord
  /// for peer-peer Bluetooth applications.
  ///
  /// Use BluetoothSocket.connect to initiate the outgoing connection. This will
  /// also perform an SDP lookup of the given uuid to determine which channel to
  /// connect to.
  ///
  /// The remote device will be authenticated and communication on this socket
  /// will be encrypted.
  ///
  /// Use this socket only if an authenticated socket link is possible. Authentication
  /// refers to the authentication of the link key to prevent person-in-the-middle
  /// type of attacks. For example, for Bluetooth 2.1 devices, if any of the
  /// devices does not have an input and output capability or just has the ability
  /// to display a numeric key, a secure socket connection is not possible. In
  /// such a case, use createInsecureRfcommSocketToServiceRecord. For more details,
  /// refer to the Security Model section 5.2 (vol 3) of Bluetooth Core Specification
  /// version 2.1 + EDR.
  ///
  /// Hint: If you are connecting to a Bluetooth serial board then try using the
  /// well-known SPP UUID 00001101-0000-1000-8000-00805F9B34FB. However if you
  /// are connecting to an Android peer then please generate your own unique UUID.
  BluetoothSocket createRfcommSocketToServiceRecord(UUID uuid);

  /// Perform a service discovery on the remote device to get the UUIDs supported.
  ///
  /// This API is asynchronous and ACTION_UUID intent is sent, with the UUIDs
  /// supported by the remote end. If there is an error in getting the SDP records
  /// or if the process takes a long time, or the device is bonding and we have
  /// its UUIDs cached, ACTION_UUID intent is sent with the UUIDs that is currently
  /// present in the cache. Clients should use the getUuids to get UUIDs if service
  /// discovery is not to be performed. If there is an ongoing bonding process,
  /// service discovery or device inquiry, the request will be queued.
  bool fetchUuidsWithSdp();

  /// Returns the address type of this BluetoothDevice, one of ADDRESS_TYPE_PUBLIC,
  /// ADDRESS_TYPE_RANDOM, ADDRESS_TYPE_ANONYMOUS, or ADDRESS_TYPE_UNKNOWN.
  @KotlinProxyApiOptions(
    minAndroidApi: 35,
  )
  int getAddressType();

  /// Get the locally modifiable name (alias) of the remote Bluetooth device.
  @KotlinProxyApiOptions(
    minAndroidApi: 30,
  )
  String? getAlias();

  /// Get the Bluetooth class of the remote device.
  BluetoothClass getBluetoothClass();

  /// Get the bond state of the remote device.
  ///
  /// Possible values for the bond state are: BOND_NONE, BOND_BONDING, BOND_BONDED.
  int getBondState();

  /// Get the friendly Bluetooth name of the remote device.
  ///
  /// The local adapter will automatically retrieve remote names when performing
  /// a device scan, and will cache them. This method just returns the name for
  /// this device from the cache.
  String getName();

  /// Get the Bluetooth device type of the remote device.
  int getType();

  /// Returns the supported features (UUIDs) of the remote device.
  ///
  /// This method does not start a service discovery procedure to retrieve the
  /// UUIDs from the remote device. Instead, the local cached copy of the service
  /// UUIDs are returned.
  ///
  /// Use fetchUuidsWithSdp if fresh UUIDs are desired.
  List<ParcelUuid> getUuids();

  /// Sets the locally modifiable name (alias) of the remote Bluetooth device.
  /// This method overwrites the previously stored alias. The new alias is saved
  /// in local storage so that the change is preserved over power cycles.
  ///
  /// This method requires the calling app to have the android.Manifest.permission#BLUETOOTH_CONNECT permission. Additionally, an app must either have the android.Manifest.permission#BLUETOOTH_PRIVILEGED or be associated with the Companion Device manager (see android.companion.CompanionDeviceManager#associate( * AssociationRequest, android.companion.CompanionDeviceManager.Callback, Handler))
  @KotlinProxyApiOptions(
    minAndroidApi: 31,
  )
  int setAlias(String? alias);

  /// Confirm passkey for PAIRING_VARIANT_PASSKEY_CONFIRMATION pairing.
  ///
  /// Requires android.Manifest.permission#BLUETOOTH_CONNECT and
  /// android.Manifest.permission#BLUETOOTH_PRIVILEGED
  bool setPairingConfirmation(bool confirm);

  /// Set the pin during pairing when the pairing method is PAIRING_VARIANT_PIN
  bool setPin(Uint8List pin);
}

/// Public API for the Bluetooth GATT Profile.
///
/// This class provides Bluetooth GATT functionality to enable communication with
/// Bluetooth Smart or Smart Ready devices.
///
/// To connect to a remote peripheral device, create a BluetoothGattCallback and
/// call android.bluetooth.BluetoothDevice#connectGatt to get a instance of this
/// class. GATT capable devices can be discovered using the Bluetooth device
/// discovery or BLE scan process.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothGatt',
  ),
)
abstract class BluetoothGatt {
  /// Cancels a reliable write transaction for a given device.
  ///
  /// Calling this function will discard all queued characteristic write operations
  /// for a given remote device.
  void abortReliableWrite();

  /// Initiates a reliable write transaction for a given remote device.
  ///
  /// Once a reliable write transaction has been initiated, all calls to
  /// #writeCharacteristic are sent to the remote device for verification and
  /// queued up for atomic execution. The application will receive a
  /// BluetoothGattCallback.onCharacteristicWrite callback in response to every
  /// writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)
  /// call and is responsible for verifying if the value has been transmitted
  /// accurately.
  ///
  /// After all characteristics have been queued up and verified, executeReliableWrite
  /// will execute all writes. If a characteristic was not written correctly,
  /// calling #abortReliableWrite will cancel the current transaction without
  /// committing any values on the remote device.
  bool beginReliableWrite();

  /// Close this Bluetooth GATT client.
  ///
  /// Application should call this method as early as possible after it is done with this GATT client.
  void close();

  /// Connect back to remote device.
  ///
  /// This method is used to re-connect to a remote device after the connection
  /// has been dropped. If the device is not in range, the re-connection will be
  /// triggered once the device is back in range.
  bool connect();

  /// Disconnects an established connection, or cancels a connection attempt
  /// currently in progress.
  void disconnect();

  /// Discovers services offered by a remote device as well as their characteristics
  /// and descriptors.
  ///
  /// This is an asynchronous operation. Once service discovery is completed, the
  /// android.bluetooth.BluetoothGattCallback#onServicesDiscovered callback is
  /// triggered. If the discovery was successful, the remote services can be
  /// retrieved using the getServices function.
  bool discoverServices();

  /// Executes a reliable write transaction for a given remote device.
  ///
  /// This function will commit all queued up characteristic write operations for
  /// a given remote device.
  ///
  /// A BluetoothGattCallback.onReliableWriteCompleted callback is invoked to
  /// indicate whether the transaction has been executed correctly.
  bool executeReliableWrite();

  /// Return the remote bluetooth device this GATT client targets to
  BluetoothDevice getDevice();

  /// Returns a BluetoothGattService, if the requested UUID is supported by the
  /// remote device.
  ///
  /// This function requires that service discovery has been completed for the
  /// given device.
  ///
  /// If multiple instances of the same service (as identified by UUID) exist,
  /// the first instance of the service is returned.
  BluetoothGattService getService(UUID uuid);

  /// Returns a list of GATT services offered by the remote device.
  ///
  /// This function requires that service discovery has been completed for the
  /// given device.
  List<BluetoothGattService> getServices();

  /// Reads the requested characteristic from the associated remote device.
  ///
  /// This is an asynchronous operation. The result of the read operation is
  /// reported by the BluetoothGattCallback.onCharacteristicRead(BluetoothGatt,
  /// BluetoothGattCharacteristic, callback.
  bool readCharacteristic(BluetoothGattCharacteristic characteristic);

  /// Reads the value for a given descriptor from the associated remote device.
  ///
  /// Once the read operation has been completed, the
  /// android.bluetooth.BluetoothGattCallback#onDescriptorRead callback is triggered,
  /// signaling the result of the operation.
  bool readDescriptor(BluetoothGattDescriptor descriptor);

  /// Read the current transmitter PHY and receiver PHY of the connection. The
  /// values are returned in BluetoothGattCallback.onPhyRead
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void readPhy();

  /// Read the RSSI for a connected remote device.
  ///
  /// The BluetoothGattCallback.onReadRemoteRssi callback will be invoked when
  /// the RSSI value has been read.
  bool readRemoteRssi();

  /// Request a connection parameter update.
  ///
  /// This function will send a connection parameter update request to the remote
  /// device.
  bool requestConnectionPriority(int connectionPriority);

  /// Request an MTU size used for a given connection. Please note that starting
  /// from Android 14, the Android Bluetooth stack requests the BLE ATT MTU to
  /// 517 bytes when the first GATT client requests an MTU, and disregards all
  /// subsequent MTU requests. Check out MTU is set to 517 for the first GATT
  /// client requesting an MTU for more information.
  ///
  /// When performing a write request operation (write without response), the data
  /// sent is truncated to the MTU size. This function may be used to request a
  /// larger MTU size to be able to send more data at once.
  ///
  /// A BluetoothGattCallback.onMtuChanged callback will indicate whether this
  /// operation was successful.
  bool requestMtu(int mtu);

  /// Enable or disable notifications/indications for a given characteristic.
  ///
  /// Once notifications are enabled for a characteristic, a
  /// android.bluetooth.BluetoothGattCallback#onCharacteristicChanged(android.bluetooth.BluetoothGatt,android.bluetooth.BluetoothGattCharacteristic,byte[])
  /// callback will be triggered if the remote device indicates that the given
  /// characteristic has changed.
  bool setCharacteristicNotification(
      BluetoothGattCharacteristic characteristic, bool enable);

  /// Set the preferred connection PHY for this app. Please note that this is just
  /// a recommendation, whether the PHY change will happen depends on other
  /// applications preferences, local and remote controller capabilities. Controller
  /// can override these settings.
  ///
  /// BluetoothGattCallback.onPhyUpdate will be triggered as a result of this
  /// call, even if no PHY change happens. It is also triggered when remote device
  /// updates the PHY.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void setPreferredPhy(int txPhy, int rxPhy, int phyOptions);

  /// Writes a given characteristic and its values to the associated remote device.
  ///
  /// Once the write operation has been completed, the
  /// android.bluetooth.BluetoothGattCallback#onCharacteristicWrite callback is
  /// invoked, reporting the result of the operation.
  @Deprecated(
      'Use BluetoothGatt.writeCharacteristic(BluetoothGattCharacteristic, byte[], as this is not memory safe because it relies on a BluetoothGattCharacteristic object whose underlying fields are subject to change outside this method.')
  bool writeCharacteristic1(BluetoothGattCharacteristic characteristic);

  /// Writes a given characteristic and its values to the associated remote device.
  ///
  /// Once the write operation has been completed, the
  /// android.bluetooth.BluetoothGattCallback#onCharacteristicWrite callback is
  /// invoked, reporting the result of the operation.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  int writeCharacteristic2(BluetoothGattCharacteristic characteristic,
      Uint8List value, int writeType);

  /// Write the value of a given descriptor to the associated remote device.
  ///
  /// A BluetoothGattCallback.onDescriptorWrite callback is triggered to report
  /// the result of the write operation.
  @Deprecated(
      ' Use BluetoothGatt.writeDescriptor(BluetoothGattDescriptor, byte[]) as this is not memory safe because it relies on a BluetoothGattDescriptor object whose underlying fields are subject to change outside this method.')
  bool writeDescriptor1(BluetoothGattDescriptor descriptor);

  /// Write the value of a given descriptor to the associated remote device.
  ///
  /// A BluetoothGattCallback.onDescriptorWrite callback is triggered to report
  /// the result of the write operation.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  int writeDescriptor2(BluetoothGattDescriptor descriptor, Uint8List value);
}

/// This abstract class is used to implement BluetoothGatt callbacks.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothGattCallback',
  ),
)
abstract class BluetoothGattCallback {
  /// Callback triggered as a result of a remote characteristic notification.
  @Deprecated(
      'Use BluetoothGattCallback.onCharacteristicChanged(BluetoothGatt, as it is memory safe by providing the characteristic value at the time of notification.')
  void onCharacteristicChanged1(
      BluetoothGatt gatt, BluetoothGattCharacteristic characteristic);

  /// Callback triggered as a result of a remote characteristic notification. Note
  /// that the value within the characteristic object may have changed since
  /// receiving the remote characteristic notification, so check the parameter
  /// value for the value at the time of notification.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  void onCharacteristicChanged2(BluetoothGatt gatt,
      BluetoothGattCharacteristic characteristic, Uint8List value);

  /// Callback reporting the result of a characteristic read operation.
  @Deprecated(
      'Use BluetoothGattCallback.onCharacteristicRead(BluetoothGatt, as it is memory safe')
  void onCharacteristicRead1(BluetoothGatt gatt,
      BluetoothGattCharacteristic characteristic, int status);

  /// Callback reporting the result of a characteristic read operation.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  void onCharacteristicRead2(BluetoothGatt gatt,
      BluetoothGattCharacteristic characteristic, Uint8List value, int status);

  /// Callback indicating the result of a characteristic write operation.
  ///
  /// If this callback is invoked while a reliable write transaction is in progress,
  /// the value of the characteristic represents the value reported by the remote
  /// device. An application should compare this value to the desired value to be
  /// written. If the values don't match, the application must abort the reliable
  /// write transaction.
  void onCharacteristicWrite(BluetoothGatt gatt,
      BluetoothGattCharacteristic characteristic, int status);

  /// Callback indicating when GATT client has connected/disconnected to/from a
  /// remote GATT server.
  void onConnectionStateChange(BluetoothGatt gatt, int status, int newState);

  /// Callback triggered as a result of a remote descriptor read operation.
  @Deprecated(
      'Use BluetoothGattCallback.onDescriptorRead(BluetoothGatt, as it is memory safe by providing the descriptor value at the time it was read.')
  void onDescriptorRead1(
      BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status);

  /// Callback reporting the result of a descriptor read operation.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  void onDescriptorRead2(BluetoothGatt gatt, BluetoothGattDescriptor descriptor,
      int status, Uint8List value);

  /// Callback triggered as a result of a remote descriptor write operation.
  void onDescriptorWrite(
      BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status);

  /// Callback indicating the MTU for a given device connection has changed.
  ///
  /// This callback is triggered in response to the BluetoothGatt.requestMtu
  /// function, or in response to a connection event.
  void onMtuChanged(BluetoothGatt gatt, int mtu, int status);

  /// Callback triggered as result of BluetoothGatt.readPhy
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void onPhyRead(BluetoothGatt gatt, int txPhy, int rxPhy, int status);

  /// Callback triggered as result of BluetoothGatt.setPreferredPhy, or as a result
  /// of remote device changing the PHY.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void onPhyUpdate(BluetoothGatt gatt, int txPhy, int rxPhy, int status);

  /// Callback reporting the RSSI for a remote device connection.
  ///
  /// This callback is triggered in response to the BluetoothGatt.readRemoteRssi
  /// function.
  void onReadRemoteRssi(BluetoothGatt gatt, int rssi, int status);

  /// Callback invoked when a reliable write transaction has been completed.
  void onReliableWriteCompleted(BluetoothGatt gatt, int status);

  /// Callback indicating service changed event is received
  ///
  /// Receiving this event means that the GATT database is out of sync with the
  /// remote device. BluetoothGatt.discoverServices should be called to re-discover
  /// the services.
  @KotlinProxyApiOptions(
    minAndroidApi: 31,
  )
  void onServiceChanged(BluetoothGatt gatt);

  /// Callback invoked when the list of remote services, characteristics and
  /// descriptors for the remote device have been updated, ie new services have
  /// been discovered.
  void onServicesDiscovered(BluetoothGatt gatt, int status);
}

/// Represents a Bluetooth GATT Characteristic
///
/// A GATT characteristic is a basic data element used to construct a GATT service,
/// BluetoothGattService. The characteristic contains a value as well as additional
/// information and optional GATT descriptors, BluetoothGattDescriptor.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothGattCharacteristic',
  ),
)
abstract class BluetoothGattCharacteristic {
  /// Create a new BluetoothGattCharacteristic.
  BluetoothGattCharacteristic(
    UUID uuid,
    int properties,
    int permissions,
  );

  /// Adds a descriptor to this characteristic.
  bool addDescriptor(BluetoothGattDescriptor descriptor);

  /// Returns a descriptor with a given UUID out of the list of descriptors for
  /// this characteristic.
  BluetoothGattDescriptor? getDescriptor(UUID uuid);

  /// Returns a list of descriptors for this characteristic.
  List<BluetoothGattDescriptor> getDescriptors();

  /// Return the stored value of this characteristic.
  ///
  /// See getValue for details.
  @Deprecated(
      'Use BluetoothGatt.readCharacteristic(BluetoothGattCharacteristic) to get the characteristic value')
  double getFloatValue(int formatType, int offset);

  /// Returns the instance ID for this characteristic.
  ///
  /// If a remote device offers multiple characteristics with the same UUID, the
  /// instance ID is used to distuinguish between characteristics.
  int getInstanceId();

  /// Return the stored value of this characteristic.
  ///
  /// The formatType parameter determines how the characteristic value is to be
  /// interpreted. For example, setting formatType to FORMAT_UINT16 specifies that
  /// the first two bytes of the characteristic value at the given offset are
  /// interpreted to generate the return value.
  @Deprecated(
      'Use BluetoothGatt.readCharacteristic(BluetoothGattCharacteristic) to get the characteristic value')
  int getIntValue(int formatType, int offset);

  /// Returns the permissions for this characteristic.
  int getPermissions();

  /// Returns the properties of this characteristic.
  ///
  /// The properties contain a bit mask of property flags indicating the features
  /// of this characteristic.
  int getProperties();

  /// Returns the service this characteristic belongs to.
  BluetoothGattService getService();

  /// Return the stored value of this characteristic.
  @Deprecated(
      'Use BluetoothGatt.readCharacteristic(BluetoothGattCharacteristic) to get the characteristic value')
  String getStringValue(int offset);

  /// Returns the UUID of this characteristic
  UUID getUuid();

  /// Get the stored value for this characteristic.
  ///
  /// This function returns the stored value for this characteristic as retrieved
  /// by calling BluetoothGatt.readCharacteristic. The cached value of the
  /// characteristic is updated as a result of a read characteristic operation or
  /// if a characteristic update notification has been received.
  @Deprecated(
      ' Use BluetoothGatt.readCharacteristic(BluetoothGattCharacteristic) instead')
  Uint8List getValue();

  /// Gets the write type for this characteristic.
  int getWriteType();

  /// Updates the locally stored value of this characteristic.
  ///
  /// This function modifies the locally stored cached value of this characteristic.
  /// To send the value to the remote device, call android.bluetooth.BluetoothGatt#writeCharacteristic
  /// to send the value to the remote device.
  @Deprecated(
      'Pass the characteristic value directly into android.bluetooth.BluetoothGatt#writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)')
  bool setValue1(Uint8List value);

  /// Set the locally stored value of this characteristic.
  ///
  /// See setValue(byte[]) for details.
  @Deprecated(
      'Pass the characteristic value directly into android.bluetooth.BluetoothGatt#writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)')
  bool setValue2(Uint8List value, int formatType, int offset);

  /// Set the locally stored value of this characteristic.
  ///
  /// See setValue(byte[]) for details.
  @Deprecated(
      ' Pass the characteristic value directly into android.bluetooth.BluetoothGatt#writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)')
  bool setValue3(int mantissa, int exponent, int formatType, int offset);

  /// Set the locally stored value of this characteristic.
  ///
  /// See setValue(byte[]) for details.
  @Deprecated(
      'Pass the characteristic value directly into android.bluetooth.BluetoothGatt#writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)')
  bool setValue4(String value);

  /// Set the write type for this characteristic
  ///
  /// Setting the write type of a characteristic determines how the
  /// android.bluetooth.BluetoothGatt#writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)
  /// function write this characteristic.
  void setWriteType(int writeType);
}

/// Represents a Bluetooth GATT Descriptor
///
/// GATT Descriptors contain additional information and attributes of a GATT
/// characteristic, BluetoothGattCharacteristic. They can be used to describe the
/// characteristic's features or to control certain behaviours of the characteristic.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothGattDescriptor',
  ),
)
abstract class BluetoothGattDescriptor {
  /// Create a new BluetoothGattDescriptor.
  BluetoothGattDescriptor(
    UUID uuid,
    int permissions,
  );

  /// Returns the characteristic this descriptor belongs to.
  BluetoothGattCharacteristic getCharacteristic();

  /// Returns the permissions for this descriptor.
  int getPermissions();

  /// Returns the UUID of this descriptor.
  UUID getUuid();

  /// Returns the stored value for this descriptor
  ///
  /// This function returns the stored value for this descriptor as retrieved by
  /// calling android.bluetooth.BluetoothGatt#readDescriptor. The cached value of
  /// the descriptor is updated as a result of a descriptor read operation.
  @Deprecated(
      'Use BluetoothGatt.readDescriptor(BluetoothGattDescriptor) instead')
  Uint8List getValue();

  /// Updates the locally stored value of this descriptor.
  ///
  /// This function modifies the locally stored cached value of this descriptor.
  /// To send the value to the remote device, call android.bluetooth.BluetoothGatt#writeDescriptor
  /// to send the value to the remote device.
  @Deprecated(
      'Pass the descriptor value directly into android.bluetooth.BluetoothGatt#writeDescriptor(android.bluetooth.BluetoothGattDescriptor,byte[])')
  bool setValue(Uint8List value);

  @static
  Uint8List get disableNotificationValue;
  @static
  Uint8List get enableIndicationValue;
  @static
  Uint8List get enableNotificationValue;
}

/// Public API for the Bluetooth GATT Profile server role.
///
/// This class provides Bluetooth GATT server role functionality, allowing
/// applications to create Bluetooth Smart services and characteristics.
///
/// BluetoothGattServer is a proxy object for controlling the Bluetooth Service
/// via IPC. Use BluetoothManager.openGattServer to get an instance of this class.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothGattServer',
  ),
)
abstract class BluetoothGattServer {
  /// Add a service to the list of services to be hosted.
  ///
  /// Once a service has been added to the list, the service and its included
  /// characteristics will be provided by the local device.
  ///
  /// If the local device has already exposed services when this function is
  /// called, a service update notification will be sent to all clients.
  ///
  /// The BluetoothGattServerCallback.onServiceAdded callback will indicate whether
  /// this service has been added successfully. Do not add another service before
  /// this callback.
  bool addService(BluetoothGattService service);

  /// Disconnects an established connection, or cancels a connection attempt
  /// currently in progress.
  void cancelConnection(BluetoothDevice device);

  /// Remove all services from the list of provided services.
  void clearServices();

  /// Close this GATT server instance.
  void close();

  /// Initiate a connection to a Bluetooth GATT capable device.
  ///
  /// The connection may not be established right away, but will be completed when
  /// the remote device is available. A BluetoothGattServerCallback.onConnectionStateChange
  /// callback will be invoked when the connection state changes as a result of
  /// this function.
  ///
  /// The autoConnect parameter determines whether to actively connect to the
  /// remote device, or rather passively scan and finalize the connection when
  /// the remote device is in range/available. Generally, the first ever connection
  /// to a device should be direct (autoConnect set to false) and subsequent
  /// connections to known devices should be invoked with the autoConnect parameter
  /// set to true.
  bool connect(BluetoothDevice device, bool autoConnect);

  /// Not supported - please use BluetoothManager.getConnectedDevices(int) with
  /// android.bluetooth.BluetoothProfile#GATT as argument
  List<BluetoothDevice> getConnectedDevices();

  /// Not supported - please use BluetoothManager.getConnectedDevices(int) with
  /// android.bluetooth.BluetoothProfile#GATT as argument
  int getConnectionState(BluetoothDevice device);

  /// Not supported - please use BluetoothManager.getDevicesMatchingConnectionStates(int,
  /// with BluetoothProfile.GATT as first argument
  List<BluetoothDevice> getDevicesMatchingConnectionStates(List<int> states);

  /// Returns a BluetoothGattService from the list of services offered by this
  /// device.
  ///
  /// If multiple instances of the same service (as identified by UUID) exist,
  /// the first instance of the service is returned.
  BluetoothGattService getService(UUID uuid);

  /// Returns a list of GATT services offered by this device.
  ///
  /// An application must call addService to add a service to the list of services
  /// offered by this device.
  List<BluetoothGattService> getServices();

  /// Send a notification or indication that a local characteristic has been
  /// updated.
  ///
  /// A notification or indication is sent to the remote device to signal that
  /// the characteristic has been updated. This function should be invoked for
  /// every client that requests notifications/indications by writing to the
  /// "Client Configuration" descriptor for the given characteristic.
  @Deprecated(
      'Use BluetoothGattServer.notifyCharacteristicChanged(BluetoothDevice, as this is not memory safe.')
  bool notifyCharacteristicChanged(BluetoothDevice device,
      BluetoothGattCharacteristic characteristic, bool confirm);

  /// Send a notification or indication that a local characteristic has been
  /// updated.
  ///
  /// A notification or indication is sent to the remote device to signal that
  /// the characteristic has been updated. This function should be invoked for
  /// every client that requests notifications/indications by writing to the
  /// "Client Configuration" descriptor for the given characteristic.
  @KotlinProxyApiOptions(
    minAndroidApi: 33,
  )
  int notifyCharacteristicChanged1(
      BluetoothDevice device,
      BluetoothGattCharacteristic characteristic,
      bool confirm,
      Uint8List value);

  /// Read the current transmitter PHY and receiver PHY of the connection. The
  /// values are returned in BluetoothGattServerCallback.onPhyRead
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void readPhy(BluetoothDevice device);

  /// Removes a service from the list of services to be provided.
  bool removeService(BluetoothGattService service);

  /// Send a response to a read or write request to a remote device.
  ///
  /// This function must be invoked in when a remote read/write request is received
  /// by one of these callback methods:
  ///
  /// * BluetoothGattServerCallback.onCharacteristicReadRequest
  /// * BluetoothGattServerCallback.onCharacteristicWriteRequest
  /// * BluetoothGattServerCallback.onDescriptorReadRequest
  /// * BluetoothGattServerCallback.onDescriptorWriteRequest
  bool sendResponse(BluetoothDevice device, int requestId, int status,
      int offset, Uint8List value);

  /// Set the preferred connection PHY for this app. Please note that this is just
  /// a recommendation, whether the PHY change will happen depends on other
  /// applications preferences, local and remote controller capabilities. Controller
  /// can override these settings.
  ///
  /// BluetoothGattServerCallback.onPhyUpdate will be triggered as a result of
  /// this call, even if no PHY change happens. It is also triggered when remote
  /// device updates the PHY.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void setPreferredPhy(
      BluetoothDevice device, int txPhy, int rxPhy, int phyOptions);
}

/// This abstract class is used to implement BluetoothGattServer callbacks.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothGattServerCallback',
  ),
)
abstract class BluetoothGattServerCallback {
  /// A remote client has requested to read a local characteristic.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  void onCharacteristicReadRequest(BluetoothDevice device, int requestId,
      int offset, BluetoothGattCharacteristic characteristic);

  /// A remote client has requested to write to a local characteristic.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  void onCharacteristicWriteRequest(
      BluetoothDevice device,
      int requestId,
      BluetoothGattCharacteristic characteristic,
      bool preparedWrite,
      bool responseNeeded,
      int offset,
      Uint8List value);

  /// Callback indicating when a remote device has been connected or disconnected.
  void onConnectionStateChange(
      BluetoothDevice device, int status, int newState);

  /// A remote client has requested to read a local descriptor.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  void onDescriptorReadRequest(BluetoothDevice device, int requestId,
      int offset, BluetoothGattDescriptor descriptor);

  /// A remote client has requested to write to a local descriptor.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  void onDescriptorWriteRequest(
      BluetoothDevice device,
      int requestId,
      BluetoothGattDescriptor descriptor,
      bool preparedWrite,
      bool responseNeeded,
      int offset,
      Uint8List value);

  /// Execute all pending write operations for this device.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  void onExecuteWrite(BluetoothDevice device, int requestId, bool execute);

  /// Callback indicating the MTU for a given device connection has changed.
  ///
  /// This callback will be invoked if a remote client has requested to change
  /// the MTU for a given connection.
  @KotlinProxyApiOptions(
    minAndroidApi: 22,
  )
  void onMtuChanged(BluetoothDevice device, int mtu);

  /// Callback invoked when a notification or indication has been sent to a remote
  /// device.
  ///
  /// When multiple notifications are to be sent, an application must wait for
  /// this callback to be received before sending additional notifications.
  void onNotificationSent(BluetoothDevice device, int status);

  /// Callback triggered as result of BluetoothGattServer.readPhy
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void onPhyRead(BluetoothDevice device, int txPhy, int rxPhy, int status);

  /// Callback triggered as result of BluetoothGattServer.setPreferredPhy, or as
  /// a result of remote device changing the PHY.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void onPhyUpdate(BluetoothDevice device, int txPhy, int rxPhy, int status);

  /// Indicates whether a local service has been added successfully.
  void onServiceAdded(int status, BluetoothGattService service);
}

/// Represents a Bluetooth GATT Service
///
/// Gatt Service contains a collection of BluetoothGattCharacteristic, as well as
/// referenced services.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothGattService',
  ),
)
abstract class BluetoothGattService {
  /// Create a new BluetoothGattService.
  BluetoothGattService(UUID uuid, int serviceType);

  /// Add a characteristic to this service.
  bool addCharacteristic(BluetoothGattCharacteristic characteristic);

  /// Add an included service to this service.
  bool addService(BluetoothGattService service);

  /// Returns a characteristic with a given UUID out of the list of characteristics
  /// offered by this service.
  ///
  /// This is a convenience function to allow access to a given characteristic
  /// without enumerating over the list returned by getCharacteristics manually.
  ///
  /// If a remote service offers multiple characteristics with the same UUID, the
  /// first instance of a characteristic with the given UUID is returned.
  BluetoothGattCharacteristic? getCharacteristic(UUID uuid);

  /// Returns a list of characteristics included in this service.
  List<BluetoothGattCharacteristic> getCharacteristics();

  /// Get the list of included GATT services for this service.
  List<BluetoothGattService> getIncludedServices();

  /// Returns the instance ID for this service
  ///
  /// If a remote device offers multiple services with the same UUID (ex. multiple
  /// battery services for different batteries), the instance ID is used to
  /// distuinguish services.
  int getInstanceId();

  /// Get the type of this service (primary/secondary)
  int getType();

  /// Returns the UUID of this service
  UUID getUuid();
}

/// High level manager used to obtain an instance of an BluetoothAdapter and to
/// conduct overall Bluetooth Management.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothManager',
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

abstract class BluetoothServerSocket {}

abstract class BluetoothSocket {}

abstract class BluetoothStatusCodes {}

/// This class provides a way to perform Bluetooth LE advertise operations, such
/// as starting and stopping advertising. An advertiser can broadcast up to 31
/// bytes of advertisement data represented by AdvertiseData.
///
/// To get an instance of BluetoothLeAdvertiser, call the
/// android.bluetooth.BluetoothAdapter#getBluetoothLeAdvertiser() method.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.BluetoothLeAdvertiser',
  ),
)
abstract class BluetoothLeAdvertiser {
  /// Start Bluetooth LE Advertising. On success, the advertiseData will be
  /// broadcasted. Returns immediately, the operation status is delivered through
  /// callback.
  ///
  /// Requires the android.Manifest.permission#BLUETOOTH_PRIVILEGED permission
  /// only when settings.getOwnAddressType() is different from
  /// AdvertisingSetParameters.ADDRESS_TYPE_DEFAULT.
  ///
  /// The android.Manifest.permission#BLUETOOTH_ADVERTISE permission is always
  /// enforced.
  void startAdvertising1(AdvertiseSettings settings,
      AdvertiseData advertiseData, AdvertiseCallback callback);

  /// Start Bluetooth LE Advertising. The advertiseData will be broadcasted if
  /// the operation succeeds. The scanResponse is returned when a scanning device
  /// sends an active scan request. This method returns immediately, the operation
  /// status is delivered through callback.
  ///
  /// Requires the android.Manifest.permission#BLUETOOTH_PRIVILEGED permission
  /// only when settings.getOwnAddressType() is different from
  /// AdvertisingSetParameters.ADDRESS_TYPE_DEFAULT.
  ///
  /// The android.Manifest.permission#BLUETOOTH_ADVERTISE permission is always
  /// enforced.
  void startAdvertising2(
      AdvertiseSettings settings,
      AdvertiseData advertiseData,
      AdvertiseData scanResponse,
      AdvertiseCallback callback);

  /// Creates a new advertising set. If operation succeed, device will start
  /// advertising. This method returns immediately, the operation status is
  /// delivered through callback.onAdvertisingSetStarted().
  ///
  /// Requires the android.Manifest.permission#BLUETOOTH_PRIVILEGED permission
  /// when parameters.getOwnAddressType() is different from
  /// AdvertisingSetParameters.ADDRESS_TYPE_DEFAULT or parameters.isDirected() is
  /// true.
  ///
  /// The android.Manifest.permission#BLUETOOTH_ADVERTISE permission is always
  /// enforced.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void startAdvertisingSet1(
    AdvertisingSetParameters parameters,
    AdvertiseData advertiseData,
    AdvertiseData scanResponse,
    PeriodicAdvertisingParameters periodicParameters,
    AdvertiseData periodicData,
    AdvertisingSetCallback callback,
  );

  /// Creates a new advertising set. If operation succeed, device will start
  /// advertising. This method returns immediately, the operation status is
  /// delivered through callback.onAdvertisingSetStarted().
  ///
  /// Requires the android.Manifest.permission#BLUETOOTH_PRIVILEGED permission
  /// when parameters.getOwnAddressType() is different from
  /// AdvertisingSetParameters.ADDRESS_TYPE_DEFAULT or parameters.isDirected() is
  /// true.
  ///
  /// The android.Manifest.permission#BLUETOOTH_ADVERTISE permission is always
  /// enforced.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void startAdvertisingSet2(
    AdvertisingSetParameters parameters,
    AdvertiseData advertiseData,
    AdvertiseData scanResponse,
    PeriodicAdvertisingParameters periodicParameters,
    AdvertiseData periodicData,
    int duration,
    int maxExtendedAdvertisingEvents,
    AdvertisingSetCallback callback,
  );

  /// Stop Bluetooth LE advertising. The callback must be the same one use in
  /// android.bluetooth.le.BluetoothLeAdvertiser#startAdvertising.
  void stopAdvertising(AdvertiseCallback callback);

  /// Used to dispose of a AdvertisingSet object, obtained with
  /// android.bluetooth.le.BluetoothLeAdvertiser#startAdvertisingSet.
  @KotlinProxyApiOptions(
    minAndroidApi: 26,
  )
  void stopAdvertisingSet(AdvertisingSetCallback callback);
}

/// This class provides methods to perform scan related operations for Bluetooth
/// LE devices. An application can scan for a particular type of Bluetooth LE
/// devices using ScanFilter. It can also request different types of callbacks
/// for delivering the result.
///
/// Use BluetoothAdapter.getBluetoothLeScanner() to get an instance of BluetoothLeScanner.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.BluetoothLeScanner',
  ),
)
abstract class BluetoothLeScanner {
  /// Flush pending batch scan results stored in Bluetooth controller. This will
  /// return Bluetooth LE scan results batched on bluetooth controller. Returns
  /// immediately, batch scan results data will be delivered through the callback.
  void flushPendingScanResults(ScanCallback callback);

  /// Start Bluetooth LE scan with default parameters and no filters. The scan
  /// results will be delivered through callback. For unfiltered scans, scanning
  /// is stopped on screen off to save power. Scanning is resumed when screen is
  /// turned on again. To avoid this, use
  /// startScan(java.util.List,android.bluetooth.le.ScanSettings,android.bluetooth.le.ScanCallback)
  /// with desired ScanFilter.
  ///
  /// An app must have ACCESS_COARSE_LOCATION permission in order to get results.
  /// An App targeting Android Q or later must have ACCESS_FINE_LOCATION permission
  /// in order to get results.
  void startScan1(ScanCallback callback);

  /// Start Bluetooth LE scan using a PendingIntent. The scan results will be
  /// delivered via the PendingIntent. Use this method of scanning if your process
  /// is not always running and it should be started when scan results are available.
  ///
  /// An app must have ACCESS_COARSE_LOCATION permission in order to get results.
  /// An App targeting Android Q or later must have ACCESS_FINE_LOCATION permission
  /// in order to get results.
  ///
  /// When the PendingIntent is delivered, the Intent passed to the receiver or
  /// activity will contain one or more of the extras EXTRA_CALLBACK_TYPE,
  /// EXTRA_ERROR_CODE and EXTRA_LIST_SCAN_RESULT to indicate the result of the
  /// scan.
  void startScan2(List<ScanFilter>? filters, ScanSettings? settings,
      PendingIntent callbackIntent);

  /// Start Bluetooth LE scan. The scan results will be delivered through callback.
  /// For unfiltered scans, scanning is stopped on screen off to save power.
  /// Scanning is resumed when screen is turned on again. To avoid this, do filtered
  /// scanning by using proper ScanFilter.
  ///
  /// An app must have ACCESS_COARSE_LOCATION permission in order to get results.
  /// An App targeting Android Q or later must have ACCESS_FINE_LOCATION permission
  /// in order to get results.
  void startScan3(
      List<ScanFilter> filters, ScanSettings settings, ScanCallback callback);

  /// Stops an ongoing Bluetooth LE scan started using a PendingIntent. When
  /// creating the PendingIntent parameter, please do not use the FLAG_CANCEL_CURRENT
  /// flag. Otherwise, the stop scan may have no effect.
  void stopScan1(PendingIntent callbackIntent);

  /// Stops an ongoing Bluetooth LE scan.
  void stopScan2(ScanCallback callback);
}

abstract class LeScanCallback {
  LeScanCallback();

  late final void Function(
      BluetoothDevice device, int rssi, Uint8List scanRecord) onLeScan;
}

abstract class BluetoothProfileServiceListener {}

abstract class ScanCallback {}

abstract class BluetoothProfile {
  List<BluetoothDevice> getConnectedDevices();
  int getConnectionState(BluetoothDevice device);
  List<BluetoothDevice> getDevicesMatchingConnectionStates(List<int> states);
}

abstract class UUID {}

abstract class ParcelUuid {}

abstract class AdvertiseSettings {}

abstract class AdvertiseData {}

abstract class AdvertiseCallback {}

abstract class AdvertisingSetParameters {}

abstract class PeriodicAdvertisingParameters {}

abstract class AdvertisingSetCallback {}

abstract class ScanFilter {}

abstract class ScanSettings {}

abstract class PendingIntent {}
