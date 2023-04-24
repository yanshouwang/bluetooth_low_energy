//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bluetooth_low_energy/bluetooth_low_energy_plugin_c_api.h>
#include <quick_blue_windows/quick_blue_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BluetoothLowEnergyPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BluetoothLowEnergyPluginCApi"));
  QuickBlueWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("QuickBlueWindowsPlugin"));
}
