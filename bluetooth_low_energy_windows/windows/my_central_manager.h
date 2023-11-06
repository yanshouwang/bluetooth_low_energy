#ifndef BLEW_MY_CENTRAL_MANAGER_H_
#define BLEW_MY_CENTRAL_MANAGER_H_

#include "winrt/Windows.Devices.Bluetooth.h"
#include "winrt/Windows.Devices.Bluetooth.Advertisement.h"
#include "winrt/Windows.Devices.Bluetooth.GenericAttributeProfile.h"
#include "winrt/Windows.Devices.Radios.h"

#include "my_api.g.h"

using namespace winrt;
using namespace winrt::Windows::Devices::Bluetooth;
using namespace winrt::Windows::Devices::Bluetooth::Advertisement;
using namespace winrt::Windows::Devices::Bluetooth::GenericAttributeProfile;
using namespace winrt::Windows::Devices::Radios;

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

		void Connect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError> reply)> result) override;

		void Disconnect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError> reply)> result) override;

		ErrorOr<int64_t> GetMaximumWriteLength(int64_t peripheral_hash_code_args, int64_t type_number_args) override;

		void ReadRSSI(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<int64_t> reply)> result) override;

		void DiscoverGATT(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result) override;

		void ReadCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result) override;

		void WriteCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError> reply)> result) override;

		void NotifyCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, bool state_args, std::function<void(std::optional<FlutterError> reply)> result) override;

		void ReadDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result) override;

		void WriteDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result) override;
	private:
		std::optional<MyCentralManagerFlutterApi> m_api = nullptr;
		std::optional<BluetoothLEAdvertisementWatcher> m_watcher = nullptr;
		std::optional<BluetoothAdapter> m_adapter = nullptr;
		std::optional<Radio> m_radio = nullptr;
		std::map<int64_t, std::optional<BluetoothLEDevice>> m_devices;
		std::map<int64_t, std::optional<GattSession>> m_gatt_sessions;
		std::map<int64_t, std::optional<GattDeviceService>> m_services;
		std::map<int64_t, std::optional<GattCharacteristic>> m_characteristics;
		std::map<int64_t, std::optional<GattDescriptor>> m_descriptors;
		std::optional<event_token> m_watcher_received_token;
		std::optional<event_token> m_radio_state_changed_token;
		std::map<int64_t, std::optional<event_token>> m_device_connection_status_changed_tokens;

		fire_and_forget m_set_up(std::function<void(ErrorOr<MyCentralManagerArgs> reply)> result);
		fire_and_forget m_connect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError> reply)> result);
		fire_and_forget m_disconnect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError> reply)> result);
		fire_and_forget m_read_rssi(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<int64_t> reply)> result);
		fire_and_forget m_discover_gatt(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		fire_and_forget m_read_characteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		fire_and_forget m_write_characteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError> reply)> result);
		fire_and_forget m_notify_characteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, bool state_args, std::function<void(std::optional<FlutterError> reply)> result);
		fire_and_forget m_read_descriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		fire_and_forget m_write_descriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result);

		MyBluetoothLowEnergyStateArgs m_format_radio_state(RadioState state);
		std::string m_format_address(uint64_t address);
		MyAdvertisementArgs m_format_advertisement(BluetoothLEAdvertisement advertisement);
	};

}

#endif // !PIGEON_MY_CENTRAL_MANAGER_API_H_
