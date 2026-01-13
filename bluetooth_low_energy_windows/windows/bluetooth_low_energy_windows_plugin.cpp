#include "bluetooth_low_energy_windows_plugin.h"

namespace bluetooth_low_energy_windows
{
	// static
	void BluetoothLowEnergyWindowsPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar)
	{
		auto messenger = registrar->messenger();

		auto central_manager = std::make_unique<CentralManagerImpl>(messenger);
		CentralManagerHostApi::SetUp(messenger, central_manager.get());

		auto peripheral_manager = std::make_unique<PeripheralManagerImpl>(messenger);
		PeripheralManagerHostApi::SetUp(messenger, peripheral_manager.get());

		auto plugin = std::make_unique<BluetoothLowEnergyWindowsPlugin>(std::move(central_manager), std::move(peripheral_manager));
		registrar->AddPlugin(std::move(plugin));
	}

	BluetoothLowEnergyWindowsPlugin::BluetoothLowEnergyWindowsPlugin(std::unique_ptr<CentralManagerImpl> central_manager, std::unique_ptr<PeripheralManagerImpl> peripheral_manager)
	{
		m_central_manager = std::move(central_manager);
		m_peripheral_manager = std::move(peripheral_manager);
	}

	BluetoothLowEnergyWindowsPlugin::~BluetoothLowEnergyWindowsPlugin() {}
} // namespace bluetooth_low_energy_windows
