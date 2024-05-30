#ifndef FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_PLUGIN_H_

#include <flutter/plugin_registrar_windows.h>

#include "my_central_manager.h"
#include "my_peripheral_manager.h"

namespace bluetooth_low_energy_windows
{
	class BluetoothLowEnergyWindowsPlugin : public flutter::Plugin
	{
	public:
		static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

		BluetoothLowEnergyWindowsPlugin(std::unique_ptr<MyCentralManager> central_manager, std::unique_ptr<MyPeripheralManager> peripheral_manager);

		virtual ~BluetoothLowEnergyWindowsPlugin();

		// Disallow copy and assign.
		BluetoothLowEnergyWindowsPlugin(const BluetoothLowEnergyWindowsPlugin &) = delete;
		BluetoothLowEnergyWindowsPlugin &operator=(const BluetoothLowEnergyWindowsPlugin &) = delete;

	private:
		std::unique_ptr<MyCentralManager> m_central_manager;
		std::unique_ptr<MyPeripheralManager> m_peripheral_manager;
	};
} // namespace bluetooth_low_energy_windows

#endif // FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_WINDOWS_PLUGIN_H_
