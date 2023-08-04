package dev.yanshouwang.bluetooth_low_energy

import android.os.ParcelUuid
import java.util.UUID

class ParcelUuidApi(private val instanceManager: InstanceManager) : ParcelUuidHostApi {
    override fun newInstance(uuidHashCode: Long): Long {
        val uuid = instanceManager.valueOf(uuidHashCode) as UUID
        val parcelUUID = ParcelUuid(uuid)
        return instanceManager.allocate(parcelUUID)
    }

    override fun fromString(uuid: String): Long {
        val parcelUUID = ParcelUuid.fromString(uuid)
        return instanceManager.allocate(parcelUUID)
    }
}