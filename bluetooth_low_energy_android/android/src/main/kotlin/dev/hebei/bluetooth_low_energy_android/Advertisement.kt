package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.ScanRecord
import java.util.UUID

class Advertisement {
    val name: String?
    val serviceUUIDs: List<UUID>
    val serviceData: Map<UUID, ByteArray>
    val manufacturerSpecificData: List<ManufacturerSpecificData>

    constructor(
        name: String? = null,
        serviceUUIDs: List<UUID> = emptyList(),
        serviceData: Map<UUID, ByteArray> = emptyMap(),
        manufacturerSpecificData: List<ManufacturerSpecificData> = emptyList()
    ) {
        this.name = name
        this.serviceUUIDs = serviceUUIDs
        this.serviceData = serviceData
        this.manufacturerSpecificData = manufacturerSpecificData
    }

    internal constructor(obj: ScanRecord) {
        this.name = obj.deviceName
        this.serviceUUIDs = obj.serviceUuids?.map { it.uuid } ?: emptyList()
        this.serviceData = obj.serviceData?.mapKeys { it.key.uuid } ?: emptyMap()
        this.manufacturerSpecificData = obj.manufacturerSpecificData?.manufacturerSpecificDataArgs ?: emptyList()
    }
}