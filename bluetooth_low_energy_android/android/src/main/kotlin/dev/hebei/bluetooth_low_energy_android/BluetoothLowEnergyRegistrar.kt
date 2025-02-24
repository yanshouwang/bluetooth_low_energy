package dev.hebei.bluetooth_low_energy_android

import io.flutter.plugin.common.BinaryMessenger

class BluetoothLowEnergyRegistrar(binaryMessenger: BinaryMessenger) :
    BluetoothLowEnergyPigeonProxyApiRegistrar(binaryMessenger) {
    override fun getPigeonApiAny(): PigeonApiAny {
        return AnyImpl(this)
    }

    override fun getPigeonApiBluetoothAdapter(): PigeonApiBluetoothAdapter {
        return BluetoothAdapterImpl(this)
    }

    override fun getPigeonApiBluetoothClass(): PigeonApiBluetoothClass {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothDevice(): PigeonApiBluetoothDevice {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothGatt(): PigeonApiBluetoothGatt {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothGattCallback(): PigeonApiBluetoothGattCallback {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothGattCharacteristic(): PigeonApiBluetoothGattCharacteristic {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothGattDescriptor(): PigeonApiBluetoothGattDescriptor {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothGattServer(): PigeonApiBluetoothGattServer {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothGattServerCallback(): PigeonApiBluetoothGattServerCallback {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothGattService(): PigeonApiBluetoothGattService {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothManager(): PigeonApiBluetoothManager {
        return BluetoothManagerImpl(this)
    }

    override fun getPigeonApiBluetoothServerSocket(): PigeonApiBluetoothServerSocket {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothSocket(): PigeonApiBluetoothSocket {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothAdapterLeScanCallback(): PigeonApiBluetoothAdapterLeScanCallback {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothProfile(): PigeonApiBluetoothProfile {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothProfileServiceListener(): PigeonApiBluetoothProfileServiceListener {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiAdvertiseCallback(): PigeonApiAdvertiseCallback {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiAdvertiseData(): PigeonApiAdvertiseData {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiAdvertiseDataBuilder(): PigeonApiAdvertiseDataBuilder {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiAdvertiseSettings(): PigeonApiAdvertiseSettings {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiAdvertiseSettingsBuilder(): PigeonApiAdvertiseSettingsBuilder {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiAdvertisingSet(): PigeonApiAdvertisingSet {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiAdvertisingSetCallback(): PigeonApiAdvertisingSetCallback {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiAdvertisingSetParameters(): PigeonApiAdvertisingSetParameters {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiAdvertisingSetParametersBuilder(): PigeonApiAdvertisingSetParametersBuilder {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothLeAdvertiser(): PigeonApiBluetoothLeAdvertiser {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiBluetoothLeScanner(): PigeonApiBluetoothLeScanner {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiPeriodicAdvertisingParameters(): PigeonApiPeriodicAdvertisingParameters {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiPeriodicAdvertisingParametersBuilder(): PigeonApiPeriodicAdvertisingParametersBuilder {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiScanCallback(): PigeonApiScanCallback {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiScanFilter(): PigeonApiScanFilter {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiScanFilterBuilder(): PigeonApiScanFilterBuilder {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiScanRecord(): PigeonApiScanRecord {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiScanResult(): PigeonApiScanResult {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiScanSettings(): PigeonApiScanSettings {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiScanSettingsBuilder(): PigeonApiScanSettingsBuilder {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiParcelUuid(): PigeonApiParcelUuid {
        TODO("Not yet implemented")
    }

    override fun getPigeonApiUUID(): PigeonApiUUID {
        TODO("Not yet implemented")
    }
}