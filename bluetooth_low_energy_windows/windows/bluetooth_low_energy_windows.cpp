#include "bluetooth_low_energy_windows.h"
#include "my_central_manager.h"

namespace bluetooth_low_energy_windows {
	// static
	void BluetoothLowEnergyWindows::RegisterWithRegistrar(
		flutter::PluginRegistrarWindows* registrar) {
		auto messenger_pointer = registrar->messenger();
		auto my_central_manager = std::make_unique<MyCentralManager>();
		auto my_central_manager_pointer = my_central_manager.get();
		MyCentralManagerHostApi::SetUp(messenger_pointer, my_central_manager_pointer);

		auto plugin = std::make_unique<BluetoothLowEnergyWindows>();
		registrar->AddPlugin(std::move(plugin));
	}

	BluetoothLowEnergyWindows::BluetoothLowEnergyWindows() {}

	BluetoothLowEnergyWindows::~BluetoothLowEnergyWindows() {}

}  // namespace bluetooth_low_energy_windows
