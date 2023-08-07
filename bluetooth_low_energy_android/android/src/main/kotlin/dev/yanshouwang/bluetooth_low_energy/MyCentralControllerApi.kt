package dev.yanshouwang.bluetooth_low_energy

import android.content.Context

class MyCentralControllerApi(context: Context, private val instanceManager: MyInstanceManager) : MyCentralControllerHostApi {
    private val controller = MyCentralController(context)

    override fun allocate(): Long {
        return instanceManager.allocate(controller)
    }

    override fun getState(hashCode: Long): Long {
        val controller = instanceManager.instanceOf(hashCode) as MyCentralController
        return controller.getState()
    }

    override fun startDiscovery(hashCode: Long) {
        val controller = instanceManager.instanceOf(hashCode) as MyCentralController
        return controller.startDiscovery()
    }

    override fun stopDiscovery(hashCode: Long) {
        val controller = instanceManager.instanceOf(hashCode) as MyCentralController
        return controller.stopDiscovery()
    }

    override fun connect(hashCode: Long, peripheralHashCode: Long) {
        TODO("Not yet implemented")
    }

    override fun disconnect(hashCode: Long, peripheralHashCode: Long) {
        TODO("Not yet implemented")
    }

    override fun discoverServices(hashCode: Long, peripheralHashCode: Long): List<Long> {
        TODO("Not yet implemented")
    }

    override fun discoverCharacteristics(hashCode: Long, serviceHashCode: Long): List<Long> {
        TODO("Not yet implemented")
    }

    override fun discoverDescriptors(hashCode: Long, characteristicHashCode: Long): List<Long> {
        TODO("Not yet implemented")
    }

    override fun readCharacteristic(hashCode: Long, characteristicHashCode: Long): ByteArray {
        TODO("Not yet implemented")
    }

    override fun writeCharacteristic(hashCode: Long, characteristicHashCode: Long, value: ByteArray, type: Long) {
        TODO("Not yet implemented")
    }

    override fun notifyCharacteristic(hashCode: Long, characteristicHashCode: Long, state: Boolean) {
        TODO("Not yet implemented")
    }

    override fun readDescriptor(hashCode: Long, descriptorHashCode: Long): ByteArray {
        TODO("Not yet implemented")
    }

    override fun writeDescriptor(hashCode: Long, descriptorHashCode: Long, value: ByteArray) {
        TODO("Not yet implemented")
    }
}