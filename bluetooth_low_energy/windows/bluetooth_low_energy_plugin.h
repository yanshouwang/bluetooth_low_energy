#ifndef FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_PLUGIN_H_
#define FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace bluetooth_low_energy {

class BluetoothLowEnergyPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  BluetoothLowEnergyPlugin();

  virtual ~BluetoothLowEnergyPlugin();

  // Disallow copy and assign.
  BluetoothLowEnergyPlugin(const BluetoothLowEnergyPlugin&) = delete;
  BluetoothLowEnergyPlugin& operator=(const BluetoothLowEnergyPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace bluetooth_low_energy

#endif  // FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_PLUGIN_H_
