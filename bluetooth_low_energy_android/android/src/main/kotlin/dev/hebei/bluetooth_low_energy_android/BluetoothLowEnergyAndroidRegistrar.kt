package dev.hebei.bluetooth_low_energy_android

import io.flutter.plugin.common.BinaryMessenger

class BluetoothLowEnergyAndroidRegistrar(
    binaryMessenger: BinaryMessenger, private val bluetoothLowEnergyAndroidPlugin: BluetoothLowEnergyAndroidPlugin
) : BluetoothLowEnergyAndroidPigeonProxyApiRegistrar(binaryMessenger) {
    override fun getPigeonApiBluetoothLowEnergyAndroidPlugin(): PigeonApiBluetoothLowEnergyAndroidPlugin {
        return BluetoothLowEnergyAndroidPluginApi(this, bluetoothLowEnergyAndroidPlugin)
    }

    override fun getPigeonApiRequestPermissionsResultListener(): PigeonApiRequestPermissionsResultListener {
        return RequestPermissionsResultListenerApi(this)
    }

    override fun getPigeonApiActivityResultListener(): PigeonApiActivityResultListener {
        return ActivityResultListenerApi(this)
    }

    override fun getPigeonApiAny(): PigeonApiAny {
        return AnyApi(this)
    }

    override fun getPigeonApiBluetoothAdapter(): PigeonApiBluetoothAdapter {
        return BluetoothAdapterApi(this)
    }

    override fun getPigeonApiBluetoothClass(): PigeonApiBluetoothClass {
        return BluetoothClassApi(this)
    }

    override fun getPigeonApiBluetoothDevice(): PigeonApiBluetoothDevice {
        return BluetoothDeviceApi(this)
    }

    override fun getPigeonApiBluetoothGatt(): PigeonApiBluetoothGatt {
        return BluetoothGattApi(this)
    }

    override fun getPigeonApiBluetoothGattCallback(): PigeonApiBluetoothGattCallback {
        return BluetoothGattCallbackApi(this)
    }

    override fun getPigeonApiBluetoothGattCharacteristic(): PigeonApiBluetoothGattCharacteristic {
        return BluetoothGattCharacteristicApi(this)
    }

    override fun getPigeonApiBluetoothGattDescriptor(): PigeonApiBluetoothGattDescriptor {
        return BluetoothGattDescriptorApi(this)
    }

    override fun getPigeonApiBluetoothGattServer(): PigeonApiBluetoothGattServer {
        return BluetoothGattServerApi(this)
    }

    override fun getPigeonApiBluetoothGattServerCallback(): PigeonApiBluetoothGattServerCallback {
        return BluetoothGattServerCallbackApi(this)
    }

    override fun getPigeonApiBluetoothGattService(): PigeonApiBluetoothGattService {
        return BluetoothGattServiceApi(this)
    }

    override fun getPigeonApiBluetoothManager(): PigeonApiBluetoothManager {
        return BluetoothManagerApi(this)
    }

    override fun getPigeonApiBluetoothServerSocket(): PigeonApiBluetoothServerSocket {
        return BluetoothServerSocketApi(this)
    }

    override fun getPigeonApiBluetoothSocket(): PigeonApiBluetoothSocket {
        return BluetoothSocketApi(this)
    }

    override fun getPigeonApiLeScanCallback(): PigeonApiLeScanCallback {
        return LeScanCallbackApi(this)
    }

    override fun getPigeonApiBluetoothProfile(): PigeonApiBluetoothProfile {
        return BluetoothProfileApi(this)
    }

    override fun getPigeonApiServiceListener(): PigeonApiServiceListener {
        return ServiceListenerApi(this)
    }

    override fun getPigeonApiAdvertiseCallback(): PigeonApiAdvertiseCallback {
        return AdvertiseCallbackApi(this)
    }

    override fun getPigeonApiAdvertiseData(): PigeonApiAdvertiseData {
        return AdvertiseDataApi(this)
    }

    override fun getPigeonApiAdvertiseDataBuilder(): PigeonApiAdvertiseDataBuilder {
        return AdvertiseDataBuilderApi(this)
    }

    override fun getPigeonApiAdvertiseSettings(): PigeonApiAdvertiseSettings {
        return AdvertiseSettingsApi(this)
    }

    override fun getPigeonApiAdvertiseSettingsBuilder(): PigeonApiAdvertiseSettingsBuilder {
        return AdvertiseSettingsBuilderApi(this)
    }

    override fun getPigeonApiAdvertisingSet(): PigeonApiAdvertisingSet {
        return AdvertisingSetApi(this)
    }

    override fun getPigeonApiAdvertisingSetCallback(): PigeonApiAdvertisingSetCallback {
        return AdvertisingSetCallbackApi(this)
    }

    override fun getPigeonApiAdvertisingSetParameters(): PigeonApiAdvertisingSetParameters {
        return AdvertisingSetParametersApi(this)
    }

    override fun getPigeonApiAdvertisingSetParametersBuilder(): PigeonApiAdvertisingSetParametersBuilder {
        return AdvertisingSetParametersBuilderApi(this)
    }

    override fun getPigeonApiBluetoothLeAdvertiser(): PigeonApiBluetoothLeAdvertiser {
        return BluetoothLeAdvertiserApi(this)
    }

    override fun getPigeonApiBluetoothLeScanner(): PigeonApiBluetoothLeScanner {
        return BluetoothLeScannerApi(this)
    }

    override fun getPigeonApiPeriodicAdvertisingParameters(): PigeonApiPeriodicAdvertisingParameters {
        return PeriodicAdvertisingParametersApi(this)
    }

    override fun getPigeonApiPeriodicAdvertisingParametersBuilder(): PigeonApiPeriodicAdvertisingParametersBuilder {
        return PeriodicAdvertisingParametersBuilderApi(this)
    }

    override fun getPigeonApiScanCallback(): PigeonApiScanCallback {
        return ScanCallbackApi(this)
    }

    override fun getPigeonApiScanFilter(): PigeonApiScanFilter {
        return ScanFilterApi(this)
    }

    override fun getPigeonApiScanFilterBuilder(): PigeonApiScanFilterBuilder {
        return ScanFilterBuilderApi(this)
    }

    override fun getPigeonApiScanRecord(): PigeonApiScanRecord {
        return ScanRecordApi(this)
    }

    override fun getPigeonApiScanResult(): PigeonApiScanResult {
        return ScanResultApi(this)
    }

    override fun getPigeonApiScanSettings(): PigeonApiScanSettings {
        return ScanSettingsApi(this)
    }

    override fun getPigeonApiScanSettingsBuilder(): PigeonApiScanSettingsBuilder {
        return ScanSettingsBuilderApi(this)
    }

    override fun getPigeonApiBroadcastReceiver(): PigeonApiBroadcastReceiver {
        return BroadcastReceiverApi(this)
    }

    override fun getPigeonApiContext(): PigeonApiContext {
        return ContextApi(this)
    }

    override fun getPigeonApiIntentFilter(): PigeonApiIntentFilter {
        return IntentFilterApi(this)
    }

    override fun getPigeonApiPackageManager(): PigeonApiPackageManager {
        return PackageManagerApi(this)
    }

    override fun getPigeonApiParcelUuid(): PigeonApiParcelUuid {
        return ParcelUuidApi(this)
    }

    override fun getPigeonApiActivityCompat(): PigeonApiActivityCompat {
        return ActivityCompatApi(this)
    }

    override fun getPigeonApiContextCompat(): PigeonApiContextCompat {
        return ContextCompatApi(this)
    }

    override fun getPigeonApiUUID(): PigeonApiUUID {
        return UUIDApi(this)
    }
}