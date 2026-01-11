#ifndef FLUTTER_PLUGIN_PERIPHERAL_MANAGER_H_
#define FLUTTER_PLUGIN_PERIPHERAL_MANAGER_H_

#include "winrt/Windows.Devices.Bluetooth.h"
#include "winrt/Windows.Devices.Bluetooth.Advertisement.h"
#include "winrt/Windows.Devices.Bluetooth.GenericAttributeProfile.h"
#include "winrt/Windows.Devices.Radios.h"
#include "winrt/Windows.Foundation.h"
#include "winrt/Windows.Foundation.Collections.h"
#include "winrt/Windows.Storage.Streams.h"

#include "bluetooth_low_energy_api.g.h"
#include "bluetooth_low_energy_exception.h"

namespace bluetooth_low_energy_windows
{
	class PeripheralManagerImpl : public PeripheralManagerHostApi
	{
	public:
		PeripheralManagerImpl(flutter::BinaryMessenger *messenger);
		virtual ~PeripheralManagerImpl();

		// Disallow copy and assign.
		PeripheralManagerImpl(const PeripheralManagerImpl &) = delete;
		PeripheralManagerImpl &operator=(const PeripheralManagerImpl &) = delete;

		void Initialize(std::function<void(std::optional<FlutterError> reply)> result) override;
		ErrorOr<BluetoothLowEnergyStateArgs> GetState() override;
		void AddService(const MutableGATTServiceArgs &service_args, std::function<void(std::optional<FlutterError> reply)> result) override;
		std::optional<FlutterError> RemoveService(int64_t hash_code_args) override;
		std::optional<FlutterError> StartAdvertising(const AdvertisementArgs &advertisement_args) override;
		std::optional<FlutterError> StopAdvertising() override;
		ErrorOr<int64_t> GetMaxNotificationSize(int64_t address_args) override;
		std::optional<FlutterError> RespondReadRequestWithValue(int64_t id_args, const std::vector<uint8_t> &value_args) override;
		std::optional<FlutterError> RespondReadRequestWithProtocolError(int64_t id_args, const GATTProtocolErrorArgs &error_args) override;
		std::optional<FlutterError> RespondWriteRequest(int64_t id_args) override;
		std::optional<FlutterError> RespondWriteRequestWithProtocolError(int64_t id_args, const GATTProtocolErrorArgs &error_args) override;
		void NotifyValue(int64_t address_args, int64_t hash_code_args, const std::vector<uint8_t> &value_args, std::function<void(std::optional<FlutterError> reply)> result) override;

	private:
		std::optional<PeripheralManagerFlutterApi> m_api;
		std::optional<winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementPublisher> m_publisher;
		std::optional<winrt::Windows::Devices::Bluetooth::BluetoothAdapter> m_adapter;
		std::optional<winrt::Windows::Devices::Radios::Radio> m_radio;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSubscribedClient>> m_clients;
		std::map<int64_t, std::optional<MutableGATTServiceArgs>> m_services_args;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattServiceProvider>> m_service_providers;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic>> m_characteristics;
		std::map<int64_t, std::optional<winrt::Windows::Foundation::Deferral>> m_deferrals;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequest>> m_read_requests;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequest>> m_write_requests;

		std::optional<winrt::Windows::Devices::Radios::Radio::StateChanged_revoker> m_radio_state_changed_revoker;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSession::MaxPduSizeChanged_revoker>> m_session_max_pdu_size_changed_revokers;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic::ReadRequested_revoker>> m_characteristic_read_requested_revokers;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic::WriteRequested_revoker>> m_characteristic_write_requested_revokers;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic::SubscribedClientsChanged_revoker>> m_characteristic_subscribed_clients_changed_revokers;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalDescriptor::ReadRequested_revoker>> m_descriptor_read_requested_revokers;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalDescriptor::WriteRequested_revoker>> m_descriptor_write_requested_revokers;

		winrt::fire_and_forget InitializeAsync(std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget AddServiceAsync(const MutableGATTServiceArgs &service_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget NotifyValueAsync(int64_t address_args, int64_t hash_code_args, const std::vector<uint8_t> &value_args, std::function<void(std::optional<FlutterError> reply)> result);

		winrt::Windows::Foundation::IAsyncAction CreateServiceAsync(const MutableGATTServiceArgs service_args);
		winrt::Windows::Foundation::IAsyncAction CreateCharacteristicAsync(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalService &service, const MutableGATTCharacteristicArgs characteristic_args);
		winrt::Windows::Foundation::IAsyncAction CreateDescriptorAsync(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic &characteristic, const MutableGATTDescriptorArgs descriptor_args);

		void RemoveServiceArgs(const MutableGATTServiceArgs &service_args);
		void RemoveCharacteristicArgs(const MutableGATTCharacteristicArgs &characteristic_args);
		void RemoveDescriptorArgs(const MutableGATTDescriptorArgs &descriptor_args);

		winrt::fire_and_forget OnCharacteristicReadRequestedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs event_args);
		winrt::fire_and_forget OnCharacteristicWriteRequestedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs event_args);
		winrt::fire_and_forget OnCharacteristicSubscribedClientsChangedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic &characteristic);
		winrt::fire_and_forget OnDescriptorReadRequestedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs event_args);
		winrt::fire_and_forget OnDescriptorWriteRequestedAsync(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs event_args);

		BluetoothLowEnergyStateArgs RadioStateToArgs(const winrt::Windows::Devices::Radios::RadioState &state);
		GATTCharacteristicWriteTypeArgs WriteOptionToArgs(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption &option);

		winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEManufacturerData ArgsToManufacturerData(const ManufacturerSpecificDataArgs &manufacturer_specific_data_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties ArgsToCharacteristicProperties(const flutter::EncodableList property_numbers_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattProtectionLevel ArgsToProtectionLevel(const GATTProtectionLevelArgs &level_args);
		uint8_t ArgsToProtocolError(const GATTProtocolErrorArgs &error_args);
	};

} // namespace bluetooth_low_energy_windows

#endif // FLUTTER_PLUGIN_PERIPHERAL_MANAGER_H_
