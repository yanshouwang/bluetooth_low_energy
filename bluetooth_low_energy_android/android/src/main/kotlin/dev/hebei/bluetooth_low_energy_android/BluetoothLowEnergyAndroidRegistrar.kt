package dev.hebei.bluetooth_low_energy_android

import io.flutter.plugin.common.BinaryMessenger

class BluetoothLowEnergyAndroidRegistrar(
    binaryMessenger: BinaryMessenger, private val contextUtil: ContextUtil, private val activityUtil: ActivityUtil
) : BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar(binaryMessenger) {
    override fun getPigeonApiBluetoothLowEnergyManagerApi(): PigeonApiBluetoothLowEnergyManagerApi {
        return BluetoothLowEnergyManagerImpl(this)
    }

    override fun getPigeonApiStateChangedListenerApi(): PigeonApiStateChangedListenerApi {
        return BluetoothLowEnergyManagerImpl.StateChangedListenerImpl(this)
    }

    override fun getPigeonApiNameChangedListenerApi(): PigeonApiNameChangedListenerApi {
        return BluetoothLowEnergyManagerImpl.NameChangedListenerImpl(this)
    }

    override fun getPigeonApiCentralManagerApi(): PigeonApiCentralManagerApi {
        return CentralManagerImpl(this, contextUtil, activityUtil)
    }

    override fun getPigeonApiDiscoveredListenerApi(): PigeonApiDiscoveredListenerApi {
        return CentralManagerImpl.DiscoveredListenerImpl(this)
    }

    override fun getPigeonApiConnectionStateChangedListenerApi(): PigeonApiConnectionStateChangedListenerApi {
        return CentralManagerImpl.ConnectionStateChangedListenerImpl(this, contextUtil.mainExecutor)
    }

    override fun getPigeonApiMTUChangedListenerApi(): PigeonApiMTUChangedListenerApi {
        return CentralManagerImpl.MTUChangedListenerImpl(this, contextUtil.mainExecutor)
    }

    override fun getPigeonApiCharacteristicNotifiedListenerApi(): PigeonApiCharacteristicNotifiedListenerApi {
        return CentralManagerImpl.CharacteristicNotifiedListenerImpl(this, contextUtil.mainExecutor)
    }

    override fun getPigeonApiBluetoothLowEnergyPeerApi(): PigeonApiBluetoothLowEnergyPeerApi {
        return BluetoothLowEnergyPeerImpl(this)
    }

    override fun getPigeonApiGATTAttributeApi(): PigeonApiGATTAttributeApi {
        return GATTAttributeImpl(this)
    }

    override fun getPigeonApiGATTCharacteristicApi(): PigeonApiGATTCharacteristicApi {
        return GATTCharacteristicImpl(this)
    }

    override fun getPigeonApiGATTServiceApi(): PigeonApiGATTServiceApi {
        return GATTServiceImpl(this)
    }
}