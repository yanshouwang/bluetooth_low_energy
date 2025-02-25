package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.*
import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.ParcelUuid
import java.util.*

class BluetoothDeviceImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) : PigeonApiBluetoothDevice(registrar) {
    override fun connectGatt1(
        pigeon_instance: BluetoothDevice, context: Context, autoConnect: Boolean, callback: BluetoothGattCallback
    ): BluetoothGatt {
        return pigeon_instance.connectGatt(context, autoConnect, callback)
    }

    override fun connectGatt2(
        pigeon_instance: BluetoothDevice,
        context: Context,
        autoConnect: Boolean,
        callback: BluetoothGattCallback,
        transport: Long
    ): BluetoothGatt {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            pigeon_instance.connectGatt(context, autoConnect, callback, transport.toInt())
        } else {
            // From Android LOLLIPOP (21) the transport types exists, but it is private
            // have to use reflection to call it for TRANSPORT_LE
            val method = pigeon_instance.javaClass.getDeclaredMethod(
                "connectGatt",
                Context::class.java,
                Boolean::class.javaPrimitiveType,
                BluetoothGattCallback::class.java,
                Int::class.javaPrimitiveType
            )
            method.isAccessible = true
            method.invoke(pigeon_instance, context, autoConnect, callback, transport.toInt()) as BluetoothGatt
        }
    }

    override fun connectGatt3(
        pigeon_instance: BluetoothDevice,
        context: Context,
        autoConnect: Boolean,
        callback: BluetoothGattCallback,
        transport: Long,
        phy: Long
    ): BluetoothGatt {
        return pigeon_instance.connectGatt(context, autoConnect, callback, transport.toInt(), phy.toInt())
    }

    override fun connectGatt4(
        pigeon_instance: BluetoothDevice,
        context: Context,
        autoConnect: Boolean,
        callback: BluetoothGattCallback,
        transport: Long,
        phy: Long,
        handler: Handler
    ): BluetoothGatt {
        return pigeon_instance.connectGatt(context, autoConnect, callback, transport.toInt(), phy.toInt(), handler)
    }

    override fun createBond(pigeon_instance: BluetoothDevice): Boolean {
        return pigeon_instance.createBond()
    }

    override fun createInsecureL2capChannel(pigeon_instance: BluetoothDevice, psm: Long): BluetoothSocket {
        return pigeon_instance.createInsecureL2capChannel(psm.toInt())
    }

    override fun createInsecureRfcommSocketToServiceRecord(
        pigeon_instance: BluetoothDevice, uuid: UUID
    ): BluetoothSocket {
        return pigeon_instance.createInsecureRfcommSocketToServiceRecord(uuid)
    }

    override fun createL2capChannel(pigeon_instance: BluetoothDevice, psm: Long): BluetoothSocket {
        return pigeon_instance.createL2capChannel(psm.toInt())
    }

    override fun createRfcommSocketToServiceRecord(pigeon_instance: BluetoothDevice, uuid: UUID): BluetoothSocket {
        return pigeon_instance.createRfcommSocketToServiceRecord(uuid)
    }

    override fun fetchUuidsWithSdp(pigeon_instance: BluetoothDevice): Boolean {
        return pigeon_instance.fetchUuidsWithSdp()
    }

    override fun getAddressType(pigeon_instance: BluetoothDevice): Long {
        return pigeon_instance.addressType.toLong()
    }

    override fun getAlias(pigeon_instance: BluetoothDevice): String? {
        return pigeon_instance.alias
    }

    override fun getBluetoothClass(pigeon_instance: BluetoothDevice): BluetoothClass {
        return pigeon_instance.bluetoothClass
    }

    override fun getBondState(pigeon_instance: BluetoothDevice): Long {
        return pigeon_instance.bondState.toLong()
    }

    override fun getName(pigeon_instance: BluetoothDevice): String {
        return pigeon_instance.name
    }

    override fun getType(pigeon_instance: BluetoothDevice): Long {
        return pigeon_instance.type.toLong()
    }

    override fun getUuids(pigeon_instance: BluetoothDevice): List<ParcelUuid> {
        return pigeon_instance.uuids.toList()
    }

    override fun setAlias(pigeon_instance: BluetoothDevice, alias: String?): Long {
        return pigeon_instance.setAlias(alias).toLong()
    }

    override fun setPairingConfirmation(pigeon_instance: BluetoothDevice, confirm: Boolean): Boolean {
        return pigeon_instance.setPairingConfirmation(confirm)
    }

    override fun setPin(pigeon_instance: BluetoothDevice, pin: ByteArray): Boolean {
        return pigeon_instance.setPin(pin)
    }
}