package dev.hebei.bluetooth_low_energy_android

data class ManufacturerSpecificData(val id: Int, val data: ByteArray) {
    override fun equals(other: Any?): Boolean {
        if (other === this) return true
        return other is ManufacturerSpecificData && other.id == id && other.data.contentEquals(data)
    }

    override fun hashCode(): Int {
        var result = id
        result = 31 * result + data.contentHashCode()
        return result
    }
}
