#ifndef BLEW_MY_CENTRAL_MANAGER_H_
#define BLEW_MY_CENTRAL_MANAGER_H_

#include "my_api.g.h"
#include "my_exception.h"
#include "my_format.h"

#include "winrt/Windows.Devices.Bluetooth.h"
#include "winrt/Windows.Devices.Bluetooth.Advertisement.h"
#include "winrt/Windows.Devices.Bluetooth.GenericAttributeProfile.h"
#include "winrt/Windows.Devices.Radios.h"
#include "winrt/Windows.Foundation.Collections.h"
#include "winrt/Windows.Security.Cryptography.h"
#include "winrt/Windows.Storage.Streams.h"

#include <iomanip>
#include <sstream>

namespace bluetooth_low_energy_windows
{
	class MyCentralManager : public MyCentralManagerHostAPI
	{
	public:
		MyCentralManager(flutter::BinaryMessenger* messenger);
		virtual ~MyCentralManager();

		// Disallow copy and assign.
		MyCentralManager(const MyCentralManager&) = delete;
		MyCentralManager& operator=(const MyCentralManager&) = delete;

		// 通过 MyCentralManagerHostApi 继承
		void Initialize(std::function<void(std::optional<FlutterError> reply)> result) override;
		ErrorOr<MyBluetoothLowEnergyStateArgs> GetState() override;
		std::optional<FlutterError> StartDiscovery(const flutter::EncodableList& service_uuids_args) override;
		std::optional<FlutterError> StopDiscovery() override;
		void Connect(int64_t address_args, std::function<void(std::optional<FlutterError> reply)> result) override;
		std::optional<FlutterError> Disconnect(int64_t address_args) override;
		ErrorOr<int64_t> GetMTU(int64_t address_args) override;
		void GetServicesAsync(int64_t address_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result) override;
		void GetIncludedServicesAsync(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result) override;
		void GetCharacteristicsAsync(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result) override;
		void GetDescriptorsAsync(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result) override;
		void ReadCharacteristic(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result) override;
		void WriteCharacteristic(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, const MyGATTCharacteristicWriteTypeArgs& type_args, std::function<void(std::optional<FlutterError> reply)> result) override;
		void SetCharacteristicNotifyState(int64_t address_args, int64_t handle_args, const MyGATTCharacteristicNotifyStateArgs& state_args, std::function<void(std::optional<FlutterError> reply)> result) override;
		void ReadDescriptor(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result) override;
		void WriteDescriptor(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result) override;
	private:
		std::optional<MyCentralManagerFlutterAPI> m_api;
		std::optional<winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementWatcher> m_watcher;
		std::optional<winrt::Windows::Devices::Bluetooth::BluetoothAdapter> m_adapter;
		std::optional<winrt::Windows::Devices::Radios::Radio> m_radio;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::BluetoothLEDevice>> m_devices;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSession>> m_sessions;
		std::map<int64_t, std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService>>> m_services;
		std::map<int64_t, std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic>>> m_characteristics;
		std::map<int64_t, std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor>>> m_descriptors;
		std::optional<winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementWatcher::Received_revoker> m_watcher_received_revoker;
		std::optional<winrt::Windows::Devices::Radios::Radio::StateChanged_revoker> m_radio_state_changed_revoker;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::BluetoothLEDevice::ConnectionStatusChanged_revoker>> m_device_connection_status_changed_revokers;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSession::MaxPduSizeChanged_revoker>> m_session_max_pdu_size_changed_revokers;
		std::map<int64_t, std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic::ValueChanged_revoker>>> m_characteristic_value_changed_revokers;

		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService& m_retrieve_service(int64_t address_args, int64_t handle_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic& m_retrieve_characteristic(int64_t address, int64_t handle_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor& m_retrieve_descriptor(int64_t address_args, int64_t handle_args);

		winrt::fire_and_forget m_initialize(std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget m_connect(int64_t address_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget m_get_services_async(int64_t address_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget m_get_included_services_async(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget m_get_characteristics_async(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget m_get_descriptors_async(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget m_read_characteristic(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		winrt::fire_and_forget m_write_characteristic(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, const MyGATTCharacteristicWriteTypeArgs& type_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget m_set_characteristic_notify_state(int64_t address_args, int64_t handle_args, const MyGATTCharacteristicNotifyStateArgs& state_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget m_read_descriptor(int64_t address_args, int64_t handle_args, const MyCacheModeArgs& mode_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		winrt::fire_and_forget m_write_descriptor(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result);

		void m_disconnect(int64_t address_args);
		MyBluetoothLowEnergyStateArgs m_radio_state_to_args(const winrt::Windows::Devices::Radios::RadioState& state);
		MyConnectionStateArgs m_connection_status_to_args(const winrt::Windows::Devices::Bluetooth::BluetoothConnectionStatus& status);
		MyAdvertisementArgs m_advertisement_to_args(const winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisement& advertisement);
		MyGATTServiceArgs m_service_to_args(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService& service);
		MyGATTCharacteristicArgs m_characteristic_to_args(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic& characteristic);
		flutter::EncodableList m_characteristic_properties_to_args(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties properties);
		MyGATTDescriptorArgs m_descriptor_to_args(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor& descriptor);
		std::string m_uuid_to_args(const winrt::guid& uuid);
		winrt::Windows::Devices::Bluetooth::BluetoothCacheMode m_cache_mode_args_to_cache_mode(const MyCacheModeArgs& mode_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption m_write_type_args_to_write_option(const MyGATTCharacteristicWriteTypeArgs& type_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattClientCharacteristicConfigurationDescriptorValue m_notify_state_args_to_descriptor_value(const MyGATTCharacteristicNotifyStateArgs& state_args);
	};
}
#endif // !PIGEON_MY_CENTRAL_MANAGER_API_H_
