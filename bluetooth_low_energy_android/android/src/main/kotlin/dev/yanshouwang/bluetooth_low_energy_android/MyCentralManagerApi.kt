package dev.yanshouwang.bluetooth_low_energy_android

import MyCentralManagerFlutterApi
import MyCentralManagerHostApi
import MyCentralManagerState
import MyGattCharacteristic
import MyGattCharacteristicWriteType
import MyGattDescriptor
import MyGattService
import MyPeripheral
import MyPeripheralState
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import java.nio.ByteBuffer
import java.util.UUID

class MyCentralManagerApi(private val context: Context, binaryMessenger: BinaryMessenger) :
    MyCentralManagerHostApi {
    companion object {
        private const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
    }

    private val api = MyCentralManagerFlutterApi(binaryMessenger)

    private val mainHandler = Handler(context.mainLooper)
    private val mainExecutor = ContextCompat.getMainExecutor(context)

    private val hasFeature
        get() = context.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)

    private val bluetoothManager
        get() = ContextCompat.getSystemService(
            context, BluetoothManager::class.java
        ) as BluetoothManager

    private val bluetoothAdapter
        get() = bluetoothManager.adapter as BluetoothAdapter

    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val oldState = intent.getIntExtra(
                BluetoothAdapter.EXTRA_PREVIOUS_STATE, BluetoothAdapter.STATE_OFF
            )
            val newState = intent.getIntExtra(
                BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF
            )
            if (newState == oldState) return
            val myState = when (newState) {
                BluetoothAdapter.STATE_ON -> MyCentralManagerState.POWEREDON
                else -> MyCentralManagerState.POWEREDOFF
            }.raw.toLong()
            api.onStateChanged(myState) {}
        }
    }

    private val scanCallback = object : ScanCallback() {
        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            scanError = BluetoothLowEnergyError("Start scan failed with code: $errorCode")
        }

        override fun onScanResult(callbackType: Int, result: ScanResult) {
            super.onScanResult(callbackType, result)
            onScanned(result)
        }

        override fun onBatchScanResults(results: MutableList<ScanResult>) {
            super.onBatchScanResults(results)
            for (result in results) {
                onScanned(result)
            }
        }
    }

    private val bluetoothGattCallback = object : BluetoothGattCallback() {
        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            super.onConnectionStateChange(gatt, status, newState)
            // NOTICE: 不要通过 status 判断是否为连接成功，测试发现某为在连接丢失时 status 也是 GATT_SUCCESS
            val id = gatt.device.address
            val isConnected =
                status == BluetoothGatt.GATT_SUCCESS && newState == BluetoothProfile.STATE_CONNECTED
            val result = if (isConnected) {
                gatts[id] = gatt
                Result.success(Unit)
            } else {
                gatt.close()
                gatts.remove(id)
                val error =
                    BluetoothLowEnergyError("GATT connect failed, status: $status; newState: $newState")
                Result.failure(error)
            }
            val callback = connectCallbacks.remove(id)
            if (callback != null) {
                callback(result)
            }
            val myState = if (isConnected) {
                MyPeripheralState.CONNECTED
            } else {
                MyPeripheralState.DISCONNECTED
            }.raw.toLong()
            mainExecutor.execute {
                api.onPeripheralStateChanged(id, myState) {}
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            super.onServicesDiscovered(gatt, status)
            val id = gatt.device.address
            val callback =
                discoverServicesCallbacks.remove(id) as (Result<List<MyGattService>>) -> Unit
            val result = if (status == BluetoothGatt.GATT_SUCCESS) {
                val myServices = gatt.services.map { service -> service.myService }
                Result.success(myServices)
            } else {
                val error =
                    BluetoothLowEnergyError("GATT discover services failed with status: $status")
                Result.failure(error)
            }
            callback(result)
        }

        override fun onCharacteristicRead(
            gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
        ) {
            super.onCharacteristicRead(gatt, characteristic, status)
            val id = gatt.device.address
            val serviceId = characteristic.service.uuid.toString()
            val characteristicId = characteristic.uuid.toString()
            val callback =
                readCharacteristicCallbacks.remove("$id/$serviceId/$characteristicId") as (Result<ByteArray>) -> Unit
            val result = if (status == BluetoothGatt.GATT_SUCCESS) {
                Result.success(characteristic.value)
            } else {
                val error =
                    BluetoothLowEnergyError("GATT read characteristic failed with status: $status.")
                Result.failure(error)
            }
            callback(result)
        }

        override fun onCharacteristicWrite(
            gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int
        ) {
            super.onCharacteristicWrite(gatt, characteristic, status)
            val id = gatt.device.address
            val serviceId = characteristic.service.uuid.toString()
            val characteristicId = characteristic.uuid.toString()
            val callback =
                writeCharacteristicCallbacks.remove("$id/$serviceId/$characteristicId") as (Result<Unit>) -> Unit
            val result = if (status == BluetoothGatt.GATT_SUCCESS) {
                Result.success(Unit)
            } else {
                val error =
                    BluetoothLowEnergyError("GATT write characteristic failed with status: $status.")
                Result.failure(error)
            }
            callback(result)
        }

        override fun onCharacteristicChanged(
            gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic
        ) {
            super.onCharacteristicChanged(gatt, characteristic)
            val id = gatt.device.address
            val serviceId = characteristic.service.uuid.toString()
            val characteristicId = characteristic.uuid.toString()
            val value = characteristic.value
            mainExecutor.execute {
                api.onCharacteristicValueChanged(id, serviceId, characteristicId, value) {}
            }
        }

        override fun onDescriptorRead(
            gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int
        ) {
            super.onDescriptorRead(gatt, descriptor, status)
            val id = gatt.device.address
            val serviceId = descriptor.characteristic.service.uuid.toString()
            val characteristicId = descriptor.characteristic.uuid.toString()
            val descriptorId = descriptor.uuid.toString()
            val callback =
                readDescriptorCallbacks.remove("$id/$serviceId/$characteristicId/$descriptorId") as (Result<ByteArray>) -> Unit
            val result = if (status == BluetoothGatt.GATT_SUCCESS) {
                Result.success(descriptor.value)
            } else {
                val error =
                    BluetoothLowEnergyError("GATT read descriptor failed with status: $status.")
                Result.failure(error)
            }
            callback(result)
        }

        override fun onDescriptorWrite(
            gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int
        ) {
            super.onDescriptorWrite(gatt, descriptor, status)
            val id = gatt.device.address
            val serviceId = descriptor.characteristic.service.uuid.toString()
            val characteristicId = descriptor.characteristic.uuid.toString()
            val descriptorId = descriptor.uuid.toString()
            val callback =
                writeDescriptorCallbacks.remove("$id/$serviceId/$characteristicId/$descriptorId") as (Result<Unit>) -> Unit
            val result = if (status == BluetoothGatt.GATT_SUCCESS) {
                Result.success(Unit)
            } else {
                val error =
                    BluetoothLowEnergyError("GATT write descriptor failed with status: $status.")
                Result.failure(error)
            }
            callback(result)
        }
    }

    private var scanError: Throwable? = null

    private val gatts = mutableMapOf<String, BluetoothGatt>()

    private val connectCallbacks = mutableMapOf<String, (Result<Unit>) -> Unit>()
    private val discoverServicesCallbacks =
        mutableMapOf<String, (Result<List<MyGattService>>) -> Unit>()
    private val readCharacteristicCallbacks = mutableMapOf<String, (Result<ByteArray>) -> Unit>()
    private val writeCharacteristicCallbacks = mutableMapOf<String, (Result<Unit>) -> Unit>()
    private val readDescriptorCallbacks = mutableMapOf<String, (Result<ByteArray>) -> Unit>()
    private val writeDescriptorCallbacks = mutableMapOf<String, (Result<Unit>) -> Unit>()

    init {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(receiver, filter)
    }

    private fun onScanned(result: ScanResult) {
        val device = result.device
        val id = device.address
        val name = device.name
        val rssi = result.rssi.toLong()
        val myManufacturerSpecificData = result.myManufacturerSpecificData
        val myPeripheral = MyPeripheral(id, rssi, name, myManufacturerSpecificData)
        api.onDiscovered(myPeripheral) {}
    }

    override fun getState(): Long {
        return if (hasFeature) {
            bluetoothAdapter.myState
        } else {
            MyCentralManagerState.UNSUPPORTED
        }.raw.toLong()
    }

    override fun startDiscovery(callback: (Result<Unit>) -> Unit) {
        bluetoothAdapter.bluetoothLeScanner.startScan(scanCallback)
        // Use main handler.post to delay until ScanCallback.onScanFailed executed.
        mainHandler.post {
            val error = this.scanError
            val result = if (error == null) {
                Result.success(Unit)
            } else {
                Result.failure(error)
            }
            callback(result)
        }
    }

    override fun stopDiscovery() {
        bluetoothAdapter.bluetoothLeScanner.stopScan(scanCallback)
    }

    override fun connect(id: String, callback: (Result<Unit>) -> Unit) {
        val device = bluetoothAdapter.getRemoteDevice(id)
        val autoConnect = false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val transport = BluetoothDevice.TRANSPORT_LE
            device.connectGatt(context, autoConnect, bluetoothGattCallback, transport)
        } else {
            device.connectGatt(context, autoConnect, bluetoothGattCallback)
        }
        connectCallbacks[id] = callback
        val myState = MyPeripheralState.CONNECTING.raw.toLong()
        api.onPeripheralStateChanged(id, myState) {}
    }

    override fun disconnect(id: String) {
        val gatt = gatts[id] as BluetoothGatt
        gatt.disconnect()
    }

    override fun discoverServices(id: String, callback: (Result<List<MyGattService>>) -> Unit) {
        val gatt = gatts[id] as BluetoothGatt
        val isSuccessful = gatt.discoverServices()
        if (isSuccessful) {
            discoverServicesCallbacks[id] = callback
        } else {
            val error = BluetoothLowEnergyError("GATT discover services failed.")
            val result = Result.failure<List<MyGattService>>(error)
            callback(result)
        }
    }

    override fun readCharacteristic(
        id: String,
        serviceId: String,
        characteristicId: String,
        callback: (Result<ByteArray>) -> Unit
    ) {
        val serviceUUID = UUID.fromString(serviceId)
        val characteristicUUID = UUID.fromString(characteristicId)
        val gatt = gatts[id] as BluetoothGatt
        val service = gatt.getService(serviceUUID)
        val characteristic = service.getCharacteristic(characteristicUUID)
        val isSuccessful = gatt.readCharacteristic(characteristic)
        if (isSuccessful) {
            readCharacteristicCallbacks["$id/$serviceId/$characteristicId"] = callback
        } else {
            val error = BluetoothLowEnergyError("GATT read characteristic failed.")
            val result = Result.failure<ByteArray>(error)
            callback(result)
        }
    }

    override fun writeCharacteristic(
        id: String,
        serviceId: String,
        characteristicId: String,
        value: ByteArray,
        type: Long,
        callback: (Result<Unit>) -> Unit
    ) {
        val serviceUUID = UUID.fromString(serviceId)
        val characteristicUUID = UUID.fromString(characteristicId)
        val gatt = gatts[id] as BluetoothGatt
        val service = gatt.getService(serviceUUID)
        val characteristic = service.getCharacteristic(characteristicUUID)
        val myType =
            MyGattCharacteristicWriteType.ofRaw(type.toInt()) as MyGattCharacteristicWriteType
        characteristic.value = value
        characteristic.writeType = myType.nativeType
        val isSuccessful = gatt.writeCharacteristic(characteristic)
        if (isSuccessful) {
            writeCharacteristicCallbacks["$id/$serviceId/$characteristicId"] = callback
        } else {
            val error = BluetoothLowEnergyError("GATT read characteristic failed.")
            val result = Result.failure<Unit>(error)
            callback(result)
        }
    }

    override fun notifyCharacteristic(
        id: String,
        serviceId: String,
        characteristicId: String,
        value: Boolean,
        callback: (Result<Unit>) -> Unit
    ) {
        val serviceUUID = UUID.fromString(serviceId)
        val characteristicUUID = UUID.fromString(characteristicId)
        val gatt = gatts[id] as BluetoothGatt
        val service = gatt.getService(serviceUUID)
        val characteristic = service.getCharacteristic(characteristicUUID)
        val isSuccessful = gatt.setCharacteristicNotification(characteristic, value)
        if (isSuccessful) {
            /// Write client characteristic config descriptor
            val cccValue = if (value) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
            else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
            writeDescriptor(
                id, serviceId, characteristicId, CLIENT_CHARACTERISTIC_CONFIG, cccValue, callback
            )
        } else {
            val error = BluetoothLowEnergyError("GATT set characteristic notification failed.")
            val result = Result.failure<Unit>(error)
            callback(result)
        }
    }

    override fun readDescriptor(
        id: String,
        serviceId: String,
        characteristicId: String,
        descriptorId: String,
        callback: (Result<ByteArray>) -> Unit
    ) {
        val serviceUUID = UUID.fromString(serviceId)
        val characteristicUUID = UUID.fromString(characteristicId)
        val descriptorUUID = UUID.fromString(descriptorId)
        val gatt = gatts[id] as BluetoothGatt
        val service = gatt.getService(serviceUUID)
        val characteristic = service.getCharacteristic(characteristicUUID)
        val descriptor = characteristic.getDescriptor(descriptorUUID)
        val isSuccessful = gatt.readDescriptor(descriptor)
        if (isSuccessful) {
            readDescriptorCallbacks["$id/$serviceId/$characteristicId/$descriptorId"] = callback
        } else {
            val error = BluetoothLowEnergyError("GATT read descriptor failed.")
            val result = Result.failure<ByteArray>(error)
            callback(result)
        }
    }

    override fun writeDescriptor(
        id: String,
        serviceId: String,
        characteristicId: String,
        descriptorId: String,
        value: ByteArray,
        callback: (Result<Unit>) -> Unit
    ) {
        val serviceUUID = UUID.fromString(serviceId)
        val characteristicUUID = UUID.fromString(characteristicId)
        val descriptorUUID = UUID.fromString(descriptorId)
        val gatt = gatts[id] as BluetoothGatt
        val service = gatt.getService(serviceUUID)
        val characteristic = service.getCharacteristic(characteristicUUID)
        val descriptor = characteristic.getDescriptor(descriptorUUID)
        descriptor.value = value
        val isSuccessful = gatt.writeDescriptor(descriptor)
        if (isSuccessful) {
            writeDescriptorCallbacks["$id/$serviceId/$characteristicId/$descriptorId"] = callback
        } else {
            val error = BluetoothLowEnergyError("GATT write descriptor failed.")
            val result = Result.failure<Unit>(error)
            callback(result)
        }
    }
}

val BluetoothAdapter.myState: MyCentralManagerState
    get() {
        return when (state) {
            BluetoothAdapter.STATE_ON -> MyCentralManagerState.POWEREDON
            else -> MyCentralManagerState.POWEREDOFF
        }
    }

val ScanResult.myManufacturerSpecificData: ByteArray?
    get() {
        val scanRecord = this.scanRecord
        if (scanRecord == null || scanRecord.manufacturerSpecificData.size() == 0) return null
        val key = scanRecord.manufacturerSpecificData.keyAt(0)
        val vid = ByteBuffer.allocate(4).putInt(key).array()
        val value = scanRecord.manufacturerSpecificData.valueAt(0)
        return vid.plus(value)
    }

val BluetoothGattService.myService: MyGattService
    get() {
        val id = uuid.toString()
        val myCharacteristics =
            characteristics.map { characteristic -> characteristic.myCharacteristic }
        return MyGattService(id, myCharacteristics)
    }

val BluetoothGattCharacteristic.myCharacteristic: MyGattCharacteristic
    get() {
        val id = uuid.toString()
        val canRead = properties and BluetoothGattCharacteristic.PROPERTY_READ != 0
        val canWrite = properties and BluetoothGattCharacteristic.PROPERTY_WRITE != 0
        val canWriteWithoutResponse =
            properties and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0
        val canNotify = properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
        val myDescriptors = descriptors.map { descriptor -> descriptor.myDescriptor }
        return MyGattCharacteristic(
            id, canRead, canWrite, canWriteWithoutResponse, canNotify, myDescriptors
        )
    }

val BluetoothGattDescriptor.myDescriptor: MyGattDescriptor
    get() {
        val id = uuid.toString()
        return MyGattDescriptor(id)
    }

val MyGattCharacteristicWriteType.nativeType: Int
    get() = when (this) {
        MyGattCharacteristicWriteType.WITHRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        MyGattCharacteristicWriteType.WITHOUTRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
    }