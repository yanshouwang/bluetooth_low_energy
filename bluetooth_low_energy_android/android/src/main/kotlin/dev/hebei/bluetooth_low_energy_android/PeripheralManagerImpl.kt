package dev.hebei.bluetooth_low_energy_android

import io.flutter.plugin.common.BinaryMessenger

class PeripheralManagerImpl(messenger: BinaryMessenger) : PeripheralManagerHostApi {
    private val api = PeripheralManagerFlutterApi(messenger)
    override fun addStateChangedListener() {
        TODO("Not yet implemented")
    }

    override fun removeStateChangedListener() {
        TODO("Not yet implemented")
    }

    override fun addNameChangedListener() {
        TODO("Not yet implemented")
    }

    override fun removeNameChangedListener() {
        TODO("Not yet implemented")
    }

    override fun addConnectionStateChangedListener() {
        TODO("Not yet implemented")
    }

    override fun removeConnectionStateChangedListener() {
        TODO("Not yet implemented")
    }

    override fun addMTUChangedListener() {
        TODO("Not yet implemented")
    }

    override fun removeMTUChangedListener() {
        TODO("Not yet implemented")
    }

    override fun addCharacteristicReadRequestedListener() {
        TODO("Not yet implemented")
    }

    override fun removeCharacteristicReadRequestedListener() {
        TODO("Not yet implemented")
    }

    override fun addCharacteristicWriteRequestedListener() {
        TODO("Not yet implemented")
    }

    override fun removeCharacteristicWriteRequestedListener() {
        TODO("Not yet implemented")
    }

    override fun addCharacteristicNotifyStateChangedListener() {
        TODO("Not yet implemented")
    }

    override fun removeCharacteristicNotifyStateChangedListener() {
        TODO("Not yet implemented")
    }

    override fun addDescriptorReadRequestedListener() {
        TODO("Not yet implemented")
    }

    override fun removeDescriptorReadRequestedListener() {
        TODO("Not yet implemented")
    }

    override fun addDescriptorWriteRequestedListener() {
        TODO("Not yet implemented")
    }

    override fun removeDescriptorWriteRequestedListener() {
        TODO("Not yet implemented")
    }

    override fun getState(): BluetoothLowEnergyStateApi {
        TODO("Not yet implemented")
    }

    override fun shouldShowAuthorizeRationale(): Boolean {
        TODO("Not yet implemented")
    }

    override fun authorize(callback: (Result<Boolean>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun showAppSettings() {
        TODO("Not yet implemented")
    }

    override fun turnOn(callback: (Result<Unit>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun turnOff(callback: (Result<Unit>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun getName(): String? {
        TODO("Not yet implemented")
    }

    override fun setName(name: String?, callback: (Result<String?>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun addService(service: MutableGATTServiceApi) {
        TODO("Not yet implemented")
    }

    override fun removeService(id: Long) {
        TODO("Not yet implemented")
    }

    override fun removeAllServices() {
        TODO("Not yet implemented")
    }

    override fun startAdvertising(advertisement: AdvertisementApi, callback: (Result<Unit>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun stopAdvertising() {
        TODO("Not yet implemented")
    }

    override fun getMaximumNotifyLength(address: String): Long {
        TODO("Not yet implemented")
    }

    override fun respondReadRequestWithValue(id: Long, value: ByteArray) {
        TODO("Not yet implemented")
    }

    override fun respondReadRequestWithError(id: Long, error: GATTErrorApi) {
        TODO("Not yet implemented")
    }

    override fun respondWriteRequest(id: Long) {
        TODO("Not yet implemented")
    }

    override fun respondWriteRequestWithError(id: Long, error: GATTErrorApi) {
        TODO("Not yet implemented")
    }

    override fun notifyCharacteristic(id: Long, value: ByteArray, addresses: List<String>?) {
        TODO("Not yet implemented")
    }
}