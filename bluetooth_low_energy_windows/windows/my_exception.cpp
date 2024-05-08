#include "my_exception.h"

namespace bluetooth_low_energy_windows
{
	MyException::MyException(const std::string& message) :m_message(message)
	{
	}

	MyException::~MyException()
	{
	}

	const char* MyException::what() const noexcept
	{
		return m_message.c_str();
	}
}