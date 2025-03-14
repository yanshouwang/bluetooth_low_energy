package dev.hebei.bluetooth_low_energy_android

import io.flutter.plugin.common.BinaryMessenger

class BluetoothLowEnergyAndroidRegistrar(
    binaryMessenger: BinaryMessenger, private val instance: BluetoothLowEnergyAndroidPlugin
) : BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar(binaryMessenger) {
    override fun getPigeonApiBluetoothLowEnergyAndroidPlugin(): PigeonApiBluetoothLowEnergyAndroidPlugin {
        return BluetoothLowEnergyAndroidPluginImpl(this, instance)
    }

    override fun getPigeonApiRequestPermissionsResultListener(): PigeonApiRequestPermissionsResultListener {
        return RequestPermissionsResultListenerImpl(this)
    }

    override fun getPigeonApiActivityResultListener(): PigeonApiActivityResultListener {
        return ActivityResultListenerImpl(this)
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
        return BluetoothLeScannerImpl(this)
    }

    override fun getPigeonApiPeriodicAdvertisingParameters(): PigeonApiPeriodicAdvertisingParameters {
        return PeriodicAdvertisingParametersImpl(this)
    }

    override fun getPigeonApiPeriodicAdvertisingParametersBuilder(): PigeonApiPeriodicAdvertisingParametersBuilder {
        return PeriodicAdvertisingParametersBuilderImpl(this)
    }

    override fun getPigeonApiScanCallback(): PigeonApiScanCallback {
        return ScanCallbackImpl(this)
    }

    override fun getPigeonApiScanFilter(): PigeonApiScanFilter {
        return ScanFilterImpl(this)
    }

    override fun getPigeonApiScanFilterBuilder(): PigeonApiScanFilterBuilder {
        return ScanFilterBuilderImpl(this)
    }

    override fun getPigeonApiScanRecord(): PigeonApiScanRecord {
        return ScanRecordImpl(this)
    }

    override fun getPigeonApiScanResult(): PigeonApiScanResult {
        return ScanResultImpl(this)
    }

    override fun getPigeonApiScanSettings(): PigeonApiScanSettings {
        return ScanSettingsImpl(this)
    }

    override fun getPigeonApiScanSettingsBuilder(): PigeonApiScanSettingsBuilder {
        return ScanSettingsBuilderImpl(this)
    }

    override fun getPigeonApiBroadcastReceiver(): PigeonApiBroadcastReceiver {
        return BroadcastReceiverImpl(this)
    }

    override fun getPigeonApiContext(): PigeonApiContext {
        return ContextImpl(this)
    }

    override fun getPigeonApiIntentFilter(): PigeonApiIntentFilter {
        return IntentFilterImpl(this)
    }

    override fun getPigeonApiPackageManager(): PigeonApiPackageManager {
        return PackageManagerImpl(this)
    }

    override fun getPigeonApiParcelUuid(): PigeonApiParcelUuid {
        return ParcelUuidImpl(this)
    }

    override fun getPigeonApiActivityCompat(): PigeonApiActivityCompat {
        return ActivityCompatImpl(this)
    }

    override fun getPigeonApiContextCompat(): PigeonApiContextCompat {
        return ContextCompatImpl(this)
    }

    override fun getPigeonApiUUID(): PigeonApiUUID {
        return UUIDImpl(this)
    }
}