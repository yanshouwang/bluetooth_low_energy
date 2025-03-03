// Run with `dart run pigeon --input api.dart`.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/bluetooth_low_energy.g.dart',
    kotlinOut:
        'android/src/main/kotlin/dev/hebei/bluetooth_low_energy_android/BluetoothLowEnergy.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.hebei.bluetooth_low_energy_android',
      errorClassName: 'BluetoothLowEnergyError',
    ),
  ),
)
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'dev.hebei.bluetooth_low_energy_android.BluetoothLowEnergyAndroidPlugin',
  ),
)
abstract class BluetoothLowEnergyAndroidPlugin extends Any {
  @static
  late final BluetoothLowEnergyAndroidPlugin instance;

  @attached
  late final Context applicationContext;

  Activity? getActivity();

  void addRequestPermissionsResultListener(
      RequestPermissionsResultListener listener);
  void removeRequestPermissionsResultListener(
      RequestPermissionsResultListener listener);

  void addActivityResultListener(ActivityResultListener listener);
  void removeActivityResultListener(ActivityResultListener listener);
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener',
  ),
)
abstract class RequestPermissionsResultListener {
  late final void Function(
          int requestCode, List<String> permissions, List<int> grantResults)
      onRequestPermissionsResult;
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName:
        'io.flutter.plugin.common.PluginRegistry.ActivityResultListener',
  ),
)
abstract class ActivityResultListener {
  late final void Function(int requestCode, int resultCode, Intent? data)
      onActivityResult;
}

// https://kotlinlang.org/api/core/kotlin-stdlib/kotlin/

/// The root of the Kotlin class hierarchy. Every Kotlin class has Any as a
/// superclass.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'Any',
  ),
)
abstract class Any {
  Any();

  /// Indicates whether some other object is "equal to" this one. Implementations
  /// must fulfil the following requirements:
  bool equals(Any? other);

  /// Returns a hash code value for the object.  The general contract of hashCode
  /// is:
  int hashCodeX();

  /// Returns a string representation of the object.
  String toStringX();
}

// https://developer.android.google.cn/reference/kotlin/android/app/package-summary

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.app.Activity',
  ),
)
abstract class Activity extends Context {}

/// A description of an Intent and target action to perform with it. Instances of
/// this class are created with #getActivity, #getActivities, getBroadcast, and
/// getService; the returned object can be handed to other applications so that
/// they can perform the action you described on your behalf at a later time.
///
/// By giving a PendingIntent to another application, you are granting it the
/// right to perform the operation you have specified as if the other application
/// was yourself (with the same permissions and identity). As such, you should be
/// careful about how you build the PendingIntent: almost always, for example,
/// the base Intent you supply should have the component name explicitly set to
/// one of your own components, to ensure it is ultimately sent there and nowhere
/// else.
///
/// A PendingIntent itself is simply a reference to a token maintained by the
/// system describing the original data used to retrieve it. This means that, even
/// if its owning application's process is killed, the PendingIntent itself will
/// remain usable from other processes that have been given it. If the creating
/// application later re-retrieves the same kind of PendingIntent (same operation,
/// same Intent action, data, categories, and components, and same flags), it will
/// receive a PendingIntent representing the same token if that is still valid,
/// and can thus call cancel to remove it.
///
/// Because of this behavior, it is important to know when two Intents are considered
/// to be the same for purposes of retrieving a PendingIntent. A common mistake
/// people make is to create multiple PendingIntent objects with Intents that only
/// vary in their "extra" contents, expecting to get a different PendingIntent
/// each time. This does not happen. The parts of the Intent that are used for
/// matching are the same ones defined by Intent.filterEquals. If you use two
/// Intent objects that are equivalent as per Intent.filterEquals, then you will
/// get the same PendingIntent for both of them.
///
/// There are two typical ways to deal with this.
///
/// If you truly need multiple distinct PendingIntent objects active at the same
/// time (such as to use as two notifications that are both shown at the same
/// time), then you will need to ensure there is something that is different about
/// them to associate them with different PendingIntents. This may be any of the
/// Intent attributes considered by Intent.filterEquals, or different request code
/// integers supplied to #getActivity, #getActivities, getBroadcast, or getService.
///
/// If you only need one PendingIntent active at a time for any of the Intents
/// you will use, then you can alternatively use the flags FLAG_CANCEL_CURRENT or
/// FLAG_UPDATE_CURRENT to either cancel or modify whatever current PendingIntent
/// is associated with the Intent you are supplying.
///
/// Also note that flags like FLAG_ONE_SHOT or FLAG_IMMUTABLE describe the
/// PendingIntent instance and thus, are used to identify it. Any calls to retrieve
/// or modify a PendingIntent created with these flags will also require these
/// flags to be supplied in conjunction with others. E.g. To retrieve an existing
/// PendingIntent created with FLAG_ONE_SHOT, both FLAG_ONE_SHOT and FLAG_NO_CREATE
/// need to be supplied.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.app.PendingIntent',
  ),
)
abstract class PendingIntent extends Any {}

// https://developer.android.google.cn/reference/kotlin/android/bluetooth/package-summary

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
abstract class BluetoothAdapter extends Any {
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
  // @Deprecated(
  //     'Starting with android.os.Build.VERSION_CODES#TIRAMISU, applications are not allowed to enable/disable Bluetooth. Compatibility Note: For applications targeting android.os.Build.VERSION_CODES#TIRAMISU or above, this API will always fail and return false. If apps are targeting an older SDK (android.os.Build.VERSION_CODES#S or below), they can continue to use this API.')
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
  // @Deprecated(
  //     'Starting with android.os.Build.VERSION_CODES#TIRAMISU, applications are not allowed to enable/disable Bluetooth. Compatibility Note: For applications targeting android.os.Build.VERSION_CODES#TIRAMISU or above, this API will always fail and return false. If apps are targeting an older SDK (android.os.Build.VERSION_CODES#S or below), they can continue to use this API.')
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
  // @Deprecated(
  //     'this method will continue to work, but developers are strongly encouraged to migrate to using BluetoothManager.getAdapter(), since that approach enables support for Context.createAttributionContext.')
  @static
  BluetoothAdapter getDefaultAdapter();

  /// Get the timeout duration of the SCAN_MODE_CONNECTABLE_DISCOVERABLE.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  Duration? getDiscoverableTimeout();

  /// Return the maximum LE advertising data length in bytes, if LE Extended
  /// Advertising feature is supported, 0 otherwise.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  int getLeMaximumAdvertisingDataLength();

  /// Get the maximum number of connected devices per audio profile for this
  /// device.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
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
  int getProfileConnectionState(int profile);

  /// Get the profile proxy object associated with the profile.
  ///
  /// The ServiceListener's methods will be invoked on the application's main
  /// looper
  bool getProfileProxy(Context context, ServiceListener listener, int profile);

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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  bool isLe2MPhySupported();

  /// Returns BluetoothStatusCodes.FEATURE_SUPPORTED if the LE audio broadcast
  /// assistant feature is supported, BluetoothStatusCodes.FEATURE_NOT_SUPPORTED
  /// if the feature is not supported, or an error code.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  int isLeAudioBroadcastAssistantSupported();

  /// Returns BluetoothStatusCodes.FEATURE_SUPPORTED if the LE audio broadcast
  /// source feature is supported, BluetoothStatusCodes.FEATURE_NOT_SUPPORTED if
  /// the feature is not supported, or an error code.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  int isLeAudioBroadcastSourceSupported();

  /// Returns BluetoothStatusCodes.FEATURE_SUPPORTED if the LE audio feature is
  /// supported, BluetoothStatusCodes.FEATURE_NOT_SUPPORTED if the feature is not
  /// supported, or an error code.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  int isLeAudioSupported();

  /// Return true if LE Coded PHY feature is supported.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  bool isLeCodedPhySupported();

  /// Return true if LE Extended Advertising feature is supported.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  bool isLeExtendedAdvertisingSupported();

  /// Return true if LE Periodic Advertising feature is supported.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 29,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 29,
  // )
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

  /// Starts a scan for Bluetooth LE devices.
  ///
  /// Results of the scan are reported using the LeScanCallback.onLeScan callback.
  // @Deprecated(
  //     'use BluetoothLeScanner.startScan(List, ScanSettings, ScanCallback) instead.')
  bool startLeScan1(LeScanCallback callback);

  /// Starts a scan for Bluetooth LE devices, looking for devices that advertise
  /// given services.
  ///
  /// Devices which advertise all specified services are reported using the
  /// BluetoothAdapter.LeScanCallback.onLeScan(BluetoothDevice, int, byte) callback.
  // @Deprecated(
  //     'use BluetoothLeScanner.startScan(List, ScanSettings, ScanCallback) instead.')
  bool startLeScan2(List<UUID> serviceUuids, LeScanCallback callback);

  /// Stops an ongoing Bluetooth LE device scan.
  // @Deprecated('Use BluetoothLeScanner.stopScan(ScanCallback) instead.')
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
abstract class BluetoothClass extends Any {
  /// Check class bits for possible bluetooth profile support. This is a simple
  /// heuristic that tries to guess if a device with the given class bits might
  /// support specified profile. It is not accurate for all devices. It tries to
  /// err on the side of false positives.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
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
abstract class BluetoothDevice extends Any {
  /// Connect to GATT Server hosted by this device. Caller acts as GATT client.
  /// The callback is used to deliver results to Caller, such as connection status
  /// as well as any further GATT client operations. The method returns a
  /// BluetoothGatt instance. You can use BluetoothGatt to conduct GATT client
  /// operations.
  BluetoothGatt connectGatt1(
      Context context, bool autoConnect, BluetoothGattCallback callback);

  /// Connect to GATT Server hosted by this device. Caller acts as GATT client.
  /// The callback is used to deliver results to Caller, such as connection status
  /// as well as any further GATT client operations. The method returns a
  /// BluetoothGatt instance. You can use BluetoothGatt to conduct GATT client
  /// operations.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 23,
  // )
  BluetoothGatt connectGatt2(Context context, bool autoConnect,
      BluetoothGattCallback callback, int transport);

  /// Connect to GATT Server hosted by this device. Caller acts as GATT client.
  /// The callback is used to deliver results to Caller, such as connection status
  /// as well as any further GATT client operations. The method returns a
  /// BluetoothGatt instance. You can use BluetoothGatt to conduct GATT client
  /// operations.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  BluetoothGatt connectGatt3(Context context, bool autoConnect,
      BluetoothGattCallback callback, int transport, int phy);

  /// Connect to GATT Server hosted by this device. Caller acts as GATT client.
  /// The callback is used to deliver results to Caller, such as connection status
  /// as well as any further GATT client operations. The method returns a
  /// BluetoothGatt instance. You can use BluetoothGatt to conduct GATT client
  /// operations.
  BluetoothGatt connectGatt4(Context context, bool autoConnect,
      BluetoothGattCallback callback, int transport, int phy, Handler handler);

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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 29,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 29,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 35,
  // )
  int getAddressType();

  /// Get the locally modifiable name (alias) of the remote Bluetooth device.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 30,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 31,
  // )
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
abstract class BluetoothGatt extends Any {
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  void setPreferredPhy(int txPhy, int rxPhy, int phyOptions);

  /// Writes a given characteristic and its values to the associated remote device.
  ///
  /// Once the write operation has been completed, the
  /// android.bluetooth.BluetoothGattCallback#onCharacteristicWrite callback is
  /// invoked, reporting the result of the operation.
  // @Deprecated(
  //     'Use BluetoothGatt.writeCharacteristic(BluetoothGattCharacteristic, byte[], as this is not memory safe because it relies on a BluetoothGattCharacteristic object whose underlying fields are subject to change outside this method.')
  bool writeCharacteristic1(BluetoothGattCharacteristic characteristic);

  /// Writes a given characteristic and its values to the associated remote device.
  ///
  /// Once the write operation has been completed, the
  /// android.bluetooth.BluetoothGattCallback#onCharacteristicWrite callback is
  /// invoked, reporting the result of the operation.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  int writeCharacteristic2(BluetoothGattCharacteristic characteristic,
      Uint8List value, int writeType);

  /// Write the value of a given descriptor to the associated remote device.
  ///
  /// A BluetoothGattCallback.onDescriptorWrite callback is triggered to report
  /// the result of the write operation.
  // @Deprecated(
  //     ' Use BluetoothGatt.writeDescriptor(BluetoothGattDescriptor, byte[]) as this is not memory safe because it relies on a BluetoothGattDescriptor object whose underlying fields are subject to change outside this method.')
  bool writeDescriptor1(BluetoothGattDescriptor descriptor);

  /// Write the value of a given descriptor to the associated remote device.
  ///
  /// A BluetoothGattCallback.onDescriptorWrite callback is triggered to report
  /// the result of the write operation.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  int writeDescriptor2(BluetoothGattDescriptor descriptor, Uint8List value);
}

/// This abstract class is used to implement BluetoothGatt callbacks.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothGattCallback',
  ),
)
abstract class BluetoothGattCallback extends Any {
  BluetoothGattCallback();

  /// Callback triggered as a result of a remote characteristic notification.
  // @Deprecated(
  //     'Use BluetoothGattCallback.onCharacteristicChanged(BluetoothGatt, as it is memory safe by providing the characteristic value at the time of notification.')
  late final void Function(
          BluetoothGatt gatt, BluetoothGattCharacteristic characteristic)
      onCharacteristicChanged1;

  /// Callback triggered as a result of a remote characteristic notification. Note
  /// that the value within the characteristic object may have changed since
  /// receiving the remote characteristic notification, so check the parameter
  /// value for the value at the time of notification.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  late final void Function(
      BluetoothGatt gatt,
      BluetoothGattCharacteristic characteristic,
      Uint8List value) onCharacteristicChanged2;

  /// Callback reporting the result of a characteristic read operation.
  // @Deprecated(
  //     'Use BluetoothGattCallback.onCharacteristicRead(BluetoothGatt, as it is memory safe')
  late final void Function(
      BluetoothGatt gatt,
      BluetoothGattCharacteristic characteristic,
      int status) onCharacteristicRead1;

  /// Callback reporting the result of a characteristic read operation.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  late final void Function(
      BluetoothGatt gatt,
      BluetoothGattCharacteristic characteristic,
      Uint8List value,
      int status) onCharacteristicRead2;

  /// Callback indicating the result of a characteristic write operation.
  ///
  /// If this callback is invoked while a reliable write transaction is in progress,
  /// the value of the characteristic represents the value reported by the remote
  /// device. An application should compare this value to the desired value to be
  /// written. If the values don't match, the application must abort the reliable
  /// write transaction.
  late final void Function(
      BluetoothGatt gatt,
      BluetoothGattCharacteristic characteristic,
      int status) onCharacteristicWrite;

  /// Callback indicating when GATT client has connected/disconnected to/from a
  /// remote GATT server.
  late final void Function(BluetoothGatt gatt, int status, int newState)
      onConnectionStateChange;

  /// Callback triggered as a result of a remote descriptor read operation.
  // @Deprecated(
  //     'Use BluetoothGattCallback.onDescriptorRead(BluetoothGatt, as it is memory safe by providing the descriptor value at the time it was read.')
  late final void Function(
          BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status)
      onDescriptorRead1;

  /// Callback reporting the result of a descriptor read operation.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  late final void Function(
      BluetoothGatt gatt,
      BluetoothGattDescriptor descriptor,
      int status,
      Uint8List value) onDescriptorRead2;

  /// Callback triggered as a result of a remote descriptor write operation.
  late final void Function(
          BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status)
      onDescriptorWrite;

  /// Callback indicating the MTU for a given device connection has changed.
  ///
  /// This callback is triggered in response to the BluetoothGatt.requestMtu
  /// function, or in response to a connection event.
  late final void Function(BluetoothGatt gatt, int mtu, int status)
      onMtuChanged;

  /// Callback triggered as result of BluetoothGatt.readPhy
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  late final void Function(BluetoothGatt gatt, int txPhy, int rxPhy, int status)
      onPhyRead;

  /// Callback triggered as result of BluetoothGatt.setPreferredPhy, or as a result
  /// of remote device changing the PHY.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  late final void Function(BluetoothGatt gatt, int txPhy, int rxPhy, int status)
      onPhyUpdate;

  /// Callback reporting the RSSI for a remote device connection.
  ///
  /// This callback is triggered in response to the BluetoothGatt.readRemoteRssi
  /// function.
  late final void Function(BluetoothGatt gatt, int rssi, int status)
      onReadRemoteRssi;

  /// Callback invoked when a reliable write transaction has been completed.
  late final void Function(BluetoothGatt gatt, int status)
      onReliableWriteCompleted;

  /// Callback indicating service changed event is received
  ///
  /// Receiving this event means that the GATT database is out of sync with the
  /// remote device. BluetoothGatt.discoverServices should be called to re-discover
  /// the services.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 31,
  // )
  late final void Function(BluetoothGatt gatt) onServiceChanged;

  /// Callback invoked when the list of remote services, characteristics and
  /// descriptors for the remote device have been updated, ie new services have
  /// been discovered.
  late final void Function(BluetoothGatt gatt, int status) onServicesDiscovered;
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
abstract class BluetoothGattCharacteristic extends Any {
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
  // @Deprecated(
  //     'Use BluetoothGatt.readCharacteristic(BluetoothGattCharacteristic) to get the characteristic value')
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
  // @Deprecated(
  //     'Use BluetoothGatt.readCharacteristic(BluetoothGattCharacteristic) to get the characteristic value')
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
  // @Deprecated(
  //     'Use BluetoothGatt.readCharacteristic(BluetoothGattCharacteristic) to get the characteristic value')
  String getStringValue(int offset);

  /// Returns the UUID of this characteristic
  UUID getUuid();

  /// Get the stored value for this characteristic.
  ///
  /// This function returns the stored value for this characteristic as retrieved
  /// by calling BluetoothGatt.readCharacteristic. The cached value of the
  /// characteristic is updated as a result of a read characteristic operation or
  /// if a characteristic update notification has been received.
  // @Deprecated(
  //     ' Use BluetoothGatt.readCharacteristic(BluetoothGattCharacteristic) instead')
  Uint8List getValue();

  /// Gets the write type for this characteristic.
  int getWriteType();

  /// Updates the locally stored value of this characteristic.
  ///
  /// This function modifies the locally stored cached value of this characteristic.
  /// To send the value to the remote device, call android.bluetooth.BluetoothGatt#writeCharacteristic
  /// to send the value to the remote device.
  // @Deprecated(
  //     'Pass the characteristic value directly into android.bluetooth.BluetoothGatt#writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)')
  bool setValue1(Uint8List value);

  /// Set the locally stored value of this characteristic.
  ///
  /// See setValue(byte[]) for details.
  // @Deprecated(
  //     'Pass the characteristic value directly into android.bluetooth.BluetoothGatt#writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)')
  bool setValue2(int value, int formatType, int offset);

  /// Set the locally stored value of this characteristic.
  ///
  /// See setValue(byte[]) for details.
  // @Deprecated(
  //     ' Pass the characteristic value directly into android.bluetooth.BluetoothGatt#writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)')
  bool setValue3(int mantissa, int exponent, int formatType, int offset);

  /// Set the locally stored value of this characteristic.
  ///
  /// See setValue(byte[]) for details.
  // @Deprecated(
  //     'Pass the characteristic value directly into android.bluetooth.BluetoothGatt#writeCharacteristic(android.bluetooth.BluetoothGattCharacteristic,byte[],int)')
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
abstract class BluetoothGattDescriptor extends Any {
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
  // @Deprecated(
  //     'Use BluetoothGatt.readDescriptor(BluetoothGattDescriptor) instead')
  Uint8List getValue();

  /// Updates the locally stored value of this descriptor.
  ///
  /// This function modifies the locally stored cached value of this descriptor.
  /// To send the value to the remote device, call android.bluetooth.BluetoothGatt#writeDescriptor
  /// to send the value to the remote device.
  // @Deprecated(
  //     'Pass the descriptor value directly into android.bluetooth.BluetoothGatt#writeDescriptor(android.bluetooth.BluetoothGattDescriptor,byte[])')
  bool setValue(Uint8List value);

  @static
  Uint8List disableNotificationValue();
  @static
  Uint8List enableIndicationValue();
  @static
  Uint8List enableNotificationValue();
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
abstract class BluetoothGattServer extends Any {
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
  // @Deprecated(
  //     'Use BluetoothGattServer.notifyCharacteristicChanged(BluetoothDevice, as this is not memory safe.')
  bool notifyCharacteristicChanged(BluetoothDevice device,
      BluetoothGattCharacteristic characteristic, bool confirm);

  /// Send a notification or indication that a local characteristic has been
  /// updated.
  ///
  /// A notification or indication is sent to the remote device to signal that
  /// the characteristic has been updated. This function should be invoked for
  /// every client that requests notifications/indications by writing to the
  /// "Client Configuration" descriptor for the given characteristic.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  int notifyCharacteristicChanged1(
      BluetoothDevice device,
      BluetoothGattCharacteristic characteristic,
      bool confirm,
      Uint8List value);

  /// Read the current transmitter PHY and receiver PHY of the connection. The
  /// values are returned in BluetoothGattServerCallback.onPhyRead
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  void setPreferredPhy(
      BluetoothDevice device, int txPhy, int rxPhy, int phyOptions);
}

/// This abstract class is used to implement BluetoothGattServer callbacks.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothGattServerCallback',
  ),
)
abstract class BluetoothGattServerCallback extends Any {
  BluetoothGattServerCallback();

  /// A remote client has requested to read a local characteristic.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  late final void Function(BluetoothDevice device, int requestId, int offset,
      BluetoothGattCharacteristic characteristic) onCharacteristicReadRequest;

  /// A remote client has requested to write to a local characteristic.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  late final void Function(
      BluetoothDevice device,
      int requestId,
      BluetoothGattCharacteristic characteristic,
      bool preparedWrite,
      bool responseNeeded,
      int offset,
      Uint8List value) onCharacteristicWriteRequest;

  /// Callback indicating when a remote device has been connected or disconnected.
  late final void Function(BluetoothDevice device, int status, int newState)
      onConnectionStateChange;

  /// A remote client has requested to read a local descriptor.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  late final void Function(BluetoothDevice device, int requestId, int offset,
      BluetoothGattDescriptor descriptor) onDescriptorReadRequest;

  /// A remote client has requested to write to a local descriptor.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  late final void Function(
      BluetoothDevice device,
      int requestId,
      BluetoothGattDescriptor descriptor,
      bool preparedWrite,
      bool responseNeeded,
      int offset,
      Uint8List value) onDescriptorWriteRequest;

  /// Execute all pending write operations for this device.
  ///
  /// An application must call BluetoothGattServer.sendResponse to complete the
  /// request.
  late final void Function(BluetoothDevice device, int requestId, bool execute)
      onExecuteWrite;

  /// Callback indicating the MTU for a given device connection has changed.
  ///
  /// This callback will be invoked if a remote client has requested to change
  /// the MTU for a given connection.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 22,
  // )
  late final void Function(BluetoothDevice device, int mtu) onMtuChanged;

  /// Callback invoked when a notification or indication has been sent to a remote
  /// device.
  ///
  /// When multiple notifications are to be sent, an application must wait for
  /// this callback to be received before sending additional notifications.
  late final void Function(BluetoothDevice device, int status)
      onNotificationSent;

  /// Callback triggered as result of BluetoothGattServer.readPhy
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  late final void Function(
      BluetoothDevice device, int txPhy, int rxPhy, int status) onPhyRead;

  /// Callback triggered as result of BluetoothGattServer.setPreferredPhy, or as
  /// a result of remote device changing the PHY.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  late final void Function(
      BluetoothDevice device, int txPhy, int rxPhy, int status) onPhyUpdate;

  /// Indicates whether a local service has been added successfully.
  late final void Function(int status, BluetoothGattService service)
      onServiceAdded;
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
abstract class BluetoothGattService extends Any {
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
abstract class BluetoothManager extends Any {
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
  BluetoothGattServer openGattServer(
      Context context, BluetoothGattServerCallback callback);
}

/// A listening Bluetooth socket.
///
/// The interface for Bluetooth Sockets is similar to that of TCP sockets:
/// java.net.Socket and java.net.ServerSocket. On the server side, use a
/// BluetoothServerSocket to create a listening server socket. When a connection
/// is accepted by the BluetoothServerSocket, it will return a new BluetoothSocket
/// to manage the connection. On the client side, use a single BluetoothSocket to
/// both initiate an outgoing connection and to manage the connection.
///
/// For Bluetooth BR/EDR, the most common type of socket is RFCOMM, which is the
/// type supported by the Android APIs. RFCOMM is a connection-oriented, streaming
/// transport over Bluetooth BR/EDR. It is also known as the Serial Port Profile
/// (SPP). To create a listening BluetoothServerSocket that's ready for incoming
/// Bluetooth BR/EDR connections, use BluetoothAdapter.listenUsingRfcommWithServiceRecord().
///
/// For Bluetooth LE, the socket uses LE Connection-oriented Channel (CoC). LE
/// CoC is a connection-oriented, streaming transport over Bluetooth LE and has
/// a credit-based flow control. Correspondingly, use BluetoothAdapter.listenUsingL2capChannel()
/// to create a listening BluetoothServerSocket that's ready for incoming Bluetooth
/// LE CoC connections. For LE CoC, you can use getPsm() to get the protocol/service
/// multiplexer (PSM) value that the peer needs to use to connect to your socket.
///
/// After the listening BluetoothServerSocket is created, call accept() to listen
/// for incoming connection requests. This call will block until a connection is
/// established, at which point, it will return a BluetoothSocket to manage the
/// connection. Once the BluetoothSocket is acquired, it's a good idea to call
/// #close() on the BluetoothServerSocket when it's no longer needed for accepting
/// connections. Closing the BluetoothServerSocket will not close the returned
/// BluetoothSocket.
///
/// BluetoothServerSocket is thread safe. In particular, #close will always
/// immediately abort ongoing operations and close the server socket.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothServerSocket',
  ),
)
abstract class BluetoothServerSocket extends Any {
  /// Block until a connection is established.
  ///
  /// Returns a connected BluetoothSocket on successful connection.
  ///
  /// Once this call returns, it can be called again to accept subsequent incoming connections.
  ///
  /// close can be used to abort this call from another thread.
  BluetoothSocket accept1();

  /// Block until a connection is established, with timeout.
  ///
  /// Returns a connected BluetoothSocket on successful connection.
  ///
  /// Once this call returns, it can be called again to accept subsequent incoming
  /// connections.
  ///
  /// close can be used to abort this call from another thread.
  BluetoothSocket accept2(int timeout);

  /// Immediately close this socket, and release all associated resources.
  ///
  /// Causes blocked calls on this socket in other threads to immediately throw
  /// an IOException.
  ///
  /// Closing the BluetoothServerSocket will not close any BluetoothSocket received
  /// from accept().
  void close();

  /// Returns the assigned dynamic protocol/service multiplexer (PSM) value for
  /// the listening L2CAP Connection-oriented Channel (CoC) server socket. This
  /// server socket must be returned by the BluetoothAdapter.listenUsingL2capChannel()
  /// or android.bluetooth.BluetoothAdapter#listenUsingInsecureL2capChannel().
  /// The returned value is undefined if this method is called on non-L2CAP server
  /// sockets.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 29,
  // )
  int getPsm();
}

/// A connected or connecting Bluetooth socket.
///
/// The interface for Bluetooth Sockets is similar to that of TCP sockets:
/// java.net.Socket and java.net.ServerSocket. On the server side, use a
/// BluetoothServerSocket to create a listening server socket. When a connection
/// is accepted by the BluetoothServerSocket, it will return a new BluetoothSocket
/// to manage the connection. On the client side, use a single BluetoothSocket to
/// both initiate an outgoing connection and to manage the connection.
///
/// The most common type of Bluetooth socket is RFCOMM, which is the type supported
/// by the Android APIs. RFCOMM is a connection-oriented, streaming transport over
/// Bluetooth. It is also known as the Serial Port Profile (SPP).
///
/// To create a BluetoothSocket for connecting to a known device, use
/// BluetoothDevice.createRfcommSocketToServiceRecord(). Then call connect() to
/// attempt a connection to the remote device. This call will block until a
/// connection is established or the connection fails.
///
/// To create a BluetoothSocket as a server (or "host"), see the BluetoothServerSocket
/// documentation.
///
/// Once the socket is connected, whether initiated as a client or accepted as a
/// server, open the IO streams by calling getInputStream and getOutputStream in
/// order to retrieve java.io.InputStream and java.io.OutputStream objects,
/// respectively, which are automatically connected to the socket.
///
/// BluetoothSocket is thread safe. In particular, #close will always immediately
/// abort ongoing operations and close the socket.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothSocket',
  ),
)
abstract class BluetoothSocket extends Any {
  void close();

  /// Attempt to connect to a remote device.
  ///
  /// This method will block until a connection is made or the connection fails.
  /// If this method returns without an exception then this socket is now connected.
  ///
  /// Creating new connections to remote Bluetooth devices should not be attempted
  /// while device discovery is in progress. Device discovery is a heavyweight
  /// procedure on the Bluetooth adapter and will significantly slow a device
  /// connection. Use android.bluetooth.BluetoothAdapter#cancelDiscovery() to
  /// cancel an ongoing discovery. Discovery is not managed by the Activity, but
  /// is run as a system service, so an application should always call
  /// android.bluetooth.BluetoothAdapter#cancelDiscovery() even if it did not
  /// directly request a discovery, just to be sure.
  ///
  /// close can be used to abort this call from another thread.
  ///
  /// Requires the android.Manifest.permission#BLUETOOTH_PRIVILEGED permission
  /// only when mDataPath is different from android.bluetooth.BluetoothSocketSettings#DATA_PATH_NO_OFFLOAD.
  void connect();

  /// Get the type of the underlying connection.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 23,
  // )
  int getConnectionType();

  /// Get the input stream associated with this socket.
  ///
  /// The input stream will be returned even if the socket is not yet connected,
  /// but operations on that stream will throw IOException until the associated
  /// socket is connected.
  InputStream getInputStream();

  /// Get the maximum supported Receive packet size for the underlying transport.
  /// Use this to optimize the reads done on the input stream, as any call to read
  /// will return a maximum of this amount of bytes - or for some transports a
  /// multiple of this value.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 23,
  // )
  int getMaxReceivePacketSize();

  /// Get the maximum supported Transmit packet size for the underlying transport.
  /// Use this to optimize the writes done to the output socket, to avoid sending
  /// half full packets.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 23,
  // )
  int getMaxTransmitPacketSize();

  /// Get the output stream associated with this socket.
  ///
  /// The output stream will be returned even if the socket is not yet connected,
  /// but operations on that stream will throw IOException until the associated
  /// socket is connected.
  OutputStream getOutputStream();

  /// Get the remote device this socket is connecting, or connected, to.
  BluetoothDevice getRemoteDevice();

  /// Get the connection status of this socket, ie, whether there is an active
  /// connection with remote device.
  bool isConnected();
}

/// A class with constants representing possible return values for Bluetooth APIs.
/// General return values occupy the range 0 to 199. Profile-specific return values
/// occupy the range 200-999. API-specific return values start at 1000. The
/// exception to this is the "UNKNOWN" error code which occupies the max integer
/// value.
enum BluetoothStatusCodes {
  /// Error code indicating that the API call was initiated by neither the system
  /// nor the active user.
  errorBluetoothNotAllowed,

  /// Error code indicating that Bluetooth is not enabled.
  errorBluetoothNotEnabled,

  /// Error code indicating that the Bluetooth Device specified is not bonded.
  errorDeviceNotBonded,

  /// A GATT writeCharacteristic request is not permitted on the remote device.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  errorGattWriteNotAllowed,

  /// A GATT writeCharacteristic request is issued to a busy remote device.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  errorGattWriteRequestBusy,

  /// Error code indicating that the caller does not have the
  /// android.Manifest.permission#BLUETOOTH_CONNECT permission.
  errorMissingBluetoothConnectPermission,

  /// Error code indicating that the profile service is not bound. You can bind
  /// a profile service by calling BluetoothAdapter.getProfileProxy.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  errorProfileServiceNotBound,

  /// Indicates that an unknown error has occurred.
  errorUnknown,

  /// Indicates that the feature status is not configured yet.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 34,
  // )
  featureNotConfigured,

  /// Indicates that the feature is not supported.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  featureNotSupported,

  /// Indicates that the feature is supported.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 33,
  // )
  featureSupported,

  /// Indicates that the API call was successful.
  success,
}

/// Callback interface used to deliver LE scan results.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothAdapter.LeScanCallback',
  ),
)
abstract class LeScanCallback {
  LeScanCallback();

  late final void Function(
      BluetoothDevice device, int rssi, Uint8List scanRecord) onLeScan;
}

/// Public APIs for the Bluetooth Profiles.
///
/// Clients should call BluetoothAdapter.getProfileProxy, to get the Profile Proxy.
/// Each public profile with this interface.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothProfile',
  ),
)
abstract class BluetoothProfile {
  List<BluetoothDevice> getConnectedDevices();
  int getConnectionState(BluetoothDevice device);
  List<BluetoothDevice> getDevicesMatchingConnectionStates(List<int> states);
}

/// An interface for notifying BluetoothProfile IPC clients when they have been
/// connected or disconnected to the service.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.BluetoothProfile.ServiceListener',
  ),
)
abstract class ServiceListener {
  ServiceListener();

  /// Called to notify the client when the proxy object has been connected to the
  /// service.
  late final void Function(int profile, BluetoothProfile proxy)
      onServiceConnected;

  /// Called to notify the client that this proxy object has been disconnected
  /// from the service.
  late final void Function(int profile) onServiceDisconnected;
}

// https://developer.android.google.cn/reference/kotlin/android/bluetooth/le/package-summary

/// Bluetooth LE advertising callbacks, used to deliver advertising operation
/// status.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.AdvertiseCallback',
  ),
)
abstract class AdvertiseCallback extends Any {
  AdvertiseCallback();

  /// Callback when advertising could not be started.
  late final void Function(int errorCode) onStartFailure;

  /// Callback triggered in response to android.bluetooth.le.BluetoothLeAdvertiser#startAdvertising
  /// indicating that the advertising has been started successfully.
  late final void Function(AdvertiseSettings settingsInEffect) onStartSuccess;
}

/// Advertise data packet container for Bluetooth LE advertising. This represents the data to be advertised as well as the scan response data for active scans.
///
/// Use AdvertiseData.Builder to create an instance of AdvertiseData to be advertised.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.AdvertiseData',
  ),
)
abstract class AdvertiseData extends Any {
  /// Whether the device name will be included in the advertisement packet.
  bool getIncludeDeviceName();

  /// Whether the transmission power level will be included in the advertisement
  /// packet.
  bool getIncludeTxPowerLevel();

  /// Returns an array of manufacturer Id and the corresponding manufacturer
  /// specific data. The manufacturer id is a non-negative number assigned by
  /// Bluetooth SIG.
  Map<int, Uint8List> getManufacturerSpecificData();

  /// Returns a map of 16-bit UUID and its corresponding service data.
  Map<ParcelUuid, Uint8List> getServiceData();

  /// Returns a list of service solicitation UUIDs within the advertisement that
  /// we invite to connect.
  List<ParcelUuid> getServiceSolicitationUuids();

  /// Returns a list of service UUIDs within the advertisement that are used to
  /// identify the Bluetooth GATT services.
  List<ParcelUuid> getServiceUuids();

  /// Returns a list of TransportDiscoveryData within the advertisement.
  List<TransportDiscoveryData> getTransportDiscoveryData();
}

/// Builder for AdvertiseData.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.AdvertiseData.Builder',
  ),
)
abstract class AdvertiseDataBuilder extends Any {
  AdvertiseDataBuilder();

  /// Add manufacturer specific data.
  ///
  /// Please refer to the Bluetooth Assigned Numbers document provided by the
  /// Bluetooth SIG for a list of existing company identifiers.
  AdvertiseDataBuilder addManufacturerData(
      int manufacturerId, Uint8List manufacturerSpecificData);

  /// Add service data to advertise data.
  AdvertiseDataBuilder addServiceData(
      ParcelUuid serviceDataUuid, Uint8List serviceData);

  /// Add a service solicitation UUID to advertise data.
  AdvertiseDataBuilder addServiceSolicitationUuid(
      ParcelUuid serviceSolicitationUuid);

  /// Add a service UUID to advertise data.
  AdvertiseDataBuilder addServiceUuid(ParcelUuid serviceUuid);

  /// Add Transport Discovery Data to advertise data.
  AdvertiseDataBuilder addTransportDiscoveryData(
      TransportDiscoveryData transportDiscoveryData);

  /// Build the AdvertiseData.
  AdvertiseData build();

  /// Set whether the device name should be included in advertise packet.
  AdvertiseDataBuilder setIncludeDeviceName(bool includeDeviceName);

  /// Whether the transmission power level should be included in the advertise
  /// packet. Tx power level field takes 3 bytes in advertise packet.
  AdvertiseDataBuilder setIncludeTxPowerLevel(bool includeTxPowerLevel);
}

/// The AdvertiseSettings provide a way to adjust advertising preferences for each
/// Bluetooth LE advertisement instance. Use AdvertiseSettings.Builder to create
/// an instance of this class.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.AdvertiseSettings',
  ),
)
abstract class AdvertiseSettings extends Any {
  /// Returns the advertise mode.
  int getMode();

  /// Returns the advertising time limit in milliseconds.
  int getTimeout();

  /// Returns the TX power level for advertising.
  int getTxPowerLevel();

  /// Returns whether the advertisement will indicate connectable.
  bool isConnectable();

  /// Returns whether the advertisement will be discoverable.
  bool isDiscoverable();
}

/// Builder class for AdvertiseSettings.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.AdvertiseSettings.Builder',
  ),
)
abstract class AdvertiseSettingsBuilder extends Any {
  AdvertiseSettingsBuilder();

  /// Build the AdvertiseSettings object.
  AdvertiseSettings build();

  /// Set advertise mode to control the advertising power and latency.
  AdvertiseSettingsBuilder setAdvertiseMode(int advertiseMode);

  /// Set whether the advertisement type should be connectable or non-connectable.
  AdvertiseSettingsBuilder setConnectable(bool connectable);

  /// Set whether the advertisement type should be discoverable or non-discoverable.
  AdvertiseSettingsBuilder setDiscoverable(bool discoverable);

  /// Limit advertising to a given amount of time.
  AdvertiseSettingsBuilder setTimeout(int timeoutMillis);

  /// Set advertise TX power level to control the transmission power level for
  /// the advertising.
  AdvertiseSettingsBuilder setTxPowerLevel(int txPowerLevel);
}

/// This class provides a way to control single Bluetooth LE advertising instance.
///
/// To get an instance of AdvertisingSet, call the
/// android.bluetooth.le.BluetoothLeAdvertiser#startAdvertisingSet method.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.AdvertisingSet',
    minAndroidApi: 26,
  ),
)
abstract class AdvertisingSet extends Any {
  /// Enables Advertising. This method returns immediately, the operation status
  /// is delivered through callback.onAdvertisingEnabled().
  void enableAdvertising(
      bool enable, int duration, int maxExtendedAdvertisingEvents);

  /// Set/update data being Advertised. Make sure that data doesn't exceed the
  /// size limit for specified AdvertisingSetParameters. This method returns
  /// immediately, the operation status is delivered through callback.onAdvertisingDataSet().
  ///
  /// Advertising data must be empty if non-legacy scannable advertising is used.
  void setAdvertisingData(AdvertiseData advertiseData);

  /// Update advertising parameters associated with this AdvertisingSet. Must be
  /// called when advertising is not active. This method returns immediately, the
  /// operation status is delivered through callback.onAdvertisingParametersUpdated.
  ///
  /// Requires the android.Manifest.permission#BLUETOOTH_PRIVILEGED permission
  /// when parameters.getOwnAddressType() is different from
  /// AdvertisingSetParameters.ADDRESS_TYPE_DEFAULT or parameters.isDirected() is
  /// true.
  void setAdvertisingParameters(AdvertisingSetParameters parameters);

  /// Used to set periodic advertising data, must be called after
  /// setPeriodicAdvertisingParameters, or after advertising was started with
  /// periodic advertising data set. This method returns immediately, the operation
  /// status is delivered through callback.onPeriodicAdvertisingDataSet().
  void setPeriodicAdvertisingData(AdvertiseData periodicData);

  /// Used to enable/disable periodic advertising. This method returns immediately,
  /// the operation status is delivered through callback.onPeriodicAdvertisingEnable().
  void setPeriodicAdvertisingEnabled(bool enable);

  /// Update periodic advertising parameters associated with this set. Must be
  /// called when periodic advertising is not enabled. This method returns
  /// immediately, the operation status is delivered through
  /// callback.onPeriodicAdvertisingParametersUpdated().
  void setPeriodicAdvertisingParameters(
      PeriodicAdvertisingParameters parameters);

  /// Set/update scan response data. Make sure that data doesn't exceed the size
  /// limit for specified AdvertisingSetParameters. This method returns immediately,
  /// the operation status is delivered through callback.onScanResponseDataSet().
  void setScanResponseData(AdvertiseData scanResponse);
}

/// Bluetooth LE advertising set callbacks, used to deliver advertising operation
/// status.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.AdvertisingSetCallback',
    minAndroidApi: 26,
  ),
)
abstract class AdvertisingSetCallback extends Any {
  AdvertisingSetCallback();

  /// Callback triggered in response to AdvertisingSet.setAdvertisingData indicating
  /// result of the operation. If status is ADVERTISE_SUCCESS, then data was
  /// changed.
  late final void Function(AdvertisingSet advertisingSet, int status)
      onAdvertisingDataSet;

  /// Callback triggered in response to android.bluetooth.le.BluetoothLeAdvertiser#startAdvertisingSet
  /// indicating result of the operation. If status is ADVERTISE_SUCCESS, then
  /// advertising set is advertising.
  late final void Function(
          AdvertisingSet advertisingSet, bool enable, int status)
      onAdvertisingEnabled;

  /// Callback triggered in response to AdvertisingSet.setAdvertisingParameters
  /// indicating result of the operation.
  late final void Function(
          AdvertisingSet advertisingSet, int txPower, int status)
      onAdvertisingParametersUpdated;

  /// Callback triggered in response to android.bluetooth.le.BluetoothLeAdvertiser#startAdvertisingSet
  /// indicating result of the operation. If status is ADVERTISE_SUCCESS, then
  /// advertisingSet contains the started set and it is advertising. If error
  /// occurred, advertisingSet is null, and status will be set to proper error
  /// code.
  late final void Function(
          AdvertisingSet advertisingSet, int txPower, int status)
      onAdvertisingSetStarted;

  /// Callback triggered in response to BluetoothLeAdvertiser.stopAdvertisingSet
  /// indicating advertising set is stopped.
  late final void Function(AdvertisingSet advertisingSet)
      onAdvertisingSetStopped;

  /// Callback triggered in response to AdvertisingSet.setPeriodicAdvertisingData
  /// indicating result of the operation.
  late final void Function(AdvertisingSet advertisingSet, int status)
      onPeriodicAdvertisingDataSet;

  /// Callback triggered in response to AdvertisingSet.setPeriodicAdvertisingEnabled
  /// indicating result of the operation.
  late final void Function(
          AdvertisingSet advertisingSet, bool enable, int status)
      onPeriodicAdvertisingEnabled;

  /// Callback triggered in response to AdvertisingSet.setPeriodicAdvertisingParameters
  /// indicating result of the operation.
  late final void Function(AdvertisingSet advertisingSet, int status)
      onPeriodicAdvertisingParametersUpdated;

  /// Callback triggered in response to AdvertisingSet.setAdvertisingData indicating
  /// result of the operation.
  late final void Function(AdvertisingSet advertisingSet, int status)
      onScanResponseDataSet;
}

/// The AdvertisingSetParameters provide a way to adjust advertising preferences
/// for each Bluetooth LE advertising set. Use AdvertisingSetParameters.Builder
/// to create an instance of this class.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.AdvertisingSetParameters',
    minAndroidApi: 26,
  ),
)
abstract class AdvertisingSetParameters extends Any {
  /// Returns the advertising interval.
  int getInterval();

  /// Returns the primary advertising phy.
  int getPrimaryPhy();

  /// Returns the secondary advertising phy.
  int getSecondaryPhy();

  /// Returns the TX power level for advertising.
  int getTxPowerLevel();

  /// Returns whether the TX Power will be included.
  bool includeTxPower();

  /// Returns whether the advertisement will be anonymous.
  bool isAnonymous();

  /// Returns whether the advertisement will be connectable.
  bool isConnectable();

  /// Returns whether the advertisement will be discoverable.
  bool isDiscoverable();

  /// Returns whether the legacy advertisement will be used.
  bool isLegacy();

  /// Returns whether the advertisement will be scannable.
  bool isScannable();
}

/// Builder class for AdvertisingSetParameters.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.AdvertisingSetParameters.Builder',
    minAndroidApi: 26,
  ),
)
abstract class AdvertisingSetParametersBuilder extends Any {
  AdvertisingSetParametersBuilder();

  /// Build the AdvertisingSetParameters object.
  AdvertisingSetParameters build();

  /// Set whether advertiser address should be omitted from all packets. If this
  /// mode is used, periodic advertising can't be enabled for this set.
  ///
  /// This is used only if legacy mode is not used.
  AdvertisingSetParametersBuilder setAnonymous(bool isAnonymous);

  /// Set whether the advertisement type should be connectable or non-connectable.
  /// Legacy advertisements can be both connectable and scannable. Non-legacy
  /// advertisements can be only scannable or only connectable.
  AdvertisingSetParametersBuilder setConnectable(bool connectable);

  /// Set whether the advertisement type should be discoverable or non-discoverable.
  /// By default, advertisements will be discoverable. Devices connecting to
  /// non-discoverable advertisements cannot initiate bonding.
  AdvertisingSetParametersBuilder setDiscoverable(bool discoverable);

  /// Set whether TX power should be included in the extended header.
  ///
  /// This is used only if legacy mode is not used.
  AdvertisingSetParametersBuilder setIncludeTxPower(bool includeTxPower);

  /// Set advertising interval.
  AdvertisingSetParametersBuilder setInterval(int interval);

  /// When set to true, advertising set will advertise 4.x Spec compliant
  /// advertisements.
  AdvertisingSetParametersBuilder setLegacyMode(bool isLegacy);

  /// Set the primary physical channel used for this advertising set.
  ///
  /// This is used only if legacy mode is not used.
  ///
  /// Use BluetoothAdapter.isLeCodedPhySupported to determine if LE Coded PHY is
  /// supported on this device.
  AdvertisingSetParametersBuilder setPrimaryPhy(int primaryPhy);

  /// Set whether the advertisement type should be scannable. Legacy advertisements
  /// can be both connectable and scannable. Non-legacy advertisements can be only
  /// scannable or only connectable.
  AdvertisingSetParametersBuilder setScannable(bool scannable);

  /// Set the secondary physical channel used for this advertising set.
  ///
  /// This is used only if legacy mode is not used.
  ///
  /// Use BluetoothAdapter.isLeCodedPhySupported and android.bluetooth.BluetoothAdapter#isLe2MPhySupported
  /// to determine if LE Coded PHY or 2M PHY is supported on this device.
  AdvertisingSetParametersBuilder setSecondaryPhy(int secondaryPhy);

  /// Set the transmission power level for the advertising.
  AdvertisingSetParametersBuilder setTxPowerLevel(int txPowerLevel);
}

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
abstract class BluetoothLeAdvertiser extends Any {
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
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
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
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
abstract class BluetoothLeScanner extends Any {
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

/// The PeriodicAdvertisingParameters provide a way to adjust periodic advertising
/// preferences for each Bluetooth LE advertising set. Use PeriodicAdvertisingParameters.Builder
/// to create an instance of this class.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.PeriodicAdvertisingParameters',
    minAndroidApi: 26,
  ),
)
abstract class PeriodicAdvertisingParameters extends Any {
  /// Returns whether the TX Power will be included.
  bool getIncludeTxPower();

  /// Returns the periodic advertising interval, in 1.25ms unit. Valid values are
  /// from 80 (100ms) to 65519 (81.89875s).
  int getInterval();
}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.PeriodicAdvertisingParameters.Builder',
    minAndroidApi: 26,
  ),
)
abstract class PeriodicAdvertisingParametersBuilder extends Any {
  PeriodicAdvertisingParametersBuilder();

  /// Build the AdvertisingSetParameters object.
  PeriodicAdvertisingParameters build();

  /// Whether the transmission power level should be included in the periodic
  /// packet.
  PeriodicAdvertisingParametersBuilder setIncludeTxPower(bool includeTxPower);

  /// Set advertising interval for periodic advertising, in 1.25ms unit. Valid
  /// values are from 80 (100ms) to 65519 (81.89875s). Value from range
  /// [interval, interval+20ms] will be picked as the actual value.
  PeriodicAdvertisingParametersBuilder setInterval(int interval);
}

/// Bluetooth LE scan callbacks. Scan results are reported using these callbacks.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.ScanCallback',
  ),
)
abstract class ScanCallback extends Any {
  ScanCallback();

  /// Callback when batch results are delivered.
  late final void Function(List<ScanResult> results) onBatchScanResults;

  /// Callback when scan could not be started.
  late final void Function(int errorCode) onScanFailed;

  /// Callback when a BLE advertisement has been found.
  late final void Function(ScanResult result) onScanResult;
}

/// Criteria for filtering result from Bluetooth LE scans. A ScanFilter allows
/// clients to restrict scan results to only those that are of interest to them.
///
/// Current filtering on the following fields are supported:
///
/// * Service UUIDs which identify the bluetooth gatt services running on the device.
/// * Name of remote Bluetooth LE device.
/// * Mac address of the remote device.
/// * Service data which is the data associated with a service.
/// * Manufacturer specific data which is the data associated with a particular manufacturer.
/// * Advertising data type and corresponding data.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.ScanFilter',
  ),
)
abstract class ScanFilter extends Any {
  /// Returns the advertising data of this filter.
  Uint8List? getAdvertisingData();

  /// Returns the advertising data mask of this filter.
  Uint8List? getAdvertisingDataMask();

  /// Returns the advertising data type of this filter. Returns ScanRecord.DATA_TYPE_NONE
  /// if the type is not set. The values of advertising data type are defined in
  /// the Bluetooth Generic Access Profile (https://www.bluetooth.com/specifications/assigned-numbers/)
  int getAdvertisingDataType();
  String? getDeviceAddress();

  /// Returns the filter set the device name field of Bluetooth advertisement
  /// data.
  String? getDeviceName();

  Uint8List? getManufacturerData();
  Uint8List? getManufacturerDataMask();

  /// Returns the manufacturer id. -1 if the manufacturer filter is not set.
  int getManufacturerId();
  Uint8List? getServiceData();
  Uint8List? getServiceDataMask();
  ParcelUuid? getServiceDataUuid();

  /// Returns the filter set on the service Solicitation uuid.
  ParcelUuid? getServiceSolicitationUuid();

  /// Returns the filter set on the service Solicitation uuid mask.
  ParcelUuid? getServiceSolicitationUuidMask();

  /// Returns the filter set on the service uuid.
  ParcelUuid? getServiceUuid();
  ParcelUuid? getServiceUuidMask();

  /// Check if the scan filter matches a scanResult. A scan result is considered
  /// as a match if it matches all the field filters.
  bool matches(ScanResult scanResult);
}

/// Builder class for ScanFilter.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.ScanFilter.Builder',
  ),
)
abstract class ScanFilterBuilder extends Any {
  ScanFilterBuilder();

  /// Build ScanFilter.
  ScanFilter build();

  /// Set filter on advertising data with specific advertising data type.
  ///
  /// The values of advertisingDataType are assigned by Bluetooth SIG. For more
  /// details refer to Bluetooth Generic Access Profile.
  /// (https://www.bluetooth.com/specifications/assigned-numbers/)
  ScanFilterBuilder setAdvertisingDataType(int advertisingDataType);

  /// Set filter on advertising data with specific advertising data type. For any
  /// bit in the mask, set it the 1 if it needs to match the one in advertising
  /// data, otherwise set it to 0.
  ///
  /// The values of advertisingDataType are assigned by Bluetooth SIG. For more
  /// details refer to Bluetooth Generic Access Profile.
  /// (https://www.bluetooth.com/specifications/assigned-numbers/) The
  /// advertisingDataMask must have the same length of advertisingData.
  ScanFilterBuilder setAdvertisingDataTypeWithData(int advertisingDataType,
      Uint8List advertisingData, Uint8List advertisingDataMask);

  /// Set a scan filter on the remote device address.
  ///
  /// The address passed to this API must be in big endian byte order. It needs
  /// to be in the format of "01:02:03:AB:CD:EF". The device address can be
  /// validated using android.bluetooth.BluetoothAdapter#checkBluetoothAddress.
  /// The @AddressType is defaulted to android.bluetooth.BluetoothDevice#ADDRESS_TYPE_PUBLIC.
  ScanFilterBuilder setDeviceAddress(String deviceAddress);

  /// Set filter on device name.
  ScanFilterBuilder setDeviceName(String deviceName);

  /// Set filter on on manufacturerData. A negative manufacturerId is considered
  /// as invalid id.
  ScanFilterBuilder setManufacturerData1(
      int manufacturerId, Uint8List manufacturerData);

  /// Set filter on partial manufacture data. For any bit in the mask, set it the
  /// 1 if it needs to match the one in manufacturer data, otherwise set it to 0.
  ///
  /// The manufacturerDataMask must have the same length of manufacturerData.
  ScanFilterBuilder setManufacturerData2(int manufacturerId,
      Uint8List manufacturerData, Uint8List manufacturerDataMask);

  /// Set filtering on service data.
  ScanFilterBuilder setServiceData1(
      ParcelUuid serviceDataUuid, Uint8List serviceData);

  /// Set partial filter on service data. For any bit in the mask, set it to 1 if
  /// it needs to match the one in service data, otherwise set it to 0 to ignore
  /// that bit.
  ///
  /// The serviceDataMask must have the same length of the serviceData.
  ScanFilterBuilder setServiceData2(ParcelUuid serviceDataUuid,
      Uint8List serviceData, Uint8List serviceDataMask);

  /// Set filter on service solicitation uuid.
  ScanFilterBuilder setServiceSolicitationUuid1(
      ParcelUuid? serviceSolicitationUuid);

  /// Set filter on partial service Solicitation uuid. The SolicitationUuidMask
  /// is the bit mask for the serviceSolicitationUuid. Set any bit in the mask to
  /// 1 to indicate a match is needed for the bit in serviceSolicitationUuid, and
  /// 0 to ignore that bit.
  ScanFilterBuilder setServiceSolicitationUuid2(
      ParcelUuid? serviceSolicitationUuid, ParcelUuid? solicitationUuidMask);

  /// Set filter on service uuid.
  ScanFilterBuilder setServiceUuid1(ParcelUuid serviceUuid);

  /// Set filter on partial service uuid. The uuidMask is the bit mask for the
  /// serviceUuid. Set any bit in the mask to 1 to indicate a match is needed for
  /// the bit in serviceUuid, and 0 to ignore that bit.
  ScanFilterBuilder setServiceUuid2(
      ParcelUuid serviceUuid, ParcelUuid uuidMask);
}

/// Represents a scan record from Bluetooth LE scan.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.ScanRecord',
  ),
)
abstract class ScanRecord extends Any {
  /// Returns the advertising flags indicating the discoverable mode and capability
  /// of the device. Returns -1 if the flag field is not set.
  int getAdvertiseFlags();

  /// Returns a map of advertising data type and its corresponding advertising
  /// data. The values of advertising data type are defined in the Bluetooth
  /// Generic Access Profile (https://www.bluetooth.com/specifications/assigned-numbers/)
  Map<int, Uint8List> getAdvertisingDataMap();

  /// Returns raw bytes of scan record.
  Uint8List getBytes();

  /// Returns the local name of the BLE device. This is a UTF-8 encoded string.
  String? getDeviceName();

  /// Returns a sparse array of manufacturer identifier and its corresponding
  /// manufacturer specific data.
  Map<int, Uint8List> getManufacturerSpecificData1();

  /// Returns the manufacturer specific data associated with the manufacturer id.
  /// Returns null if the manufacturerId is not found.
  Uint8List? getManufacturerSpecificData2(int manufacturerId);

  /// Returns a map of service UUID and its corresponding service data.
  Map<ParcelUuid, Uint8List> getServiceData1();

  /// Returns the service data byte array associated with the serviceUuid. Returns
  /// null if the serviceDataUuid is not found.
  Uint8List? getServiceData2(ParcelUuid serviceDataUuid);

  /// Returns a list of service solicitation UUIDs within the advertisement that
  /// are used to identify the Bluetooth GATT services.
  List<ParcelUuid> getServiceSolicitationUuids();

  /// Returns a list of service UUIDs within the advertisement that are used to
  /// identify the bluetooth GATT services.
  List<ParcelUuid> getServiceUuids();

  /// Returns the transmission power level of the packet in dBm. Returns
  /// Integer.MIN_VALUE if the field is not set. This value can be used to calculate
  /// the path loss of a received packet using the following equation:
  ///
  /// `pathloss = txPowerLevel - rssi`
  int getTxPowerLevel();
}

/// ScanResult for Bluetooth LE scan.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.ScanResult',
  ),
)
abstract class ScanResult extends Any {
  /// Returns the advertising set id. May return ScanResult.SID_NOT_PRESENT if no
  /// set id was is present.
  int getAdvertisingSid();

  /// Returns the data status. Can be one of ScanResult.DATA_COMPLETE or
  /// android.bluetooth.le.ScanResult#DATA_TRUNCATED.
  int getDataStatus();

  /// Returns the remote Bluetooth device identified by the Bluetooth device
  /// address. If the device is bonded, calling BluetoothDevice.getAddress on the
  /// object returned by this method will return the address that was originally
  /// bonded with (either identity address or random address).
  BluetoothDevice getDevice();

  /// Returns the periodic advertising interval in units of 1.25ms. Valid range
  /// is 6 (7.5ms) to 65536 (81918.75ms). A value of ScanResult.PERIODIC_INTERVAL_NOT_PRESENT
  /// means periodic advertising interval is not present.
  int getPeriodicAdvertisingInterval();

  /// Returns the primary Physical Layer on which this advertisement was received.
  /// Can be one of BluetoothDevice.PHY_LE_1M or BluetoothDevice.PHY_LE_CODED.
  int getPrimaryPhy();

  /// Returns the received signal strength in dBm. The valid range is [-127, 126].
  int getRssi();

  /// Returns the scan record, which is a combination of advertisement and scan
  /// response.
  ScanRecord? getScanRecord();

  /// Returns the secondary Physical Layer on which this advertisement was received.
  /// Can be one of BluetoothDevice.PHY_LE_1M, BluetoothDevice.PHY_LE_2M,
  /// android.bluetooth.BluetoothDevice#PHY_LE_CODED or ScanResult.PHY_UNUSED -
  /// if the advertisement was not received on a secondary physical channel.
  int getSecondaryPhy();

  /// Returns timestamp since boot when the scan record was observed.
  int getTimestampNanos();

  /// Returns the transmit power in dBm. Valid range is [-127, 126]. A value of
  /// android.bluetooth.le.ScanResult#TX_POWER_NOT_PRESENT indicates that the TX
  /// power is not present.
  int getTxPower();

  /// Returns true if this object represents connectable scan result.
  bool isConnectable();

  /// Returns true if this object represents legacy scan result. Legacy scan
  /// results do not contain advanced advertising information as specified in the
  /// Bluetooth Core Specification v5.
  bool isLegacy();
}

/// Bluetooth LE scan settings are passed to android.bluetooth.le.BluetoothLeScanner#startScan
/// to define the parameters for the scan.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.ScanSettings',
  ),
)
abstract class ScanSettings extends Any {
  int getCallbackType();

  /// Returns whether only legacy advertisements will be returned. Legacy
  /// advertisements include advertisements as specified by the Bluetooth core
  /// specification 4.2 and below.
  bool getLegacy();

  /// Returns the physical layer used during a scan.
  int getPhy();

  /// Returns report delay timestamp based on the device clock.
  int getReportDelayMillis();
  int getScanMode();
  int getScanResultType();
}

/// Builder for ScanSettings.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.ScanSettings.Builder',
  ),
)
abstract class ScanSettingsBuilder extends Any {
  ScanSettingsBuilder();

  /// Build ScanSettings.
  ScanSettings build();

  /// Set callback type for Bluetooth LE scan.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 23,
  // )
  ScanSettingsBuilder setCallbackType(int callbackType);

  /// Set whether only legacy advertisements should be returned in scan results.
  /// Legacy advertisements include advertisements as specified by the Bluetooth
  /// core specification 4.2 and below. This is true by default for compatibility
  /// with older apps.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  ScanSettingsBuilder setLegacy(bool legacy);

  /// Set match mode for Bluetooth LE scan filters hardware match.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 23,
  // )
  ScanSettingsBuilder setMatchMode(int matchMode);

  /// Set the number of matches for Bluetooth LE scan filters hardware match.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 23,
  // )
  ScanSettingsBuilder setNumOfMatches(int numOfMatches);

  /// Set the Physical Layer to use during this scan. This is used only if
  /// android.bluetooth.le.ScanSettings.Builder#setLegacy is set to false.
  /// android.bluetooth.BluetoothAdapter#isLeCodedPhySupported may be used to
  /// check whether LE Coded phy is supported by calling
  /// android.bluetooth.BluetoothAdapter#isLeCodedPhySupported. Selecting an
  /// unsupported phy will result in failure to start scan.
  // @KotlinProxyApiOptions(
  //   minAndroidApi: 26,
  // )
  ScanSettingsBuilder setPhy(int phy);

  /// Set report delay timestamp for Bluetooth LE scan. If set to 0, you will be
  /// notified of scan results immediately. If > 0, scan results are queued up
  /// and delivered after the requested delay or 5000 milliseconds (whichever is
  /// higher). Note scan results may be delivered sooner if the internal buffers
  /// fill up.
  ScanSettingsBuilder setReportDelay(int reportDelayMillis);

  /// Set scan mode for Bluetooth LE scan.
  ScanSettingsBuilder setScanMode(int scanMode);
}

/// Wrapper for Transport Discovery Data Transport Blocks. This class represents
/// a Transport Block from a Transport Discovery Data.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.TransportBlock',
    minAndroidApi: 33,
  ),
)
abstract class TransportBlock extends Any {}

/// Wrapper for Transport Discovery Data AD Type. This class contains the Transport
/// Discovery Data AD Type Code as well as a list of potential Transport Blocks.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.bluetooth.le.TransportDiscoveryData',
    minAndroidApi: 33,
  ),
)
abstract class TransportDiscoveryData extends Any {}

// https://developer.android.google.cn/reference/kotlin/android/content/package-summary

/// Interface to global information about an application environment. This is an
/// abstract class whose implementation is provided by the Android system. It
/// allows access to application-specific resources and classes, as well as up-calls for application-level operations such as launching activities, broadcasting and receiving intents, etc.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.content.Context',
  ),
)
abstract class Context extends Any {}

@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.content.Intent',
  ),
)
abstract class Intent extends Any {}

// https://developer.android.google.cn/reference/kotlin/android/os/package-summary

/// A Handler allows you to send and process Message and Runnable objects associated
/// with a thread's MessageQueue. Each Handler instance is associated with a single
/// thread and that thread's message queue. When you create a new Handler it is
/// bound to a Looper. It will deliver messages and runnables to that Looper's
/// message queue and execute them on that Looper's thread.
///
/// There are two main uses for a Handler: (1) to schedule messages and runnables
/// to be executed at some point in the future; and (2) to enqueue an action to
/// be performed on a different thread than your own.
///
/// Scheduling messages is accomplished with the post, postAtTime(java.lang.Runnable,long),
/// #postDelayed, sendEmptyMessage, sendMessage, sendMessageAtTime, and
/// sendMessageDelayed methods. The post versions allow you to enqueue Runnable
/// objects to be called by the message queue when they are received; the sendMessage
/// versions allow you to enqueue a Message object containing a bundle of data
/// that will be processed by the Handler's handleMessage method (requiring that
/// you implement a subclass of Handler).
///
/// When posting or sending to a Handler, you can either allow the item to be
/// processed as soon as the message queue is ready to do so, or specify a delay
/// before it gets processed or absolute time for it to be processed. The latter
/// two allow you to implement timeouts, ticks, and other timing-based behavior.
///
/// When a process is created for your application, its main thread is dedicated
/// to running a message queue that takes care of managing the top-level application
/// objects (activities, broadcast receivers, etc) and any windows they create.
/// You can create your own threads, and communicate back with the main application
/// thread through a Handler. This is done by calling the same post or sendMessage
/// methods as before, but from your new thread. The given Runnable or Message
/// will then be scheduled in the Handler's message queue and processed when
/// appropriate.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.os.Handler',
  ),
)
abstract class Handler extends Any {}

/// This class is a Parcelable wrapper around UUID which is an immutable representation
/// of a 128-bit universally unique identifier.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.os.ParcelUuid',
  ),
)
abstract class ParcelUuid extends Any {
  /// Constructor creates a ParcelUuid instance from the given UUID.
  ParcelUuid(UUID uuid);

  /// Creates a new ParcelUuid from a string representation of UUID.
  @static
  ParcelUuid fromString(String uuid);

  /// Get the UUID represented by the ParcelUuid.
  UUID getUuid();
}

// https://developer.android.google.cn/reference/kotlin/java/io/package-summary

/// This abstract class is the superclass of all classes representing an input
/// stream of bytes.
///
/// Applications that need to define a subclass of InputStream must always provide
/// a method that returns the next byte of input.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'java.io.InputStream',
  ),
)
abstract class InputStream extends Any {}

/// This abstract class is the superclass of all classes representing an output
/// stream of bytes. An output stream accepts output bytes and sends them to some
/// sink.
///
/// Applications that need to define a subclass of OutputStream must always provide
/// at least a method that writes one byte of output.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'java.io.OutputStream',
  ),
)
abstract class OutputStream extends Any {}

// https://developer.android.google.cn/reference/kotlin/java/time/package-summary

/// A time-based amount of time, such as '34.5 seconds'.
///
/// This class models a quantity or amount of time in terms of seconds and
/// nanoseconds. It can be accessed using other duration-based units, such as
/// minutes and hours. In addition, the DAYS unit can be used and is treated as
/// exactly equal to 24 hours, thus ignoring daylight savings effects. See Period
/// for the date-based equivalent to this class.
///
/// A physical duration could be of infinite length. For practicality, the duration
/// is stored with constraints similar to Instant. The duration uses nanosecond
/// resolution with a maximum value of the seconds that can be held in a long.
/// This is greater than the current estimated age of the universe.
///
/// The range of a duration requires the storage of a number larger than a long.
/// To achieve this, the class stores a long representing seconds and an int
/// representing nanosecond-of-second, which will always be between 0 and 999,999,999.
/// The model is of a directed duration, meaning that the duration may be negative.
///
/// The duration is measured in "seconds", but these are not necessarily identical
/// to the scientific "SI second" definition based on atomic clocks. This difference
/// only impacts durations measured near a leap-second and should not affect most
/// applications. See Instant for a discussion as to the meaning of the second
/// and time-scales.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'java.time.Duration',
    minAndroidApi: 26,
  ),
)
abstract class Duration extends Any {}

// https://developer.android.google.cn/reference/kotlin/java/util/package-summary

/// Constructs a new UUID using the specified data. mostSigBits is used for the
/// most significant 64 bits of the UUID and leastSigBits becomes the least
/// significant 64 bits of the UUID.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'java.util.UUID',
  ),
)
abstract class UUID extends Any {
  UUID(int mostSigBits, int leastSigBits);

  /// The clock sequence value associated with this UUID.
  ///
  /// The 14 bit clock sequence value is constructed from the clock sequence field
  /// of this UUID. The clock sequence field is used to guarantee temporal uniqueness
  /// in a time-based UUID.
  ///
  /// The clockSequence value is only meaningful in a time-based UUID, which has
  /// version type 1. If this UUID is not a time-based UUID then this method throws
  /// UnsupportedOperationException.
  int clockSequence();

  /// Compares this UUID with the specified UUID.
  ///
  /// The first of two UUIDs is greater than the second if the most significant
  /// field in which the UUIDs differ is greater for the first UUID.
  int compareTo(UUID other);

  /// Creates a UUID from the string standard representation as described in the
  /// toString method.
  @static
  UUID fromString(String name);

  /// Returns the least significant 64 bits of this UUID's 128 bit value.
  int getLeastSignificantBits();

  /// Returns the most significant 64 bits of this UUID's 128 bit value.
  int getMostSignificantBits();

  /// Static factory to retrieve a type 3 (name based) UUID based on the specified
  /// byte array.
  @static
  UUID nameUUIDFromBytes(Uint8List name);

  /// The node value associated with this UUID.
  ///
  /// The 48 bit node value is constructed from the node field of this UUID. This
  /// field is intended to hold the IEEE 802 address of the machine that generated
  /// this UUID to guarantee spatial uniqueness.
  ///
  /// The node value is only meaningful in a time-based UUID, which has version
  /// type 1. If this UUID is not a time-based UUID then this method throws
  /// UnsupportedOperationException.
  int node();

  /// Static factory to retrieve a type 4 (pseudo randomly generated) UUID. The
  /// UUID is generated using a cryptographically strong pseudo random number
  /// generator.
  @static
  UUID randomUUID();

  /// The timestamp value associated with this UUID.
  ///
  /// The 60 bit timestamp value is constructed from the time_low, time_mid, and
  /// time_hi fields of this UUID. The resulting timestamp is measured in
  /// 100-nanosecond units since midnight, October 15, 1582 UTC.
  ///
  /// The timestamp value is only meaningful in a time-based UUID, which has
  /// version type 1. If this UUID is not a time-based UUID then this method throws
  /// UnsupportedOperationException.
  int timestamp();

  /// The variant number associated with this UUID. The variant number describes the layout of the UUID. The variant number has the following meaning:
  ///
  /// * 0 Reserved for NCS backward compatibility
  /// * 2 IETF RFC 4122 (Leach-Salz), used by this class
  /// * 6 Reserved, Microsoft Corporation backward compatibility
  /// * 7 Reserved for future definition
  int variant();
}
