package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.ScanSettings

class ScanSettingsBuilderImpl(registrar: BluetoothLowEnergyPigeonProxyApiRegistrar) :
    PigeonApiScanSettingsBuilder(registrar) {
    override fun pigeon_defaultConstructor(): ScanSettings.Builder {
        return ScanSettings.Builder()
    }

    override fun build(pigeon_instance: ScanSettings.Builder): ScanSettings {
        return pigeon_instance.build()
    }

    override fun setCallbackType(pigeon_instance: ScanSettings.Builder, callbackType: Long): ScanSettings.Builder {
        return pigeon_instance.setCallbackType(callbackType.toInt())
    }

    override fun setLegacy(pigeon_instance: ScanSettings.Builder, legacy: Boolean): ScanSettings.Builder {
        return pigeon_instance.setLegacy(legacy)
    }

    override fun setMatchMode(pigeon_instance: ScanSettings.Builder, matchMode: Long): ScanSettings.Builder {
        return pigeon_instance.setMatchMode(matchMode.toInt())
    }

    override fun setNumOfMatches(pigeon_instance: ScanSettings.Builder, numOfMatches: Long): ScanSettings.Builder {
        return pigeon_instance.setNumOfMatches(numOfMatches.toInt())
    }

    override fun setPhy(pigeon_instance: ScanSettings.Builder, phy: Long): ScanSettings.Builder {
        return pigeon_instance.setPhy(phy.toInt())
    }

    override fun setReportDelay(pigeon_instance: ScanSettings.Builder, reportDelayMillis: Long): ScanSettings.Builder {
        return pigeon_instance.setReportDelay(reportDelayMillis)
    }

    override fun setScanMode(pigeon_instance: ScanSettings.Builder, scanMode: Long): ScanSettings.Builder {
        return pigeon_instance.setScanMode(scanMode.toInt())
    }
}