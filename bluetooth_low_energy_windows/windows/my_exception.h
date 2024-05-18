#ifndef BLEW_MY_EXCEPTION_H_
#define BLEW_MY_EXCEPTION_H_

#include <string>

namespace bluetooth_low_energy_windows
{
	class MyException : public std::exception
	{
	public:
		MyException(const std::string &message) : m_message(message) {}
		~MyException() {}

		const char *what() const noexcept override
		{
			return m_message.c_str();
		}

	private:
		std::string m_message;
	};
}
#endif // !BLEW_MY_EXCEPTION_H_
