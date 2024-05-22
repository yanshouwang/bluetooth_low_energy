#include "my_peripheral_manager.h"

namespace bluetooth_low_energy_windows
{
	MyPeripheralManager::MyPeripheralManager(flutter::BinaryMessenger* messenger)
	{
		api = MyPeripheralManagerFlutterAPI(messenger);
		publisher = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementPublisher();
	}

	MyPeripheralManager::~MyPeripheralManager()
	{
	}

	void MyPeripheralManager::Initialize(std::function<void(std::optional<FlutterError> reply)> result)
	{
		FireAndForgetInitialize(std::move(result));
	}

	ErrorOr<MyBluetoothLowEnergyStateArgs> MyPeripheralManager::GetState()
	{
		const auto& radio = this->radio.value();
		const auto state = radio.State();
		const auto state_args = RadioStateToArgs(state);
		return state_args;
	}

	void MyPeripheralManager::AddService(const MyMutableGATTServiceArgs& service_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		FireAndForgetAddService(service_args, std::move(result));
	}

	std::optional<FlutterError> MyPeripheralManager::RemoveService(int64_t hash_code_args)
	{
		return std::optional<FlutterError>();
	}

	std::optional<FlutterError> MyPeripheralManager::StartAdvertising(const MyAdvertisementArgs& advertisement_args)
	{
		const auto& publisher = this->publisher.value();
		const auto& advertisement = publisher.Advertisement();
		const auto name_args = advertisement_args.name_args();
		if (name_args != nullptr)
		{
			const auto name = winrt::to_hstring(*name_args);
			advertisement.LocalName(name);
		}
		const auto& service_uuids = advertisement.ServiceUuids();
		const auto& service_uuid_values = advertisement_args.service_u_u_i_ds_args();
		for (const auto& service_uuid_value : service_uuid_values) {
			const auto& service_uuid_args = std::get<std::string>(service_uuid_value);
			const auto& service_uuid = winrt::guid(service_uuid_args);
			service_uuids.Append(service_uuid);
		}
		const auto data_sections = advertisement.DataSections();
		const auto& service_data_values = advertisement_args.service_data_args();
		for (const auto& service_data_value : service_data_values) {
			const auto service_data = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementDataSection();
			const auto data_type = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementDataTypes::ServiceData128BitUuids();
			service_data.DataType(data_type);
			const auto writer = winrt::Windows::Storage::Streams::DataWriter();
			const auto& uuid_args = std::get<std::string>(service_data_value.first);
			const auto uuid = winrt::guid(uuid_args);
			writer.WriteGuid(uuid);
			const auto& data_args = std::get<std::vector<uint8_t>>(service_data_value.second);
			writer.WriteBytes(data_args);
			const auto data = writer.DetachBuffer();
			service_data.Data(data);
			data_sections.Append(service_data);
		}
		const auto& manufacturer_data = advertisement.ManufacturerData();
		const auto manufacturer_specific_data_args = advertisement_args.manufacturer_specific_data_args();
		if (manufacturer_specific_data_args != nullptr)
		{
			const auto manufacturer_specific_data = winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEManufacturerData();
			const auto id_args = manufacturer_specific_data_args->id_args();
			const auto id = static_cast<uint16_t>(id_args);
			manufacturer_specific_data.CompanyId(id);
			const auto& data_args = manufacturer_specific_data_args->data_args();
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
		const auto& publisher = this->publisher.value();
		publisher.Stop();
		return std::nullopt;
	}

	ErrorOr<int64_t> MyPeripheralManager::GetMTU(int64_t address_args)
	{
		const auto& session = sessions[address_args].value();
		const auto mtu = session.MaxPduSize();
		const auto mtu_args = static_cast<int64_t>(mtu);
		return mtu_args;
	}

	std::optional<FlutterError> MyPeripheralManager::RespondReadRequestWithValue(int64_t address_args, int64_t hash_code_args, const std::vector<uint8_t>& value_args)
	{
		return std::optional<FlutterError>();
	}

	std::optional<FlutterError> MyPeripheralManager::RespondReadRequestWithProtocolError(int64_t address_args, int64_t hash_code_args, const MyGATTProtocolErrorArgs& error_args)
	{
		return std::optional<FlutterError>();
	}

	std::optional<FlutterError> MyPeripheralManager::RespondWriteRequest(int64_t address_args, int64_t hash_code_args)
	{
		return std::optional<FlutterError>();
	}

	std::optional<FlutterError> MyPeripheralManager::RespondWriteRequestWithProtocolError(int64_t address_args, int64_t hash_code_args, const MyGATTProtocolErrorArgs& error_args)
	{
		return std::optional<FlutterError>();
	}

	void MyPeripheralManager::NotifyValueAsync(const std::string& address_args, int64_t hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	winrt::fire_and_forget MyPeripheralManager::FireAndForgetInitialize(std::function<void(std::optional<FlutterError> reply)> result)
	{
		try
		{
			const auto& publisher = this->publisher.value();
			const auto status = publisher.Status();
			if (status == winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementPublisherStatus::Started)
			{
				publisher.Stop();
			}

			if (!radio_state_changed_revoker)
			{
				const auto& adapter = co_await winrt::Windows::Devices::Bluetooth::BluetoothAdapter::GetDefaultAsync();
				const auto& radio = co_await adapter.GetRadioAsync();
				radio_state_changed_revoker = radio.StateChanged(winrt::auto_revoke, [this](winrt::Windows::Devices::Radios::Radio radio, auto obj)
					{
						auto& api = this->api.value();
						const auto state = radio.State();
						const auto state_args = RadioStateToArgs(state);
						// TODO: Make this thread safe when this issue closed: https://github.com/flutter/flutter/issues/134346.
						api.OnStateChanged(state_args, [] {}, [](auto error) {});
					});
			}
		}
		catch (const winrt::hresult_error& ex)
		{
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
		catch (...)
		{
			const auto code = "unknown_exception";
			const auto message = "Initialize failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyPeripheralManager::FireAndForgetAddService(const MyMutableGATTServiceArgs& service_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		try
		{
			const auto& uuid_args = service_args.uuid_args();
			const auto uuid = winrt::guid(uuid_args);
			const auto& r = co_await winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattServiceProvider::CreateAsync(uuid);
			const auto error = r.Error();
			if (error != winrt::Windows::Devices::Bluetooth::BluetoothError::Success)
			{
				const auto error_code = static_cast<int32_t>(error);
				const auto message = "Create service failed with error: " + std::to_string(error_code);
				throw MyException(message);
			}
			const auto service_provider = r.ServiceProvider();
			const auto service = service_provider.Service();
			const auto& characteristic_values = service_args.characteristics_args();
			for (const auto& characteristic_value : characteristic_values)
			{
				const auto& custom_characteristic_value = std::get<flutter::CustomEncodableValue>(characteristic_value);
				const auto& characteristic_args = std::any_cast<MyMutableGATTCharacteristicArgs>(custom_characteristic_value);
				co_await CreateCharacteristicAsync(service, characteristic_args);
			}
			const auto parameters = winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattServiceProviderAdvertisingParameters();
			parameters.IsDiscoverable(true);
			parameters.IsConnectable(true);
			service_provider.StartAdvertising(parameters);
		}
		catch (const winrt::hresult_error& ex)
		{
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
		catch (...)
		{
			const auto code = "unknown_exception";
			const auto message = "Add service failed with unknown exception.";
			const auto error = FlutterError(code, message);
			result(error);
		}
	}

	winrt::fire_and_forget MyPeripheralManager::FireAndForgetNotifyValueAsync(const std::string& address_args, int64_t hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
		return winrt::fire_and_forget();
	}

	winrt::Windows::Foundation::IAsyncAction MyPeripheralManager::CreateCharacteristicAsync(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalService& service, const MyMutableGATTCharacteristicArgs& characteristic_args)
	{
		const auto& characteristic_uuid_args = characteristic_args.uuid_args();
		const auto characteristic_uuid = winrt::guid(characteristic_uuid_args);
		const auto parameters = winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristicParameters();
		const auto value_args = characteristic_args.value_args();
		if (value_args != nullptr)
		{
			const auto writer = winrt::Windows::Storage::Streams::DataWriter();
			writer.WriteBytes(*value_args);
			const auto value = writer.DetachBuffer();
			parameters.StaticValue(value);
		}
		const auto& property_number_values = characteristic_args.property_numbers_args();
		const auto properties = CharacteristicPropertyNumberValuesToProperties(property_number_values);
		parameters.CharacteristicProperties(properties);
		const auto& permission_number_values = characteristic_args.permission_numbers_args();
		const auto& begin = permission_number_values.begin();
		const auto& end = permission_number_values.end();
		std::sort(begin, end);
		for (const auto& permission_number_value : permission_number_values)
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
		const auto& r = co_await service.CreateCharacteristicAsync(characteristic_uuid, parameters);
		const auto error = r.Error();
		if (error != winrt::Windows::Devices::Bluetooth::BluetoothError::Success)
		{
			const auto error_code = static_cast<int32_t>(error);
			const auto message = "Create characteristic failed with error: " + std::to_string(error_code);
			throw MyException(message);
		}
		const auto characteristic = r.Characteristic();
		const auto characteristic_hash_code_args = characteristic_args.hash_code_args();
		characteristic_read_requested_revokers[characteristic_hash_code_args] = characteristic.ReadRequested(
			winrt::auto_revoke,
			[this, characteristic_hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic& characteristic, winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs& event_args)
			{
				FireAndForgetCharacteristicReadRequested(characteristic_hash_code_args, event_args);
			});
		characteristic_write_requested_revokers[characteristic_hash_code_args] = characteristic.WriteRequested(
			winrt::auto_revoke,
			[this, characteristic_hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic& characteristic, winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs& event_args)
			{
				FireAndForgetCharacteristicWriteRequested(characteristic_hash_code_args, event_args);
			});
		characteristic_subscribed_clients_changed_revokers[characteristic_hash_code_args] = characteristic.SubscribedClientsChanged(
			winrt::auto_revoke,
			[this, characteristic_hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic& characteristic, auto obj)
			{
				const auto& api = this->api.value();
				auto centrals_args = flutter::EncodableList();
				const auto& clients = characteristic.SubscribedClients();
				std::transform(
					clients.begin(),
					clients.end(),
					std::back_inserter(centrals_args),
					[](const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSubscribedClient& client)
					{
						return SubscribedClientToArgs(client);
					});
				api.OnCharacteristicSubscribedClientsChanged(characteristic_hash_code_args, centrals_args, []() {}, [](const auto& error) {});
			});
		const auto& descriptor_values = characteristic_args.descriptors_args();
		for (const auto& descriptor_value : descriptor_values) {
			const auto& custom_descriptor_value = std::get<flutter::CustomEncodableValue>(descriptor_value);
			const auto& descriptor_args = std::any_cast<MyMutableGATTDescriptorArgs>(custom_descriptor_value);
			co_await CreateDescriptorAsync(characteristic, descriptor_args);
		}
	}

	winrt::Windows::Foundation::IAsyncAction MyPeripheralManager::CreateDescriptorAsync(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic& characteristic, const MyMutableGATTDescriptorArgs& descriptor_args)
	{
		const auto& uuid_args = descriptor_args.uuid_args();
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
		const auto& permission_number_values = descriptor_args.permission_numbers_args();
		const auto& begin = permission_number_values.begin();
		const auto& end = permission_number_values.end();
		std::sort(begin, end);
		for (const auto& permission_number_value : permission_number_values)
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
		const auto& r = co_await characteristic.CreateDescriptorAsync(uuid, parameters);
		const auto error = r.Error();
		if (error != winrt::Windows::Devices::Bluetooth::BluetoothError::Success)
		{
			const auto error_code = static_cast<int32_t>(error);
			const auto message = "Create descriptor failed with error: " + std::to_string(error_code);
			throw MyException(message);
		}
		const auto descriptor = r.Descriptor();
		const auto descriptor_hash_code_args = descriptor_args.hash_code_args();
		descriptor_read_requested_revokers[descriptor_hash_code_args] = descriptor.ReadRequested(
			winrt::auto_revoke,
			[this, descriptor_hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalDescriptor& descriptor, winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs& event_args)
			{
				FireAndForgetDescriptorReadRequested(descriptor_hash_code_args, event_args);
			});
		descriptor_write_requested_revokers[descriptor_hash_code_args] = descriptor.WriteRequested(
			winrt::auto_revoke,
			[this, descriptor_hash_code_args](winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalDescriptor& descriptor, winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs& event_args)
			{
				FireAndForgetDescriptorWriteRequested(descriptor_hash_code_args, event_args);
			});
	}

	winrt::fire_and_forget MyPeripheralManager::FireAndForgetCharacteristicReadRequested(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs& event_args)
	{
		const auto& deferral = event_args.GetDeferral();
		const auto& request = co_await event_args.GetRequestAsync();
		const auto request_address = std::addressof(request);
		const auto request_address_args = reinterpret_cast<int64_t>(request_address);
	}

	winrt::fire_and_forget MyPeripheralManager::FireAndForgetCharacteristicWriteRequested(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs& event_args)
	{
		return winrt::fire_and_forget();
	}

	winrt::fire_and_forget MyPeripheralManager::FireAndForgetDescriptorReadRequested(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs& event_args)
	{
		return winrt::fire_and_forget();
	}

	winrt::fire_and_forget MyPeripheralManager::FireAndForgetDescriptorWriteRequested(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs& event_args)
	{
		return winrt::fire_and_forget();
	}

} // namespace bluetooth_low_energy_windows
