package dev.hebei.bluetooth_low_energy_android

import android.content.IntentFilter

class IntentFilterImpl(registrar: BluetoothLowEnergyAndroidApiPigeonProxyApiRegistrar) :
    PigeonApiIntentFilter(registrar) {
    override fun new1(): IntentFilter {
        return IntentFilter()
    }

    override fun new2(o: IntentFilter): IntentFilter {
        return IntentFilter(o)
    }

    override fun new3(action: String): IntentFilter {
        return IntentFilter(action)
    }

    override fun new4(action: String, dataType: String): IntentFilter {
        return IntentFilter(action, dataType)
    }
}