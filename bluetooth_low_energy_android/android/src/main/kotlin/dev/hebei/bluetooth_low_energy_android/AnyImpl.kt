package dev.hebei.bluetooth_low_energy_android

class AnyImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) : PigeonApiAny(registrar) {
    override fun pigeon_defaultConstructor(): Any {
        return Any()
    }

    override fun equals(pigeon_instance: Any, other: Any?): Boolean {
        return pigeon_instance == other
    }

    override fun hashCodeX(pigeon_instance: Any): Long {
        return pigeon_instance.hashCode().toLong()
    }

    override fun toStringX(pigeon_instance: Any): String {
        return pigeon_instance.toString()
    }
}