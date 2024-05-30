#include "my_peripheral_manager.h"

namespace bluetooth_low_energy_windows
{
	MyPeripheralManager::MyPeripheralManager(flutter::BinaryMessenger *messenger)
	{
		const auto api = MyPeripheralManagerFlutterAPI(messenger);
		const auto publisher = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementPublisher();
		m_api = api;
		m_publisher = publisher;
	}

	MyPeripheralManager::~MyPeripheralManager()
	{
	}

	void MyPeripheralManager::Initialize(std::function<void(std::optional<FlutterError> reply)> result)
	{
		InitializeAsync(std::move(result));
	}

	ErrorOr<MyBluetoothLowEnergyStateArgs> MyPeripheralManager::GetState()
	{
		const auto &radio = m_radio.value();
		const auto state = radio.State();
		const auto state_args = RadioStateToArgs(state);
		return state_args;
	}

	void MyPeripheralManager::AddService(const MyMutableGATTServiceArgs &service_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		AddServiceAsync(service_args, std::move(result));
	}

	std::optional<FlutterError> MyPeripheralManager::RemoveService(int64_t hash_code_args)
	{
		const auto service_args = m_services_args[hash_code_args].value();
		m_services_args.erase(hash_code_args);
		const auto service_provider = m_service_providers[hash_code_args].value();
		m_service_providers.erase(hash_code_args);
		RemoveServiceArgs(service_args);
		service_provider.StopAdvertising();
		return std::nullopt;
	}

	std::optional<FlutterError> MyPeripheralManager::StartAdvertising(const MyAdvertisementArgs &advertisement_args)
	{
		const auto &publisher = m_publisher.value();
		const auto &advertisement = publisher.Advertisement();
		const auto name_args = advertisement_args.name_args();
		if (name_args != nullptr)
		{
			const auto name = winrt::to_hstring(*name_args);
			advertisement.LocalName(name);
		}
		const auto &service_uuids = advertisement.ServiceUuids();
		const auto &service_uuid_values = advertisement_args.service_u_u_i_ds_args();
		for (const auto &service_uuid_value : service_uuid_values)
		{
			const auto &service_uuid_args = std::get<std::string>(service_uuid_value);
			const auto &service_uuid = winrt::guid(service_uuid_args);
			service_uuids.Append(service_uuid);
		}
		const auto data_sections = advertisement.DataSections();
		const auto &service_data_values = advertisement_args.service_data_args();
		for (const auto &service_data_value : service_data_values)
		{
			const auto service_data = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementDataSection();
			const auto data_type = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementDataTypes::ServiceData128BitUuids();
			service_data.DataType(data_type);
			const auto writer = winrt::Windows::Storage::Streams::DataWriter();
			const auto &uuid_args = std::get<std::string>(service_data_value.first);
			const auto uuid = winrt::guid(uuid_args);
			writer.WriteGuid(uuid);
			const auto &data_args = std::get<std::vector<uint8_t>>(service_data_value.second);
			writer.WriteBytes(data_args);
			const auto data = writer.DetachBuffer();
			service_data.Data(data);
			data_sections.Append(service_data);
		}
		const auto &manufacturer_data = advertisement.ManufacturerData();
		const auto manufacturer_specific_data_args = advertisement_args.manufacturer_specific_data_args();
		if (manufacturer_specific_data_args != nullptr)
		{
			const auto manufacturer_specific_data = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEManufacturerData();
			const auto id_args = manufacturer_specific_data_args->id_args();
			const auto id = static_cast<uint16_t>(id_args);
			manufacturer_specific_data.CompanyId(id);
			const auto &data_args = manufacturer_specific_data_args->data_args();
			const auto writer = winrt::Windows::Storage::Streams::DataWriter();
			writer.WriteBytes(data_args);
			const auto data = writer.DetachBuffer();
			manufacturer_specific_data.Data(data);
			manufacturer_data.Append(manufacturer_specific_data);
		}
		publisher.Start();
		return std::nullopt;
	}

	std::optional<FlutterError> MyPeripheralManager::StopAdvertising()
	{
		const auto &publisher = m_publisher.value();
		publisher.Stop();
		return std::nullopt;
	}

	ErrorOr<int64_t> MyPeripheralManager::GetMaxNotificationSize(int64_t address_args)
	{
		const auto client = m_clients[address_args].value();
		const auto max_notification_size = client.MaxNotificationSize();
		const auto max_notification_size_args = static_cast<int64_t>(max_notification_size);
		return max_notification_size;
	}

	std::optional<FlutterError> MyPeripheralManager::RespondReadRequestWithValue(int64_t hash_code_args, const std::vector<uint8_t> &value_args)
	{
		const auto deferal = m_deferrals[hash_code_args].value();
		const auto request = m_read_requests[hash_code_args].value();
		m_deferrals.erase(hash_code_args);
		m_read_requests.erase(hash_code_args);
		const auto writer = winrt::Windows::Storage::Streams::DataWriter();
		writer.WriteBytes(value_args);
		const auto value = writer.DetachBuffer();
		request.RespondWithValue(value);
		deferal.Complete();
	}

	std::optional<FlutterError> MyPeripheralManager::RespondReadRequestWithProtocolError(int64_t hash_code_args, const MyGATTProtocolErrorArgs &error_args)
	{
		const auto deferal = m_deferrals[hash_code_args].value();
		const auto request = m_read_requests[hash_code_args].value();
		m_deferrals.erase(hash_code_args);
		m_read_requests.erase(hash_code_args);
		const auto error = ArgsToProtocolError(error_args);
		request.RespondWithProtocolError(error);
		deferal.Complete();
	}

	std::optional<FlutterError> MyPeripheralManager::RespondWriteRequest(int64_t hash_code_args)
	{
		const auto deferal = m_deferrals[hash_code_args].value();
		const auto request = m_write_requests[hash_code_args].value();
		m_deferrals.erase(hash_code_args);
		m_write_requests.erase(hash_code_args);
		request.Respond();
		deferal.Complete();
	}

	std::optional<FlutterError> MyPeripheralManager::RespondWriteRequestWithProtocolError(int64_t hash_code_args, const MyGATTProtocolErrorArgs &error_args)
	{
		const auto deferal = m_deferrals[hash_code_args].value();
		const auto request = m_write_requests[hash_code_args].value();
		m_deferrals.erase(hash_code_args);
		m_write_requests.erase(hash_code_args);
		const auto error = ArgsToProtocolError(error_args);
		request.RespondWithProtocolError(error);
		deferal.Complete();
	}

	void MyPeripheralManager::NotifyValue(int64_t address_args, int64_t hash_code_args, const std::vector<uint8_t> &value_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		NotifyValueAsync(address_args, hash_code_args, value_args, std::move(result));
	}

	winrt::fire_and_forget MyPeripheralManager::InitializeAsync(std::function<void(std::optional<FlutterError> reply)> result)
	{
		try
		{
			const auto &publisher = m_publisher.value();
			const auto status = publisher.Status();
			if (status == winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementPublisherStatus::Started)
			{
				publisher.Stop();
			}

			if (!m_radio_state_changed_revoker)
			{
				const auto &adapter = co_await winrt::Windows::Devices::Bluetooth::BluetoothAdapter::GetDefaultAsync();
				const auto &radio = co_await adapter.GetRadioAsync();
				m_radio_state_changed_revoker = radio.StateChanged(
					winrt::auto_revoke,
					[this](winrt::Windows::Devices::Radios::Radio radio, auto obj)
					{
						auto &api = m_api.value();
						const auto state = radio.State();
						const auto state_args = RadioStateToArgs(state);
						// TODO: Make this thread safe when this issue closed: https://github.com/flutter/flutter/issues/134346.
						api.OnStateChanged(state_args, [] {}, [](auto error) {});
					});
			}
		}
		catch (const winrt::hresult_error &ex)
		{
			const auto code = "winrt::hresult_error";
			const auto winrt_message = ex.message();
			const auto message = winrt::to_string(winrt_message);
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (const std::exception &ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyPeripheralManager::AddServiceAsync(const MyMutableGATTServiceArgs &service_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		try
		{
			const auto hash_code_args = service_args.hash_code_args();
			const auto &uuid_args = service_args.uuid_args();
			const auto uuid = winrt::guid(uuid_args);
			const auto &r = co_await winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattServiceProvider::CreateAsync(uuid);
			const auto error = r.Error();
			if (error != winrt::Windows::Devices::Bluetooth::BluetoothError::Success)
			{
				const auto error_code = static_cast<int32_t>(error);
				const auto message = "Create service failed with error: " + std::to_string(error_code);
				throw MyException(message);
			}
			const auto service_provider = r.ServiceProvider();
			const auto service = service_provider.Service();
			const auto &characteristics_args_value = service_args.characteristics_args();
			for (const auto &characteristic_args_value : characteristics_args_value)
			{
				const auto &custom_characteristic_args_value = std::get<flutter::CustomEncodableValue>(characteristic_args_value);
				const auto &characteristic_args = std::any_cast<MyMutableGATTCharacteristicArgs>(custom_characteristic_args_value);
				co_await CreateCharacteristicAsync(service, characteristic_args);
			}
			const auto parameters = winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattServiceProviderAdvertisingParameters();
			parameters.IsDiscoverable(true);
			parameters.IsConnectable(true);
			service_provider.StartAdvertising(parameters);
			m_service_providers[hash_code_args] = service_provider;
			m_services_args[hash_code_args] = service_args;
		}
		catch (const winrt::hresult_error &ex)
		{
			const auto code = "winrt::hresult_error";
			const auto winrt_message = ex.message();
			const auto message = winrt::to_string(winrt_message);
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (const std::exception &ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyPeripheralManager::NotifyValueAsync(int64_t address_args, int64_t hash_code_args, const std::vector<uint8_t> &value_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		try
		{
			const auto client = m_clients[address_args].value();
			const auto characteristic = m_characteristics[hash_code_args].value();
			const auto writer = winrt::Windows::Storage::Streams::DataWriter();
			writer.WriteBytes(value_args);
			const auto value = writer.DetachBuffer();
			co_await characteristic.NotifyValueAsync(value);
		}
		catch (const winrt::hresult_error &ex)
		{
			const auto code = "winrt::hresult_error";
			const auto winrt_message = ex.message();
			const auto message = winrt::to_string(winrt_message);
			const auto error = FlutterError(code, message);
			result(error);
		}
		catch (const std::exception &ex)
		{
			const auto code = "std::exception";
			const auto message = ex.what();
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::Windows::Foundation::IAsyncAction MyPeripheralManager::CreateCharacteristicAsync(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalService &service, const MyMutableGATTCharacteristicArgs &characteristic_args)
	{
		const auto hash_code_args = characteristic_args.hash_code_args();
		const auto &uuid_args = characteristic_args.uuid_args();
		const auto uuid = winrt::guid(uuid_args);
		const auto parameters = winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristicParameters();
		const auto value_args = characteristic_args.value_args();
		if (value_args != nullptr)
		{
			const auto writer = winrt::Windows::Storage::Streams::DataWriter();
			writer.WriteBytes(*value_args);
			const auto value = writer.DetachBuffer();
			parameters.StaticValue(value);
		}
		const auto &property_number_values = characteristic_args.property_numbers_args();
		const auto properties = CharacteristicPropertyNumberValuesToProperties(property_number_values);
		parameters.CharacteristicProperties(properties);
		const auto &permission_number_values = characteristic_args.permission_numbers_args();
		const auto &begin = permission_number_values.begin();
		const auto &end = permission_number_values.end();
		std::sort(begin, end);
		for (const auto &permission_number_value : permission_number_values)
		{
			const auto permission_number = std::get<std::int64_t>(permission_number_value);
			const auto permission_args = static_cast<MyGATTCharacteristicPermissionArgs>(permission_number);
			switch (permission_args)
			{
			case MyGATTCharacteristicPermissionArgs::read:
				parameters.ReadProtectionLevel(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtectionLevel::Plain);
				break;
			case MyGATTCharacteristicPermissionArgs::readEncrypted:
				parameters.ReadProtectionLevel(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtectionLevel::EncryptionRequired);
				break;
			case MyGATTCharacteristicPermissionArgs::write:
				parameters.WriteProtectionLevel(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtectionLevel::Plain);
				break;
			case MyGATTCharacteristicPermissionArgs::writeEncrypted:
				parameters.WriteProtectionLevel(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtectionLevel::EncryptionRequired);
				break;
			default:
				break;
			}
		}
		const auto &r = co_await service.CreateCharacteristicAsync(uuid, parameters);
		const auto error = r.Error();
		if (error != winrt::Windows::Devices::Bluetooth::BluetoothError::Success)
		{
			const auto error_code = static_cast<int32_t>(error);
			const auto message = "Create characteristic failed with error: " + std::to_string(error_code);
			throw MyException(message);
		}
		const auto characteristic = r.Characteristic();
		m_characteristic_read_requested_revokers[hash_code_args] = characteristic.ReadRequested(
			winrt::auto_revoke,
			[this, hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic &characteristic, winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs &event_args)
			{
				OnCharacteristicReadRequestedAsync(hash_code_args, event_args);
			});
		m_characteristic_write_requested_revokers[hash_code_args] = characteristic.WriteRequested(
			winrt::auto_revoke,
			[this, hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic &characteristic, winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs &event_args)
			{
				OnCharacteristicWriteRequestedAsync(hash_code_args, event_args);
			});
		m_characteristic_subscribed_clients_changed_revokers[hash_code_args] = characteristic.SubscribedClientsChanged(
			winrt::auto_revoke,
			[this, hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic &characteristic, auto obj)
			{
				OnCharacteristicSubscribedClientsChangedAsync(hash_code_args, characteristic);
			});
		const auto &descriptors_args_value = characteristic_args.descriptors_args();
		for (const auto &descriptor_args_value : descriptors_args_value)
		{
			const auto &custom_descriptor_args_value = std::get<flutter::CustomEncodableValue>(descriptor_args_value);
			const auto &descriptor_args = std::any_cast<MyMutableGATTDescriptorArgs>(custom_descriptor_args_value);
			co_await CreateDescriptorAsync(characteristic, descriptor_args);
		}
		m_characteristics[hash_code_args] = characteristic;
	}

	winrt::Windows::Foundation::IAsyncAction MyPeripheralManager::CreateDescriptorAsync(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic &characteristic, const MyMutableGATTDescriptorArgs &descriptor_args)
	{
		const auto &uuid_args = descriptor_args.uuid_args();
		const auto uuid = winrt::guid(uuid_args);
		const auto parameters = winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalDescriptorParameters();
		const auto value_args = descriptor_args.value_args();
		if (value_args != nullptr)
		{
			const auto writer = winrt::Windows::Storage::Streams::DataWriter();
			writer.WriteBytes(*value_args);
			const auto value = writer.DetachBuffer();
			parameters.StaticValue(value);
		}
		const auto &permission_number_values = descriptor_args.permission_numbers_args();
		const auto &begin = permission_number_values.begin();
		const auto &end = permission_number_values.end();
		std::sort(begin, end);
		for (const auto &permission_number_value : permission_number_values)
		{
			const auto permission_number = std::get<std::int64_t>(permission_number_value);
			const auto permission_args = static_cast<MyGATTCharacteristicPermissionArgs>(permission_number);
			switch (permission_args)
			{
			case MyGATTCharacteristicPermissionArgs::read:
				parameters.ReadProtectionLevel(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtectionLevel::Plain);
				break;
			case MyGATTCharacteristicPermissionArgs::readEncrypted:
				parameters.ReadProtectionLevel(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtectionLevel::EncryptionRequired);
				break;
			case MyGATTCharacteristicPermissionArgs::write:
				parameters.WriteProtectionLevel(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtectionLevel::Plain);
				break;
			case MyGATTCharacteristicPermissionArgs::writeEncrypted:
				parameters.WriteProtectionLevel(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtectionLevel::EncryptionRequired);
				break;
			default:
				break;
			}
		}
		const auto &r = co_await characteristic.CreateDescriptorAsync(uuid, parameters);
		const auto error = r.Error();
		if (error != winrt::Windows::Devices::Bluetooth::BluetoothError::Success)
		{
			const auto error_code = static_cast<int32_t>(error);
			const auto message = "Create descriptor failed with error: " + std::to_string(error_code);
			throw MyException(message);
		}
		const auto descriptor = r.Descriptor();
		const auto descriptor_hash_code_args = descriptor_args.hash_code_args();
		m_descriptor_read_requested_revokers[descriptor_hash_code_args] = descriptor.ReadRequested(
			winrt::auto_revoke,
			[this, descriptor_hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalDescriptor &descriptor, winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs &event_args)
			{
				OnDescriptorReadRequestedAsync(descriptor_hash_code_args, event_args);
			});
		m_descriptor_write_requested_revokers[descriptor_hash_code_args] = descriptor.WriteRequested(
			winrt::auto_revoke,
			[this, descriptor_hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalDescriptor &descriptor, winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs &event_args)
			{
				OnDescriptorWriteRequestedAsync(descriptor_hash_code_args, event_args);
			});
	}

	void MyPeripheralManager::RemoveServiceArgs(const MyMutableGATTServiceArgs &service_args)
	{
		const auto &characteristics_args_value = service_args.characteristics_args();
		for (const auto &characteristic_args_value : characteristics_args_value)
		{
			const auto &custom_characteristic_args_value = std::get<flutter::CustomEncodableValue>(characteristic_args_value);
			const auto &characteristic_args = std::any_cast<MyMutableGATTCharacteristicArgs>(custom_characteristic_args_value);
			RemoveCharacteristicArgs(characteristic_args);
		}
	}

	void MyPeripheralManager::RemoveCharacteristicArgs(const MyMutableGATTCharacteristicArgs &characteristic_args)
	{
		const auto hash_code_args = characteristic_args.hash_code_args();
		const auto &descriptors_args_value = characteristic_args.descriptors_args();
		for (const auto &descriptor_args_value : descriptors_args_value)
		{
			const auto &custom_descriptor_args_value = std::get<flutter::CustomEncodableValue>(descriptor_args_value);
			const auto &descriptor_args = std::any_cast<MyMutableGATTDescriptorArgs>(custom_descriptor_args_value);
			RemoveDescriptorArgs(descriptor_args);
		}
		m_characteristic_read_requested_revokers.erase(hash_code_args);
		m_characteristic_write_requested_revokers.erase(hash_code_args);
		m_characteristic_subscribed_clients_changed_revokers.erase(hash_code_args);
		m_characteristics.erase(hash_code_args);
	}

	void MyPeripheralManager::RemoveDescriptorArgs(const MyMutableGATTDescriptorArgs &descriptor_args)
	{
		const auto hash_code_args = descriptor_args.hash_code_args();
		m_descriptor_read_requested_revokers.erase(hash_code_args);
		m_descriptor_write_requested_revokers.erase(hash_code_args);
	}

	winrt::fire_and_forget MyPeripheralManager::OnCharacteristicReadRequestedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs &event_args)
	{
		auto api = m_api.value();
		const auto session = event_args.Session();
		const auto central_args = co_await SessionToArgsAsync(session);
		const auto &deferral = event_args.GetDeferral();
		const auto &request = co_await event_args.GetRequestAsync();
		const auto id = std::addressof(request);
		const auto id_args = reinterpret_cast<int64_t>(id);
		const auto offset = request.Offset();
		const auto offset_args = static_cast<int64_t>(offset);
		const auto length = request.Length();
		const auto length_args = static_cast<int64_t>(length);
		m_deferrals[id_args] = deferral;
		m_read_requests[id_args] = request;
		const auto request_args = MyGATTReadRequestArgs(id_args, offset_args, length_args);
		api.OnCharacteristicReadRequest(central_args, hash_code_args, request_args, []() {}, [](const auto &error) {});
	}

	winrt::fire_and_forget MyPeripheralManager::OnCharacteristicWriteRequestedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs &event_args)
	{
		auto api = m_api.value();
		const auto session = event_args.Session();
		const auto central_args = co_await SessionToArgsAsync(session);
		const auto &deferral = event_args.GetDeferral();
		const auto &request = co_await event_args.GetRequestAsync();
		const auto id = std::addressof(request);
		const auto id_args = reinterpret_cast<int64_t>(id);
		const auto offset = request.Offset();
		const auto offset_args = static_cast<int64_t>(offset);
		const auto value = request.Value();
		const auto value_length = value.Length();
		const auto value_args = std::vector<uint8_t>(value_length);
		const auto reader = winrt::Windows::Storage::Streams::DataReader::FromBuffer(value);
		reader.ReadBytes(value_args);
		const auto option = request.Option();
		const auto type_args = WriteOptionToArgs(option);
		m_deferrals[id_args] = deferral;
		m_write_requests[id_args] = request;
		const auto request_args = MyGATTWriteRequestArgs(id_args, offset_args, value_args, type_args);
		api.OnCharacteristicWriteRequest(central_args, hash_code_args, request_args, []() {}, [](const auto &error) {});
	}

	winrt::fire_and_forget MyPeripheralManager::OnCharacteristicSubscribedClientsChangedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic &characteristic)
	{
		auto &api = m_api.value();
		auto centrals_args = flutter::EncodableList();
		const auto &clients = characteristic.SubscribedClients();
		for (const auto client : clients)
		{
			const auto session = client.Session();
			const auto central_args = co_await SessionToArgsAsync(session);
			const auto address_args = central_args.address_args();
			m_clients[address_args] = client;
			const auto central_args_value = flutter::CustomEncodableValue(central_args);
			centrals_args.emplace_back(central_args_value);
		}
		api.OnCharacteristicSubscribedClientsChanged(hash_code_args, centrals_args, []() {}, [](const auto &error) {});
	}

	winrt::fire_and_forget MyPeripheralManager::OnDescriptorReadRequestedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs &event_args)
	{
		auto api = m_api.value();
		const auto session = event_args.Session();
		const auto central_args = co_await SessionToArgsAsync(session);
		const auto &deferral = event_args.GetDeferral();
		const auto &request = co_await event_args.GetRequestAsync();
		const auto id = std::addressof(request);
		const auto id_args = reinterpret_cast<int64_t>(id);
		const auto offset = request.Offset();
		const auto offset_args = static_cast<int64_t>(offset);
		const auto length = request.Length();
		const auto length_args = static_cast<int64_t>(length);
		m_deferrals[id_args] = deferral;
		m_read_requests[id_args] = request;
		const auto request_args = MyGATTReadRequestArgs(id_args, offset_args, length_args);
		api.OnDescriptorReadRequest(central_args, hash_code_args, request_args, []() {}, [](const auto &error) {});
	}

	winrt::fire_and_forget MyPeripheralManager::OnDescriptorWriteRequestedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs &event_args)
	{
		auto api = m_api.value();
		const auto session = event_args.Session();
		const auto central_args = co_await SessionToArgsAsync(session);
		const auto &deferral = event_args.GetDeferral();
		const auto &request = co_await event_args.GetRequestAsync();
		const auto id = std::addressof(request);
		const auto id_args = reinterpret_cast<int64_t>(id);
		const auto offset = request.Offset();
		const auto offset_args = static_cast<int64_t>(offset);
		const auto value = request.Value();
		const auto value_length = value.Length();
		const auto value_args = std::vector<uint8_t>(value_length);
		const auto reader = winrt::Windows::Storage::Streams::DataReader::FromBuffer(value);
		reader.ReadBytes(value_args);
		const auto option = request.Option();
		const auto type_args = WriteOptionToArgs(option);
		m_deferrals[id_args] = deferral;
		m_write_requests[id_args] = request;
		const auto request_args = MyGATTWriteRequestArgs(id_args, offset_args, value_args, type_args);
		api.OnDescriptorWriteRequest(central_args, hash_code_args, request_args, []() {}, [](const auto &error) {});
	}

	MyBluetoothLowEnergyStateArgs MyPeripheralManager::RadioStateToArgs(const winrt::Windows::Devices::Radios::RadioState &state)
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

	winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties MyPeripheralManager::CharacteristicPropertyNumberValuesToProperties(const flutter::EncodableList property_numbers_args_value)
	{
		auto properties = winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::None;
		for (const auto property_number_args_value : property_numbers_args_value)
		{
			const auto property_number_args = std::get<int64_t>(property_number_args_value);
			const auto property_args = static_cast<MyGATTCharacteristicPropertyArgs>(property_number_args);
			switch (property_args)
			{
			case MyGATTCharacteristicPropertyArgs::read:
				properties |= winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::Read;
				break;
			case MyGATTCharacteristicPropertyArgs::write:
				properties |= winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::Write;
				break;
			case MyGATTCharacteristicPropertyArgs::writeWithoutResponse:
				properties |= winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::WriteWithoutResponse;
				break;
			case MyGATTCharacteristicPropertyArgs::notify:
				properties |= winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::Notify;
				break;
			case MyGATTCharacteristicPropertyArgs::indicate:
				properties |= winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties::Indicate;
				break;
			default:
				break;
			}
		}
		return properties;
	}

	winrt::Windows::Foundation::IAsyncOperation<MyCentralArgs> MyPeripheralManager::SessionToArgsAsync(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSession &session)
	{
		const auto id = session.DeviceId().Id();
		const auto device = co_await winrt::Windows::Devices::Bluetooth::BluetoothLEDevice::FromIdAsync(id);
		const auto address = device.BluetoothAddress();
		const auto address_args = static_cast<int64_t>(address);
		const auto central_args = MyCentralArgs(address_args);
		m_session_max_pdu_size_changed_revokers[address_args] = session.MaxPduSizeChanged(
			winrt::auto_revoke,
			[this, central_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSession &session, auto obj)
			{
				auto &api = m_api.value();
				const auto mtu = session.MaxPduSize();
				const auto mtu_args = static_cast<int64_t>(mtu);
				// TODO: Make this thread safe when this issue closed: https://github.com/flutter/flutter/issues/134346.
				api.OnMTUChanged(central_args, mtu_args, [] {}, [](auto error) {});
			});
		co_return central_args;
	}

	MyGATTCharacteristicWriteTypeArgs MyPeripheralManager::WriteOptionToArgs(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption &option)
	{
		switch (option)
		{
		case winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption::WriteWithResponse:
			return MyGATTCharacteristicWriteTypeArgs::withResponse;
		case winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption::WriteWithoutResponse:
			return MyGATTCharacteristicWriteTypeArgs::withoutResponse;
		default:
			throw std::bad_cast();
		}
	}

	uint8_t MyPeripheralManager::ArgsToProtocolError(const MyGATTProtocolErrorArgs &error_args)
	{
		switch (error_args)
		{
		case MyGATTProtocolErrorArgs::invalidHandle:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::InvalidHandle();
		case MyGATTProtocolErrorArgs::readNotPermitted:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::ReadNotPermitted();
		case MyGATTProtocolErrorArgs::writeNotPermitted:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::WriteNotPermitted();
		case MyGATTProtocolErrorArgs::invalidPDU:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::InvalidPdu();
		case MyGATTProtocolErrorArgs::insufficientAuthentication:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::InsufficientAuthentication();
		case MyGATTProtocolErrorArgs::requestNotSupported:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::RequestNotSupported();
		case MyGATTProtocolErrorArgs::invalidOffset:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::InvalidOffset();
		case MyGATTProtocolErrorArgs::insufficientAuthorization:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::InsufficientAuthorization();
		case MyGATTProtocolErrorArgs::prepareQueueFull:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::PrepareQueueFull();
		case MyGATTProtocolErrorArgs::attributeNotFound:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::AttributeNotFound();
		case MyGATTProtocolErrorArgs::attributeNotLong:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::AttributeNotLong();
		case MyGATTProtocolErrorArgs::insufficientEncryptionKeySize:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::InsufficientEncryptionKeySize();
		case MyGATTProtocolErrorArgs::invalidAttributeValueLength:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::InvalidAttributeValueLength();
		case MyGATTProtocolErrorArgs::unlikelyError:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::UnlikelyError();
		case MyGATTProtocolErrorArgs::insufficientEncryption:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::InsufficientEncryption();
		case MyGATTProtocolErrorArgs::unsupportedGroupType:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::UnsupportedGroupType();
		case MyGATTProtocolErrorArgs::insufficientResources:
			return winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtocolError::InsufficientResources();
		default:
			throw std::bad_cast();
		}
	}

} // namespace bluetooth_low_energy_windows
