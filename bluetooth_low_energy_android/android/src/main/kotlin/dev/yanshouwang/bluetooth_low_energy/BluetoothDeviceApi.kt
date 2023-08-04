package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGattCallback
import android.content.Context
import android.os.Build
import android.os.Handler
import androidx.annotation.RequiresApi
import java.util.UUID

class BluetoothDeviceApi(private val context: Context, private val instanceManager: InstanceManager) : BluetoothDeviceHostApi {
    override fun getAddress(hashCode: Long): String {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.address
    }

    override fun getName(hashCode: Long): String {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.name
    }

    @RequiresApi(Build.VERSION_CODES.R)
    override fun getAlias(hashCode: Long): String? {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.alias
    }

    @RequiresApi(Build.VERSION_CODES.S)
    override fun setAlias(hashCode: Long, alias: String?): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.setAlias(alias).toLong()
    }

    override fun getBluetoothClass(hashCode: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        val bluetoothClass = device.bluetoothClass
        return instanceManager.allocate(bluetoothClass)
    }

    override fun getBondState(hashCode: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.bondState.toLong()
    }

    override fun getType(hashCode: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.type.toLong()
    }

    override fun getUUIDs(hashCode: Long): List<Long> {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.uuids.map { uuid -> instanceManager.allocate(uuid) }
    }

    override fun fetchUuidsWithSdp(hashCode: Long): Boolean {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.fetchUuidsWithSdp()
    }

    override fun setPin(hashCode: Long, pin: ByteArray): Boolean {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.setPin(pin)
    }

    override fun setPairingConfirmation(hashCode: Long, confirm: Boolean): Boolean {
        // TODO: Permission is only granted to system apps
//        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
//        return device.setPairingConfirmation(confirm)
        throw UnsupportedOperationException()
    }

    override fun createBond(hashCode: Long): Boolean {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        return device.createBond()
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun createInsecureL2capChannel(hashCode: Long, psm: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        val psm1 = psm.toInt()
        val socket = device.createInsecureL2capChannel(psm1)
        return instanceManager.allocate(socket)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun createL2capChannel(hashCode: Long, psm: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        val psm1 = psm.toInt()
        val socket = device.createL2capChannel(psm1)
        return instanceManager.allocate(socket)
    }

    override fun createInsecureRfcommSocketToServiceRecord(hashCode: Long, uuidHashCode: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        val uuid = instanceManager.valueOf(uuidHashCode) as UUID
        val socket = device.createInsecureRfcommSocketToServiceRecord(uuid)
        return instanceManager.allocate(socket)
    }

    override fun createRfcommSocketToServiceRecord(hashCode: Long, uuidHashCode: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        val uuid = instanceManager.valueOf(uuidHashCode) as UUID
        val socket = device.createRfcommSocketToServiceRecord(uuid)
        return instanceManager.allocate(socket)
    }

    override fun connectGatt(hashCode: Long, autoConnect: Boolean, callbackHashCode: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        val callback = instanceManager.valueOf(callbackHashCode) as BluetoothGattCallback
        val gatt = device.connectGatt(context, autoConnect, callback)
        return instanceManager.allocate(gatt)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun connectGatt1(hashCode: Long, autoConnect: Boolean, callbackHashCode: Long, transport: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        val callback = instanceManager.valueOf(callbackHashCode) as BluetoothGattCallback
        val transport1 = transport.toInt()
        val gatt = device.connectGatt(context, autoConnect, callback, transport1)
        return instanceManager.allocate(gatt)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun connectGatt2(hashCode: Long, autoConnect: Boolean, callbackHashCode: Long, transport: Long, phy: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        val callback = instanceManager.valueOf(callbackHashCode) as BluetoothGattCallback
        val transport1 = transport.toInt()
        val phy1 = phy.toInt()
        val gatt = device.connectGatt(context, autoConnect, callback, transport1, phy1)
        return instanceManager.allocate(gatt)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun connectGatt3(hashCode: Long, autoConnect: Boolean, callbackHashCode: Long, transport: Long, phy: Long, handlerHashCode: Long): Long {
        val device = instanceManager.valueOf(hashCode) as BluetoothDevice
        val callback = instanceManager.valueOf(callbackHashCode) as BluetoothGattCallback
        val transport1 = transport.toInt()
        val phy1 = phy.toInt()
        val handler = instanceManager.valueOf(handlerHashCode) as Handler
        val gatt = device.connectGatt(context, autoConnect, callback, transport1, phy1, handler)
        return instanceManager.allocate(gatt)
    }
}