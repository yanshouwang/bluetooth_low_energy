// This must be included before many other Windows headers.
#include <windows.h>

#include <iomanip>
#include <sstream>

#include "winrt/Windows.Foundation.Collections.h"
#include "winrt/Windows.Security.Cryptography.h"
#include "winrt/Windows.Storage.Streams.h"

#include "my_central_manager.h"
#include "my_exception.h"

namespace bluetooth_low_energy_windows
{
	MyCentralManager::MyCentralManager(flutter::BinaryMessenger* messenger)
	{
		m_api = MyCentralManagerFlutterAPI(messenger);
		m_watcher = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementWatcher();
	}

	MyCentralManager::~MyCentralManager()
	{
	}

	void MyCentralManager::Initialize(std::function<void(std::optional<FlutterError> reply)> result)
	{
		m_initialize(std::move(result));
	}

	ErrorOr<MyBluetoothLowEnergyStateArgs> MyCentralManager::GetState()
	{
		const auto state = m_radio->State();
		const auto state_args = m_radio_state_to_args(state);
		return state_args;
	}

	std::optional<FlutterError> MyCentralManager::StartDiscovery(const flutter::EncodableList& service_uuids_args)
	{
		const auto service_uuids_args_not_empty = !service_uuids_args.empty();
		if (service_uuids_args_not_empty)
		{
			const auto filter = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementFilter::BluetoothLEAdvertisementFilter();
			const auto advertisement = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisement();
			const auto service_uuids = advertisement.ServiceUuids();
			for (const auto& service_uuid_args : service_uuids_args) {
				const auto& service_uuid_value = std::get<std::string>(service_uuid_args);
				const auto service_uuid = winrt::guid(service_uuid_value);
				service_uuids.Append(service_uuid);
			}
			filter.Advertisement(advertisement);
			m_watcher->AdvertisementFilter(filter);
		}
		m_watcher->Start();
		return std::nullopt;
	}

	std::optional<FlutterError> MyCentralManager::StopDiscovery()
	{
		m_watcher->Stop();
		return std::nullopt;
	}

	void MyCentralManager::Connect(int64_t address_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		m_connect(address_args, std::move(result));
	}

	std::optional<FlutterError> MyCentralManager::Disconnect(int64_t address_args)
	{
		m_disconnect(address_args);
		return std::nullopt;
	}

	ErrorOr<int64_t> MyCentralManager::GetMTU(int64_t address_args)
	{
		const auto& session = m_sessions[address_args];
		const auto mtu = session->MaxPduSize();
		const auto mtu_args = static_cast<int64_t>(mtu);
		return mtu_args;
	}

	void MyCentralManager::DiscoverServices(int64_t address_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		m_discover_services(address_args, std::move(result));
	}

	void MyCentralManager::DiscoverCharacteristics(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		m_discover_characteristics(address_args, handle_args, std::move(result));
	}

	void MyCentralManager::DiscoverDescriptors(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		m_discover_descriptors(address_args, handle_args, std::move(result));
	}

	void MyCentralManager::ReadCharacteristic(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		m_read_characteristic(address_args, handle_args, std::move(result));
	}

	void MyCentralManager::WriteCharacteristic(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, const MyGATTCharacteristicWriteTypeArgs& type_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		m_write_characteristic(address_args, handle_args, value_args, type_args, std::move(result));
	}

	void MyCentralManager::SetCharacteristicNotifyState(int64_t address_args, int64_t handle_args, const MyGATTCharacteristicNotifyStateArgs& state_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		m_set_characteristic_notify_state(address_args, handle_args, state_args, std::move(result));
	}

	void MyCentralManager::ReadDescriptor(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		m_read_descriptor(address_args, handle_args, std::move(result));
	}

	void MyCentralManager::WriteDescriptor(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		m_write_descriptor(address_args, handle_args, value_args, std::move(result));
	}

	winrt::fire_and_forget MyCentralManager::m_initialize(std::function<void(std::optional<FlutterError> reply)> result)
	{
		try
		{
			// 停止扫描
			const auto status = m_watcher->Status();
			if (status == winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementWatcherStatus::Started)
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
				[](const auto device)
				{
					return device.first;
				});
			for (const auto address : addresses) {
				const auto address_args = static_cast<int64_t>(address);
				m_disconnect(address_args);
			}
			// 监听状态
			if (!m_radio_state_changed_revoker) {
				m_adapter = co_await winrt::Windows::Devices::Bluetooth::BluetoothAdapter::GetDefaultAsync();
				m_radio = co_await m_adapter->GetRadioAsync();
				m_radio_state_changed_revoker = m_radio->StateChanged(winrt::auto_revoke, [this](winrt::Windows::Devices::Radios::Radio radio, auto obj)
					{
						const auto state = radio.State();
						const auto state_args = m_radio_state_to_args(state);
						m_api->OnStateChanged(state_args, [] {}, [](auto error) {});
					});
			}
			if (!m_watcher_received_revoker)
			{
				m_watcher_received_revoker = m_watcher->Received(winrt::auto_revoke, [this](winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementWatcher watcher, winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementReceivedEventArgs event_args)
					{
						const auto type = event_args.AdvertisementType();
						// TODO: 支持扫描响应和扫描扩展
						if (type == winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementType::ScanResponse ||
							type == winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementType::Extended)
						{
							return;
						}
						const auto address = event_args.BluetoothAddress();
						const auto peripheral_args = m_address_to_peripheral_args(address);
						const auto rssi = event_args.RawSignalStrengthInDBm();
						const auto rssi_args = static_cast<int64_t>(rssi);
						const auto advertisement = event_args.Advertisement();
						const auto advertisement_args = m_advertisement_to_args(advertisement);
						// TODO: Make this thread safe when this issue closed: https://github.com/flutter/flutter/issues/134346.
						// 
						// [ERROR:flutter/shell/common/shell.cc(1038)] The 'dev.flutter.pigeon.bluetooth_low_energy_windows.MyCentralManagerFlutterAPI.onDiscovered' 
						// channel sent a message from native to Flutter on a non-platform thread. Platform channel messages must be sent on the platform thread. 
						// Failure to do so may result in data loss or crashes, and must be fixed in the plugin or application code creating that channel.
						// 
						// See https ://docs.flutter.dev/platform-integration/platform-channels#channels-and-platform-threading for more information.
						m_api->OnDiscovered(peripheral_args, rssi_args, advertisement_args, [] {}, [](auto error) {});
					});
			}
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
			const auto code = "unknown_exception";
			const auto message = "Initialize failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyCentralManager::m_connect(int64_t address_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		try
		{
			// 通过单独调用此方法创建 BluetoothLEDevice 对象不（一定）会启动连接。 若要启动连接，请将 
			// GattSession.MaintainConnection 设置为 true，或在 BluetoothLEDevice 上调用未缓存
			// 的服务发现方法，或对设备执行读/写操作。
			// 参考：https://learn.microsoft.com/zh-cn/windows/uwp/devices-sensors/gatt-client#connecting-to-the-device
			const auto address = static_cast<uint64_t>(address_args);
			const auto& device = co_await winrt::Windows::Devices::Bluetooth::BluetoothLEDevice::FromBluetoothAddressAsync(address);
			const auto id = device.BluetoothDeviceId();
			const auto& session = co_await winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSession::FromDeviceIdAsync(id);
			const auto& r = co_await device.GetGattServicesAsync(winrt::Windows::Devices::Bluetooth::BluetoothCacheMode::Uncached);
			const auto r_status = r.Status();
			if (r_status != winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCommunicationStatus::Success)
			{
				const auto r_status_code = static_cast<int32_t>(r_status);
				const auto message = "Connect failed with status: " + std::to_string(r_status_code);
				throw MyException(message);
			}
			m_device_connection_status_changed_revokers[address_args] = device.ConnectionStatusChanged(winrt::auto_revoke, [this](winrt::Windows::Devices::Bluetooth::BluetoothLEDevice device, auto obj)
				{
					const auto address = device.BluetoothAddress();
					const auto status = device.ConnectionStatus();
					const auto address_args = static_cast<int64_t>(address);
					const auto state_args = m_connection_status_to_args(status);
					if (status == winrt::Windows::Devices::Bluetooth::BluetoothConnectionStatus::Disconnected)
					{
						m_disconnect(address_args);
					}
					m_api->OnConnectionStateChanged(address_args, state_args, [] {}, [](auto error) {});
				});
			m_session_max_pdu_size_changed_revokers[address_args] = session.MaxPduSizeChanged(winrt::auto_revoke, [this, device](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSession session, auto obj)
				{
					const auto address = device.BluetoothAddress();
					const auto mtu = session.MaxPduSize();
					const auto address_args = static_cast<int64_t>(address);
					const auto mtu_args = static_cast<int64_t>(mtu);
					m_api->OnMTUChanged(address_args, mtu_args, [] {}, [](auto error) {});
				});
			m_devices[address_args] = device;
			m_sessions[address_args] = session;
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
			const auto code = "unknown_exception";
			const auto message = "Connect failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyCentralManager::m_discover_services(int64_t address_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		try
		{
			const auto& device = m_devices[address_args];
			const auto& r = co_await device->GetGattServicesAsync(winrt::Windows::Devices::Bluetooth::BluetoothCacheMode::Uncached);
			const auto status = r.Status();
			if (status != winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Discover services failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
			const auto new_services = r.Services();
			auto& services = m_services[address_args];
			auto services_args_values = flutter::EncodableList();
			for (const auto service : new_services) {
				const auto service_args = m_service_to_args(service);
				const auto service_args_value = flutter::CustomEncodableValue(service_args);
				const auto service_handle_args = service_args.handle_args();
				services[service_handle_args] = service;
				services_args_values.emplace_back(service_args_value);
			}
			result(services_args_values);
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
			const auto code = "unknown_exception";
			const auto message = "Discover services failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyCentralManager::m_discover_characteristics(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		try
		{
			const auto service = m_retrieve_service(address_args, handle_args);
			const auto& r = co_await service->GetCharacteristicsAsync(winrt::Windows::Devices::Bluetooth::BluetoothCacheMode::Uncached);
			const auto status = r.Status();
			if (status != winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Discover characteristics failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
			const auto new_characteristics = r.Characteristics();
			auto& characteristics = m_characteristics[address_args];
			auto& revokers = m_characteristic_value_changed_revokers[address_args];
			auto characteristics_args_values = flutter::EncodableList();
			for (const auto characteristic : new_characteristics) {
				const auto characteristic_args = m_characteristic_to_args(characteristic);
				const auto characteristic_args_value = flutter::CustomEncodableValue(characteristic_args);
				const auto characteristic_handle_args = characteristic_args.handle_args();
				characteristics[characteristic_handle_args] = characteristic;
				revokers[characteristic_handle_args] = characteristic.ValueChanged(winrt::auto_revoke, [this, address_args, characteristic_handle_args](const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic& characteristic, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattValueChangedEventArgs& event_args)
					{
						const auto value = event_args.CharacteristicValue();
						const auto begin = value.data();
						const auto end = begin + value.Length();
						const auto value_args = std::vector<uint8_t>(begin, end);
						m_api->OnCharacteristicNotified(address_args, characteristic_handle_args, value_args, []() {}, [](const auto& error) {});
					});
				characteristics_args_values.emplace_back(characteristic_args_value);
			}
			result(characteristics_args_values);
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
			const auto code = "unknown_exception";
			const auto message = "Discover characteristics failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyCentralManager::m_discover_descriptors(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result)
	{
		try
		{
			const auto characteristic = m_retrieve_characteristic(address_args, handle_args);
			const auto& r = co_await characteristic->GetDescriptorsAsync(winrt::Windows::Devices::Bluetooth::BluetoothCacheMode::Uncached);
			const auto status = r.Status();
			if (status != winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Discover descriptors failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
			const auto new_descriptors = r.Descriptors();
			auto& descriptors = m_descriptors[address_args];
			auto descriptor_args_values = flutter::EncodableList();
			for (const auto descriptor : new_descriptors) {
				const auto descriptor_args = m_descriptor_to_args(descriptor);
				const auto descriptor_args_value = flutter::CustomEncodableValue(descriptor_args);
				const auto descriptor_handle_args = descriptor_args.handle_args();
				descriptors[descriptor_handle_args] = descriptor;
				descriptor_args_values.emplace_back(descriptor_args_value);
			}
			result(descriptor_args_values);
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
			const auto code = "unknown_exception";
			const auto message = "Discover descriptors failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyCentralManager::m_read_characteristic(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		try
		{
			const auto characteristic = m_retrieve_characteristic(address_args, handle_args);
			const auto& r = co_await characteristic->ReadValueAsync(winrt::Windows::Devices::Bluetooth::BluetoothCacheMode::Uncached);
			const auto status = r.Status();
			if (status != winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Read characteristic failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
			const auto value = r.Value();
			const auto begin = value.data();
			const auto end = begin + value.Length();
			const auto value_args = std::vector<uint8_t>(begin, end);
			result(value_args);
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
			const auto code = "unknown_exception";
			const auto message = "Read characteristic failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyCentralManager::m_write_characteristic(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, const MyGATTCharacteristicWriteTypeArgs& type_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		try
		{
			const auto characteristic = m_retrieve_characteristic(address_args, handle_args);
			const auto value = winrt::Windows::Security::Cryptography::CryptographicBuffer::CreateFromByteArray(value_args);
			const auto option = m_write_type_args_to_write_option(type_args);
			const auto status = co_await characteristic->WriteValueAsync(value, option);
			if (status != winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Write characteristic failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
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
			const auto code = "unknown_exception";
			const auto message = "Write characteristic failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyCentralManager::m_set_characteristic_notify_state(int64_t address_args, int64_t handle_args, const MyGATTCharacteristicNotifyStateArgs& state_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		try
		{
			const auto characteristic = m_retrieve_characteristic(address_args, handle_args);
			const auto value = m_notify_state_args_to_cccd_value(state_args);
			const auto status = co_await characteristic->WriteClientCharacteristicConfigurationDescriptorAsync(value);
			if (status != winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Notify characteristic failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
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
			const auto code = "unknown_exception";
			const auto message = "Notify characteristic failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyCentralManager::m_read_descriptor(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result)
	{
		try
		{
			const auto descriptor = m_retrieve_descriptor(address_args, handle_args);
			const auto& r = co_await descriptor->ReadValueAsync(winrt::Windows::Devices::Bluetooth::BluetoothCacheMode::Uncached);
			const auto status = r.Status();
			if (status != winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Read descriptor failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
			const auto value = r.Value();
			const auto begin = value.data();
			const auto end = begin + value.Length();
			const auto value_args = std::vector<uint8_t>(begin, end);
			result(value_args);
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
			const auto code = "unknown_exception";
			const auto message = "Read descriptor failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyCentralManager::m_write_descriptor(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError>reply)> result)
	{
		try
		{
			const auto descriptor = m_retrieve_descriptor(address_args, handle_args);
			const auto value = winrt::Windows::Security::Cryptography::CryptographicBuffer::CreateFromByteArray(value_args);
			const auto status = co_await descriptor->WriteValueAsync(value);
			if (status != winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCommunicationStatus::Success)
			{
				const auto status_code = static_cast<int32_t>(status);
				const auto message = "Write characteristic failed with status: " + std::to_string(status_code);
				throw MyException(message);
			}
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
			const auto code = "unknown_exception";
			const auto message = "Write descriptor failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	void MyCentralManager::m_disconnect(int64_t address_args)
	{
		// 通过释放连接实例，触发断开连接
		m_device_connection_status_changed_revokers.erase(address_args);
		m_session_max_pdu_size_changed_revokers.erase(address_args);
		m_characteristic_value_changed_revokers.erase(address_args);
		m_devices.erase(address_args);
		m_sessions.erase(address_args);
		m_services.erase(address_args);
		m_characteristics.erase(address_args);
		m_descriptors.erase(address_args);
	}

	MyBluetoothLowEnergyStateArgs MyCentralManager::m_radio_state_to_args(const winrt::Windows::Devices::Radios::RadioState& state)
	{
		switch (state)
		{
		case winrt::Windows::Devices::Radios::RadioState::Unknown:
			return MyBluetoothLowEnergyStateArgs::unknown;
		case winrt::Windows::Devices::Radios::RadioState::Disabled:
			return MyBluetoothLowEnergyStateArgs::disabled;
		case winrt::Windows::Devices::Radios::RadioState::Off:
			return MyBluetoothLowEnergyStateArgs::off;
		case winrt::Windows::Devices::Radios::RadioState::On:
			return MyBluetoothLowEnergyStateArgs::on;
		default:
			return MyBluetoothLowEnergyStateArgs::unknown;
		}
	}

	MyConnectionStateArgs MyCentralManager::m_connection_status_to_args(const winrt::Windows::Devices::Bluetooth::BluetoothConnectionStatus& status)
	{
		switch (status)
		{
		case winrt::Windows::Devices::Bluetooth::BluetoothConnectionStatus::Disconnected:
			return MyConnectionStateArgs::disconnected;
		case winrt::Windows::Devices::Bluetooth::BluetoothConnectionStatus::Connected:
			return MyConnectionStateArgs::connected;
		default:
			throw std::bad_cast();
		}
	}

	MyAdvertisementArgs MyCentralManager::m_advertisement_to_args(const winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisement& advertisement)
	{
		const auto name = advertisement.LocalName();
		const auto name_args = winrt::to_string(name);
		const auto service_uuids = advertisement.ServiceUuids();
		auto service_uuids_args = flutter::EncodableList();
		for (const auto uuid : service_uuids) {
			const auto uuid_args = m_uuid_to_args(uuid);
			service_uuids_args.emplace_back(uuid_args);
		}
		const auto data_sections = advertisement.DataSections();
		auto service_data_args = flutter::EncodableMap();
		for (const auto data_section : data_sections)
		{
			const auto section_type = data_section.DataType();
			const auto section_buffer = data_section.Data();
			const auto section_data_length = section_buffer.Length();
			const auto type16 = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementDataTypes::ServiceData16BitUuids();
			const auto type32 = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementDataTypes::ServiceData32BitUuids();
			const auto type128 = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementDataTypes::ServiceData128BitUuids();
			if (section_type == type16 && section_data_length > 2)
			{
				const auto section_data = section_buffer.data();
				auto data1 = uint16_t();
				std::memcpy(&data1, section_data, 2Ui64);
				const auto uuid_args = std::format("{:04X}", data1);
				const auto data_args = std::vector<uint8_t>(section_data + 2, section_data + section_data_length);
				service_data_args[uuid_args] = data_args;
			}
			else if (section_type == type32 && section_data_length > 4)
			{
				const auto section_data = section_buffer.data();
				auto data1 = uint32_t();
				std::memcpy(&data1, section_data, 4Ui64);
				const auto uuid_args = std::format("{:08X}", data1);
				const auto data_args = std::vector<uint8_t>(section_data + 4, section_data + section_data_length);
				service_data_args[uuid_args] = data_args;
			}
			else if (section_type == type128 && section_data_length > 16)
			{
				const auto section_data = section_buffer.data();
				auto data1 = uint32_t();
				std::memcpy(&data1, section_data, 4Ui64);
				auto data2 = uint16_t();
				std::memcpy(&data2, section_data + 4, 2Ui64);
				auto data3 = uint16_t();
				std::memcpy(&data3, section_data + 6, 2Ui64);
				auto data4 = std::array<uint8_t, 8Ui64>();
				std::memcpy(&data4, section_data + 8, 8Ui64);
				const auto uuid = winrt::guid(data1, data2, data3, data4);
				const auto uuid_args = m_uuid_to_args(uuid);
				const auto data_args = std::vector<uint8_t>(section_data + 16, section_data + section_data_length);
				service_data_args[uuid_args] = data_args;
			}
		}
		const auto manufacturer_data = advertisement.ManufacturerData();
		const auto manufacturer_data_size = manufacturer_data.Size();
		if (manufacturer_data_size > 0)
		{
			const auto last_manufacturer_data = manufacturer_data.GetAt(manufacturer_data_size - 1);
			const auto id = last_manufacturer_data.CompanyId();
			const auto id_args = static_cast<int64_t>(id);
			const auto data = last_manufacturer_data.Data();
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

	MyGATTServiceArgs MyCentralManager::m_service_to_args(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService& service)
	{
		const auto handle = service.AttributeHandle();
		const auto handle_args = static_cast<int64_t>(handle);
		const auto uuid = service.Uuid();
		const auto uuid_args = m_uuid_to_args(uuid);
		const auto characteristics_args = flutter::EncodableList();
		return MyGATTServiceArgs(handle_args, uuid_args, characteristics_args);
	}

	MyGATTCharacteristicArgs MyCentralManager::m_characteristic_to_args(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic& characteristic)
	{
		const auto handle = characteristic.AttributeHandle();
		const auto handle_args = static_cast<int64_t>(handle);
		const auto uuid = characteristic.Uuid();
		const auto uuid_args = m_uuid_to_args(uuid);
		const auto properties = characteristic.CharacteristicProperties();
		const auto property_numbers_args = m_characteristic_properties_to_args(properties);
		const auto descriptors_args = flutter::EncodableList();
		return MyGATTCharacteristicArgs(handle_args, uuid_args, property_numbers_args, descriptors_args);
	}

	flutter::EncodableList MyCentralManager::m_characteristic_properties_to_args(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties properties)
	{
		const auto readable = static_cast<int>(properties & winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::Read);
		const auto writable = static_cast<int>(properties & winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::Write);
		const auto writableWithoutResponse = static_cast<int>(properties & winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::WriteWithoutResponse);
		const auto notifiable = static_cast<int>(properties & winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::Notify);
		const auto indicatable = static_cast<int>(properties & winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::Indicate);
		auto property_numbers_args = flutter::EncodableList();
		if (readable)
		{
			const auto property_number_args = static_cast<int>(MyGATTCharacteristicPropertyArgs::read);
			property_numbers_args.emplace_back(property_number_args);
		}
		if (writable)
		{
			const auto property_number_args = static_cast<int>(MyGATTCharacteristicPropertyArgs::write);
			property_numbers_args.emplace_back(property_number_args);
		}
		if (writableWithoutResponse)
		{
			const auto property_number_args = static_cast<int>(MyGATTCharacteristicPropertyArgs::writeWithoutResponse);
			property_numbers_args.emplace_back(property_number_args);
		}
		if (notifiable)
		{
			const auto property_number_args = static_cast<int>(MyGATTCharacteristicPropertyArgs::notify);
			property_numbers_args.emplace_back(property_number_args);
		}
		if (indicatable)
		{
			const auto property_number_args = static_cast<int>(MyGATTCharacteristicPropertyArgs::indicate);
			property_numbers_args.emplace_back(property_number_args);
		}
		return property_numbers_args;
	}

	MyGATTDescriptorArgs MyCentralManager::m_descriptor_to_args(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor& descriptor)
	{
		const auto handle = descriptor.AttributeHandle();
		const auto handle_args = static_cast<int64_t>(handle);
		const auto uuid = descriptor.Uuid();
		const auto uuid_args = m_uuid_to_args(uuid);
		return MyGATTDescriptorArgs(handle_args, uuid_args);
	}

	std::string MyCentralManager::m_uuid_to_args(const winrt::guid& uuid)
	{
		//const auto uuid_value = winrt::to_hstring(uuid);
		//return winrt::to_string(uuid_value);
		return std::format("{}", uuid);
	}

	winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption MyCentralManager::m_write_type_args_to_write_option(const MyGATTCharacteristicWriteTypeArgs& type_args)
	{
		switch (type_args)
		{
		case MyGATTCharacteristicWriteTypeArgs::withoutResponse:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption::WriteWithoutResponse;
		case MyGATTCharacteristicWriteTypeArgs::withResponse:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption::WriteWithResponse;
		default:
			throw std::bad_cast();
		}
	}

	winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattClientCharacteristicConfigurationDescriptorValue MyCentralManager::m_notify_state_args_to_cccd_value(const MyGATTCharacteristicNotifyStateArgs& state_args)
	{
		switch (state_args)
		{
		case MyGATTCharacteristicNotifyStateArgs::none:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattClientCharacteristicConfigurationDescriptorValue::None;
		case MyGATTCharacteristicNotifyStateArgs::notify:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattClientCharacteristicConfigurationDescriptorValue::Notify;
		case MyGATTCharacteristicNotifyStateArgs::indicate:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattClientCharacteristicConfigurationDescriptorValue::Indicate;
		default:
			throw std::bad_cast();
		}
	}

	std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService> MyCentralManager::m_retrieve_service(int64_t address_args, int64_t handle_args)
	{
		auto& services = m_services[address_args];
		return services[handle_args];
	}

	std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic> MyCentralManager::m_retrieve_characteristic(int64_t address_args, int64_t handle_args)
	{
		auto& characteristics = m_characteristics[address_args];
		return characteristics[handle_args];
	}

	std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor> MyCentralManager::m_retrieve_descriptor(int64_t address_args, int64_t handle_args)
	{
		auto& descriptors = m_descriptors[address_args];
		return descriptors[handle_args];
	}
}

template <>
struct std::formatter<winrt::guid> : std::formatter<std::string>
{
	// NOTE: the format function should be a const member function.
	// see: https://developercommunity.visualstudio.com/t/standrad-formatters-should-use-const-and/1662387?q=Angular+standalone+%28esproj%29
	// see: https://developercommunity.visualstudio.com/t/Custom-std::formatter-breaks-after-upgra/10515914?space=8&ftype=problem&sort=newest&q=Suggestion&viewtype=solutions
	auto format(const winrt::guid& guid, std::format_context& context) const
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