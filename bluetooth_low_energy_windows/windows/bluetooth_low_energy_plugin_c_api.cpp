#include "include/bluetooth_low_energy/bluetooth_low_energy_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "bluetooth_low_energy_plugin.h"

void BluetoothLowEnergyPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  bluetooth_low_energy::BluetoothLowEnergyPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
