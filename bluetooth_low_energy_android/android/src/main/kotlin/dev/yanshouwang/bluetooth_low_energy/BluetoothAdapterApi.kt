package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothProfile.ServiceListener
import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import java.util.UUID

class BluetoothAdapterApi(private val context: Context, private val instanceManager: InstanceManager) : BluetoothAdapterHostApi {
    override fun getAddress(hashCode: Long): String {
        // TODO: Permission is only granted to system apps
//        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
//        return adapter.address
        throw UnsupportedOperationException()
    }

    override fun getState(hashCode: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.state.toLong()
    }

    override fun isEnabled(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.isEnabled
    }

    override fun isDiscovering(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.isDiscovering
    }

    override fun getName(hashCode: Long): String {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.name
    }

    override fun setName(hashCode: Long, name: String): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.setName(name)
    }

    override fun getScanMode(hashCode: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.scanMode.toLong()
    }

    override fun getBluetoothLeScanner(hashCode: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val scanner = adapter.bluetoothLeScanner
        return instanceManager.allocate(scanner)
    }

    override fun getBluetoothLeAdvertiser(hashCode: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val advertiser = adapter.bluetoothLeAdvertiser
        return instanceManager.allocate(advertiser)
    }

    override fun getBondedDevices(hashCode: Long): List<Long> {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.bondedDevices.map { device -> instanceManager.allocate(device) }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isLe2MPhySupported(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.isLe2MPhySupported
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isLeCodedPhySupported(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.isLeCodedPhySupported
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isLeExtendedAdvertisingSupported(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.isLeExtendedAdvertisingSupported
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun isLePeriodicAdvertisingSupported(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.isLePeriodicAdvertisingSupported
    }

    override fun isMultipleAdvertisementSupported(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.isMultipleAdvertisementSupported
    }

    override fun isOffloadedFilteringSupported(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.isOffloadedFilteringSupported
    }

    override fun isOffloadedScanBatchingSupported(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.isOffloadedScanBatchingSupported
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun leMaximumAdvertisingDataLength(hashCode: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.leMaximumAdvertisingDataLength.toLong()
    }

    override fun enable(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.enable()
    }

    override fun disable(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.disable()
    }

    override fun startDiscovery(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.startDiscovery()
    }

    override fun cancelDiscovery(hashCode: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        return adapter.cancelDiscovery()
    }

    override fun getRemoteDevice(hashCode: Long, address: String): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val device = adapter.getRemoteDevice(address)
        return instanceManager.allocate(device)
    }

    override fun getRemoteDevice1(hashCode: Long, address: ByteArray): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val device = adapter.getRemoteDevice(address)
        return instanceManager.allocate(device)
    }

    override fun getProfileProxy(hashCode: Long, listenerHashCode: Long, profile: Long): Boolean {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val listener = instanceManager.valueOf(listenerHashCode) as ServiceListener
        val profile1 = profile.toInt()
        return adapter.getProfileProxy(context, listener, profile1)
    }

    override fun closeProfileProxy(hashCode: Long, profile: Long, proxyHashCode: Long) {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val profile1 = profile.toInt()
        val proxy = instanceManager.valueOf(proxyHashCode) as BluetoothProfile
        adapter.closeProfileProxy(profile1, proxy)
    }

    override fun getProfileConnectionState(hashCode: Long, profile: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val profile1 = profile.toInt()
        return adapter.getProfileConnectionState(profile1).toLong()
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun listenUsingInsecureL2capChannel(hashCode: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val socket = adapter.listenUsingInsecureL2capChannel()
        return instanceManager.allocate(socket)
    }

    override fun listenUsingInsecureRfcommWithServiceRecord(hashCode: Long, name: String, uuidHashCode: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val uuid = instanceManager.valueOf(uuidHashCode) as UUID
        val socket = adapter.listenUsingInsecureRfcommWithServiceRecord(name, uuid)
        return instanceManager.allocate(socket)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun listenUsingL2capChannel(hashCode: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val socket = adapter.listenUsingL2capChannel()
        return instanceManager.allocate(socket)
    }

    override fun listenUsingRfcommWithServiceRecord(hashCode: Long, name: String, uuidHashCode: Long): Long {
        val adapter = instanceManager.valueOf(hashCode) as BluetoothAdapter
        val uuid = instanceManager.valueOf(uuidHashCode) as UUID
        val socket = adapter.listenUsingRfcommWithServiceRecord(name, uuid)
        return instanceManager.allocate(socket)
    }
}