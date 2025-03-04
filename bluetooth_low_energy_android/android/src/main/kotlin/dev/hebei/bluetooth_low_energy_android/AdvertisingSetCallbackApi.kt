package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.AdvertisingSet
import android.bluetooth.le.AdvertisingSetCallback
import android.os.Build
import androidx.annotation.RequiresApi

class AdvertisingSetCallbackApi(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiAdvertisingSetCallback(registrar) {

    @RequiresApi(Build.VERSION_CODES.O)
    override fun pigeon_defaultConstructor(): AdvertisingSetCallback {
        return object : AdvertisingSetCallback() {
            override fun onAdvertisingDataSet(advertisingSet: AdvertisingSet, status: Int) {
                super.onAdvertisingDataSet(advertisingSet, status)
                this@AdvertisingSetCallbackApi.onAdvertisingDataSet(this, advertisingSet, status.toLong()) {}
            }

            override fun onAdvertisingEnabled(advertisingSet: AdvertisingSet, enable: Boolean, status: Int) {
                super.onAdvertisingEnabled(advertisingSet, enable, status)
                this@AdvertisingSetCallbackApi.onAdvertisingEnabled(this, advertisingSet, enable, status.toLong()) {}
            }

            override fun onAdvertisingParametersUpdated(advertisingSet: AdvertisingSet, txPower: Int, status: Int) {
                super.onAdvertisingParametersUpdated(advertisingSet, txPower, status)
                this@AdvertisingSetCallbackApi.onAdvertisingParametersUpdated(
                    this, advertisingSet, txPower.toLong(), status.toLong()
                ) {}
            }

            override fun onAdvertisingSetStarted(advertisingSet: AdvertisingSet, txPower: Int, status: Int) {
                super.onAdvertisingSetStarted(advertisingSet, txPower, status)
                this@AdvertisingSetCallbackApi.onAdvertisingSetStarted(
                    this, advertisingSet, txPower.toLong(), status.toLong()
                ) {}
            }

            override fun onAdvertisingSetStopped(advertisingSet: AdvertisingSet) {
                super.onAdvertisingSetStopped(advertisingSet)
                this@AdvertisingSetCallbackApi.onAdvertisingSetStopped(this, advertisingSet) {}
            }

            override fun onPeriodicAdvertisingDataSet(advertisingSet: AdvertisingSet, status: Int) {
                super.onPeriodicAdvertisingDataSet(advertisingSet, status)
                this@AdvertisingSetCallbackApi.onPeriodicAdvertisingDataSet(this, advertisingSet, status.toLong()) {}
            }

            override fun onPeriodicAdvertisingEnabled(advertisingSet: AdvertisingSet, enable: Boolean, status: Int) {
                super.onPeriodicAdvertisingEnabled(advertisingSet, enable, status)
                this@AdvertisingSetCallbackApi.onPeriodicAdvertisingEnabled(
                    this, advertisingSet, enable, status.toLong()
                ) {}
            }

            override fun onPeriodicAdvertisingParametersUpdated(advertisingSet: AdvertisingSet, status: Int) {
                super.onPeriodicAdvertisingParametersUpdated(advertisingSet, status)
                this@AdvertisingSetCallbackApi.onPeriodicAdvertisingParametersUpdated(
                    this, advertisingSet, status.toLong()
                ) {}
            }

            override fun onScanResponseDataSet(advertisingSet: AdvertisingSet, status: Int) {
                super.onScanResponseDataSet(advertisingSet, status)
                this@AdvertisingSetCallbackApi.onScanResponseDataSet(this, advertisingSet, status.toLong()) {}
            }
        }
    }
}