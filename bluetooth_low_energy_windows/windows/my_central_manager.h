#ifndef BLEW_MY_CENTRAL_MANAGER_H_
#define BLEW_MY_CENTRAL_MANAGER_H_

#include "winrt/Windows.Devices.Bluetooth.h"
#include "winrt/Windows.Devices.Bluetooth.Advertisement.h"
#include "winrt/Windows.Devices.Bluetooth.GenericAttributeProfile.h"
#include "winrt/Windows.Devices.Radios.h"
#include "winrt/Windows.Foundation.Collections.h"

#include "my_api.g.h"

using namespace winrt;
using namespace winrt::Windows::Devices::Bluetooth;
using namespace winrt::Windows::Devices::Bluetooth::Advertisement;
using namespace winrt::Windows::Devices::Bluetooth::GenericAttributeProfile;
using namespace winrt::Windows::Devices::Radios;
using namespace winrt::Windows::Foundation::Collections;

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
		void SetUp(std::function<void(ErrorOr<MyCentralManagerArgs> reply)> result) override;
		std::optional<FlutterError> StartDiscovery() override;
		std::optional<FlutterError> StopDiscovery() override;
		void Connect(int64_t address_args, std::function<void(std::optional<FlutterError>reply)> result) override;
		std::optional<FlutterError> Disconnect(int64_t address_args) override;
		std::optional<FlutterError> ClearGATT(int64_t address_args) override;
		void DiscoverServices(int64_t address_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;
		void DiscoverCharacteristics(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;
		void DiscoverDescriptors(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;
		void ReadCharacteristic(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result) override;
		void WriteCharacteristic(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError>reply)> result) override;
		void NotifyCharacteristic(int64_t address_args, int64_t handle_args, int64_t state_number_args, std::function<void(std::optional<FlutterError>reply)> result) override;
		void ReadDescriptor(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result) override;
		void WriteDescriptor(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError>reply)> result) override;
	private:
		std::optional<MyCentralManagerFlutterApi> m_api;
		std::optional<BluetoothLEAdvertisementWatcher> m_watcher;
		std::optional<BluetoothAdapter> m_adapter;
		std::optional<Radio> m_radio;
		std::map<uint64_t, std::optional<BluetoothLEDevice>> m_devices;
		std::map<uint64_t, std::list<std::optional<GattDeviceService>>> m_services;
		std::map<uint64_t, std::list<std::optional<GattCharacteristic>>> m_characteristics;
		std::map<uint64_t, std::list<std::optional<GattDescriptor>>> m_descriptors;
		std::optional<BluetoothLEAdvertisementWatcher::Received_revoker> m_watcher_received_revoker;
		std::optional<Radio::StateChanged_revoker> m_radio_state_changed_revoker;
		std::map<uint64_t, std::optional<BluetoothLEDevice::ConnectionStatusChanged_revoker>> m_device_connection_status_changed_revokers;
		std::map<uint64_t, std::list<std::optional<GattCharacteristic::ValueChanged_revoker>>> m_characteristic_value_changed_revokers;

		fire_and_forget m_set_up(std::function<void(ErrorOr<MyCentralManagerArgs> reply)> result);
		fire_and_forget m_connect(int64_t address_args, std::function<void(std::optional<FlutterError>reply)> result);
		fire_and_forget m_discover_services(int64_t address_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		fire_and_forget m_discover_characteristics(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		fire_and_forget m_discover_descriptors(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		fire_and_forget m_read_characteristic(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		fire_and_forget m_write_characteristic(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError> reply)> result);
		fire_and_forget m_notify_characteristic(int64_t address_args, int64_t handle_args, int64_t state_number_args, std::function<void(std::optional<FlutterError> reply)> result);
		fire_and_forget m_read_descriptor(int64_t address_args, int64_t handle_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		fire_and_forget m_write_descriptor(int64_t address_args, int64_t handle_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result);

		void m_clear_device(uint64_t address);
		void m_clear_gatt(uint64_t address);
		void m_on_device_connection_status_changed(uint64_t address, BluetoothConnectionStatus status);
		MyBluetoothLowEnergyStateArgs m_radio_state_to_args(RadioState state);
		MyAdvertisementArgs m_advertisement_to_args(const BluetoothLEAdvertisement& advertisement);
		MyPeripheralArgs m_address_to_peripheral_args(uint64_t address);
		MyGattServiceArgs m_service_to_args(const GattDeviceService& service);
		MyGattCharacteristicArgs m_characteristic_to_args(const GattCharacteristic& characteristic);
		flutter::EncodableList m_characteristic_properties_to_args(GattCharacteristicProperties properties);
		MyGattDescriptorArgs m_descriptor_to_args(const GattDescriptor& descriptor);
		std::string m_uuid_to_args(const guid& uuid);
		GattWriteOption m_write_type_number_args_to_write_option(int64_t type_number_args);
		GattClientCharacteristicConfigurationDescriptorValue m_notify_state_number_args_to_cccd_value(int64_t state_number_args);
		std::optional<BluetoothLEDevice> m_retrieve_device(uint64_t address);
		std::optional<GattDeviceService> m_retrieve_service(uint64_t address, uint16_t handle);
		std::optional<GattCharacteristic> m_retrieve_characteristic(uint64_t address, uint16_t handle);
		std::optional<GattDescriptor> m_retrieve_descriptor(uint64_t address, uint16_t handle);
	};

}

#endif // !PIGEON_MY_CENTRAL_MANAGER_API_H_
