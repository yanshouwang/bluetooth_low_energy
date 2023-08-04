package dev.yanshouwang.bluetooth_low_energy

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** BluetoothLowEnergyPlugin */
class BluetoothLowEnergyAndroid : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val binaryMessenger = binding.binaryMessenger
        val instanceManager = InstanceManager()
        val instanceManagerApi = InstanceManagerApi(instanceManager)
        val intentApi = IntentApi(context, instanceManager)
        val pendingIntentApi = PendingIntentApi(context, instanceManager)
        val uuidApi = UuidApi(instanceManager)
        val parcelUuidApi = ParcelUuidApi(instanceManager)
        val broadcastReceiverApi = BroadcastReceiverApi(binaryMessenger, instanceManager)
        val bluetoothManagerApi = BluetoothManagerApi(context, instanceManager)
        val bluetoothGattServerCallbackApi = BluetoothGattServerCallbackApi(binaryMessenger, instanceManager)
        val bluetoothAdapterApi = BluetoothAdapterApi(context, instanceManager)
        val bluetoothProfileServiceListener = BluetoothProfileServiceListenerApi(binaryMessenger, instanceManager)
        val bluetoothLeScannerApi = BluetoothLeScannerApi(instanceManager)
        val scanCallbackApi = ScanCallbackApi(binaryMessenger, instanceManager)
        val scanResultApi = ScanResultApi(instanceManager)
        val scanRecordApi = ScanRecordApi(instanceManager)
        val bluetoothDeviceApi = BluetoothDeviceApi(context, instanceManager)
        val bluetoothGattCallbackApi = BluetoothGattCallbackApi(binaryMessenger, instanceManager)
        val bluetoothGattApi = BluetoothGattApi(instanceManager)
        val bluetoothGattServiceApi = BluetoothGattServiceApi(instanceManager)
        val bluetoothGattCharacteristicApi = BluetoothGattCharacteristicApi(instanceManager)
        val bluetoothGattDescriptorApi = BluetoothGattDescriptorApi(instanceManager)

        InstanceManagerHostApi.setUp(binaryMessenger, instanceManagerApi)
        IntentHostApi.setUp(binaryMessenger, intentApi)
        PendingIntentHostApi.setUp(binaryMessenger, pendingIntentApi)
        UuidHostApi.setUp(binaryMessenger, uuidApi)
        ParcelUuidHostApi.setUp(binaryMessenger, parcelUuidApi)
        BroadcastReceiverHostApi.setUp(binaryMessenger, broadcastReceiverApi)
        BluetoothManagerHostApi.setUp(binaryMessenger, bluetoothManagerApi)
        BluetoothGattServerCallbackHostApi.setUp(binaryMessenger, bluetoothGattServerCallbackApi)
        BluetoothAdapterHostApi.setUp(binaryMessenger, bluetoothAdapterApi)
        BluetoothProfileServiceListenerHostApi.setUp(binaryMessenger, bluetoothProfileServiceListener)
        BluetoothLeScannerHostApi.setUp(binaryMessenger, bluetoothLeScannerApi)
        ScanCallbackHostApi.setUp(binaryMessenger, scanCallbackApi)
        ScanResultHostApi.setUp(binaryMessenger, scanResultApi)
        ScanRecordHostApi.setUp(binaryMessenger, scanRecordApi)
        BluetoothDeviceHostApi.setUp(binaryMessenger, bluetoothDeviceApi)
        BluetoothGattCallbackHostApi.setUp(binaryMessenger, bluetoothGattCallbackApi)
        BluetoothGattHostApi.setUp(binaryMessenger, bluetoothGattApi)
        BluetoothGattServiceHostApi.setUp(binaryMessenger, bluetoothGattServiceApi)
        BluetoothGattCharacteristicHostApi.setUp(binaryMessenger, bluetoothGattCharacteristicApi)
        BluetoothGattDescriptorHostApi.setUp(binaryMessenger, bluetoothGattDescriptorApi)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger

        InstanceManagerHostApi.setUp(binaryMessenger, null)
        IntentHostApi.setUp(binaryMessenger, null)
        PendingIntentHostApi.setUp(binaryMessenger, null)
        UuidHostApi.setUp(binaryMessenger, null)
        ParcelUuidHostApi.setUp(binaryMessenger, null)
        BroadcastReceiverHostApi.setUp(binaryMessenger, null)
        BluetoothManagerHostApi.setUp(binaryMessenger, null)
        BluetoothGattServerCallbackHostApi.setUp(binaryMessenger, null)
        BluetoothAdapterHostApi.setUp(binaryMessenger, null)
        BluetoothProfileServiceListenerHostApi.setUp(binaryMessenger, null)
        BluetoothLeScannerHostApi.setUp(binaryMessenger, null)
        ScanCallbackHostApi.setUp(binaryMessenger, null)
        ScanResultHostApi.setUp(binaryMessenger, null)
        ScanRecordHostApi.setUp(binaryMessenger, null)
        BluetoothDeviceHostApi.setUp(binaryMessenger, null)
        BluetoothGattCallbackHostApi.setUp(binaryMessenger, null)
        BluetoothGattHostApi.setUp(binaryMessenger, null)
        BluetoothGattServiceHostApi.setUp(binaryMessenger, null)
        BluetoothGattCharacteristicHostApi.setUp(binaryMessenger, null)
        BluetoothGattDescriptorHostApi.setUp(binaryMessenger, null)
    }
}
