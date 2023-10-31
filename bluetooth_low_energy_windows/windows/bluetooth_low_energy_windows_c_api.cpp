#include "include/bluetooth_low_energy_windows/bluetooth_low_energy_windows_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "bluetooth_low_energy_windows.h"

void BluetoothLowEnergyWindowsCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  bluetooth_low_energy_windows::BluetoothLowEnergyWindows::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
