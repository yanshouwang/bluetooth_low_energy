package dev.yanshouwang.bluetooth_low_energy_android

import CentralManagerFlutterApi
import CentralManagerHostApi
import CentralManagerStateArgs
import CentralManagerStateEventArgs
import GattCharacteristicWriteTypeArgs
import GattServiceArgs
import PeripheralArgs
import PeripheralEventArgs
import android.bluetooth.*
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
import java.util.*
import java.util.concurrent.Executor

class PigeonCentralManager(
    private val context: Context,
    binaryMessenger: BinaryMessenger
) : CentralManagerHostApi {
    companion object {
        private const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"
    }

    private val flutterApi = CentralManagerFlutterApi(binaryMessenger)
    private val mainHandler get() = Handler(context.mainLooper)
    private val mainExecutor: Executor get() = ContextCompat.getMainExecutor(context)
    private val hasBluetoothLowEnergyFeature
        get() = context.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)
    private val bluetoothManager
        get() = ContextCompat.getSystemService(context, BluetoothManager::class.java) as BluetoothManager
    private val bluetoothAdapter
        get() = bluetoothManager.adapter as BluetoothAdapter

    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val previousState = intent.getIntExtra(BluetoothAdapter.EXTRA_PREVIOUS_STATE, -1)
            val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, -1)
            if (state == previousState) return
            val stateArgs = when (state) {
                BluetoothAdapter.STATE_ON -> CentralManagerStateArgs.POWEREDON
                else -> CentralManagerStateArgs.POWEREDOFF
            }
            val eventArgs = CentralManagerStateEventArgs(stateArgs)
            flutterApi.onStateChanged(eventArgs) {}
        }
    }

    private val scanCallback = object : ScanCallback() {
        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            error = BluetoothLowEnergyError("Start scan failed with code: $errorCode")
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
        }
    }

    private val bluetoothGatts = mutableMapOf<String, BluetoothGatt>()
    private val connectCallbacks = mutableMapOf<String, (Result<Unit>) -> Unit>()

    private var error: Throwable? = null

    private fun onScanned(result: ScanResult) {
        val device = result.device
        val id = device.address
        val name = device.name
        val rssi = result.rssi.toLong()
        val manufacturerSpecificData = result.manufacturerSpecificData
        val peripheralArgs = PeripheralArgs(id, name, rssi, manufacturerSpecificData)
        val eventArgs = PeripheralEventArgs(peripheralArgs)
        flutterApi.onScanned(eventArgs) {}
    }

    override fun initialize() {
        val stateArgs = if (hasBluetoothLowEnergyFeature) {
            bluetoothAdapter.stateArgs
        } else {
            CentralManagerStateArgs.UNSUPPORTED
        }
        val eventArgs = CentralManagerStateEventArgs(stateArgs)
        flutterApi.onStateChanged(eventArgs) {}
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(receiver, filter)
    }

    override fun startScan(callback: (Result<Unit>) -> Unit) {
        bluetoothAdapter.bluetoothLeScanner.startScan(scanCallback)
        // Use main handler.post to delay until ScanCallback.onScanFailed executed.
        mainHandler.post {
            val error = this.error
            val result = if (error == null) {
                Result.success(Unit)
            } else {
                Result.failure(error)
            }
            callback(result)
        }
    }

    override fun stopScan() {
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
    }

    override fun disconnect(id: String) {
        val gatt = bluetoothGatts.remove(id) as BluetoothGatt
        gatt.disconnect()
    }

    override fun discoverService(id: String, serviceId: String): GattServiceArgs {
        val gatt = bluetoothGatts.remove(id) as BluetoothGatt
        val isOK = gatt.discoverServices()
        if (isOK) {
        } else {
            final error = BluetoothLowEnergyError ("GATT discover services failed.")
        }
    }

    override fun read(id: String, serviceId: String, characteristicId: String): ByteArray {
        val serviceUUID = UUID.fromString(serviceId)
        val characteristicUUID = UUID.fromString(characteristicId)
        val gatt = bluetoothGatts.remove(id) as BluetoothGatt
        val service = gatt.getService(serviceUUID)
        val characteristic = service.getCharacteristic(characteristicUUID)
        val isOK = gatt.readCharacteristic(characteristic)
        if (isOK) {

        } else {
            val error = BluetoothLowEnergyError("GATT read characteristic failed.")
        }
    }

    override fun write(
        id: String,
        serviceId: String,
        characteristicId: String,
        value: ByteArray,
        typeArgs: GattCharacteristicWriteTypeArgs
    ) {
        val serviceUUID = UUID.fromString(serviceId)
        val characteristicUUID = UUID.fromString(characteristicId)
        val gatt = bluetoothGatts.remove(id) as BluetoothGatt
        val service = gatt.getService(serviceUUID)
        val characteristic = service.getCharacteristic(characteristicUUID)
        characteristic.value = value
        characteristic.writeType = when (typeArgs) {
            GattCharacteristicWriteTypeArgs.WITHRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
            GattCharacteristicWriteTypeArgs.WITHOUTRESPONSE -> BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
        }
        val isOK = gatt.writeCharacteristic(characteristic)
        if (isOK) {

        } else {
            val error = BluetoothLowEnergyError("GATT read characteristic failed.")
        }
    }

    override fun notify(id: String, serviceId: String, characteristicId: String, value: Boolean) {
        val serviceUUID = UUID.fromString(serviceId)
        val characteristicUUID = UUID.fromString(characteristicId)
        val gatt = bluetoothGatts.remove(id) as BluetoothGatt
        val service = gatt.getService(serviceUUID)
        val characteristic = service.getCharacteristic(characteristicUUID)
        val isOK = gatt.setCharacteristicNotification(characteristic, value)
        if (isOK) {
            writeClientCharacteristicConfig(gatt, characteristic, value, result)
        } else {
            val error = BluetoothLowEnergyError("GATT set characteristic notification failed.")
        }
    }

    private fun writeClientCharacteristicConfig(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic,
        value: Boolean,
        result: Pigeon.Result<Void>
    ) {
        val uuid = UUID.fromString(CLIENT_CHARACTERISTIC_CONFIG)
        val descriptor = characteristic.getDescriptor(uuid)
        descriptor.value = if (value) {
            BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
        } else {
            BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
        }
        val isOK = gatt.writeDescriptor(descriptor)
    }
}

val BluetoothAdapter.stateArgs: CentralManagerStateArgs
    get() {
        return when (state) {
            BluetoothAdapter.STATE_ON -> CentralManagerStateArgs.POWEREDON
            else -> CentralManagerStateArgs.POWEREDOFF
        }
    }

val ScanResult.manufacturerSpecificData: ByteArray?
    get() {
        val scanRecord = this.scanRecord
        if (scanRecord == null || scanRecord.manufacturerSpecificData.size() == 0)
            return null
        val key = scanRecord.manufacturerSpecificData.keyAt(0)
        val vid = ByteBuffer.allocate(4).putInt(key).array()
        val value = scanRecord.manufacturerSpecificData.valueAt(0)
        return vid.plus(value)
    }