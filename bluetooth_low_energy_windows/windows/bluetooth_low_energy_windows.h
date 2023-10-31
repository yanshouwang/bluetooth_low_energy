#ifndef FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_H_
#define FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_H_

#include <flutter/plugin_registrar_windows.h>

namespace bluetooth_low_energy_windows {
	class BluetoothLowEnergyWindows : public flutter::Plugin {
	public:
		static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

		BluetoothLowEnergyWindows();

		virtual ~BluetoothLowEnergyWindows();

		// Disallow copy and assign.
		BluetoothLowEnergyWindows(const BluetoothLowEnergyWindows&) = delete;
		BluetoothLowEnergyWindows& operator=(const BluetoothLowEnergyWindows&) = delete;
	};

}  // namespace bluetooth_low_energy_windows

#endif  // FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_H_
