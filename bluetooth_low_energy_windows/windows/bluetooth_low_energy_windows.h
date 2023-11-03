#ifndef FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_H_
#define FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_H_

#include <flutter/plugin_registrar_windows.h>

#include "my_central_manager.h"

namespace bluetooth_low_energy_windows {
	class BluetoothLowEnergyWindows : public flutter::Plugin {
	public:
		static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

		BluetoothLowEnergyWindows(std::unique_ptr<MyCentralManager> central_manager);

		virtual ~BluetoothLowEnergyWindows();

		// Disallow copy and assign.
		BluetoothLowEnergyWindows(const BluetoothLowEnergyWindows&) = delete;
		BluetoothLowEnergyWindows& operator=(const BluetoothLowEnergyWindows&) = delete;
	private:
		std::unique_ptr<MyCentralManager> m_central_manager;
	};

}  // namespace bluetooth_low_energy_windows

#endif  // FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_H_
