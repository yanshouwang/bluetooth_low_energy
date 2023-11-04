// This must be included before many other Windows headers.
#include <windows.h>

#include <iomanip>
#include <sstream>

#include "winrt/Windows.Foundation.Collections.h"
#include "winrt/Windows.Storage.Streams.h"

#include "my_central_manager.h"

namespace bluetooth_low_energy_windows
{
	MyCentralManager::MyCentralManager(flutter::BinaryMessenger* messenger)
	{
		m_api = MyCentralManagerFlutterApi(messenger);
		m_watcher = BluetoothLEAdvertisementWatcher();
		m_watcher_received_token = m_watcher->Received([this](BluetoothLEAdvertisementWatcher watcher, BluetoothLEAdvertisementReceivedEventArgs event_args)
			{
				auto type = event_args.AdvertisementType();
				// TODO: 支持扫描响应和扫描扩展
				if (type == BluetoothLEAdvertisementType::ScanResponse ||
					type == BluetoothLEAdvertisementType::Extended)
				{
					return;
				}
				auto address = event_args.BluetoothAddress();
				auto hash_code_args = static_cast<int64_t>(address);
				auto uuid_args = m_format_address(address);
				auto peripheral_args = MyPeripheralArgs(hash_code_args, uuid_args);
				auto rssi = event_args.RawSignalStrengthInDBm();
				auto rssi_args = static_cast<int64_t>(rssi);
				auto advertisement = event_args.Advertisement();
				auto advertisement_args = m_format_advertisement(advertisement);
				m_api->OnDiscovered(peripheral_args, rssi_args, advertisement_args, [] {}, [](auto error) {});
			});
	}

	MyCentralManager::~MyCentralManager()
	{
		m_watcher->Received(m_watcher_received_token);
	}

	void MyCentralManager::SetUp(std::function<void(ErrorOr<MyCentralManagerArgs> reply)> result)
	{
		m_set_up(std::move(result));
	}

	std::optional<FlutterError> MyCentralManager::StartDiscovery()
	{
		m_watcher->Start();
		return std::nullopt;
	}

	std::optional<FlutterError> MyCentralManager::StopDiscovery()
	{
		m_watcher->Stop();
		return std::nullopt;
	}

	void MyCentralManager::Connect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	void MyCentralManager::Disconnect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	ErrorOr<int64_t> MyCentralManager::GetMaximumWriteLength(int64_t peripheral_hash_code_args, int64_t type_number_args)
	{
		return ErrorOr<int64_t>(20);
	}

	void MyCentralManager::ReadRSSI(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<int64_t> reply)> result)
	{
	}

	void MyCentralManager::DiscoverGATT(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result)
	{
	}

	void MyCentralManager::ReadCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result)
	{
	}

	void MyCentralManager::WriteCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	void MyCentralManager::NotifyCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, bool state_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	void MyCentralManager::ReadDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result)
	{
	}

	void MyCentralManager::WriteDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	winrt::fire_and_forget MyCentralManager::m_set_up(std::function<void(ErrorOr<MyCentralManagerArgs> reply)> result)
	{
		auto status = m_watcher->Status();
		if (status == BluetoothLEAdvertisementWatcherStatus::Started)
		{
			m_watcher->Stop();
		}
		m_adapter = co_await BluetoothAdapter::GetDefaultAsync();
		auto has_radio = m_radio.has_value();
		if (has_radio)
		{
			m_radio->StateChanged(m_radio_state_changed_token);
		}
		m_radio = co_await m_adapter->GetRadioAsync();
		auto state = m_radio->State();
		auto state_args = m_format_radio_state(state);
		auto state_number_args = static_cast<int64_t>(state_args);
		auto args = MyCentralManagerArgs(state_number_args);
		result(args);
		m_radio_state_changed_token = m_radio->StateChanged([this](Radio radio, auto obj)
			{
				auto state = radio.State();
				auto state_args = m_format_radio_state(state);
				auto state_number_args = static_cast<int64_t>(state_args);
				m_api->OnStateChanged(state_number_args, [] {}, [](auto error) {});
			});
		co_return;
	}

	MyBluetoothLowEnergyStateArgs MyCentralManager::m_format_radio_state(RadioState state)
	{
		switch (state)
		{
		case winrt::Windows::Devices::Radios::RadioState::Unknown:
			return MyBluetoothLowEnergyStateArgs::unknown;
		case winrt::Windows::Devices::Radios::RadioState::On:
			return MyBluetoothLowEnergyStateArgs::poweredOn;
		case winrt::Windows::Devices::Radios::RadioState::Off:
		case winrt::Windows::Devices::Radios::RadioState::Disabled:
			return MyBluetoothLowEnergyStateArgs::poweredOff;
		default:
			return MyBluetoothLowEnergyStateArgs::unknown;
		}
	}

	std::string MyCentralManager::m_format_address(uint64_t address)
	{
		auto stream = std::stringstream();
		stream << "00000000-0000-0000-0000-" << std::setfill('0') << std::setw(12) << std::hex << address;
		return stream.str();
	}

	MyAdvertisementArgs MyCentralManager::m_format_advertisement(BluetoothLEAdvertisement advertisement)
	{
		auto name = advertisement.LocalName();
		auto name_args = winrt::to_string(name);
		auto service_uuids = advertisement.ServiceUuids();
		auto service_uuids_args = flutter::EncodableList();
		auto service_data_args = flutter::EncodableMap();
		auto sections = advertisement.DataSections();
		for (const auto& section : sections) {
			auto section_type = section.DataType();
			auto section_buffer = section.Data();
			auto section_data_length = section_buffer.Length();
			auto type16 = BluetoothLEAdvertisementDataTypes::ServiceData16BitUuids();
			auto type32 = BluetoothLEAdvertisementDataTypes::ServiceData32BitUuids();
			auto type128 = BluetoothLEAdvertisementDataTypes::ServiceData128BitUuids();
			if (section_type == type16 && section_data_length > 2)
			{
				auto section_data = section_buffer.data();
				auto data1 = uint32_t();
				std::memcpy(&data1, section_data, 2Ui64);
				auto data2 = static_cast<uint16_t>(0x0000);
				auto data3 = static_cast<uint16_t>(0x1000);
				auto data4 = std::to_array<uint8_t>({ 0x80,0x00, 0x00, 0x80, 0x5f, 0x9b, 0x34, 0xfb });
				auto uuid = winrt::guid(data1, data2, data3, data4);
				auto formatted_uuid = std::format("{}", uuid);
				auto uuid_args = flutter::EncodableValue(formatted_uuid);
				auto data = std::vector<uint8_t>(section_data + 2, section_data + section_data_length);
				auto data_args = flutter::EncodableValue(data);
				auto args = std::make_pair(uuid_args, data_args);
				service_data_args.insert(args);
			}
			else if (section_type == type32 && section_data_length > 4)
			{
				auto section_data = section_buffer.data();
				auto data1 = uint32_t();
				std::memcpy(&data1, section_data, 4Ui64);
				auto data2 = static_cast<uint16_t>(0x0000);
				auto data3 = static_cast<uint16_t>(0x1000);
				auto data4 = std::to_array<uint8_t>({ 0x80,0x00, 0x00, 0x80, 0x5f, 0x9b, 0x34, 0xfb });
				auto uuid = winrt::guid(data1, data2, data3, data4);
				auto formatted_uuid = std::format("{}", uuid);
				auto uuid_args = flutter::EncodableValue(formatted_uuid);
				auto data = std::vector<uint8_t>(section_data + 4, section_data + section_data_length);
				auto data_args = flutter::EncodableValue(data);
				auto args = std::make_pair(uuid_args, data_args);
				service_data_args.insert(args);
			}
			else if (section_type == type128 && section_data_length > 16)
			{
				auto section_data = section_buffer.data();
				auto data1 = uint32_t();
				std::memcpy(&data1, section_data, 4Ui64);
				auto data2 = uint16_t();
				std::memcpy(&data2, section_data + 4, 2Ui64);
				auto data3 = uint16_t();
				std::memcpy(&data3, section_data + 6, 2Ui64);
				auto data4 = std::array<uint8_t, 8Ui64>();
				std::memcpy(&data4, section_data + 8, 8Ui64);
				auto uuid = winrt::guid(data1, data2, data3, data4);
				auto formatted_uuid = std::format("{}", uuid);
				auto uuid_args = flutter::EncodableValue(formatted_uuid);
				auto data = std::vector<uint8_t>(section_data + 16, section_data + section_data_length);
				auto data_args = flutter::EncodableValue(data);
				auto args = std::make_pair(uuid_args, data_args);
				service_data_args.insert(args);
			}
		}
		auto manufacturer_data = advertisement.ManufacturerData();
		auto manufacturer_data_size = manufacturer_data.Size();
		if (manufacturer_data_size > 0)
		{
			auto last_manufacturer_data = manufacturer_data.GetAt(manufacturer_data_size - 1);
			auto id = last_manufacturer_data.CompanyId();
			auto id_args = static_cast<int64_t>(id);
			auto data = last_manufacturer_data.Data();
			auto begin = data.data();
			auto end = begin + data.Length();
			auto data_args = std::vector<uint8_t>(begin, end);
			auto manufacturer_specific_data_args = MyManufacturerSpecificDataArgs(id_args, data_args);
			return MyAdvertisementArgs(&name_args, service_uuids_args, service_data_args, &manufacturer_specific_data_args);
		}
		else
		{
			return MyAdvertisementArgs(&name_args, service_uuids_args, service_data_args, nullptr);
		}
	}
}

template<>
struct std::formatter<winrt::guid> : std::formatter<string>
{
	auto format(const winrt::guid& guid, std::format_context& context) {
		auto formatted = context.out();
		formatted = std::format_to(formatted, "{:08X}-", guid.Data1);
		formatted = std::format_to(formatted, "{:04X}-", guid.Data2);
		formatted = std::format_to(formatted, "{:04X}-", guid.Data3);
		formatted = std::format_to(formatted, "{:02X}{:02X}-", guid.Data4[0], guid.Data4[1]);
		formatted = std::format_to(formatted, "{:02X}{:02X}{:02X}{:02X}{:02X}{:02X}", guid.Data4[2], guid.Data4[3], guid.Data4[4], guid.Data4[5], guid.Data4[6], guid.Data4[7]);
		return formatted;
	}
};