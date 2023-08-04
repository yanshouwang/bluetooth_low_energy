package dev.yanshouwang.bluetooth_low_energy

import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothProfile.ServiceListener

class MyBluetoothProfileServiceListener(private val api: BluetoothProfileServiceListenerFlutterApi, private val instanceManager: InstanceManager) : ServiceListener {
    override fun onServiceConnected(profile: Int, proxy: BluetoothProfile) {
        val profile1 = profile.toLong()
        val proxyHashCode = instanceManager.allocate(proxy)
        api.onServiceConnected(hashCode1, profile1, proxyHashCode) {}
    }

    override fun onServiceDisconnected(profile: Int) {
        val profile1 = profile.toLong()
        api.onServiceDisconnected(hashCode1, profile1) {}
    }
}