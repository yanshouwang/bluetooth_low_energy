#ifndef FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_EXCEPTION_H_
#define FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_EXCEPTION_H_

#include <string>

namespace bluetooth_low_energy_windows
{
	class BluetoothLowEnergyException : public std::exception
	{
	public:
		BluetoothLowEnergyException(const std::string &message) : message(message) {}
		~BluetoothLowEnergyException() {}

		const char *what() const noexcept override
		{
			return message.c_str();
		}

	private:
		std::string message;
	};
}

#endif // !FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_EXCEPTION_H_
