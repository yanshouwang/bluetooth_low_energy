#ifndef FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_FORMAT_H_
#define FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_FORMAT_H_

#include "winrt/base.h"

template <>
struct std::formatter<winrt::guid> : std::formatter<std::string>
{
	// NOTE: the format function should be a const member function.
	// see: https://developercommunity.visualstudio.com/t/standrad-formatters-should-use-const-and/1662387?q=Angular+standalone+%28esproj%29
	// see: https://developercommunity.visualstudio.com/t/Custom-std::formatter-breaks-after-upgra/10515914?space=8&ftype=problem&sort=newest&q=Suggestion&viewtype=solutions
	auto format(const winrt::guid &guid, std::format_context &context) const
	{
		auto formatted = context.out();
		formatted = std::format_to(formatted, "{:08X}-", guid.Data1);
		formatted = std::format_to(formatted, "{:04X}-", guid.Data2);
		formatted = std::format_to(formatted, "{:04X}-", guid.Data3);
		formatted = std::format_to(formatted, "{:02X}{:02X}-", guid.Data4[0], guid.Data4[1]);
		formatted = std::format_to(formatted, "{:02X}{:02X}{:02X}{:02X}{:02X}{:02X}", guid.Data4[2], guid.Data4[3], guid.Data4[4], guid.Data4[5], guid.Data4[6], guid.Data4[7]);
		return formatted;
	}
};

#endif // !FLUTTER_PLUGIN_BLUETOOTH_LOW_ENERGY_FORMAT_H_
