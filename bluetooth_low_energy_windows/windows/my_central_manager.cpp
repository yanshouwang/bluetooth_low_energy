// This must be included before many other Windows headers.
#include <windows.h>

#include <iomanip>
#include <sstream>

#include "winrt/Windows.Devices.Enumeration.h"
#include "winrt/Windows.Foundation.Collections.h"
#include "winrt/Windows.Storage.Streams.h"

#include "my_central_manager.h"

namespace bluetooth_low_energy_windows
{
	MyCentralManager::MyCentralManager(flutter::BinaryMessenger* messenger)
	{
		m_api = MyCentralManagerFlutterApi(messenger);
		m_watcher = BluetoothLEAdvertisementWatcher();
	}

	MyCentralManager::~MyCentralManager()
	{
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
		m_connect(peripheral_hash_code_args, std::move(result));
	}

	std::optional<FlutterError>  MyCentralManager::Disconnect(int64_t peripheral_hash_code_args)
	{
		auto& device_connection_status_changed_token = m_device_connection_status_changed_tokens[peripheral_hash_code_args];
		auto& device = m_devices[peripheral_hash_code_args];
		auto& gatt_session = m_gatt_sessions[peripheral_hash_code_args];
		auto address = device->BluetoothAddress();
		device->ConnectionStatusChanged(*device_connection_status_changed_token);
		device->Close();
		gatt_session->Close();
		// 通过释放连接实例，触发断开连接
		auto& service_hash_codes = m_service_hash_codes[peripheral_hash_code_args];
		m_service_hash_codes.erase(peripheral_hash_code_args);
		for (const auto& service_hash_code : service_hash_codes) {
			auto& characteristic_hash_codes = m_characteristic_hash_codes[service_hash_code];
			m_characteristic_hash_codes.erase(service_hash_code);
			for (const auto& characteristic_hash_code : characteristic_hash_codes) {
				auto& descriptor_hash_codes = m_descriptor_hash_codes[characteristic_hash_code];
				m_descriptor_hash_codes.erase(characteristic_hash_code);
				for (const auto& descriptor_hash_code : descriptor_hash_codes) {
					m_descriptors.erase(descriptor_hash_code);
				}
				m_characteristics.erase(characteristic_hash_code);
			}
			m_services.erase(service_hash_code);
		}
		m_device_connection_status_changed_tokens.erase(peripheral_hash_code_args);
		m_devices.erase(peripheral_hash_code_args);
		m_gatt_sessions.erase(peripheral_hash_code_args);
		auto uuid_args = m_format_address(address);
		auto peripheral_args = MyPeripheralArgs(peripheral_hash_code_args, uuid_args);
		auto state_args = false;
		m_api->OnPeripheralStateChanged(peripheral_args, state_args, [] {}, [](auto error) {});
		return std::nullopt;
	}

	ErrorOr<int64_t> MyCentralManager::GetMaximumWriteLength(int64_t peripheral_hash_code_args, int64_t type_number_args)
	{
		auto type = static_cast<MyGattCharacteristicWriteTypeArgs>(type_number_args);
		switch (type)
		{
		case bluetooth_low_energy_windows::MyGattCharacteristicWriteTypeArgs::withResponse:
			return 512;
		case bluetooth_low_energy_windows::MyGattCharacteristicWriteTypeArgs::withoutResponse:
		default:
			auto& gatt_session = m_gatt_sessions[peripheral_hash_code_args];
			auto max_pdu_size = gatt_session->MaxPduSize();
			auto maximum_write_length = max_pdu_size - 3;
			if (maximum_write_length < 20)
			{
				maximum_write_length = 20;
			}
			else if (maximum_write_length > 512)
			{
				maximum_write_length = 512;
			}
			auto maximum_write_length_args = static_cast<int64_t>(maximum_write_length);
			return maximum_write_length_args;
		}
	}

	void MyCentralManager::ReadRSSI(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<int64_t> reply)> result)
	{
		m_read_rssi(peripheral_hash_code_args, std::move(result));
	}

	void MyCentralManager::DiscoverServices(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result)
	{
		m_discover_services(peripheral_hash_code_args, std::move(result));
	}

	void MyCentralManager::DiscoverCharacteristics(int64_t service_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result)
	{
		m_discover_characteristics(service_hash_code_args, std::move(result));
	}

	void MyCentralManager::DiscoverDescriptors(int64_t characteristic_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result)
	{
		m_discover_descriptors(characteristic_hash_code_args, std::move(result));
	}

	void MyCentralManager::ReadCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result)
	{
		m_read_characteristic(peripheral_hash_code_args, characteristic_hash_code_args, std::move(result));
	}

	void MyCentralManager::WriteCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		m_write_characteristic(peripheral_hash_code_args, characteristic_hash_code_args, value_args, type_number_args, std::move(result));
	}

	void MyCentralManager::NotifyCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, bool state_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		m_notify_characteristic(peripheral_hash_code_args, characteristic_hash_code_args, state_args, std::move(result));
	}

	void MyCentralManager::ReadDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result)
	{
		m_read_descriptor(peripheral_hash_code_args, descriptor_hash_code_args, std::move(result));
	}

	void MyCentralManager::WriteDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		m_write_descriptor(peripheral_hash_code_args, descriptor_hash_code_args, value_args, std::move(result));
	}

	fire_and_forget MyCentralManager::m_set_up(std::function<void(ErrorOr<MyCentralManagerArgs> reply)> result)
	{
		try
		{
			auto status = m_watcher->Status();
			if (status == BluetoothLEAdvertisementWatcherStatus::Started)
			{
				m_watcher->Stop();
			}
			for (const auto& item : m_device_connection_status_changed_tokens) {
				auto& peripheral_hash_code_args = item.first;
				auto& device_connection_status_changed_token = item.second;
				auto& device = m_devices[peripheral_hash_code_args];
				auto& gatt_session = m_gatt_sessions[peripheral_hash_code_args];
				device->ConnectionStatusChanged(*device_connection_status_changed_token);
				device->Close();
				gatt_session->Close();
			}
			m_device_connection_status_changed_tokens.clear();
			m_devices.clear();
			m_gatt_sessions.clear();
			m_services.clear();
			m_characteristics.clear();
			m_descriptors.clear();
			if (!m_watcher_received_token)
			{
				m_watcher_received_token = m_watcher->Received([this](BluetoothLEAdvertisementWatcher watcher, BluetoothLEAdvertisementReceivedEventArgs event_args)
					{
						try
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
						}
						catch (const std::exception& e)
						{
							std::cout << e.what() << std::endl;
						}
					});
			}
			if (!m_radio_state_changed_token) {
				m_adapter = co_await BluetoothAdapter::GetDefaultAsync();
				m_radio = co_await m_adapter->GetRadioAsync();
				m_radio_state_changed_token = m_radio->StateChanged([this](Radio radio, auto obj)
					{
						try
						{
							auto state = radio.State();
							auto state_args = m_format_radio_state(state);
							auto state_number_args = static_cast<int64_t>(state_args);
							m_api->OnStateChanged(state_number_args, [] {}, [](auto error) {});
						}
						catch (const std::exception& e)
						{
							std::cout << e.what() << std::endl;
						}
					});
			}
			auto state = m_radio->State();
			auto state_args = m_format_radio_state(state);
			auto state_number_args = static_cast<int64_t>(state_args);
			auto args = MyCentralManagerArgs(state_number_args);
			result(args);
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_connect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		try
		{
			auto address = static_cast<uint64_t>(peripheral_hash_code_args);
			auto device = co_await BluetoothLEDevice::FromBluetoothAddressAsync(address);
			auto device_id = device.BluetoothDeviceId();
			auto gatt_session = co_await GattSession::FromDeviceIdAsync(device_id);
			auto device_information = device.DeviceInformation();
			auto device_properties = device_information.Properties();
			for (const auto& device_property : device_properties) {
				auto key = device_property.Key();
				std::cout << to_string(key) << std::endl;
			}
			auto device_connection_status_changed_token = device.ConnectionStatusChanged([this](BluetoothLEDevice device, auto obj)
				{
					try
					{
						auto address = device.BluetoothAddress();
						auto hash_code_args = static_cast<int64_t>(address);
						auto uuid_args = m_format_address(address);
						auto peripheral_args = MyPeripheralArgs(hash_code_args, uuid_args);
						auto status = device.ConnectionStatus();
						auto state_args = status == BluetoothConnectionStatus::Connected;
						m_api->OnPeripheralStateChanged(peripheral_args, state_args, [] {}, [](auto error) {});
					}
					catch (const std::exception& e)
					{
						std::cout << e.what() << std::endl;
					}
				});
			m_devices[peripheral_hash_code_args] = device;
			m_gatt_sessions[peripheral_hash_code_args] = gatt_session;
			m_device_connection_status_changed_tokens[peripheral_hash_code_args] = device_connection_status_changed_token;
			result(std::nullopt);
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_read_rssi(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<int64_t>reply)> result)
	{
		try
		{
			result(-50);
			co_return;
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_discover_services(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		try
		{
			auto& device = m_devices[peripheral_hash_code_args];
			auto get_services_result = co_await device->GetGattServicesAsync();
			auto status = get_services_result.Status();
			if (status != GattCommunicationStatus::Success)
			{
				auto stream = std::stringstream();
				stream << "Discover services failed with status: " << static_cast<int32_t>(status);
				auto message = stream.str();
				auto message_c_str = message.c_str();
				throw std::bad_exception(message_c_str);
			}
			// 检查设备是否已经释放
			auto disposed = !m_devices.contains(peripheral_hash_code_args);
			if (disposed)
			{
				auto message = "Discover services failed as the device has disposed";
				throw std::bad_exception(message);
			}
			auto services = get_services_result.Services();
			auto servicesArgs = flutter::EncodableList();
			for (const auto& service : services) {
				auto hash_code = &service;
				auto hash_code_args = reinterpret_cast<int64_t>(hash_code);
				std::cout << hash_code_args << std::endl;
				auto uuid = service.Uuid();
				auto uuid_args = std::format("{}", uuid);
				auto characteristics_args = flutter::EncodableList();
				auto service_args_value = MyGattServiceArgs(hash_code_args, uuid_args, characteristics_args);
				auto service_args = flutter::CustomEncodableValue(service_args_value);
				servicesArgs.push_back(service_args);
				m_services[hash_code_args] = service;
				auto& service_hash_codes = m_service_hash_codes[peripheral_hash_code_args];
				service_hash_codes.push_back(hash_code_args);
			}
			result(servicesArgs);
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_discover_characteristics(int64_t service_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		try
		{
			auto& service = m_services[service_hash_code_args];
			auto get_characteristics_result = co_await service->GetCharacteristicsAsync();
			auto status = get_characteristics_result.Status();
			if (status != GattCommunicationStatus::Success)
			{
				auto stream = std::stringstream();
				stream << "Discover characteristics failed with status: " << static_cast<int32_t>(status);
				auto message = stream.str();
				auto message_c_str = message.c_str();
				throw std::bad_exception(message_c_str);
			}
			// 检查服务是否已经释放
			auto disposed = !m_services.contains(service_hash_code_args);
			if (disposed)
			{
				auto message = "Discover characteristics failed as the service has disposed";
				throw std::bad_exception(message);
			}
			auto characteristics = get_characteristics_result.Characteristics();
			auto characteristicsArgs = flutter::EncodableList();
			for (const auto& characteristic : characteristics) {
				auto hash_code = &characteristic;
				auto hash_code_args = reinterpret_cast<int64_t>(hash_code);
				auto uuid = characteristic.Uuid();
				auto uuid_args = std::format("{}", uuid);
				auto property_numbers_args = flutter::EncodableList();
				auto properties = characteristic.CharacteristicProperties();
				auto readProperty = static_cast<int>(properties & GattCharacteristicProperties::Read);
				auto writeProperty = static_cast<int>(properties & GattCharacteristicProperties::Write);
				auto writeWithoutResponseProperty = static_cast<int>(properties & GattCharacteristicProperties::WriteWithoutResponse);
				auto notifyProperty = static_cast<int>(properties & GattCharacteristicProperties::Notify);
				auto indicateProperty = static_cast<int>(properties & GattCharacteristicProperties::Indicate);
				if (readProperty)
				{
					auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::read);
					property_numbers_args.push_back(property_number_args);
				}
				if (writeProperty)
				{
					auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::write);
					property_numbers_args.push_back(property_number_args);
				}
				if (writeWithoutResponseProperty)
				{
					auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::writeWithoutResponse);
					property_numbers_args.push_back(property_number_args);
				}
				if (notifyProperty)
				{
					auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::notify);
					property_numbers_args.push_back(property_number_args);
				}
				if (indicateProperty)
				{
					auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::indicate);
					property_numbers_args.push_back(property_number_args);
				}
				auto descriptors_args = flutter::EncodableList();
				auto characteristic_args_value = MyGattCharacteristicArgs(hash_code_args, uuid_args, property_numbers_args, descriptors_args);
				auto characteristic_args = flutter::CustomEncodableValue(characteristic_args_value);
				characteristicsArgs.push_back(characteristic_args);
				m_characteristics[hash_code_args] = characteristic;
				auto& characteristic_hash_codes = m_characteristic_hash_codes[service_hash_code_args];
				characteristic_hash_codes.push_back(hash_code_args);
			}
			result(characteristicsArgs);
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_discover_descriptors(int64_t characteristic_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		try
		{
			auto& characteristic = m_characteristics[characteristic_hash_code_args];
			auto get_descriptors_result = co_await characteristic->GetDescriptorsAsync();
			auto status = get_descriptors_result.Status();
			if (status != GattCommunicationStatus::Success)
			{
				auto stream = std::stringstream();
				stream << "Discover descriptors failed with status: " << static_cast<int32_t>(status);
				auto message = stream.str();
				auto message_c_str = message.c_str();
				throw std::bad_exception(message_c_str);
			}
			// 检查特征值是否已经释放
			auto disposed = !m_characteristics.contains(characteristic_hash_code_args);
			if (disposed)
			{
				auto message = "Discover descriptor failed as the characteristic has disposed";
				throw std::bad_exception(message);
			}
			auto descriptors = get_descriptors_result.Descriptors();
			auto descriptorsArgs = flutter::EncodableList();
			for (const auto& descriptor : descriptors) {
				auto hash_code = &descriptor;
				auto hash_code_args = reinterpret_cast<int64_t>(hash_code);
				auto uuid = descriptor.Uuid();
				auto uuid_args = std::format("{}", uuid);
				auto descriptor_args_value = MyGattDescriptorArgs(hash_code_args, uuid_args);
				auto descriptor_args = flutter::CustomEncodableValue(descriptor_args_value);
				descriptorsArgs.push_back(descriptor_args);
				m_descriptors[hash_code_args] = descriptor;
				auto& descriptor_hash_codes = m_descriptor_hash_codes[characteristic_hash_code_args];
				descriptor_hash_codes.push_back(hash_code_args);
			}
			result(descriptorsArgs);
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_read_characteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_write_characteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_notify_characteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, bool state_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_read_descriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_write_descriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& e)
		{
			auto code = e.what();
			auto error = FlutterError(code);
			result(error);
		}
	}

	MyBluetoothLowEnergyStateArgs MyCentralManager::m_format_radio_state(RadioState state)
	{
		switch (state)
		{
		case RadioState::Unknown:
			return MyBluetoothLowEnergyStateArgs::unknown;
		case RadioState::On:
			return MyBluetoothLowEnergyStateArgs::poweredOn;
		case RadioState::Off:
		case RadioState::Disabled:
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

	MyAdvertisementArgs MyCentralManager::m_format_advertisement(BluetoothLEAdvertisement& advertisement)
	{
		auto name = advertisement.LocalName();
		auto name_args = to_string(name);
		auto service_uuids = advertisement.ServiceUuids();
		auto service_uuids_args = flutter::EncodableList();
		for (const auto& uuid : service_uuids) {
			auto uuid_args = std::format("{}", uuid);
			service_uuids_args.push_back(uuid_args);
		}
		auto service_data_args = flutter::EncodableMap();
		auto sections = advertisement.DataSections();
		for (const auto& section : sections)
		{
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
				auto data4 = std::to_array<uint8_t>({ 0x80, 0x00, 0x00, 0x80, 0x5f, 0x9b, 0x34, 0xfb });
				auto uuid = guid(data1, data2, data3, data4);
				auto uuid_args = std::format("{}", uuid);
				auto data_args = std::vector<uint8_t>(section_data + 2, section_data + section_data_length);
				service_data_args[uuid_args] = data_args;
			}
			else if (section_type == type32 && section_data_length > 4)
			{
				auto section_data = section_buffer.data();
				auto data1 = uint32_t();
				std::memcpy(&data1, section_data, 4Ui64);
				auto data2 = static_cast<uint16_t>(0x0000);
				auto data3 = static_cast<uint16_t>(0x1000);
				auto data4 = std::to_array<uint8_t>({ 0x80, 0x00, 0x00, 0x80, 0x5f, 0x9b, 0x34, 0xfb });
				auto uuid = guid(data1, data2, data3, data4);
				auto uuid_args = std::format("{}", uuid);
				auto data_args = std::vector<uint8_t>(section_data + 4, section_data + section_data_length);
				service_data_args[uuid_args] = data_args;
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
				auto uuid = guid(data1, data2, data3, data4);
				auto uuid_args = std::format("{}", uuid);
				auto data_args = std::vector<uint8_t>(section_data + 16, section_data + section_data_length);
				service_data_args[uuid_args] = data_args;
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

	int64_t MyCentralManager::m_get_device_hash_code(BluetoothLEDevice& device)
	{
		auto address = device.BluetoothAddress();
		return std::hash<int>()(address);
	}

	int64_t MyCentralManager::m_get_service_hash_code(GattDeviceService& service)
	{
		return 0;
	}

	int64_t MyCentralManager::m_get_characteristic_hash_code(GattCharacteristic& characteristic)
	{
		return 0;
	}

	int64_t MyCentralManager::m_get_descriptor_hash_code(GattDescriptor& descriptor)
	{
		return 0;
	}
}

template <>
struct std::formatter<guid> : std::formatter<string>
{
	auto format(const guid& guid, std::format_context& context)
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