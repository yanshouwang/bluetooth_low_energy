package dev.yanshouwang.bluetooth_low_energy

import dev.yanshouwang.bluetooth_low_energy.pigeon.Api

object GattDescriptorHostApi : Api.GattDescriptorHostApi {
    override fun allocate(newId: String, oldId: String) {
        TODO("Not yet implemented")
    }

    override fun free(id: String) {
        TODO("Not yet implemented")
    }

    override fun read(id: String, result: Api.Result<ByteArray>?) {
        TODO("Not yet implemented")
    }

    override fun write(id: String, value: ByteArray, result: Api.Result<Void>?) {
        TODO("Not yet implemented")
    }
}
