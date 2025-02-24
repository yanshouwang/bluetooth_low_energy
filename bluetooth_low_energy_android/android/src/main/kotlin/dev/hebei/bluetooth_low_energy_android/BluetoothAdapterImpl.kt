package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothServerSocket
import android.bluetooth.le.BluetoothLeAdvertiser
import android.bluetooth.le.BluetoothLeScanner
import android.content.Context
import java.time.Duration
import java.util.*

class BluetoothAdapterImpl(registrar: ApiPigeonProxyApiRegistrar) : PigeonApiBluetoothAdapter(registrar) {
    override fun cancelDiscovery(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.cancelDiscovery()
    }

    override fun checkBluetoothAddress(address: String): Boolean {
        return BluetoothAdapter.checkBluetoothAddress(address)
    }

    override fun closeProfileProxy(pigeon_instance: BluetoothAdapter, unusedProfile: Long, proxy: BluetoothProfile) {
        pigeon_instance.closeProfileProxy(unusedProfile.toInt(), proxy)
    }

    override fun disable(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.disable()
    }

    override fun enable(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.enable()
    }

    override fun getAddress(pigeon_instance: BluetoothAdapter): String {
        return pigeon_instance.address
    }

    override fun getBluetoothLeAdvertiser(pigeon_instance: BluetoothAdapter): BluetoothLeAdvertiser {
        return pigeon_instance.bluetoothLeAdvertiser
    }

    override fun getBluetoothLeScanner(pigeon_instance: BluetoothAdapter): BluetoothLeScanner {
        return pigeon_instance.bluetoothLeScanner
    }

    override fun getBondedDevices(pigeon_instance: BluetoothAdapter): List<BluetoothDevice> {
        return pigeon_instance.bondedDevices.toList()
    }

    override fun getDefaultAdapter(): BluetoothAdapter {
        return BluetoothAdapter.getDefaultAdapter()
    }

    override fun getDiscoverableTimeout(pigeon_instance: BluetoothAdapter): Duration? {
        return pigeon_instance.discoverableTimeout
    }

    override fun getLeMaximumAdvertisingDataLength(pigeon_instance: BluetoothAdapter): Long {
        return pigeon_instance.leMaximumAdvertisingDataLength.toLong()
    }

    override fun getMaxConnectedAudioDevices(pigeon_instance: BluetoothAdapter): Long {
        return pigeon_instance.maxConnectedAudioDevices.toLong()
    }

    override fun getName(pigeon_instance: BluetoothAdapter): String {
        return pigeon_instance.name
    }

    override fun getProfileConnectionState(pigeon_instance: BluetoothAdapter, profile: Long): Long {
        return pigeon_instance.getProfileConnectionState(profile.toInt()).toLong()
    }

    override fun getProfileProxy(
        pigeon_instance: BluetoothAdapter, context: Context, listener: BluetoothProfile.ServiceListener, profile: Long
    ): Boolean {
        return pigeon_instance.getProfileProxy(context, listener, profile.toInt())
    }

    override fun getRemoteDevice1(pigeon_instance: BluetoothAdapter, address: ByteArray): BluetoothDevice {
        return pigeon_instance.getRemoteDevice(address)
    }

    override fun getRemoteDevice2(pigeon_instance: BluetoothAdapter, address: String): BluetoothDevice {
        return pigeon_instance.getRemoteDevice(address)
    }

    override fun getRemoteLeDevice(
        pigeon_instance: BluetoothAdapter, address: String, addressType: Long
    ): BluetoothDevice {
        return pigeon_instance.getRemoteLeDevice(address, addressType.toInt())
    }

    override fun getScanMode(pigeon_instance: BluetoothAdapter): Long {
        return pigeon_instance.scanMode.toLong()
    }

    override fun getState(pigeon_instance: BluetoothAdapter): Long {
        return pigeon_instance.state.toLong()
    }

    override fun isDiscovering(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.isDiscovering
    }

    override fun isEnabled(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.isEnabled
    }

    override fun isLe2MPhySupported(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.isLe2MPhySupported
    }

    override fun isLeAudioBroadcastAssistantSupported(pigeon_instance: BluetoothAdapter): Long {
        return pigeon_instance.isLeAudioBroadcastAssistantSupported.toLong()
    }

    override fun isLeAudioBroadcastSourceSupported(pigeon_instance: BluetoothAdapter): Long {
        return pigeon_instance.isLeAudioBroadcastSourceSupported.toLong()
    }

    override fun isLeAudioSupported(pigeon_instance: BluetoothAdapter): Long {
        return pigeon_instance.isLeAudioSupported.toLong()
    }

    override fun isLeCodedPhySupported(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.isLeCodedPhySupported
    }

    override fun isLeExtendedAdvertisingSupported(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.isLeExtendedAdvertisingSupported
    }

    override fun isLePeriodicAdvertisingSupported(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.isLePeriodicAdvertisingSupported
    }

    override fun isMultipleAdvertisementSupported(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.isMultipleAdvertisementSupported
    }

    override fun isOffloadedFilteringSupported(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.isOffloadedFilteringSupported
    }

    override fun isOffloadedScanBatchingSupported(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.isOffloadedScanBatchingSupported
    }

    override fun listenUsingInsecureL2capChannel(pigeon_instance: BluetoothAdapter): BluetoothServerSocket {
        return pigeon_instance.listenUsingInsecureL2capChannel()
    }

    override fun listenUsingInsecureRfcommWithServiceRecord(
        pigeon_instance: BluetoothAdapter, name: String, uuid: UUID
    ): BluetoothServerSocket {
        return pigeon_instance.listenUsingInsecureRfcommWithServiceRecord(name, uuid)
    }

    override fun listenUsingL2capChannel(pigeon_instance: BluetoothAdapter): BluetoothServerSocket {
        return pigeon_instance.listenUsingL2capChannel()
    }

    override fun listenUsingRfcommWithServiceRecord(
        pigeon_instance: BluetoothAdapter, name: String, uuid: UUID
    ): BluetoothServerSocket {
        return pigeon_instance.listenUsingRfcommWithServiceRecord(name, uuid)
    }

    override fun setName(pigeon_instance: BluetoothAdapter, name: String): Boolean {
        return pigeon_instance.setName(name)
    }

    override fun startDiscovery(pigeon_instance: BluetoothAdapter): Boolean {
        return pigeon_instance.startDiscovery()
    }

    override fun startLeScan1(pigeon_instance: BluetoothAdapter, callback: BluetoothAdapter.LeScanCallback): Boolean {
        return pigeon_instance.startLeScan(callback)
    }

    override fun startLeScan2(
        pigeon_instance: BluetoothAdapter, serviceUuids: List<UUID>, callback: BluetoothAdapter.LeScanCallback
    ): Boolean {
        return pigeon_instance.startLeScan(serviceUuids.toTypedArray(), callback)
    }

    override fun stopLeScan(pigeon_instance: BluetoothAdapter, callback: BluetoothAdapter.LeScanCallback) {
        return pigeon_instance.stopLeScan(callback)
    }
}