package dev.hebei.bluetooth_low_energy_android

class GATTAttributeImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiGATTAttributeApi(registrar) {
    override fun getUUID(pigeon_instance: GATTAttribute): String {
        return pigeon_instance.uuid.toString()
    }

    override fun getInstanceId(pigeon_instance: GATTAttribute): Long {
        return pigeon_instance.instanceId.toLong()
    }
}