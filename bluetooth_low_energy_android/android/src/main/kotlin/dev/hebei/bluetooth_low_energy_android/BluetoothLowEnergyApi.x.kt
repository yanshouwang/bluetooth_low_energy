package dev.hebei.bluetooth_low_energy_android

import java.util.UUID

val Long.impl: Int get() = toInt()
val String.uuidImpl: UUID get() = UUID.fromString(this)

val ConnectionPriorityApi.impl: ConnectionPriority
    get() = when (this) {
        ConnectionPriorityApi.BALANCED -> ConnectionPriority.BALANCED
        ConnectionPriorityApi.HIGH -> ConnectionPriority.HIGH
        ConnectionPriorityApi.LOW_POWER -> ConnectionPriority.LOW_POWER
        ConnectionPriorityApi.DCK -> ConnectionPriority.DCK
    }

val GATTCharacteristicWriteTypeApi.impl: GATTCharacteristicWriteType
    get() = when (this) {
        GATTCharacteristicWriteTypeApi.WITH_RESPONSE -> GATTCharacteristicWriteType.WITH_RESPONSE
        GATTCharacteristicWriteTypeApi.WITHOUT_RESPONSE -> GATTCharacteristicWriteType.WITHOUT_RESPONSE
    }

val Int.api: Long get() = toLong()
val UUID.api: String get() = toString()

val BluetoothLowEnergyState.api: BluetoothLowEnergyStateApi
    get() = when (this) {
        BluetoothLowEnergyState.UNKNOWN -> BluetoothLowEnergyStateApi.UNKNOWN
        BluetoothLowEnergyState.UNSUPPORTED -> BluetoothLowEnergyStateApi.UNSUPPORTED
        BluetoothLowEnergyState.UNAUTHORIZED -> BluetoothLowEnergyStateApi.UNAUTHORIZED
        BluetoothLowEnergyState.OFF -> BluetoothLowEnergyStateApi.OFF
        BluetoothLowEnergyState.TURNING_ON -> BluetoothLowEnergyStateApi.TURNING_ON
        BluetoothLowEnergyState.ON -> BluetoothLowEnergyStateApi.ON
        BluetoothLowEnergyState.TURNING_OFF -> BluetoothLowEnergyStateApi.TURNING_OFF
    }

val Peripheral.api: PeripheralApi get() = PeripheralApi(address)

val ManufacturerSpecificData.api: ManufacturerSpecificDataApi
    get() = ManufacturerSpecificDataApi(id.api, data)

val Advertisement.api: AdvertisementApi
    get() = AdvertisementApi(
        name,
        serviceUUIDs.map { it.api },
        serviceData.mapKeys { it.key.api },
        manufacturerSpecificData.map { it.api },
    )

val ConnectionState.api: ConnectionStateApi
    get() = when (this) {
        ConnectionState.DISCONNECTED -> ConnectionStateApi.DISCONNECTED
        ConnectionState.CONNECTING -> ConnectionStateApi.CONNECTING
        ConnectionState.CONNECTED -> ConnectionStateApi.CONNECTED
        ConnectionState.DISCONNECTING -> ConnectionStateApi.DISCONNECTING
    }

val GATTDescriptor.api: GATTDescriptorApi get() = GATTDescriptorApi(instanceId.api, uuid.api)

val GATTCharacteristic.api: GATTCharacteristicApi
    get() = GATTCharacteristicApi(
        instanceId.api,
        uuid.api,
        properties.map { it.api },
        descriptors.map { it.api },
    )

val GATTService.api: GATTServiceApi
    get() = GATTServiceApi(
        instanceId.api,
        uuid.api,
        isPrimary,
        includedServices.map { it.api },
        characteristics.map { it.api },
    )

val GATTCharacteristicProperty.api: GATTCharacteristicPropertyApi
    get() = when (this) {
        GATTCharacteristicProperty.READ -> GATTCharacteristicPropertyApi.READ
        GATTCharacteristicProperty.WRITE -> GATTCharacteristicPropertyApi.WRITE
        GATTCharacteristicProperty.WRITE_WITHOUT_RESPONSE -> GATTCharacteristicPropertyApi.WRITE_WITHOUT_RESPONSE
        GATTCharacteristicProperty.NOTIFY -> GATTCharacteristicPropertyApi.NOTIFY
        GATTCharacteristicProperty.INDICATE -> GATTCharacteristicPropertyApi.INDICATE
    }
