#include "include/bluetooth_low_energy_windows/bluetooth_low_energy_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "bluetooth_low_energy_windows_plugin.h"

void BluetoothLowEnergyWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  bluetooth_low_energy_windows::BluetoothLowEnergyWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
