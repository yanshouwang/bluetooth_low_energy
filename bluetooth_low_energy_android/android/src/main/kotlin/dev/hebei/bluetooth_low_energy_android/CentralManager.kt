package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothStatusCodes
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.os.Build
import android.os.ParcelUuid
import java.util.UUID
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

typealias StartDiscoveryCallback = (errorCode: Int?) -> Unit
typealias ConnectCallback = (gatt: BluetoothGatt, status: Int) -> Boolean
typealias DisconnectCallback = (gatt: BluetoothGatt, status: Int) -> Boolean
typealias RequestMTUCallback = (gatt: BluetoothGatt, mtu: Int?, status: Int) -> Boolean
typealias ReadRSSICallback = (gatt: BluetoothGatt, rssi: Int?, status: Int) -> Boolean
typealias DiscoverServicesCallback = (gatt: BluetoothGatt, status: Int) -> Boolean
typealias ReadCharacteristicCallback = (characteristic: BluetoothGattCharacteristic, value: ByteArray?, status: Int) -> Boolean
typealias WriteCharacteristicCallback = (characteristic: BluetoothGattCharacteristic, status: Int) -> Boolean
typealias ReadDescriptorCallback = (descriptor: BluetoothGattDescriptor, value: ByteArray?, status: Int) -> Boolean
typealias WriteDescriptorCallback = (descriptor: BluetoothGattDescriptor, status: Int) -> Boolean

class CentralManager(contextUtil: ContextUtil, activityUtil: ActivityUtil) :
    BluetoothLowEnergyManager(contextUtil, activityUtil) {
    private val gatts = mutableMapOf<BluetoothDevice, BluetoothGatt>()
    private val mtus = mutableMapOf<BluetoothGatt, Int>()

    private val discoveredListeners = mutableListOf<DiscoveredListener>()
    private val connectionStateChangedListeners = mutableListOf<ConnectionStateChangedListener>()
    private val mtuChangedListeners = mutableListOf<MTUChangedListener>()
    private val characteristicNotifiedListeners = mutableListOf<CharacteristicNotifiedListener>()

    private var startDiscoveryCallbacks = mutableListOf<StartDiscoveryCallback>()
    private val connectCallbacks = mutableListOf<ConnectCallback>()
    private val disconnectCallbacks = mutableListOf<DisconnectCallback>()
    private val requestMTUCallbacks = mutableListOf<RequestMTUCallback>()
    private val readRSSICallbacks = mutableListOf<ReadRSSICallback>()
    private val discoverServicesCallbacks = mutableListOf<DiscoverServicesCallback>()
    private val readCharacteristicCallbacks = mutableListOf<ReadCharacteristicCallback>()
    private val writeCharacteristicCallbacks = mutableListOf<WriteCharacteristicCallback>()
    private val readDescriptorCallbacks = mutableListOf<ReadDescriptorCallback>()
    private val writeDescriptorCallbacks = mutableListOf<WriteDescriptorCallback>()

    private val bluetoothLeScanner: BluetoothLeScanner get() = bluetoothAdapter.bluetoothLeScanner

    private val scanCallback = object : ScanCallback() {
        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            invokeStartDiscoveryCallbacks(errorCode)
        }

        override fun onScanResult(callbackType: Int, result: ScanResult) {
            super.onScanResult(callbackType, result)
            val peripheral = Peripheral(result.device)
            val rssi = result.rssi
            val advertisement = result.advertisementWrapper
            for (listener in discoveredListeners) {
                listener.onDiscovered(peripheral, rssi, advertisement)
            }
        }
    }
    private val bluetoothGattCallback = object : BluetoothGattCallback() {
        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            super.onConnectionStateChange(gatt, status, newState)
            val device = gatt.device
            val peripheral = Peripheral(device)
            val state = newState.connectionStateWrapper
            executor.execute {
                // Check connection state
                if (state == ConnectionState.DISCONNECTED) {
                    gatt.close()
                    gatts.remove(device)
                    mtus.remove(gatt)
                }
                // Call connection state changed listeners
                for (listener in connectionStateChangedListeners) {
                    listener.onChanged(peripheral, state)
                }
                // Invoke connect/disconnect callbacks
                invokeConnectCallbacks(gatt, status)
                invokeDisconnectCallbacks(gatt, status)
            }
        }

        override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
            super.onMtuChanged(gatt, mtu, status)
            val device = gatt.device
            val peripheral = Peripheral(device)
            executor.execute {
                mtus[gatt] = mtu
                for (listener in mtuChangedListeners) {
                    listener.onChanged(peripheral, mtu)
                }
                invokeRequestMTUCallbacks(gatt, mtu, status)
            }
        }

        override fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
            super.onReadRemoteRssi(gatt, rssi, status)
            val device = gatt.device
            val peripheral = Peripheral(device)
            executor.execute {
                for (listener in mtuChangedListeners) {
                    listener.onChanged(peripheral, rssi)
                }
                invokeReadRSSICallbacks(gatt, rssi, status)
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            super.onServicesDiscovered(gatt, status)
            executor.execute { invokeDiscoverServicesCallbacks(gatt, status) }
        }

        override fun onServiceChanged(gatt: BluetoothGatt) {
            super.onServiceChanged(gatt)
        }

        // TODO: remove this override when minSdkVersion >= 33
        override fun onCharacteristicRead(
            gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
        ) {
            super.onCharacteristicRead(gatt, characteristic, status)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                return
            }
            val value = characteristic.value
            executor.execute { invokeReadCharacteristicCallbacks(characteristic, value, status) }
        }

        override fun onCharacteristicRead(
            gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray, status: Int
        ) {
            super.onCharacteristicRead(gatt, characteristic, value, status)
            executor.execute { invokeReadCharacteristicCallbacks(characteristic, value, status) }
        }

        override fun onCharacteristicWrite(
            gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
        ) {
            super.onCharacteristicWrite(gatt, characteristic, status)
            executor.execute { invokeWriteCharacteristicCallbacks(characteristic, status) }
        }

        // TODO: remove this override when minSdkVersion >= 33
        override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
            super.onCharacteristicChanged(gatt, characteristic)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                return
            }
            val characteristicWrapper = GATTCharacteristic(gatt, characteristic)
            val value = characteristic.value
            executor.execute {
                for (listener in characteristicNotifiedListeners) {
                    listener.onNotified(characteristicWrapper, value)
                }
            }
        }

        override fun onCharacteristicChanged(
            gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray
        ) {
            super.onCharacteristicChanged(gatt, characteristic, value)
            val characteristicWrapper = GATTCharacteristic(gatt, characteristic)
            executor.execute {
                for (listener in characteristicNotifiedListeners) {
                    listener.onNotified(characteristicWrapper, value)
                }
            }
        }

        // TODO: remove this override when minSdkVersion >= 33
        override fun onDescriptorRead(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
            super.onDescriptorRead(gatt, descriptor, status)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                return
            }
            val value = descriptor.value
            executor.execute { invokeReadDescriptorCallbacks(descriptor, value, status) }
        }

        override fun onDescriptorRead(
            gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int, value: ByteArray
        ) {
            super.onDescriptorRead(gatt, descriptor, status, value)
            executor.execute { invokeReadDescriptorCallbacks(descriptor, value, status) }
        }

        override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
            super.onDescriptorWrite(gatt, descriptor, status)
            executor.execute { invokeWriteDescriptorCallbacks(descriptor, status) }
        }

        override fun onReliableWriteCompleted(gatt: BluetoothGatt, status: Int) {
            super.onReliableWriteCompleted(gatt, status)
        }

        override fun onPhyRead(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
            super.onPhyRead(gatt, txPhy, rxPhy, status)
        }

        override fun onPhyUpdate(gatt: BluetoothGatt, txPhy: Int, rxPhy: Int, status: Int) {
            super.onPhyUpdate(gatt, txPhy, rxPhy, status)
        }
    }

    override val permissions: Array<String>
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) arrayOf(
            android.Manifest.permission.BLUETOOTH_SCAN,
            android.Manifest.permission.BLUETOOTH_CONNECT,
        )
        else arrayOf(
            android.Manifest.permission.ACCESS_COARSE_LOCATION,
            android.Manifest.permission.ACCESS_FINE_LOCATION,
        )
    override val requestCode: Int get() = 443

    fun addDiscoveredListener(listener: DiscoveredListener) {
        discoveredListeners.add(listener)
    }

    fun removeDiscoveredListener(listener: DiscoveredListener) {
        discoveredListeners.remove(listener)
    }

    fun addConnectionStateChangedListener(listener: ConnectionStateChangedListener) {
        connectionStateChangedListeners.add(listener)
    }

    fun removeConnectionStateChangedListener(listener: ConnectionStateChangedListener) {
        connectionStateChangedListeners.remove(listener)
    }

    fun addMTUChangedListener(listener: MTUChangedListener) {
        mtuChangedListeners.add(listener)
    }

    fun removeMTUChangedListener(listener: MTUChangedListener) {
        mtuChangedListeners.remove(listener)
    }

    fun addCharacteristicNotifiedListener(listener: CharacteristicNotifiedListener) {
        characteristicNotifiedListeners.add(listener)
    }

    fun removeCharacteristicNotifiedListener(listener: CharacteristicNotifiedListener) {
        characteristicNotifiedListeners.remove(listener)
    }

    suspend fun startDiscovery(serviceUUIDs: List<UUID>) = suspendCoroutine {
        try {
            ensureState()
            val filters = serviceUUIDs.map { uuid ->
                val serviceUUID = ParcelUuid(uuid)
                ScanFilter.Builder().setServiceUuid(serviceUUID).build()
            }
            val settings = ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
            bluetoothLeScanner.startScan(filters, settings, scanCallback)
            executor.execute { invokeStartDiscoveryCallbacks(null) }
            startDiscoveryCallbacks.add { errorCode ->
                try {
                    if (errorCode != null) throw IllegalStateException("startDiscovery failed: $errorCode")
                    it.resume(Unit)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                }
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    fun stopDiscovery() {
        ensureState()
        bluetoothLeScanner.stopScan(scanCallback)
    }

    fun retrieveConnectedPeripherals(): List<Peripheral> {
        ensureState()
        // The `BluetoothProfile.GATT` and `BluetoothProfile.GATT_SERVER` return same devices.
        val devices = bluetoothManager.getConnectedDevices(BluetoothProfile.GATT)
        val peripherals = devices.map { Peripheral(it) }
        return peripherals
    }

    suspend fun connect(peripheral: Peripheral) = suspendCoroutine {
        try {
            ensureState()
            val device = peripheral.obj
            val autoConnect = false
            val gatt = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val transport = BluetoothDevice.TRANSPORT_LE
                device.connectGatt(context, autoConnect, bluetoothGattCallback, transport)
            } else {
                try {
                    val transport = 2   /* TRANSPORT_LE */
                    // From Android LOLLIPOP (21) the transport types exists, but it is private
                    // have to use reflection to call it for TRANSPORT_LE
                    val method = device.javaClass.getDeclaredMethod(
                        "connectGatt",
                        Context::class.java,
                        Boolean::class.javaPrimitiveType,
                        BluetoothGattCallback::class.java,
                        Int::class.javaPrimitiveType
                    )
                    method.isAccessible = true
                    method.invoke(device, context, autoConnect, bluetoothGattCallback, transport) as BluetoothGatt
                } catch (e: Exception) {
                    // fall back to default method if reflection fails
                    device.connectGatt(context, autoConnect, bluetoothGattCallback)
                }
            }
            gatts[device] = gatt
            connectCallbacks.add { gatt1, status ->
                if (gatt1 != gatt) return@add false
                try {
                    if (status != BluetoothGatt.GATT_SUCCESS) throw IllegalStateException("connect failed: $status")
                    it.resume(Unit)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                }
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    suspend fun disconnect(peripheral: Peripheral) = suspendCoroutine {
        try {
            ensureState()
            val gatt = retrieveGATT(peripheral.obj)
            gatt.disconnect()
            disconnectCallbacks.add { gatt1, status ->
                if (gatt1 != gatt) return@add false
                try {
                    if (status != BluetoothGatt.GATT_SUCCESS) throw IllegalStateException("disconnect failed: $status")
                    it.resume(Unit)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                }
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    suspend fun requestMTU(peripheral: Peripheral, mtu: Int): Int = suspendCoroutine {
        try {
            ensureState()
            val gatt = retrieveGATT(peripheral.obj)
            val ok = gatt.requestMtu(mtu)
            if (!ok) throw IllegalStateException("gatt.requestMtu failed")
            val listener = object : ConnectionStateChangedListener {
                override fun onChanged(peripheral: Peripheral, state: ConnectionState) {
                    if (peripheral.obj != gatt.device || state != ConnectionState.DISCONNECTED) return
                    invokeRequestMTUCallbacks(gatt, null, BluetoothGatt.GATT_FAILURE)
                }
            }
            connectionStateChangedListeners.add(listener)
            requestMTUCallbacks.add { gatt1, mtu1, status ->
                if (gatt1 != gatt) return@add false
                try {
                    if (mtu1 == null || status != BluetoothGatt.GATT_SUCCESS) throw IllegalStateException("reqeustMTU failed: $mtu1, $status")
                    it.resume(mtu1)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                } finally {
                    connectionStateChangedListeners.remove(listener)
                }
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    fun requestConnectionPriority(peripheral: Peripheral, priority: ConnectionPriority) {
        ensureState()
        val gatt = retrieveGATT(peripheral.obj)
        val ok = gatt.requestConnectionPriority(priority.obj)
        if (!ok) throw IllegalStateException("gatt.requestConnectionPriority failed")
    }

    // TODO: Can we write 512 bytes when type is GATTCharacteristicWriteType.withResponse
    fun getMaximumWriteLength(peripheral: Peripheral, type: GATTCharacteristicWriteType): Int {
        ensureState()
        val gatt = retrieveGATT(peripheral.obj)
        val mtu = retrieveMTU(gatt)
        return (mtu - 3).coerceIn(20..512)
    }

    suspend fun readRSSI(peripheral: Peripheral): Int = suspendCoroutine {
        try {
            ensureState()
            val gatt = retrieveGATT(peripheral.obj)
            val ok = gatt.readRemoteRssi()
            if (!ok) throw IllegalStateException("gatt.readRemoteRssi failed")
            val listener = object : ConnectionStateChangedListener {
                override fun onChanged(peripheral: Peripheral, state: ConnectionState) {
                    if (peripheral.obj != gatt.device || state != ConnectionState.DISCONNECTED) return
                    invokeReadRSSICallbacks(gatt, null, BluetoothGatt.GATT_FAILURE)
                }
            }
            connectionStateChangedListeners.add(listener)
            readRSSICallbacks.add { gatt1, rssi, status ->
                if (gatt1 != gatt) return@add false
                try {
                    if (rssi == null || status != BluetoothGatt.GATT_SUCCESS) throw IllegalStateException("readRSSI failed: $rssi, $status")
                    it.resume(rssi)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                } finally {
                    connectionStateChangedListeners.remove(listener)
                }
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    suspend fun discoverServices(peripheral: Peripheral): List<GATTService> = suspendCoroutine {
        try {
            ensureState()
            val gatt = retrieveGATT(peripheral.obj)
            val ok = gatt.discoverServices()
            if (!ok) throw IllegalStateException("gatt.discoverServices failed.")
            val listener = object : ConnectionStateChangedListener {
                override fun onChanged(peripheral: Peripheral, state: ConnectionState) {
                    if (peripheral.obj != gatt.device || state != ConnectionState.DISCONNECTED) return
                    invokeDiscoverServicesCallbacks(gatt, BluetoothGatt.GATT_FAILURE)
                }
            }
            connectionStateChangedListeners.add(listener)
            discoverServicesCallbacks.add { gatt1, status ->
                if (gatt1 != gatt) return@add false
                try {
                    if (status != BluetoothGatt.GATT_SUCCESS) throw IllegalStateException("discoverServices failed: $status")
                    val services = gatt.services.map { obj -> GATTService(gatt, obj) }
                    it.resume(services)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                } finally {
                    connectionStateChangedListeners.remove(listener)
                }
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    suspend fun readCharacteristic(characteristic: GATTCharacteristic): ByteArray = suspendCoroutine {
        try {
            ensureState()
            val gatt = characteristic.gattNotNull
            val ok = gatt.readCharacteristic(characteristic.obj)
            if (!ok) throw IllegalStateException("gatt.readCharacteristic failed.")
            val listener = object : ConnectionStateChangedListener {
                override fun onChanged(peripheral: Peripheral, state: ConnectionState) {
                    if (peripheral.obj != gatt.device || state != ConnectionState.DISCONNECTED) return
                    invokeReadCharacteristicCallbacks(characteristic.obj, null, BluetoothGatt.GATT_FAILURE)
                }
            }
            connectionStateChangedListeners.add(listener)
            readCharacteristicCallbacks.add { characteristic1, value, status ->
                if (characteristic1 != characteristic.obj) return@add false
                try {
                    if (value == null || status != BluetoothGatt.GATT_SUCCESS) throw IllegalStateException("readCharacteristic failed: $value, $status")
                    it.resume(value)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                } finally {
                    connectionStateChangedListeners.remove(listener)
                }
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    suspend fun writeCharacteristic(
        characteristic: GATTCharacteristic, value: ByteArray, type: GATTCharacteristicWriteType
    ) = suspendCoroutine {
        try {
            ensureState()
            val gatt = characteristic.gattNotNull
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val status = gatt.writeCharacteristic(characteristic.obj, value, type.obj)
                if (status != BluetoothStatusCodes.SUCCESS) throw IllegalStateException("gatt.writeCharacteristic failed: $status")
            } else {
                // TODO: remove this when minSdkVersion >= 33
                characteristic.obj.value = value
                characteristic.obj.writeType = type.obj
                val ok = gatt.writeCharacteristic(characteristic.obj)
                if (!ok) throw IllegalStateException("gatt.writeCharacteristic failed")
            }
            val listener = object : ConnectionStateChangedListener {
                override fun onChanged(peripheral: Peripheral, state: ConnectionState) {
                    if (peripheral.obj != gatt.device || state != ConnectionState.DISCONNECTED) return
                    invokeWriteCharacteristicCallbacks(characteristic.obj, BluetoothGatt.GATT_FAILURE)
                }
            }
            connectionStateChangedListeners.add(listener)
            writeCharacteristicCallbacks.add { characteristic1, status ->
                if (characteristic1 != characteristic.obj) return@add false
                try {
                    if (status != BluetoothGatt.GATT_SUCCESS) throw IllegalStateException("writeCharacteristic failed: $status")
                    it.resume(Unit)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                } finally {
                    connectionStateChangedListeners.remove(listener)
                }
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    suspend fun setCharacteristicNotifyState(characteristic: GATTCharacteristic, state: Boolean) {
        ensureState()
        val gatt = characteristic.gattNotNull
        val ok = gatt.setCharacteristicNotification(characteristic.obj, state)
        if (!ok) throw IllegalStateException("gatt.setCharacteristicNotification failed")
        // Seems the docs is not correct, this operation is necessary for all characteristics.
        // https://developer.android.com/guide/topics/connectivity/bluetooth/transfer-ble-data#notification
        val descriptor = characteristic.getDescriptor(GATTDescriptor.CLIENT_CHARACTERISTIC_CONFIG)
        val value = if (state) {
            val canNotify = characteristic.properties.contains(GATTCharacteristicProperty.NOTIFY)
            if (canNotify) GATTDescriptor.ENABLE_NOTIFICATION_VALUE
            else GATTDescriptor.ENABLE_INDICATION_VALUE
        } else GATTDescriptor.DISABLE_NOTIFICATION_VALUE
        writeDescriptor(descriptor, value)
    }

    suspend fun readDescriptor(descriptor: GATTDescriptor): ByteArray = suspendCoroutine {
        try {
            ensureState()
            val gatt = descriptor.gattNotNull
            val ok = gatt.readDescriptor(descriptor.obj)
            if (!ok) throw IllegalStateException("gatt.readDescriptor failed.")
            val listener = object : ConnectionStateChangedListener {
                override fun onChanged(peripheral: Peripheral, state: ConnectionState) {
                    if (peripheral.obj != gatt.device || state != ConnectionState.DISCONNECTED) return
                    invokeReadDescriptorCallbacks(descriptor.obj, null, BluetoothGatt.GATT_FAILURE)
                }
            }
            connectionStateChangedListeners.add(listener)
            readDescriptorCallbacks.add { descriptor1, value, status ->
                if (descriptor1 != descriptor.obj) return@add false
                try {
                    if (value == null || status != BluetoothGatt.GATT_SUCCESS) throw IllegalStateException("readDescriptor failed: $value, $status")
                    it.resume(value)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                } finally {
                    connectionStateChangedListeners.remove(listener)
                }
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    suspend fun writeDescriptor(descriptor: GATTDescriptor, value: ByteArray) = suspendCoroutine {
        try {
            ensureState()
            val gatt = descriptor.gattNotNull
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val status = gatt.writeDescriptor(descriptor.obj, value)
                if (status != BluetoothStatusCodes.SUCCESS) throw IllegalStateException("gatt.writeDescriptor failed: $status")
            } else {
                // TODO: remove this when minSdkVersion >= 33
                descriptor.obj.value = value
                val ok = gatt.writeDescriptor(descriptor.obj)
                if (!ok) throw IllegalStateException("gatt.writeDescriptor failed")
            }
            val listener = object : ConnectionStateChangedListener {
                override fun onChanged(peripheral: Peripheral, state: ConnectionState) {
                    if (peripheral.obj != gatt.device || state != ConnectionState.DISCONNECTED) return
                    invokeWriteDescriptorCallbacks(descriptor.obj, BluetoothGatt.GATT_FAILURE)
                }
            }
            connectionStateChangedListeners.add(listener)
            writeDescriptorCallbacks.add { descriptor1, status ->
                if (descriptor1 != descriptor.obj) return@add false
                try {
                    if (status != BluetoothGatt.GATT_SUCCESS) throw IllegalStateException("writeDescriptor failed: $status")
                    it.resume(Unit)
                } catch (e: Exception) {
                    it.resumeWithException(e)
                } finally {
                    connectionStateChangedListeners.remove(listener)
                }
                return@add true
            }
        } catch (e: Exception) {
            it.resumeWithException(e)
        }
    }

    private fun retrieveGATT(device: BluetoothDevice): BluetoothGatt {
        return gatts[device] ?: throw NullPointerException("gatt is null")
    }

    private fun retrieveMTU(gatt: BluetoothGatt): Int {
        return mtus[gatt] ?: 23
    }

    private fun invokeStartDiscoveryCallbacks(errorCode: Int?) {
        for (callback in startDiscoveryCallbacks) {
            callback(errorCode)
        }
        startDiscoveryCallbacks.clear()
    }

    private fun invokeConnectCallbacks(gatt: BluetoothGatt, status: Int) {
        val callbacks = connectCallbacks.filter { it(gatt, status) }
        connectCallbacks.removeAll(callbacks)
    }

    private fun invokeDisconnectCallbacks(gatt: BluetoothGatt, status: Int) {
        val callbacks = disconnectCallbacks.filter { it(gatt, status) }
        disconnectCallbacks.removeAll(callbacks)
    }

    private fun invokeRequestMTUCallbacks(gatt: BluetoothGatt, mtu: Int?, status: Int) {
        val callbacks = requestMTUCallbacks.filter { it(gatt, mtu, status) }
        requestMTUCallbacks.removeAll(callbacks)
    }

    private fun invokeReadRSSICallbacks(gatt: BluetoothGatt, rssi: Int?, status: Int) {
        val callbacks = readRSSICallbacks.filter { it(gatt, rssi, status) }
        readRSSICallbacks.removeAll(callbacks)
    }

    private fun invokeDiscoverServicesCallbacks(gatt: BluetoothGatt, status: Int) {
        val callbacks = discoverServicesCallbacks.filter { it(gatt, status) }
        discoverServicesCallbacks.removeAll(callbacks)
    }

    private fun invokeReadCharacteristicCallbacks(
        characteristic: BluetoothGattCharacteristic, value: ByteArray?, status: Int
    ) {
        val callbacks = readCharacteristicCallbacks.filter { it(characteristic, value, status) }
        readCharacteristicCallbacks.removeAll(callbacks)
    }

    private fun invokeWriteCharacteristicCallbacks(characteristic: BluetoothGattCharacteristic, status: Int) {
        val callbacks = writeCharacteristicCallbacks.filter { it(characteristic, status) }
        writeCharacteristicCallbacks.removeAll(callbacks)
    }

    private fun invokeReadDescriptorCallbacks(descriptor: BluetoothGattDescriptor, value: ByteArray?, status: Int) {
        val callbacks = readDescriptorCallbacks.filter { it(descriptor, value, status) }
        readDescriptorCallbacks.removeAll(callbacks)
    }

    private fun invokeWriteDescriptorCallbacks(descriptor: BluetoothGattDescriptor, status: Int) {
        val callbacks = writeDescriptorCallbacks.filter { it(descriptor, status) }
        writeDescriptorCallbacks.removeAll(callbacks)
    }

    interface DiscoveredListener {
        fun onDiscovered(peripheral: Peripheral, rssi: Int, advertisement: Advertisement)
    }

    interface ConnectionStateChangedListener {
        fun onChanged(peripheral: Peripheral, state: ConnectionState)
    }

    interface MTUChangedListener {
        fun onChanged(peripheral: Peripheral, mtu: Int)
    }

    interface CharacteristicNotifiedListener {
        fun onNotified(characteristic: GATTCharacteristic, value: ByteArray)
    }
}