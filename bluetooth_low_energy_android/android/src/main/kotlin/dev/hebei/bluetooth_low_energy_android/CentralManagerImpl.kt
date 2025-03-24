package dev.hebei.bluetooth_low_energy_android

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.UUID

class CentralManagerImpl(
    registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar, contextUtil: ContextUtil, activityUtil: ActivityUtil
) : PigeonApiCentralManagerApi(registrar) {
    private val instance by lazy { CentralManager(contextUtil, activityUtil) }

    override fun pigeon_defaultConstructor(): CentralManager {
        return instance
    }

    override fun addDiscoveredListener(pigeon_instance: CentralManager, listener: CentralManager.DiscoveredListener) {
        pigeon_instance.addDiscoveredListener(listener)
    }

    override fun removeDiscoveredListener(
        pigeon_instance: CentralManager, listener: CentralManager.DiscoveredListener
    ) {
        pigeon_instance.removeDiscoveredListener(listener)
    }

    override fun addConnectionStateChangedListener(
        pigeon_instance: CentralManager, listener: CentralManager.ConnectionStateChangedListener
    ) {
        pigeon_instance.addConnectionStateChangedListener(listener)
    }

    override fun removeConnectionStateChangedListener(
        pigeon_instance: CentralManager, listener: CentralManager.ConnectionStateChangedListener
    ) {
        pigeon_instance.removeConnectionStateChangedListener(listener)
    }

    override fun addMTUChanagedListener(pigeon_instance: CentralManager, listener: CentralManager.MTUChangedListener) {
        pigeon_instance.addMTUChangedListener(listener)
    }

    override fun removeMTUChangedListener(
        pigeon_instance: CentralManager, listener: CentralManager.MTUChangedListener
    ) {
        pigeon_instance.removeMTUChangedListener(listener)
    }

    override fun addCharacteristicNotifiedListener(
        pigeon_instance: CentralManager, listener: CentralManager.CharacteristicNotifiedListener
    ) {
        pigeon_instance.addCharacteristicNotifiedListener(listener)
    }

    override fun removeCharacteristicNotifiedListener(
        pigeon_instance: CentralManager, listener: CentralManager.CharacteristicNotifiedListener
    ) {
        pigeon_instance.removeCharacteristicNotifiedListener(listener)
    }

    override fun startDiscovery(
        pigeon_instance: CentralManager, serviceUUIDs: List<String>, callback: (Result<Unit>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                pigeon_instance.startDiscovery(serviceUUIDs.map { UUID.fromString(it) })
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun stopDiscovery(pigeon_instance: CentralManager) {
        pigeon_instance.stopDiscovery()
    }

    override fun retrieveConnectedPeripherals(pigeon_instance: CentralManager): List<Peripheral> {
        return pigeon_instance.retrieveConnectedPeripherals()
    }

    override fun connect(pigeon_instance: CentralManager, peripheral: Peripheral, callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                pigeon_instance.connect(peripheral)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun disconnect(pigeon_instance: CentralManager, peripheral: Peripheral, callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                pigeon_instance.disconnect(peripheral)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun requestMTU(
        pigeon_instance: CentralManager, peripheral: Peripheral, mtu: Long, callback: (Result<Long>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val mtu1 = pigeon_instance.requestMTU(peripheral, mtu.toInt())
                callback(Result.success(mtu1.toLong()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun requestConnectionPriority(
        pigeon_instance: CentralManager, peripheral: Peripheral, priority: ConnectionPriorityApi
    ) {
        pigeon_instance.requestConnectionPriority(peripheral, priority.obj)
    }

    override fun getMaximumWriteLength(
        pigeon_instance: CentralManager, peripheral: Peripheral, type: GATTCharacteristicWriteTypeApi
    ): Long {
        val maximumWriteLength = pigeon_instance.getMaximumWriteLength(peripheral, type.obj)
        return maximumWriteLength.toLong()
    }

    override fun readRSSI(pigeon_instance: CentralManager, peripheral: Peripheral, callback: (Result<Long>) -> Unit) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val rssi = pigeon_instance.readRSSI(peripheral)
                callback(Result.success(rssi.toLong()))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun discoverServices(
        pigeon_instance: CentralManager, peripheral: Peripheral, callback: (Result<List<GATTService>>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val services = pigeon_instance.discoverServices(peripheral)
                callback(Result.success(services))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun readCharacteristic(
        pigeon_instance: CentralManager, characterisic: GATTCharacteristic, callback: (Result<ByteArray>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val value = pigeon_instance.readCharacteristic(characterisic)
                callback(Result.success(value))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun writeCharacteristic(
        pigeon_instance: CentralManager,
        characterisic: GATTCharacteristic,
        value: ByteArray,
        type: GATTCharacteristicWriteTypeApi,
        callback: (Result<Unit>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                pigeon_instance.writeCharacteristic(characterisic, value, type.obj)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun setCharacteristicNotifyState(
        pigeon_instance: CentralManager,
        characterisic: GATTCharacteristic,
        state: Boolean,
        callback: (Result<Unit>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                pigeon_instance.setCharacteristicNotifyState(characterisic, state)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun readDescriptor(
        pigeon_instance: CentralManager, descriptor: GATTDescriptor, callback: (Result<ByteArray>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val value = pigeon_instance.readDescriptor(descriptor)
                callback(Result.success(value))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun writeDescriptor(
        pigeon_instance: CentralManager, descriptor: GATTDescriptor, value: ByteArray, callback: (Result<Unit>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                pigeon_instance.writeDescriptor(descriptor, value)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    class DiscoveredListenerImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
        PigeonApiDiscoveredListenerApi(registrar) {
        override fun pigeon_defaultConstructor(): CentralManager.DiscoveredListener {
            return object : CentralManager.DiscoveredListener {
                override fun onDiscovered(peripheral: Peripheral, rssi: Int, advertisement: Advertisement) {
                    this@DiscoveredListenerImpl.onDiscovered(
                        this, peripheral, rssi.toLong(), advertisement.api.toByteArray()
                    ) {}
                }
            }
        }
    }

    class ConnectionStateChangedListenerImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
        PigeonApiConnectionStateChangedListenerApi(registrar) {
        override fun pigeon_defaultConstructor(): CentralManager.ConnectionStateChangedListener {
            return object : CentralManager.ConnectionStateChangedListener {
                override fun onChanged(peripheral: Peripheral, state: ConnectionState) {
                    this@ConnectionStateChangedListenerImpl.onChanged(this, peripheral, state.api) {}
                }
            }
        }
    }

    class MTUChangedListenerImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
        PigeonApiMTUChangedListenerApi(registrar) {
        override fun pigeon_defaultConstructor(): CentralManager.MTUChangedListener {
            return object : CentralManager.MTUChangedListener {
                override fun onChanged(peripheral: Peripheral, mtu: Int) {
                    this@MTUChangedListenerImpl.onChanged(this, peripheral, mtu.toLong()) {}
                }
            }
        }
    }

    class CharacteristicNotifiedListenerImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
        PigeonApiCharacteristicNotifiedListenerApi(registrar) {
        override fun pigeon_defaultConstructor(): CentralManager.CharacteristicNotifiedListener {
            return object : CentralManager.CharacteristicNotifiedListener {
                override fun onNotified(characteristic: GATTCharacteristic, value: ByteArray) {
                    this@CharacteristicNotifiedListenerImpl.onNotified(this, characteristic, value) {}
                }
            }
        }
    }
}