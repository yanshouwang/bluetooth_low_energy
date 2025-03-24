package dev.hebei.bluetooth_low_energy_android

class GATTServiceImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiGATTServiceApi(registrar) {
    override fun getIsPrimary(pigeon_instance: GATTService): Boolean {
        return pigeon_instance.isPrimary
    }

    override fun getIncludedServices(pigeon_instance: GATTService): List<GATTService> {
        return pigeon_instance.includedServices
    }

    override fun getCharacteristics(pigeon_instance: GATTService): List<GATTCharacteristic> {
        return pigeon_instance.characteristics
    }
}