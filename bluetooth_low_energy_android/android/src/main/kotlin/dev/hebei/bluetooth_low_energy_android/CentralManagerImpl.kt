import dev.hebei.bluetooth_low_energy_android.ActivityUtil
import dev.hebei.bluetooth_low_energy_android.Advertisement
import dev.hebei.bluetooth_low_energy_android.BluetoothLowEnergyManager
import dev.hebei.bluetooth_low_energy_android.BluetoothLowEnergyState
import dev.hebei.bluetooth_low_energy_android.BluetoothLowEnergyStateApi
import dev.hebei.bluetooth_low_energy_android.CentralManager
import dev.hebei.bluetooth_low_energy_android.CentralManagerFlutterApi
import dev.hebei.bluetooth_low_energy_android.CentralManagerHostApi
import dev.hebei.bluetooth_low_energy_android.ConnectionPriorityApi
import dev.hebei.bluetooth_low_energy_android.ConnectionState
import dev.hebei.bluetooth_low_energy_android.ContextUtil
import dev.hebei.bluetooth_low_energy_android.GATTAttribute
import dev.hebei.bluetooth_low_energy_android.GATTCharacteristic
import dev.hebei.bluetooth_low_energy_android.GATTCharacteristicWriteTypeApi
import dev.hebei.bluetooth_low_energy_android.GATTDescriptor
import dev.hebei.bluetooth_low_energy_android.GATTService
import dev.hebei.bluetooth_low_energy_android.GATTServiceApi
import dev.hebei.bluetooth_low_energy_android.Peripheral
import dev.hebei.bluetooth_low_energy_android.PeripheralApi
import dev.hebei.bluetooth_low_energy_android.api
import dev.hebei.bluetooth_low_energy_android.impl
import io.flutter.plugin.common.BinaryMessenger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.UUID

class CentralManagerImpl(messenger: BinaryMessenger, contextUtil: ContextUtil, activityUtil: ActivityUtil) :
    CentralManagerHostApi {
    private val api = CentralManagerFlutterApi(messenger)

    // TODO: How to free these native instances automatically
    private val impl by lazy { CentralManager(contextUtil, activityUtil) }
    private val peripheralImpls = mutableMapOf<String, Peripheral>()
    private val attrImpls = mutableMapOf<Int, GATTAttribute>()

    private val stateChangedListener = object : BluetoothLowEnergyManager.StateChangedListener {
        override fun onChanged(state: BluetoothLowEnergyState) {
            api.onStateChanged(state.api) {}
        }

    }
    private val nameChangedListener = object : BluetoothLowEnergyManager.NameChangedListener {
        override fun onChanged(name: String?) {
            api.onNameChanged(name) {}
        }
    }
    private val discoveredListener = object : CentralManager.DiscoveredListener {
        override fun onDiscovered(peripheral: Peripheral, rssi: Int, advertisement: Advertisement) {
            addPeripheralImpl(peripheral)
            api.onDiscovered(peripheral.api, rssi.api, advertisement.api) {}
        }
    }
    private val connectionStateChangedListener = object : CentralManager.ConnectionStateChangedListener {
        override fun onChanged(peripheral: Peripheral, state: ConnectionState) {
            api.onConnectionStateChanged(peripheral.api, state.api) {}
        }
    }
    private val mtuChangedListener = object : CentralManager.MTUChangedListener {
        override fun onChanged(peripheral: Peripheral, mtu: Int) {
            api.onMTUChanged(peripheral.api, mtu.api) {}
        }
    }
    private val characteristicNotifiedListener = object : CentralManager.CharacteristicNotifiedListener {
        override fun onNotified(characteristic: GATTCharacteristic, value: ByteArray) {
            api.onCharacteristicNotified(characteristic.api, value) {}
        }
    }

    override fun addStateChangedListener() {
        impl.addStateChangedListener(stateChangedListener)
    }

    override fun removeStateChangedListener() {
        impl.removeStateChangedListener(stateChangedListener)
    }

    override fun addNameChangedListener() {
        impl.addNameChangedListener(nameChangedListener)
    }

    override fun removeNameChangedListener() {
        impl.removeNameChangedListener(nameChangedListener)
    }

    override fun addDiscoveredListener() {
        impl.addDiscoveredListener(discoveredListener)
    }

    override fun removeDiscoveredListener() {
        impl.removeDiscoveredListener(discoveredListener)
    }

    override fun addConnectionStateChangedListener() {
        impl.addConnectionStateChangedListener(connectionStateChangedListener)
    }

    override fun removeConnectionStateChangedListener() {
        impl.removeConnectionStateChangedListener(connectionStateChangedListener)
    }

    override fun addMTUChanagedListener() {
        impl.addMTUChangedListener(mtuChangedListener)
    }

    override fun removeMTUChangedListener() {
        impl.removeMTUChangedListener(mtuChangedListener)
    }

    override fun addCharacteristicNotifiedListener() {
        impl.addCharacteristicNotifiedListener(characteristicNotifiedListener)
    }

    override fun removeCharacteristicNotifiedListener() {
        impl.removeCharacteristicNotifiedListener(characteristicNotifiedListener)
    }

    override fun getState(): BluetoothLowEnergyStateApi {
        val stateImpl = impl.state
        return stateImpl.api
    }

    override fun shouldShowAuthorizeRationale(): Boolean {
        return impl.shouldShowAuthorizeRationale()
    }

    override fun authorize(callback: (Result<Boolean>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val isAuthorized = impl.authorize()
                callback(Result.success(isAuthorized))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun showAppSettings() {
        impl.showAppSettings()
    }

    override fun turnOn(callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                impl.turnOn()
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun turnOff(callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                impl.turnOff()
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getName(): String? {
        return impl.name
    }

    override fun setName(name: String?, callback: (Result<String?>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val name1 = impl.setName(name)
                callback(Result.success(name1))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun startDiscovery(serviceUUIDs: List<String>, callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val serviceUUIDImpls = serviceUUIDs.map { UUID.fromString(it) }
                impl.startDiscovery(serviceUUIDImpls)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun stopDiscovery() {
        impl.stopDiscovery()
    }

    override fun retrieveConnectedPeripherals(): List<PeripheralApi> {
        val peripheralImpls = impl.retrieveConnectedPeripherals()
        return peripheralImpls.map { it.api }
    }

    override fun connect(address: String, callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val peripheralImpl = retrievePeripheralImpl(address)
                impl.connect(peripheralImpl)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun disconnect(address: String, callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val peripheralImpl = retrievePeripheralImpl(address)
                impl.disconnect(peripheralImpl)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun requestMTU(address: String, mtu: Long, callback: (Result<Long>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val peripheralImpl = retrievePeripheralImpl(address)
                val mtu1Impl = impl.requestMTU(peripheralImpl, mtu.impl)
                callback(Result.success(mtu1Impl.api))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun requestConnectionPriority(address: String, priority: ConnectionPriorityApi) {
        val peripheralImpl = retrievePeripheralImpl(address)
        impl.requestConnectionPriority(peripheralImpl, priority.impl)
    }

    override fun getMaximumWriteLength(address: String, type: GATTCharacteristicWriteTypeApi): Long {
        val peripheralImpl = retrievePeripheralImpl(address)
        val maximumWriteLengthImpl = impl.getMaximumWriteLength(peripheralImpl, type.impl)
        return maximumWriteLengthImpl.api
    }

    override fun readRSSI(address: String, callback: (Result<Long>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val peripheralImpl = retrievePeripheralImpl(address)
                val rssiImpl = impl.readRSSI(peripheralImpl)
                callback(Result.success(rssiImpl.api))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun discoverServices(address: String, callback: (Result<List<GATTServiceApi>>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val peripheralImpl = retrievePeripheralImpl(address)
                val serviceImpls = impl.discoverServices(peripheralImpl)
                for (serviceImpl in serviceImpls) {
                    addServiceImpl(serviceImpl)
                }
                val services = serviceImpls.map { it.api }
                callback(Result.success(services))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun readCharacteristic(id: Long, callback: (Result<ByteArray>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val characteristicImpl = retrieveCharacteristicImpl(id.impl)
                val value = impl.readCharacteristic(characteristicImpl)
                callback(Result.success(value))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun writeCharacteristic(
        id: Long, value: ByteArray, type: GATTCharacteristicWriteTypeApi, callback: (Result<Unit>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val characteristicImpl = retrieveCharacteristicImpl(id.impl)
                impl.writeCharacteristic(characteristicImpl, value, type.impl)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun setCharacteristicNotifyState(id: Long, state: Boolean, callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val characteristicImpl = retrieveCharacteristicImpl(id.impl)
                impl.setCharacteristicNotifyState(characteristicImpl, state)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun readDescriptor(id: Long, callback: (Result<ByteArray>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val descriptorImpl = retrieveDescriptorImpl(id.impl)
                val value = impl.readDescriptor(descriptorImpl)
                callback(Result.success(value))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    override fun writeDescriptor(id: Long, value: ByteArray, callback: (Result<Unit>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val descriptorImpl = retrieveDescriptorImpl(id.impl)
                impl.writeDescriptor(descriptorImpl, value)
                callback(Result.success(Unit))
            } catch (e: Exception) {
                callback(Result.failure(e))
            }
        }
    }

    private fun addPeripheralImpl(peripheralImpl: Peripheral) {
        peripheralImpls[peripheralImpl.address] = peripheralImpl
    }

    private fun addServiceImpl(serviceImpl: GATTService) {
        val includedServiceImpls = serviceImpl.includedServices
        for (includedServiceImpl in includedServiceImpls) {
            addServiceImpl(includedServiceImpl)
        }
        for (characteristicImpl in serviceImpl.characteristics) {
            for (descriptorImpl in characteristicImpl.descriptors) {
                attrImpls[descriptorImpl.instanceId] = descriptorImpl
            }
            attrImpls[characteristicImpl.instanceId] = characteristicImpl
        }
        attrImpls[serviceImpl.instanceId] = serviceImpl
    }

    private fun retrievePeripheralImpl(address: String): Peripheral {
        return peripheralImpls[address] ?: throw NullPointerException("peripheral is null: $address")
    }

    private fun retrieveCharacteristicImpl(id: Int): GATTCharacteristic {
        val attr = attrImpls[id] ?: throw NullPointerException("characteristic is null")
        return attr as GATTCharacteristic
    }

    private fun retrieveDescriptorImpl(id: Int): GATTDescriptor {
        val attr = attrImpls[id] ?: throw NullPointerException("descriptor is null")
        return attr as GATTDescriptor
    }
}