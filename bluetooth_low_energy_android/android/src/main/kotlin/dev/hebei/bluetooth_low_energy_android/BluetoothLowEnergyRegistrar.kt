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
        return BluetoothServerSocketImpl(this)
    }

    override fun getPigeonApiBluetoothSocket(): PigeonApiBluetoothSocket {
        return BluetoothSocketImpl(this)
    }

    override fun getPigeonApiLeScanCallback(): PigeonApiLeScanCallback {
        return LeScanCallbackImpl(this)
    }

    override fun getPigeonApiBluetoothProfile(): PigeonApiBluetoothProfile {
        return BluetoothProfileImpl(this)
    }

    override fun getPigeonApiServiceListener(): PigeonApiServiceListener {
        return ServiceListenerImpl(this)
    }

    override fun getPigeonApiAdvertiseCallback(): PigeonApiAdvertiseCallback {
        return AdvertiseCallbackImpl(this)
    }

    override fun getPigeonApiAdvertiseData(): PigeonApiAdvertiseData {
        return AdvertiseDataImpl(this)
    }

    override fun getPigeonApiAdvertiseDataBuilder(): PigeonApiAdvertiseDataBuilder {
        return AdvertiseDataBuilderImpl(this)
    }

    override fun getPigeonApiAdvertiseSettings(): PigeonApiAdvertiseSettings {
        return AdvertiseSettingsImpl(this)
    }

    override fun getPigeonApiAdvertiseSettingsBuilder(): PigeonApiAdvertiseSettingsBuilder {
        return AdvertiseSettingsBuilderImpl(this)
    }

    override fun getPigeonApiAdvertisingSet(): PigeonApiAdvertisingSet {
        return AdvertisingSetImpl(this)
    }

    override fun getPigeonApiAdvertisingSetCallback(): PigeonApiAdvertisingSetCallback {
        return AdvertisingSetCallbackImpl(this)
    }

    override fun getPigeonApiAdvertisingSetParameters(): PigeonApiAdvertisingSetParameters {
        return AdvertisingSetParametersImpl(this)
    }

    override fun getPigeonApiAdvertisingSetParametersBuilder(): PigeonApiAdvertisingSetParametersBuilder {
        return AdvertisingSetParametersBuilderImpl(this)
    }

    override fun getPigeonApiBluetoothLeAdvertiser(): PigeonApiBluetoothLeAdvertiser {
        return BluetoothLeAdvertiserImpl(this)
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