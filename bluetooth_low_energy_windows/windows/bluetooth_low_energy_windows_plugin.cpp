#include "bluetooth_low_energy_windows_plugin.h"

namespace bluetooth_low_energy_windows
{
	// static
	void BluetoothLowEnergyWindowsPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar)
	{
		auto messenger = registrar->messenger();

		auto central_manager = std::make_unique<MyCentralManager>(messenger);
		MyCentralManagerHostAPI::SetUp(messenger, central_manager.get());

		auto peripheral_manager = std::make_unique<MyPeripheralManager>(messenger);
		MyPeripheralManagerHostAPI::SetUp(messenger, peripheral_manager.get());

		auto plugin = std::make_unique<BluetoothLowEnergyWindowsPlugin>(std::move(central_manager), std::move(peripheral_manager));
		registrar->AddPlugin(std::move(plugin));
	}

	BluetoothLowEnergyWindowsPlugin::BluetoothLowEnergyWindowsPlugin(std::unique_ptr<MyCentralManager> central_manager, std::unique_ptr<MyPeripheralManager> peripheral_manager)
	{
		m_central_manager = std::move(central_manager);
		m_peripheral_manager = std::move(peripheral_manager);
	}

	BluetoothLowEnergyWindowsPlugin::~BluetoothLowEnergyWindowsPlugin() {}
} // namespace bluetooth_low_energy_windows
