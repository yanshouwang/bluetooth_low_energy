package dev.hebei.bluetooth_low_energy_android

import java.util.*

class UUIDImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) : PigeonApiUUID(registrar) {
    override fun pigeon_defaultConstructor(mostSigBits: Long, leastSigBits: Long): UUID {
        return UUID(mostSigBits, leastSigBits)
    }

    override fun clockSequence(pigeon_instance: UUID): Long {
        return pigeon_instance.clockSequence().toLong()
    }

    override fun compareTo(pigeon_instance: UUID, other: UUID): Long {
        return pigeon_instance.compareTo(other).toLong()
    }

    override fun fromString(name: String): UUID {
        return UUID.fromString(name)
    }

    override fun getLeastSignificantBits(pigeon_instance: UUID): Long {
        return pigeon_instance.leastSignificantBits
    }

    override fun getMostSignificantBits(pigeon_instance: UUID): Long {
        return pigeon_instance.mostSignificantBits
    }

    override fun nameUUIDFromBytes(name: ByteArray): UUID {
        return UUID.nameUUIDFromBytes(name)
    }

    override fun node(pigeon_instance: UUID): Long {
        return pigeon_instance.node()
    }

    override fun randomUUID(): UUID {
        return UUID.randomUUID()
    }

    override fun timestamp(pigeon_instance: UUID): Long {
        return pigeon_instance.timestamp()
    }

    override fun variant(pigeon_instance: UUID): Long {
        return pigeon_instance.variant().toLong()
    }
}