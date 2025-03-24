package dev.hebei.bluetooth_low_energy_android

class GATTCharacteristicImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiGATTCharacteristicApi(registrar) {
    override fun getProperties(pigeon_instance: GATTCharacteristic): List<GATTCharacteristicPropertyApi> {
        return pigeon_instance.properties.map { it.api }
    }

    override fun getDescriptors(pigeon_instance: GATTCharacteristic): List<GATTDescriptor> {
        return pigeon_instance.descriptors
    }
}