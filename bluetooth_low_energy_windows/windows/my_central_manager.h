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
		void Connect(const MyPeripheralArgs& peripheral_args, std::function<void(std::optional<FlutterError>reply)> result) override;
		std::optional<FlutterError> Disconnect(const MyPeripheralArgs& peripheral_args) override;
		ErrorOr<int64_t> GetMaximumWriteLength(const MyPeripheralArgs& peripheral_args, int64_t type_number_args) override;
		void ReadRSSI(const MyPeripheralArgs& peripheral_args, std::function<void(ErrorOr<int64_t>reply)> result) override;
		void DiscoverServices(const MyPeripheralArgs& peripheral_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;
		void DiscoverCharacteristics(const MyPeripheralArgs& peripheral_args, const MyGattServiceArgs& service_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;
		void DiscoverDescriptors(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;
		void ReadCharacteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result) override;
		void WriteCharacteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError>reply)> result) override;
		void NotifyCharacteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, bool state_args, std::function<void(std::optional<FlutterError>reply)> result) override;
		void ReadDescriptor(const MyPeripheralArgs& peripheral_args, const MyGattDescriptorArgs& descriptor_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result) override;
		void WriteDescriptor(const MyPeripheralArgs& peripheral_args, const MyGattDescriptorArgs& descriptor_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError>reply)> result) override;
	private:
		std::optional<MyCentralManagerFlutterApi> m_api;
		std::optional<BluetoothLEAdvertisementWatcher> m_watcher;
		std::optional<BluetoothAdapter> m_adapter;
		std::optional<Radio> m_radio;
		std::map<uint64_t, std::optional<BluetoothLEDevice>> m_devices;
		std::map<uint64_t, std::optional<GattSession>> m_gatt_sessions;
		std::map<uint64_t, std::optional<IVectorView<GattDeviceService>>> m_services;
		std::map<uint64_t, std::optional<IVectorView<GattCharacteristic>>> m_characteristics;
		std::map<uint64_t, std::optional<IVectorView<GattDescriptor>>> m_descriptors;
		std::optional<event_token> m_watcher_received_token;
		std::optional<event_token> m_radio_state_changed_token;
		std::map<uint64_t, std::optional<event_token>> m_device_connection_status_changed_tokens;

		fire_and_forget m_set_up(std::function<void(ErrorOr<MyCentralManagerArgs> reply)> result);
		fire_and_forget m_connect(const MyPeripheralArgs& peripheral_args, std::function<void(std::optional<FlutterError>reply)> result);
		fire_and_forget m_read_rssi(const MyPeripheralArgs& peripheral_args, std::function<void(ErrorOr<int64_t> reply)> result);
		fire_and_forget m_discover_services(const MyPeripheralArgs& peripheral_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		fire_and_forget m_discover_characteristics(const MyPeripheralArgs& peripheral_args, const MyGattServiceArgs& service_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		fire_and_forget m_discover_descriptors(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		fire_and_forget m_read_characteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		fire_and_forget m_write_characteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError> reply)> result);
		fire_and_forget m_notify_characteristic(const MyPeripheralArgs& peripheral_args, const MyGattCharacteristicArgs& characteristic_args, bool state_args, std::function<void(std::optional<FlutterError> reply)> result);
		fire_and_forget m_read_descriptor(const MyPeripheralArgs& peripheral_args, const MyGattDescriptorArgs& descriptor_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		fire_and_forget m_write_descriptor(const MyPeripheralArgs& peripheral_args, const MyGattDescriptorArgs& descriptor_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result);

		void m_on_device_connection_status_changed(uint64_t address, BluetoothConnectionStatus status);
		MyBluetoothLowEnergyStateArgs m_radio_state_to_args(RadioState state);
		MyAdvertisementArgs m_advertisement_to_args(const BluetoothLEAdvertisement& advertisement);
		MyPeripheralArgs m_address_to_peripheral_args(uint64_t address);
		MyPeripheralArgs m_device_to_args(const BluetoothLEDevice& device);
		MyGattServiceArgs m_service_to_args(const GattDeviceService& service);
		MyGattCharacteristicArgs m_characteristic_to_args(const GattCharacteristic& characteristic);
		flutter::EncodableList m_characteristic_properties_to_args(GattCharacteristicProperties properties);
		MyGattDescriptorArgs m_descriptor_to_args(const GattDescriptor& descriptor);
		std::string m_uuid_to_args(const guid& uuid);
		GattDeviceService m_find_service(uint64_t address, uint64_t handle);
		GattCharacteristic m_find_characteristic(uint64_t address, uint64_t handle);
		GattDescriptor m_find_descriptor(uint64_t address, uint64_t handle);
	};

}

#endif // !PIGEON_MY_CENTRAL_MANAGER_API_H_
