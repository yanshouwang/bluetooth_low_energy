#include "my_exception.h"

namespace bluetooth_low_energy_windows
{
	const char* MyException::what() const noexcept
	{
		return message.c_str();
	}
}