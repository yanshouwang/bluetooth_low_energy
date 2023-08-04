package dev.yanshouwang.bluetooth_low_energy

class InstanceManagerApi(private val instanceManager: InstanceManager) : InstanceManagerHostApi {
    override fun free(hashCode: Long) {
        instanceManager.free(hashCode)
    }
}