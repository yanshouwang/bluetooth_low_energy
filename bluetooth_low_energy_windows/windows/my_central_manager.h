#ifndef BLEW_MY_CENTRAL_MANAGER_H_
#define BLEW_MY_CENTRAL_MANAGER_H_

#include "winrt/Windows.Devices.Bluetooth.h"
#include "winrt/Windows.Devices.Bluetooth.Advertisement.h"
#include "winrt/Windows.Devices.Bluetooth.GenericAttributeProfile.h"
#include "winrt/Windows.Devices.Radios.h"

#include "my_api.g.h"

namespace bluetooth_low_energy_windows
{
	class MyCentralManager : public MyCentralManagerHostApi
	{
	public:
		MyCentralManager(flutter::BinaryMessenger* messenger);
		virtual ~MyCentralManager();

		// Disallow copy and assign.
		MyCentralManager(const MyCentralManager&) = delete;
		MyCentralManager& operator=(const MyCentralManager&) = delete;

		// 通过 MyCentralManagerHostApi 继承
		void SetUp(std::function<void(std::optional<FlutterError>reply)> result) override;
		std::optional<FlutterError> StartDiscovery() override;
		std::optional<FlutterError> StopDiscovery() override;
		void Connect(int64_t address_args, std::function<void(std::optional<FlutterError>reply)> result) override;
		std::optional<FlutterError> Disconnect(int64_t address_args) override;
		void DiscoverServices(int64_t address_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;
		void DiscoverCharacteristics(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;
		void DiscoverDescriptors(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;
		void ReadCharacteristic(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result) override;
		void WriteCharacteristic(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError>reply)> result) override;
		void SetCharacteristicNotifyState(int64_t address_args, int64_t handle_args, int64_t state_number_args, std::function<void(std::optional<FlutterError>reply)> result) override;
		void ReadDescriptor(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result) override;
		void WriteDescriptor(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError>reply)> result) override;
	private:
		std::optional<MyCentralManagerFlutterApi> m_api;
		std::optional<winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementWatcher> m_watcher;
		std::optional<winrt::Windows::Devices::Bluetooth::BluetoothAdapter> m_adapter;
		std::optional<winrt::Windows::Devices::Radios::Radio> m_radio;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::BluetoothLEDevice>> m_devices;
		std::map<int64_t, std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService>>> m_services;
		std::map<int64_t, std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic>>> m_characteristics;
		std::map<int64_t, std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor>>> m_descriptors;
		std::optional<winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementWatcher::Received_revoker> m_watcher_received_revoker;
		std::optional<winrt::Windows::Devices::Radios::Radio::StateChanged_revoker> m_radio_state_changed_revoker;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::BluetoothLEDevice::ConnectionStatusChanged_revoker>> m_device_connection_status_changed_revokers;
		std::map<int64_t, std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic::ValueChanged_revoker>>> m_characteristic_value_changed_revokers;

		winrt::fire_and_forget m_set_up(std::function<void(std::optional<FlutterError>reply)> result);
		winrt::fire_and_forget m_connect(int64_t address_args, std::function<void(std::optional<FlutterError>reply)> result);
		winrt::fire_and_forget m_discover_services(int64_t address_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget m_discover_characteristics(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget m_discover_descriptors(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget m_read_characteristic(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		winrt::fire_and_forget m_write_characteristic(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget m_set_characteristic_notify_state(int64_t address_args, int64_t handle_args, int64_t state_number_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget m_read_descriptor(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		winrt::fire_and_forget m_write_descriptor(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result);

		void m_clear_state();
		void m_clear_device(int64_t address_args);
		void m_on_state_changed();
		MyBluetoothLowEnergyStateArgs m_radio_state_to_args(winrt::Windows::Devices::Radios::RadioState state);
		MyAdvertisementArgs m_advertisement_to_args(const winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisement& advertisement);
		MyPeripheralArgs m_address_to_peripheral_args(uint64_t address);
		MyGattServiceArgs m_service_to_args(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService& service);
		MyGattCharacteristicArgs m_characteristic_to_args(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic& characteristic);
		flutter::EncodableList m_characteristic_properties_to_args(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties properties);
		MyGattDescriptorArgs m_descriptor_to_args(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor& descriptor);
		std::string m_uuid_to_args(const winrt::guid& uuid);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption m_write_type_number_args_to_write_option(int64_t type_number_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattClientCharacteristicConfigurationDescriptorValue m_notify_state_number_args_to_cccd_value(int64_t state_number_args);
		std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService> m_retrieve_service(int64_t address_args, int64_t handle_args);
		std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic> m_retrieve_characteristic(int64_t address, int64_t handle_args);
		std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor> m_retrieve_descriptor(int64_t address_args, int64_t handle_args);
	};

}

#endif // !PIGEON_MY_CENTRAL_MANAGER_API_H_
