package dev.hebei.bluetooth_low_energy_android

class PeripheralManager(contextUtil: ContextUtil, activityUtil: ActivityUtil) :
    BluetoothLowEnergyManager(contextUtil, activityUtil) {
    override val permissions: Array<String>
        get() = TODO("Not yet implemented")
    override val requestCode: Int
        get() = TODO("Not yet implemented")
}