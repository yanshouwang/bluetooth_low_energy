package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattServer
import android.bluetooth.BluetoothGattServerCallback
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.os.Build
import android.os.ParcelUuid
import io.flutter.plugin.common.BinaryMessenger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.UUID

class PeripheralManagerImpl(
    messenger: BinaryMessenger,
    private val contextUtil: ContextUtil,
    private val activityUtil: ActivityUtil
) : PeripheralManagerHostApi {
    private val api = PeripheralManagerFlutterApi(messenger)
    private val impl by lazy { PeripheralManager(contextUtil, activityUtil) }

    private var gattServer: BluetoothGattServer? = null

    // Maps for tracking GATT objects
    private val devices = mutableMapOf<String, BluetoothDevice>()
    private val services = mutableMapOf<Long, BluetoothGattService>()
    private val characteristics = mutableMapOf<Long, BluetoothGattCharacteristic>()
    private val descriptors = mutableMapOf<Long, BluetoothGattDescriptor>()

    // Callback maps for async operations
    private var addServiceCallback: ((Result<Unit>) -> Unit)? = null
    private var startAdvertisingCallback: ((Result<Unit>) -> Unit)? = null

    // Map of device address -> callback for notification sent
    private val notifyCharacteristicCallbacks = mutableMapOf<String, (Result<Unit>) -> Unit>()

    private val bluetoothManager: BluetoothManager
        get() = contextUtil.getSystemService(BluetoothManager::class.java)

    private val advertiseCallback = object : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings?) {
            super.onStartSuccess(settingsInEffect)
            val callback = startAdvertisingCallback
            startAdvertisingCallback = null
            callback?.invoke(Result.success(Unit))
        }

        override fun onStartFailure(errorCode: Int) {
            super.onStartFailure(errorCode)
            val callback = startAdvertisingCallback
            startAdvertisingCallback = null
            callback?.invoke(Result.failure(IllegalStateException("Advertising failed with error code: $errorCode")))
        }
    }

    private val gattServerCallback = object : BluetoothGattServerCallback() {
        override fun onServiceAdded(status: Int, service: BluetoothGattService?) {
            super.onServiceAdded(status, service)
            contextUtil.mainExecutor.execute {
                val callback = addServiceCallback
                addServiceCallback = null
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    callback?.invoke(Result.success(Unit))
                } else {
                    callback?.invoke(Result.failure(IllegalStateException("Add service failed with status: $status")))
                }
            }
        }

        override fun onConnectionStateChange(device: BluetoothDevice?, status: Int, newState: Int) {
            super.onConnectionStateChange(device, status, newState)
            if (device == null) return
            contextUtil.mainExecutor.execute {
                devices[device.address] = device
                val central = CentralApi(device.address)
                val state = when (newState) {
                    BluetoothGatt.STATE_CONNECTED -> ConnectionStateApi.CONNECTED
                    BluetoothGatt.STATE_DISCONNECTED -> ConnectionStateApi.DISCONNECTED
                    BluetoothGatt.STATE_CONNECTING -> ConnectionStateApi.CONNECTING
                    BluetoothGatt.STATE_DISCONNECTING -> ConnectionStateApi.DISCONNECTING
                    else -> ConnectionStateApi.DISCONNECTED
                }
                api.onConnectionStateChanged(central, state) {}
            }
        }

        override fun onMtuChanged(device: BluetoothDevice?, mtu: Int) {
            super.onMtuChanged(device, mtu)
            if (device == null) return
            contextUtil.mainExecutor.execute {
                val central = CentralApi(device.address)
                api.onMTUChanged(central, mtu.toLong()) {}
            }
        }

        override fun onCharacteristicReadRequest(
            device: BluetoothDevice?,
            requestId: Int,
            offset: Int,
            characteristic: BluetoothGattCharacteristic?
        ) {
            super.onCharacteristicReadRequest(device, requestId, offset, characteristic)
            if (device == null || characteristic == null) return
            contextUtil.mainExecutor.execute {
                val central = CentralApi(device.address)
                val id = characteristic.hashCode().toLong()
                val request = GATTReadRequestApi(requestId.toLong(), offset.toLong(), 512)
                api.onCharacteristicReadRequested(id, central, request) {}
            }
        }

        override fun onCharacteristicWriteRequest(
            device: BluetoothDevice?,
            requestId: Int,
            characteristic: BluetoothGattCharacteristic?,
            preparedWrite: Boolean,
            responseNeeded: Boolean,
            offset: Int,
            value: ByteArray?
        ) {
            super.onCharacteristicWriteRequest(
                device, requestId, characteristic, preparedWrite, responseNeeded, offset, value
            )
            if (device == null || characteristic == null || value == null) return
            contextUtil.mainExecutor.execute {
                val central = CentralApi(device.address)
                val id = characteristic.hashCode().toLong()
                val request = GATTWriteRequestApi(requestId.toLong(), offset.toLong(), value)
                api.onCharacteristicWriteRequested(id, central, request) {}
            }
        }

        override fun onDescriptorReadRequest(
            device: BluetoothDevice?,
            requestId: Int,
            offset: Int,
            descriptor: BluetoothGattDescriptor?
        ) {
            super.onDescriptorReadRequest(device, requestId, offset, descriptor)
            if (device == null || descriptor == null) return
            contextUtil.mainExecutor.execute {
                // Check if this is a CCCD (Client Characteristic Configuration Descriptor)
                val cccdUuid = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
                if (descriptor.uuid == cccdUuid) {
                    // Handle CCCD read - return current notification state
                    val characteristic = descriptor.characteristic
                    val id = characteristic.hashCode().toLong()
                    val central = CentralApi(device.address)
                    val request = GATTReadRequestApi(requestId.toLong(), offset.toLong(), 2)
                    api.onDescriptorReadRequested(id, central, request) {}
                } else {
                    val central = CentralApi(device.address)
                    val id = descriptor.hashCode().toLong()
                    val request = GATTReadRequestApi(requestId.toLong(), offset.toLong(), 512)
                    api.onDescriptorReadRequested(id, central, request) {}
                }
            }
        }

        override fun onDescriptorWriteRequest(
            device: BluetoothDevice?,
            requestId: Int,
            descriptor: BluetoothGattDescriptor?,
            preparedWrite: Boolean,
            responseNeeded: Boolean,
            offset: Int,
            value: ByteArray?
        ) {
            super.onDescriptorWriteRequest(
                device, requestId, descriptor, preparedWrite, responseNeeded, offset, value
            )
            if (device == null || descriptor == null || value == null) return
            contextUtil.mainExecutor.execute {
                // Check if this is a CCCD (Client Characteristic Configuration Descriptor)
                val cccdUuid = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
                if (descriptor.uuid == cccdUuid) {
                    // Handle CCCD write - notification state change
                    val characteristic = descriptor.characteristic
                    val id = characteristic.hashCode().toLong()
                    val central = CentralApi(device.address)
                    val enableNotification = value.contentEquals(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE)
                    val enableIndication = value.contentEquals(BluetoothGattDescriptor.ENABLE_INDICATION_VALUE)
                    val state = enableNotification || enableIndication
                    api.onCharacteristicNotifyStateChanged(id, central, state) {}

                    // Send response if needed
                    if (responseNeeded) {
                        gattServer?.sendResponse(device, requestId, BluetoothGatt.GATT_SUCCESS, offset, null)
                    }
                } else {
                    val central = CentralApi(device.address)
                    val id = descriptor.hashCode().toLong()
                    val request = GATTWriteRequestApi(requestId.toLong(), offset.toLong(), value)
                    api.onDescriptorWriteRequested(id, central, request) {}
                }
            }
        }

        override fun onNotificationSent(device: BluetoothDevice?, status: Int) {
            super.onNotificationSent(device, status)
            if (device == null) return
            contextUtil.mainExecutor.execute {
                val callback = notifyCharacteristicCallbacks.remove(device.address)
                if (callback != null) {
                    if (status == BluetoothGatt.GATT_SUCCESS) {
                        callback(Result.success(Unit))
                    } else {
                        callback(Result.failure(IllegalStateException("Notification failed with status: $status")))
                    }
                }
            }
        }
    }

    private val stateChangedListener = object : BluetoothLowEnergyManager.StateChangedListener {
        override fun onChanged(state: BluetoothLowEnergyState) {
            api.onStateChanged(state.api) {}
        }
    }

    private val nameChangedListener = object : BluetoothLowEnergyManager.NameChangedListener {
        override fun onChanged(name: String?) {
            api.onNameChanged(name) {}
        }
    }

    override fun addStateChangedListener() {
        impl.addStateChangedListener(stateChangedListener)
    }

    override fun removeStateChangedListener() {
        impl.removeStateChangedListener(stateChangedListener)
    }

    override fun addNameChangedListener() {
        impl.addNameChangedListener(nameChangedListener)
    }

    override fun removeNameChangedListener() {
        impl.removeNameChangedListener(nameChangedListener)
    }

    override fun addConnectionStateChangedListener() {
        // Handled by gattServerCallback
    }

    override fun removeConnectionStateChangedListener() {
        // Handled by gattServerCallback
    }

    override fun addMTUChangedListener() {
        // Handled by gattServerCallback
    }

    override fun removeMTUChangedListener() {
        // Handled by gattServerCallback
    }

    override fun addCharacteristicReadRequestedListener() {
        // Handled by gattServerCallback
    }

    override fun removeCharacteristicReadRequestedListener() {
        // Handled by gattServerCallback
    }

    override fun addCharacteristicWriteRequestedListener() {
        // Handled by gattServerCallback
    }

    override fun removeCharacteristicWriteRequestedListener() {
        // Handled by gattServerCallback
    }

    override fun addCharacteristicNotifyStateChangedListener() {
        // Handled by gattServerCallback
    }

    override fun removeCharacteristicNotifyStateChangedListener() {
        // Handled by gattServerCallback
    }

    override fun addDescriptorReadRequestedListener() {
        // Handled by gattServerCallback
    }

    override fun removeDescriptorReadRequestedListener() {
        // Handled by gattServerCallback
    }

    override fun addDescriptorWriteRequestedListener() {
        // Handled by gattServerCallback
    }

    override fun removeDescriptorWriteRequestedListener() {
        // Handled by gattServerCallback
    }

    override fun getState(): BluetoothLowEnergyStateApi {
        return impl.state.api
    }

    override fun shouldShowAuthorizeRationale(): Boolean {
        return impl.shouldShowAuthorizeRationale()
    }

    override fun authorize(callback: (Result<Boolean>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val authorized = impl.authorize()
                callback(Result.success(authorized))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun showAppSettings() {
        impl.showAppSettings()
    }

    override fun turnOn(callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                impl.turnOn()
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun turnOff(callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                impl.turnOff()
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getName(): String? {
        return impl.name
    }

    override fun setName(name: String?, callback: (Result<String?>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val newName = impl.setName(name)
                callback(Result.success(newName))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun addService(service: MutableGATTServiceApi) {
        val server = gattServer ?: run {
            gattServer = bluetoothManager.openGattServer(contextUtil.context, gattServerCallback)
            gattServer!!
        }

        val gattService = service.toBluetoothGattService()
        services[service.id] = gattService

        // Track characteristics and descriptors
        for (charApi in service.characteristics) {
            val gattChar = gattService.characteristics.find { it.uuid.toString() == charApi.uuid }
            if (gattChar != null) {
                characteristics[charApi.id] = gattChar
                for (descApi in charApi.descriptors) {
                    val gattDesc = gattChar.descriptors.find { it.uuid.toString() == descApi.uuid }
                    if (gattDesc != null) {
                        descriptors[descApi.id.toLong()] = gattDesc
                    }
                }
            }
        }

        server.addService(gattService)
    }

    override fun removeService(id: Long) {
        val service = services.remove(id)
        if (service != null) {
            gattServer?.removeService(service)
        }
    }

    override fun removeAllServices() {
        gattServer?.clearServices()
        services.clear()
        characteristics.clear()
        descriptors.clear()
    }

    override fun startAdvertising(advertisement: AdvertisementApi, callback: (Result<Unit>) -> Unit) {
        try {
            val advertiser = bluetoothManager.adapter.bluetoothLeAdvertiser
                ?: throw IllegalStateException("BluetoothLeAdvertiser is not available")

            val settings = AdvertiseSettings.Builder()
                .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_BALANCED)
                .setConnectable(true)
                .setTimeout(0)
                .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_MEDIUM)
                .build()

            val dataBuilder = AdvertiseData.Builder()
            for (uuid in advertisement.serviceUUIDs) {
                dataBuilder.addServiceUuid(ParcelUuid.fromString(uuid))
            }
            for ((uuid, data) in advertisement.serviceData) {
                dataBuilder.addServiceData(ParcelUuid.fromString(uuid), data)
            }
            for (msd in advertisement.manufacturerSpecificData) {
                dataBuilder.addManufacturerData(msd.id.toInt(), msd.data)
            }
            val advertiseData = dataBuilder.build()

            val scanResponseBuilder = AdvertiseData.Builder()
            if (advertisement.name != null) {
                scanResponseBuilder.setIncludeDeviceName(true)
            }
            val scanResponse = scanResponseBuilder.build()

            startAdvertisingCallback = callback
            advertiser.startAdvertising(settings, advertiseData, scanResponse, advertiseCallback)
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    override fun stopAdvertising() {
        val advertiser = bluetoothManager.adapter.bluetoothLeAdvertiser
        advertiser?.stopAdvertising(advertiseCallback)
    }

    override fun getMaximumNotifyLength(address: String): Long {
        // Default MTU is 23, minus 3 bytes for ATT header = 20 bytes
        // Maximum is 512 bytes
        return 512
    }

    override fun respondReadRequestWithValue(id: Long, value: ByteArray) {
        val requestId = id.toInt()
        // Find the device that made this request - we need to track this
        for ((_, device) in devices) {
            gattServer?.sendResponse(device, requestId, BluetoothGatt.GATT_SUCCESS, 0, value)
            break
        }
    }

    override fun respondReadRequestWithError(id: Long, error: GATTErrorApi) {
        val requestId = id.toInt()
        val status = error.toGattStatus()
        for ((_, device) in devices) {
            gattServer?.sendResponse(device, requestId, status, 0, null)
            break
        }
    }

    override fun respondWriteRequest(id: Long) {
        val requestId = id.toInt()
        for ((_, device) in devices) {
            gattServer?.sendResponse(device, requestId, BluetoothGatt.GATT_SUCCESS, 0, null)
            break
        }
    }

    override fun respondWriteRequestWithError(id: Long, error: GATTErrorApi) {
        val requestId = id.toInt()
        val status = error.toGattStatus()
        for ((_, device) in devices) {
            gattServer?.sendResponse(device, requestId, status, 0, null)
            break
        }
    }

    override fun notifyCharacteristic(
        id: Long,
        value: ByteArray,
        addresses: List<String>?,
        callback: (Result<Unit>) -> Unit
    ) {
        try {
            val server = gattServer ?: throw IllegalStateException("GATT server not initialized")
            val characteristic = characteristics[id]
                ?: throw IllegalArgumentException("Characteristic not found: $id")

            // Determine which devices to notify
            val targetAddresses = addresses ?: devices.keys.toList()
            if (targetAddresses.isEmpty()) {
                callback(Result.success(Unit))
                return
            }

            // For simplicity, notify one device at a time and wait for callback
            // In a more sophisticated implementation, we could track multiple pending notifications
            val address = targetAddresses.first()
            val device = devices[address]
                ?: throw IllegalArgumentException("Device not found: $address")

            // Store the callback to be invoked when onNotificationSent is called
            notifyCharacteristicCallbacks[address] = callback

            // Send the notification
            val notifying = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val statusCode = server.notifyCharacteristicChanged(
                    device,
                    characteristic,
                    false, // confirm = false for notifications, true for indications
                    value
                )
                statusCode == BluetoothStatusCodes.SUCCESS
            } else {
                @Suppress("DEPRECATION")
                characteristic.value = value
                @Suppress("DEPRECATION")
                server.notifyCharacteristicChanged(device, characteristic, false)
            }

            if (!notifying) {
                notifyCharacteristicCallbacks.remove(address)
                callback(Result.failure(IllegalStateException("Failed to send notification")))
            }
            // Otherwise, callback will be invoked in onNotificationSent
        } catch (e: Exception) {
            callback(Result.failure(e))
        }
    }

    private fun MutableGATTServiceApi.toBluetoothGattService(): BluetoothGattService {
        val serviceType = if (isPrimary) BluetoothGattService.SERVICE_TYPE_PRIMARY
        else BluetoothGattService.SERVICE_TYPE_SECONDARY
        val service = BluetoothGattService(UUID.fromString(uuid), serviceType)

        for (charApi in characteristics) {
            val properties = charApi.properties.fold(0) { acc, prop ->
                acc or when (prop) {
                    GATTCharacteristicPropertyApi.READ -> BluetoothGattCharacteristic.PROPERTY_READ
                    GATTCharacteristicPropertyApi.WRITE -> BluetoothGattCharacteristic.PROPERTY_WRITE
                    GATTCharacteristicPropertyApi.WRITE_WITHOUT_RESPONSE -> BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE
                    GATTCharacteristicPropertyApi.NOTIFY -> BluetoothGattCharacteristic.PROPERTY_NOTIFY
                    GATTCharacteristicPropertyApi.INDICATE -> BluetoothGattCharacteristic.PROPERTY_INDICATE
                }
            }
            val permissions = charApi.permissions.fold(0) { acc, perm ->
                acc or when (perm) {
                    GATTPermissionApi.READ -> BluetoothGattCharacteristic.PERMISSION_READ
                    GATTPermissionApi.READ_ENCRYPTED -> BluetoothGattCharacteristic.PERMISSION_READ_ENCRYPTED
                    GATTPermissionApi.WRITE -> BluetoothGattCharacteristic.PERMISSION_WRITE
                    GATTPermissionApi.WRITE_ENCRYPTED -> BluetoothGattCharacteristic.PERMISSION_WRITE_ENCRYPTED
                }
            }
            val characteristic = BluetoothGattCharacteristic(
                UUID.fromString(charApi.uuid),
                properties,
                permissions
            )

            // Add CCCD if notify or indicate is supported
            if (properties and (BluetoothGattCharacteristic.PROPERTY_NOTIFY or BluetoothGattCharacteristic.PROPERTY_INDICATE) != 0) {
                val cccd = BluetoothGattDescriptor(
                    UUID.fromString("00002902-0000-1000-8000-00805f9b34fb"),
                    BluetoothGattDescriptor.PERMISSION_READ or BluetoothGattDescriptor.PERMISSION_WRITE
                )
                characteristic.addDescriptor(cccd)
            }

            for (descApi in charApi.descriptors) {
                val descPermissions =
                    BluetoothGattDescriptor.PERMISSION_READ or BluetoothGattDescriptor.PERMISSION_WRITE
                val descriptor = BluetoothGattDescriptor(
                    UUID.fromString(descApi.uuid),
                    descPermissions
                )
                characteristic.addDescriptor(descriptor)
            }

            service.addCharacteristic(characteristic)
        }

        return service
    }

    private fun GATTErrorApi.toGattStatus(): Int {
        return when (this) {
            GATTErrorApi.SUCCESS -> BluetoothGatt.GATT_SUCCESS
            GATTErrorApi.READ_NOT_PERMITTED -> BluetoothGatt.GATT_READ_NOT_PERMITTED
            GATTErrorApi.WRITE_NOT_PERMITTED -> BluetoothGatt.GATT_WRITE_NOT_PERMITTED
            GATTErrorApi.INSUFFICIENT_AUTHENTICATION -> BluetoothGatt.GATT_INSUFFICIENT_AUTHENTICATION
            GATTErrorApi.REQUEST_NOT_SUPPORTED -> BluetoothGatt.GATT_REQUEST_NOT_SUPPORTED
            GATTErrorApi.INSUFFICIENT_ENCRYPTION -> BluetoothGatt.GATT_INSUFFICIENT_ENCRYPTION
            GATTErrorApi.INVALID_OFFSET -> BluetoothGatt.GATT_INVALID_OFFSET
            GATTErrorApi.INSUFFICIENT_AUTHORIZATION -> 0x08 // GATT_INSUFFICIENT_AUTHORIZATION
            GATTErrorApi.INVALID_ATTRIBUTE_LENGTH -> BluetoothGatt.GATT_INVALID_ATTRIBUTE_LENGTH
            GATTErrorApi.CONNECTION_CONGESTED -> BluetoothGatt.GATT_CONNECTION_CONGESTED
            GATTErrorApi.FAILURE -> BluetoothGatt.GATT_FAILURE
        }
    }
}
