package dev.hebei.bluetooth_low_energy_android

class AnyImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) : PigeonApiAny(registrar) {
    override fun pigeon_defaultConstructor(): Any {
        return Any()
    }

    override fun equals(pigeon_instance: Any, other: Any?): Boolean {
        return pigeon_instance == other
    }
}