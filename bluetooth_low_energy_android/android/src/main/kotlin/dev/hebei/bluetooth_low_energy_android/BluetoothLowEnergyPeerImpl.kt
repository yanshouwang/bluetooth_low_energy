package dev.hebei.bluetooth_low_energy_android

class BluetoothLowEnergyPeerImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiBluetoothLowEnergyPeerApi(registrar) {
    override fun getAddress(pigeon_instance: BluetoothLowEnergyPeer): String {
        return pigeon_instance.address
    }
}