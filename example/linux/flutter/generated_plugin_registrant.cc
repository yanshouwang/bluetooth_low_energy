//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bluetooth_low_energy/bluetooth_low_energy_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) bluetooth_low_energy_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BluetoothLowEnergyPlugin");
  bluetooth_low_energy_plugin_register_with_registrar(bluetooth_low_energy_registrar);
}
