package dev.hebei.bluetooth_low_energy_android

import android.bluetooth.le.*
import android.os.Build
import androidx.annotation.RequiresApi

class BluetoothLeAdvertiserImpl(registrar: BluetoothLowEnergyAndroidPigeonProxyApiRegistrar) :
    PigeonApiBluetoothLeAdvertiser(registrar) {
    override fun startAdvertising1(
        pigeon_instance: BluetoothLeAdvertiser,
        settings: AdvertiseSettings,
        advertiseData: AdvertiseData,
        callback: AdvertiseCallback
    ) {
        pigeon_instance.startAdvertising(settings, advertiseData, callback)
    }

    override fun startAdvertising2(
        pigeon_instance: BluetoothLeAdvertiser,
        settings: AdvertiseSettings,
        advertiseData: AdvertiseData,
        scanResponse: AdvertiseData,
        callback: AdvertiseCallback
    ) {
        pigeon_instance.startAdvertising(settings, advertiseData, scanResponse, callback)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun startAdvertisingSet1(
        pigeon_instance: BluetoothLeAdvertiser,
        parameters: AdvertisingSetParameters,
        advertiseData: AdvertiseData,
        scanResponse: AdvertiseData,
        periodicParameters: PeriodicAdvertisingParameters,
        periodicData: AdvertiseData,
        callback: AdvertisingSetCallback
    ) {
        pigeon_instance.startAdvertisingSet(
            parameters, advertiseData, scanResponse, periodicParameters, periodicData, callback
        )
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun startAdvertisingSet2(
        pigeon_instance: BluetoothLeAdvertiser,
        parameters: AdvertisingSetParameters,
        advertiseData: AdvertiseData,
        scanResponse: AdvertiseData,
        periodicParameters: PeriodicAdvertisingParameters,
        periodicData: AdvertiseData,
        duration: Long,
        maxExtendedAdvertisingEvents: Long,
        callback: AdvertisingSetCallback
    ) {
        pigeon_instance.startAdvertisingSet(
            parameters,
            advertiseData,
            scanResponse,
            periodicParameters,
            periodicData,
            duration.toInt(),
            maxExtendedAdvertisingEvents.toInt(),
            callback
        )
    }

    override fun stopAdvertising(pigeon_instance: BluetoothLeAdvertiser, callback: AdvertiseCallback) {
        pigeon_instance.stopAdvertising(callback)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun stopAdvertisingSet(pigeon_instance: BluetoothLeAdvertiser, callback: AdvertisingSetCallback) {
        pigeon_instance.stopAdvertisingSet(callback)
    }
}