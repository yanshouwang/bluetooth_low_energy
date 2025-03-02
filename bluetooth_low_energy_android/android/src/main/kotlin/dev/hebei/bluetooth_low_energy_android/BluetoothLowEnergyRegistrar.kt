package dev.hebei.bluetooth_low_energy_android

import io.flutter.plugin.common.BinaryMessenger

class BluetoothLowEnergyRegistrar(
    binaryMessenger: BinaryMessenger, private val instance: BluetoothLowEnergyAndroidPlugin
) : BluetoothLowEnergyPigeonProxyApiRegistrar(binaryMessenger) {
    override fun getPigeonApiBluetoothLowEnergyAndroidPlugin(): PigeonApiBluetoothLowEnergyAndroidPlugin {
        return BluetoothLowEnergyAndroidPluginImpl(this, instance)
    }

    override fun getPigeonApiAny(): PigeonApiAny {
        return AnyImpl(this)
    }

    override fun getPigeonApiBluetoothAdapter(): PigeonApiBluetoothAdapter {
        return BluetoothAdapterImpl(this)
    }

    override fun getPigeonApiBluetoothClass(): PigeonApiBluetoothClass {
        return BluetoothClassImpl(this)
    }

    override fun getPigeonApiBluetoothDevice(): PigeonApiBluetoothDevice {
        return BluetoothDeviceImpl(this)
    }

    override fun getPigeonApiBluetoothGatt(): PigeonApiBluetoothGatt {
        return BluetoothGattImpl(this)
    }

    override fun getPigeonApiBluetoothGattCallback(): PigeonApiBluetoothGattCallback {
        return BluetoothGattCallbackImpl(this)
    }

    override fun getPigeonApiBluetoothGattCharacteristic(): PigeonApiBluetoothGattCharacteristic {
        return BluetoothGattCharacteristicImpl(this)
    }

    override fun getPigeonApiBluetoothGattDescriptor(): PigeonApiBluetoothGattDescriptor {
        return BluetoothGattDescriptorImpl(this)
    }

    override fun getPigeonApiBluetoothGattServer(): PigeonApiBluetoothGattServer {
        return BluetoothGattServerImpl(this)
    }

    override fun getPigeonApiBluetoothGattServerCallback(): PigeonApiBluetoothGattServerCallback {
        return BluetoothGattServerCallbackImpl(this)
    }

    override fun getPigeonApiBluetoothGattService(): PigeonApiBluetoothGattService {
        return BluetoothGattServiceImpl(this)
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