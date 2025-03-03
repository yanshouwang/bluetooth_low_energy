package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.ScanSettings

class ScanSettingsImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) : PigeonApiScanSettings(registrar) {
    override fun getCallbackType(pigeon_instance: ScanSettings): Long {
        return pigeon_instance.callbackType.toLong()
    }

    override fun getLegacy(pigeon_instance: ScanSettings): Boolean {
        return pigeon_instance.legacy
    }

    override fun getPhy(pigeon_instance: ScanSettings): Long {
        return pigeon_instance.phy.toLong()
    }

    override fun getReportDelayMillis(pigeon_instance: ScanSettings): Long {
        return pigeon_instance.reportDelayMillis
    }

    override fun getScanMode(pigeon_instance: ScanSettings): Long {
        return pigeon_instance.scanMode.toLong()
    }

    override fun getScanResultType(pigeon_instance: ScanSettings): Long {
        return pigeon_instance.scanResultType.toLong()
    }
}