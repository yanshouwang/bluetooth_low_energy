package dev.hebei.bluetooth_low_energy_android

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class BluetoothLowEnergyManagerImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiBluetoothLowEnergyManagerApi(registrar) {
    override fun addStateChangedListener(
        pigeon_instance: BluetoothLowEnergyManager, listener: BluetoothLowEnergyManager.StateChangedListener
    ) {
        pigeon_instance.addStateChangedListener(listener)
    }

    override fun removeStateChangedListener(
        pigeon_instance: BluetoothLowEnergyManager, listener: BluetoothLowEnergyManager.StateChangedListener
    ) {
        pigeon_instance.removeStateChangedListener(listener)
    }

    override fun addNameChangedListener(
        pigeon_instance: BluetoothLowEnergyManager, listener: BluetoothLowEnergyManager.NameChangedListener
    ) {
        pigeon_instance.addNameChangedListener(listener)
    }

    override fun removeNameChangedListener(
        pigeon_instance: BluetoothLowEnergyManager, listener: BluetoothLowEnergyManager.NameChangedListener
    ) {
        pigeon_instance.removeNameChangedListener(listener)
    }

    override fun getState(pigeon_instance: BluetoothLowEnergyManager): BluetoothLowEnergyStateApi {
        val state = pigeon_instance.state
        return state.api
    }

    override fun turnOn(pigeon_instance: BluetoothLowEnergyManager, callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                pigeon_instance.turnOn()
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun turnOff(pigeon_instance: BluetoothLowEnergyManager, callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                pigeon_instance.turnOff()
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getName(pigeon_instance: BluetoothLowEnergyManager): String? {
        val name = pigeon_instance.name
        return name
    }

    override fun setName(
        pigeon_instance: BluetoothLowEnergyManager, name: String?, callback: (Result<String?>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val name1 = pigeon_instance.setName(name)
                callback(Result.success(name1))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun shouldShowAuthorizeRationale(pigeon_instance: BluetoothLowEnergyManager): Boolean {
        return pigeon_instance.shouldShowAuthorizeRationale()
    }

    override fun authorize(pigeon_instance: BluetoothLowEnergyManager, callback: (Result<Boolean>) -> Unit) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val isAuthorized = pigeon_instance.authorize()
                callback(Result.success(isAuthorized))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun showAppSettings(pigeon_instance: BluetoothLowEnergyManager) {
        pigeon_instance.showAppSettings()
    }

    class StateChangedListenerImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
        PigeonApiStateChangedListenerApi(registrar) {
        override fun pigeon_defaultConstructor(): BluetoothLowEnergyManager.StateChangedListener {
            return object : BluetoothLowEnergyManager.StateChangedListener {
                override fun onChanged(state: BluetoothLowEnergyState) {
                    this@StateChangedListenerImpl.onChanged(this, state.api) {}
                }
            }
        }
    }

    class NameChangedListenerImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
        PigeonApiNameChangedListenerApi(registrar) {
        override fun pigeon_defaultConstructor(): BluetoothLowEnergyManager.NameChangedListener {
            return object : BluetoothLowEnergyManager.NameChangedListener {
                override fun onChanged(name: String?) {
                    this@NameChangedListenerImpl.onChanged(this, name) {}
                }
            }
        }
    }
}