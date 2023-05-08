#ifndef FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace bluetooth_low_energy_windows {

class BluetoothLowEnergyWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  BluetoothLowEnergyWindowsPlugin();

  virtual ~BluetoothLowEnergyWindowsPlugin();

  // Disallow copy and assign.
  BluetoothLowEnergyWindowsPlugin(const BluetoothLowEnergyWindowsPlugin&) = delete;
  BluetoothLowEnergyWindowsPlugin& operator=(const BluetoothLowEnergyWindowsPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace bluetooth_low_energy_windows

#endif  // FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_PLUGIN_H_
