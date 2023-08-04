package dev.yanshouwang.bluetooth_low_energy

import java.util.UUID

class UuidApi(private val instanceManager: InstanceManager) : UuidHostApi {
    override fun newInstance(mostSigBits: Long, leastSigBits: Long): Long {
        val uuid = UUID(mostSigBits, leastSigBits)
        return instanceManager.allocate(uuid)
    }

    override fun randomUUID(): Long {
        val uuid = UUID.randomUUID()
        return instanceManager.allocate(uuid)
    }

    override fun fromString(name: String): Long {
        val uuid = UUID.fromString(name)
        return instanceManager.allocate(uuid)
    }

    override fun nameUUIDFromBytes(name: ByteArray): Long {
        val uuid = UUID.nameUUIDFromBytes(name)
        return instanceManager.allocate(uuid)
    }
}