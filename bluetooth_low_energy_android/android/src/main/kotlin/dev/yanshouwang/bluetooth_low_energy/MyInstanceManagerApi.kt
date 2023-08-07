package dev.yanshouwang.bluetooth_low_energy

class MyInstanceManagerApi(private val myInstanceManager: MyInstanceManager) : MyInstanceManagerHostApi {
    override fun free(hashCode: Long) {
        myInstanceManager.free(hashCode)
    }
}