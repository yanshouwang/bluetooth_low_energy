package dev.hebei.bluetooth_low_energy_android

import android.os.ParcelUuid
import java.util.*

class ParcelUuidImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) : PigeonApiParcelUuid(registrar) {
    override fun pigeon_defaultConstructor(uuid: UUID): ParcelUuid {
        return ParcelUuid(uuid)
    }

    override fun fromString(uuid: String): ParcelUuid {
        return ParcelUuid.fromString(uuid)
    }

    override fun getUuid(pigeon_instance: ParcelUuid): UUID {
        return pigeon_instance.uuid
    }
}