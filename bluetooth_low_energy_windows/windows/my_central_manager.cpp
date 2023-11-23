// This must be included before many other Windows headers.
#include <windows.h>

#include <iomanip>
#include <sstream>

#include "winrt/Windows.Devices.Enumeration.h"
#include "winrt/Windows.Storage.Streams.h"

#include "my_central_manager.h"
#include "my_exception.h"

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

	void MyCentralManager::Connect(const MyPeripheralArgs& peripheral_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		m_connect(peripheral_args, std::move(result));
	}

	std::optional<FlutterError> MyCentralManager::Disconnect(const MyPeripheralArgs& peripheral_args)
	{
		try
		{
			const auto address_args = peripheral_args.address_args();
			const auto address = static_cast<uint64_t>(address_args);
			m_clear_device(address);
			m_on_device_connection_status_changed(address, BluetoothConnectionStatus::Disconnected);
			return std::nullopt;
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			return FlutterError(code, message);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Disconnect failed with unhandled exception.";
			return FlutterError(code, message);
		}
	}

	ErrorOr<int64_t> MyCentralManager::GetMaximumWriteLength(const MyPeripheralArgs& peripheral_args, int64_t type_number_args)
	{
		try
		{
			const auto type = static_cast<MyGattCharacteristicWriteTypeArgs>(type_number_args);
			switch (type)
			{
			case bluetooth_low_energy_windows::MyGattCharacteristicWriteTypeArgs::withResponse:
				return 512;
			case bluetooth_low_energy_windows::MyGattCharacteristicWriteTypeArgs::withoutResponse:
			default:
				const auto address_args = peripheral_args.address_args();
				const auto address = static_cast<uint64_t>(address_args);
				const auto& gatt_session = m_gatt_sessions[address];
				const auto max_pdu_size = gatt_session->MaxPduSize();
				auto maximum_write_length = max_pdu_size - 3;
				if (maximum_write_length < 20)
				{
					maximum_write_length = 20;
				}
				else if (maximum_write_length > 512)
				{
					maximum_write_length = 512;
				}
				const auto maximum_write_length_args = static_cast<int64_t>(maximum_write_length);
				return maximum_write_length_args;
			}
		}
		catch (const winrt::hresult_error& ex) {
			const auto code = "winrt::hresult_error";
			const auto winrt_message = ex.message();
			const auto message = winrt::to_string(winrt_message);
			return FlutterError(code, message);
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			return FlutterError(code, message);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Get maximum write length failed with unhandled exception.";
			return FlutterError(code, message);
		}
	}

	void MyCentralManager::ReadRSSI(const MyPeripheralArgs& peripheral_args, std::function<void(ErrorOr<int64_t>reply)> result)
	{
		m_read_rssi(peripheral_args, std::move(result));
	}

	void MyCentralManager::DiscoverServices(const MyPeripheralArgs& peripheral_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		m_discover_services(peripheral_args, std::move(result));
	}

	void MyCentralManager::DiscoverCharacteristics(const MyPeripheralArgs& peripheral_args, const MyGattServiceArgs& service_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		m_discover_characteristics(peripheral_args, service_args, std::move(result));
	}

	void MyCentralManager::DiscoverDescriptors(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		m_discover_descriptors(peripheral_args, characteristic_args, std::move(result));
	}

	void MyCentralManager::ReadCharacteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		m_read_characteristic(peripheral_args, characteristic_args, std::move(result));
	}

	void MyCentralManager::WriteCharacteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		m_write_characteristic(peripheral_args, characteristic_args, value_args, type_number_args, std::move(result));
	}

	void MyCentralManager::NotifyCharacteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, bool state_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		m_notify_characteristic(peripheral_args, characteristic_args, state_args, std::move(result));
	}

	void MyCentralManager::ReadDescriptor(const MyPeripheralArgs& peripheral_args, const MyGattDescriptorArgs& descriptor_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		m_read_descriptor(peripheral_args, descriptor_args, std::move(result));
	}

	void MyCentralManager::WriteDescriptor(const MyPeripheralArgs& peripheral_args, const MyGattDescriptorArgs& descriptor_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		m_write_descriptor(peripheral_args, descriptor_args, value_args, std::move(result));
	}

	fire_and_forget MyCentralManager::m_set_up(std::function<void(ErrorOr<MyCentralManagerArgs> reply)> result)
	{
		try
		{
			// 停止扫描
			const auto status = m_watcher->Status();
			if (status == BluetoothLEAdvertisementWatcherStatus::Started)
			{
				m_watcher->Stop();
			}
			// 断开连接
			auto addresses = std::list<uint64_t>();
			const auto begin = m_devices.begin();
			const auto end = m_devices.end();
			std::transform(
				begin,
				end,
				std::back_inserter(addresses),
				[](const auto& device)
				{
					return device.first;
				});
			for (const auto& address : addresses) {
				m_clear_device(address);
			}
			// 获取状态
			if (!m_radio_state_changed_token) {
				m_adapter = co_await BluetoothAdapter::GetDefaultAsync();
				m_radio = co_await m_adapter->GetRadioAsync();
				m_radio_state_changed_token = m_radio->StateChanged([this](Radio radio, auto obj)
					{
						const auto state = radio.State();
						const auto state_args = m_radio_state_to_args(state);
						const auto state_number_args = static_cast<int64_t>(state_args);
						m_api->OnStateChanged(state_number_args, [] {}, [](auto error) {});
					});
			}
			if (!m_watcher_received_token)
			{
				m_watcher_received_token = m_watcher->Received([this](BluetoothLEAdvertisementWatcher watcher, BluetoothLEAdvertisementReceivedEventArgs event_args)
					{
						const auto type = event_args.AdvertisementType();
						// TODO: 支持扫描响应和扫描扩展
						if (type == BluetoothLEAdvertisementType::ScanResponse ||
							type == BluetoothLEAdvertisementType::Extended)
						{
							return;
						}
						const auto address = event_args.BluetoothAddress();
						const auto peripheral_args = m_address_to_peripheral_args(address);
						const auto rssi = event_args.RawSignalStrengthInDBm();
						const auto rssi_args = static_cast<int64_t>(rssi);
						const auto advertisement = event_args.Advertisement();
						const auto advertisement_args = m_advertisement_to_args(advertisement);
						m_api->OnDiscovered(peripheral_args, rssi_args, advertisement_args, [] {}, [](auto error) {});
					});
			}
			const auto state = m_radio->State();
			const auto state_args = m_radio_state_to_args(state);
			const auto state_number_args = static_cast<int64_t>(state_args);
			const auto args = MyCentralManagerArgs(state_number_args);
			result(args);
		}
		catch (const winrt::hresult_error& ex) {
			const auto code = "winrt::hresult_error";
			const auto winrt_message = ex.message();
			const auto message = winrt::to_string(winrt_message);
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Set up failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_connect(const MyPeripheralArgs& peripheral_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		try
		{
			const auto address_args = peripheral_args.address_args();
			const auto address = static_cast<uint64_t>(address_args);
			const auto& device = co_await BluetoothLEDevice::FromBluetoothAddressAsync(address);
			const auto device_id = device.BluetoothDeviceId();
			const auto& gatt_session = co_await GattSession::FromDeviceIdAsync(device_id);
			const auto status = device.ConnectionStatus();
			if (status == BluetoothConnectionStatus::Disconnected)
			{
				// 通过获取 GATT 服务触发 WinRT 蓝牙连接机制
				const auto& r = co_await device.GetGattServicesAsync();
				const auto r_status = r.Status();
				if (r_status != GattCommunicationStatus::Success)
				{
					const auto r_status_code = static_cast<int32_t>(r_status);
					const auto message = "Connect failed with status: " + std::to_string(r_status_code);
					throw MyException(message);
				}
			}
			const auto& device_connection_status_changed_token = device.ConnectionStatusChanged([this](BluetoothLEDevice device, auto obj)
				{
					const auto address = device.BluetoothAddress();
					const auto status = device.ConnectionStatus();
					m_on_device_connection_status_changed(address, status);
				});
			m_devices[address] = device;
			m_gatt_sessions[address] = gatt_session;
			m_device_connection_status_changed_tokens[address] = device_connection_status_changed_token;
			m_on_device_connection_status_changed(address, BluetoothConnectionStatus::Connected);
			result(std::nullopt);
		}
		catch (const winrt::hresult_error& ex) {
			const auto code = "winrt::hresult_error";
			const auto winrt_message = ex.message();
			const auto message = winrt::to_string(winrt_message);
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Connect failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_read_rssi(const MyPeripheralArgs& peripheral_args, std::function<void(ErrorOr<int64_t>reply)> result)
	{
		try
		{
			result(-50);
			co_return;
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Read RSSI failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_discover_services(const MyPeripheralArgs& peripheral_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		try
		{
			const auto address_args = peripheral_args.address_args();
			const auto address = static_cast<uint64_t>(address_args);
			const auto& device = m_devices[address];
			if (!device)
			{
				const auto message = "Discover services failed as the device has disposed";
				throw MyException(message);
			}
			const auto& get_services_result = co_await device->GetGattServicesAsync();
			const auto status = get_services_result.Status();
			if (status != GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Discover services failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
			// 检查设备是否已经释放
			const auto disposed = !m_devices.contains(address);
			if (disposed)
			{
				const auto message = "Discover services failed as the device has disposed";
				throw MyException(message);
			}
			const auto& services = get_services_result.Services();
			auto services_args = flutter::EncodableList();
			for (const auto& service : services) {
				const auto service_args_value = m_service_to_args(service);
				const auto service_args = flutter::CustomEncodableValue(service_args_value);
				services_args.push_back(service_args);
			}
			m_services[address] = services;
			result(services_args);
		}
		catch (const winrt::hresult_error& ex) {
			const auto code = "winrt::hresult_error";
			const auto winrt_message = ex.message();
			const auto message = winrt::to_string(winrt_message);
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Discover services failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_discover_characteristics(const MyPeripheralArgs& peripheral_args, const MyGattServiceArgs& service_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		try
		{
			const auto address_args = peripheral_args.address_args();
			const auto address = static_cast<uint64_t>(address_args);
			const auto handle_args = service_args.handle_args();
			const auto handle = static_cast<uint64_t>(handle_args);
			const auto& service = m_find_service(address, handle);
			const auto& get_characteristics_result = co_await service.GetCharacteristicsAsync();
			const auto status = get_characteristics_result.Status();
			if (status != GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Discover characteristics failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
			// 检查设备是否已经释放
			const auto disposed = !m_devices.contains(address);
			if (disposed)
			{
				const auto message = "Discover characteristics failed as the device has disposed";
				throw MyException(message);
			}
			const auto& characteristics = get_characteristics_result.Characteristics();
			auto characteristics_args = flutter::EncodableList();
			for (const auto& characteristic : characteristics) {
				const auto characteristic_args_value = m_characteristic_to_args(characteristic);
				const auto characteristic_args = flutter::CustomEncodableValue(characteristic_args_value);
				characteristics_args.push_back(characteristic_args);
			}
			m_characteristics[address] = characteristics;
			result(characteristics_args);
		}
		catch (const winrt::hresult_error& ex) {
			const auto code = "winrt::hresult_error";
			const auto winrt_message = ex.message();
			const auto message = winrt::to_string(winrt_message);
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Discover characteristics failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_discover_descriptors(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		try
		{
			const auto address_args = peripheral_args.address_args();
			const auto address = static_cast<uint64_t>(address_args);
			const auto handle_args = characteristic_args.handle_args();
			const auto handle = static_cast<uint64_t>(handle_args);
			const auto& characteristic = m_find_characteristic(address, handle);
			const auto& get_descriptors_result = co_await characteristic.GetDescriptorsAsync();
			const auto status = get_descriptors_result.Status();
			if (status != GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Discover descriptors failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
			const auto& descriptors = get_descriptors_result.Descriptors();
			auto descriptors_args = flutter::EncodableList();
			for (const auto& descriptor : descriptors) {
				auto descriptor_args_value = m_descriptor_to_args(descriptor);
				auto descriptor_args = flutter::CustomEncodableValue(descriptor_args_value);
				descriptors_args.push_back(descriptor_args);
			}
			m_descriptors[address] = descriptors;
			result(descriptors_args);
		}
		catch (const winrt::hresult_error& ex) {
			const auto code = "winrt::hresult_error";
			const auto winrt_message = ex.message();
			const auto message = winrt::to_string(winrt_message);
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Discover descriptors failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_read_characteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Read characteristic failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_write_characteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Write characteristic failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_notify_characteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, bool state_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Notify characteristic failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_read_descriptor(const MyPeripheralArgs& peripheral_args, const MyGattDescriptorArgs& descriptor_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Read descriptor failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	fire_and_forget MyCentralManager::m_write_descriptor(const MyPeripheralArgs& peripheral_args, const MyGattDescriptorArgs& descriptor_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		try
		{
			return fire_and_forget();
		}
		catch (const std::exception& ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (...) {
			const auto code = "unhandled exception";
			const auto message = "Write descriptor failed with unhandled exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	void MyCentralManager::m_clear_device(uint64_t address)
	{
		// 通过释放连接实例，触发断开连接
		const auto& device = m_devices[address];
		const auto& gatt_session = m_gatt_sessions[address];
		const auto& device_connection_status_changed_token = m_device_connection_status_changed_tokens[address];
		if (device_connection_status_changed_token)
		{
			device->ConnectionStatusChanged(*device_connection_status_changed_token);
		}
		if (gatt_session)
		{
			gatt_session->Close();
		}
		if (device)
		{
			device->Close();
		}
		m_devices.erase(address);
		m_gatt_sessions.erase(address);
		m_device_connection_status_changed_tokens.erase(address);
		m_services.erase(address);
		m_characteristics.erase(address);
		m_descriptors.erase(address);
	}

	void MyCentralManager::m_on_device_connection_status_changed(uint64_t address, BluetoothConnectionStatus status)
	{
		const auto peripheral_args = m_address_to_peripheral_args(address);
		const auto state_args = status == BluetoothConnectionStatus::Connected;
		m_api->OnPeripheralStateChanged(peripheral_args, state_args, [] {}, [](auto error) {});
	}

	MyBluetoothLowEnergyStateArgs MyCentralManager::m_radio_state_to_args(RadioState state)
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

	MyAdvertisementArgs MyCentralManager::m_advertisement_to_args(const BluetoothLEAdvertisement& advertisement)
	{
		const auto name = advertisement.LocalName();
		const auto name_args = to_string(name);
		const auto& service_uuids = advertisement.ServiceUuids();
		auto service_uuids_args = flutter::EncodableList();
		for (const auto& uuid : service_uuids) {
			const auto uuid_args = m_uuid_to_args(uuid);
			service_uuids_args.push_back(uuid_args);
		}
		const auto& data_sections = advertisement.DataSections();
		auto service_data_args = flutter::EncodableMap();
		for (const auto& data_section : data_sections)
		{
			const auto section_type = data_section.DataType();
			const auto& section_buffer = data_section.Data();
			const auto section_data_length = section_buffer.Length();
			const auto type16 = BluetoothLEAdvertisementDataTypes::ServiceData16BitUuids();
			const auto type32 = BluetoothLEAdvertisementDataTypes::ServiceData32BitUuids();
			const auto type128 = BluetoothLEAdvertisementDataTypes::ServiceData128BitUuids();
			if (section_type == type16 && section_data_length > 2)
			{
				const auto& section_data = section_buffer.data();
				auto data1 = uint16_t();
				std::memcpy(&data1, section_data, 2Ui64);
				const auto uuid_args = std::format("{:04X}", data1);
				const auto data_args = std::vector<uint8_t>(section_data + 2, section_data + section_data_length);
				service_data_args[uuid_args] = data_args;
			}
			else if (section_type == type32 && section_data_length > 4)
			{
				const auto& section_data = section_buffer.data();
				auto data1 = uint32_t();
				std::memcpy(&data1, section_data, 4Ui64);
				const auto uuid_args = std::format("{:08X}", data1);
				const auto data_args = std::vector<uint8_t>(section_data + 4, section_data + section_data_length);
				service_data_args[uuid_args] = data_args;
			}
			else if (section_type == type128 && section_data_length > 16)
			{
				const auto& section_data = section_buffer.data();
				auto data1 = uint32_t();
				std::memcpy(&data1, section_data, 4Ui64);
				auto data2 = uint16_t();
				std::memcpy(&data2, section_data + 4, 2Ui64);
				auto data3 = uint16_t();
				std::memcpy(&data3, section_data + 6, 2Ui64);
				auto data4 = std::array<uint8_t, 8Ui64>();
				std::memcpy(&data4, section_data + 8, 8Ui64);
				const auto uuid = guid(data1, data2, data3, data4);
				const auto uuid_args = m_uuid_to_args(uuid);
				const auto data_args = std::vector<uint8_t>(section_data + 16, section_data + section_data_length);
				service_data_args[uuid_args] = data_args;
			}
		}
		const auto& manufacturer_data = advertisement.ManufacturerData();
		const auto manufacturer_data_size = manufacturer_data.Size();
		if (manufacturer_data_size > 0)
		{
			const auto& last_manufacturer_data = manufacturer_data.GetAt(manufacturer_data_size - 1);
			const auto id = last_manufacturer_data.CompanyId();
			const auto id_args = static_cast<int64_t>(id);
			const auto& data = last_manufacturer_data.Data();
			const auto begin = data.data();
			const auto end = begin + data.Length();
			const auto data_args = std::vector<uint8_t>(begin, end);
			const auto manufacturer_specific_data_args = MyManufacturerSpecificDataArgs(id_args, data_args);
			return MyAdvertisementArgs(&name_args, service_uuids_args, service_data_args, &manufacturer_specific_data_args);
		}
		else
		{
			return MyAdvertisementArgs(&name_args, service_uuids_args, service_data_args, nullptr);
		}
	}

	MyPeripheralArgs MyCentralManager::m_address_to_peripheral_args(uint64_t address)
	{
		const auto address_args = static_cast<int64_t>(address);
		return MyPeripheralArgs(address_args);
	}

	MyPeripheralArgs MyCentralManager::m_device_to_args(const BluetoothLEDevice& device)
	{
		const auto address = device.BluetoothAddress();
		return m_address_to_peripheral_args(address);
	}

	MyGattServiceArgs MyCentralManager::m_service_to_args(const GattDeviceService& service)
	{
		const auto handle = service.AttributeHandle();
		const auto handle_args = static_cast<int64_t>(handle);
		const auto uuid = service.Uuid();
		const auto uuid_args = m_uuid_to_args(uuid);
		const auto characteristics_args = flutter::EncodableList();
		return MyGattServiceArgs(handle_args, uuid_args, characteristics_args);
	}

	MyGattCharacteristicArgs MyCentralManager::m_characteristic_to_args(const GattCharacteristic& characteristic)
	{
		const auto handle = characteristic.AttributeHandle();
		const auto handle_args = static_cast<int64_t>(handle);
		const auto& uuid = characteristic.Uuid();
		const auto uuid_args = m_uuid_to_args(uuid);
		const auto properties = characteristic.CharacteristicProperties();
		const auto property_numbers_args = m_characteristic_properties_to_args(properties);
		const auto descriptors_args = flutter::EncodableList();
		return MyGattCharacteristicArgs(handle_args, uuid_args, property_numbers_args, descriptors_args);
	}

	flutter::EncodableList MyCentralManager::m_characteristic_properties_to_args(GattCharacteristicProperties properties)
	{
		const auto readProperty = static_cast<int>(properties & GattCharacteristicProperties::Read);
		const auto writeProperty = static_cast<int>(properties & GattCharacteristicProperties::Write);
		const auto writeWithoutResponseProperty = static_cast<int>(properties & GattCharacteristicProperties::WriteWithoutResponse);
		const auto notifyProperty = static_cast<int>(properties & GattCharacteristicProperties::Notify);
		const auto indicateProperty = static_cast<int>(properties & GattCharacteristicProperties::Indicate);
		auto property_numbers_args = flutter::EncodableList();
		if (readProperty)
		{
			const auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::read);
			property_numbers_args.push_back(property_number_args);
		}
		if (writeProperty)
		{
			const auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::write);
			property_numbers_args.push_back(property_number_args);
		}
		if (writeWithoutResponseProperty)
		{
			const auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::writeWithoutResponse);
			property_numbers_args.push_back(property_number_args);
		}
		if (notifyProperty)
		{
			const auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::notify);
			property_numbers_args.push_back(property_number_args);
		}
		if (indicateProperty)
		{
			const auto property_number_args = static_cast<int>(MyGattCharacteristicPropertyArgs::indicate);
			property_numbers_args.push_back(property_number_args);
		}
		return property_numbers_args;
	}

	MyGattDescriptorArgs MyCentralManager::m_descriptor_to_args(const GattDescriptor& descriptor)
	{
		const auto handle = descriptor.AttributeHandle();
		const auto handle_args = static_cast<int64_t>(handle);
		const auto& uuid = descriptor.Uuid();
		const auto uuid_args = m_uuid_to_args(uuid);
		return MyGattDescriptorArgs(handle_args, uuid_args);
	}

	std::string MyCentralManager::m_uuid_to_args(const guid& uuid)
	{
		return std::format("{}", uuid);
	}

	GattDeviceService MyCentralManager::m_find_service(uint64_t address, uint64_t handle)
	{
		const auto& services = m_services[address];
		const auto begin = services->begin();
		const auto end = services->end();
		const auto& i = std::find_if(begin, end, [handle](GattDeviceService service)
			{
				const auto service_handle = service.AttributeHandle();
				return service_handle == handle;
			});
		if (i == end)
		{
			const auto message = "Find service failed with address: " + std::to_string(address) + " and handle: " + std::to_string(handle);
			throw MyException(message);
		}
		return *i;
	}

	GattCharacteristic MyCentralManager::m_find_characteristic(uint64_t address, uint64_t handle)
	{
		const auto& characteristics = m_characteristics[address];
		const auto begin = characteristics->begin();
		const auto end = characteristics->end();
		const auto& i = std::find_if(begin, end, [handle](GattCharacteristic characteristic)
			{
				const auto characteristic_handle = characteristic.AttributeHandle();
				return characteristic_handle == handle;
			});
		if (i == end)
		{
			const auto message = "Find characteristic failed with address: " + std::to_string(address) + " and handle: " + std::to_string(handle);
			throw MyException(message);
		}
		return *i;
	}

	GattDescriptor MyCentralManager::m_find_descriptor(uint64_t address, uint64_t handle)
	{
		const auto& descriptors = m_descriptors[address];
		const auto begin = descriptors->begin();
		const auto end = descriptors->end();
		const auto& i = std::find_if(begin, end, [handle](GattDescriptor descriptor)
			{
				const auto descriptor_handle = descriptor.AttributeHandle();
				return descriptor_handle == handle;
			});
		if (i == end)
		{
			const auto message = "Find descriptor failed with address: " + std::to_string(address) + " and handle: " + std::to_string(handle);
			throw MyException(message);
		}
		return *i;
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