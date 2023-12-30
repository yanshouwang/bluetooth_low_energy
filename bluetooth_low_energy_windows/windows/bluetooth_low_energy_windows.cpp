// This must be included before many other Windows headers.
#include <windows.h>

#include "bluetooth_low_energy_windows.h"

namespace bluetooth_low_energy_windows {
	// static
	void BluetoothLowEnergyWindows::RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
		auto messenger = registrar->messenger();
		auto central_manager = std::make_unique<MyCentralManager>(messenger);
		MyCentralManagerHostApi::SetUp(messenger, central_manager.get());

		auto plugin = std::make_unique<BluetoothLowEnergyWindows>(std::move(central_manager));
		registrar->AddPlugin(std::move(plugin));
	}

	BluetoothLowEnergyWindows::BluetoothLowEnergyWindows(std::unique_ptr<MyCentralManager> central_manager)
	{
		m_central_manager = std::move(central_manager);
	}

	BluetoothLowEnergyWindows::~BluetoothLowEnergyWindows() {}

}  // namespace bluetooth_low_energy_windows
