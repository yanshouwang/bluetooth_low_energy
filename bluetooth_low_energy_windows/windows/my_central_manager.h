#ifndef BLEW_MY_CENTRAL_MANAGER_H_
#define BLEW_MY_CENTRAL_MANAGER_H_

#include <iomanip>
#include <sstream>

#include "winrt/Windows.Devices.Bluetooth.h"
#include "winrt/Windows.Devices.Bluetooth.Advertisement.h"
#include "winrt/Windows.Devices.Bluetooth.GenericAttributeProfile.h"
#include "winrt/Windows.Devices.Radios.h"
#include "winrt/Windows.Foundation.h"
#include "winrt/Windows.Foundation.Collections.h"
#include "winrt/Windows.Storage.Streams.h"

#include "my_api.g.h"
#include "my_exception.h"
#include "my_format.h"

namespace bluetooth_low_energy_windows
{
	class MyCentralManager : public MyCentralManagerHostAPI
	{
	public:
		MyCentralManager(flutter::BinaryMessenger *messenger);
		virtual ~MyCentralManager();

		// Disallow copy and assign.
		MyCentralManager(const MyCentralManager &) = delete;
		MyCentralManager &operator=(const MyCentralManager &) = delete;

		void Initialize(std::function<void(std::optional<FlutterError> reply)> result) override;
		ErrorOr<MyBluetoothLowEnergyStateArgs> GetState() override;
		std::optional<FlutterError> StartDiscovery(const flutter::EncodableList &service_uuids_args) override;
		std::optional<FlutterError> StopDiscovery() override;
		void Connect(int64_t address_args, std::function<void(std::optional<FlutterError> reply)> result) override;
		std::optional<FlutterError> Disconnect(int64_t address_args) override;
		ErrorOr<int64_t> GetMTU(int64_t address_args) override;
		void GetServices(int64_t address_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result) override;
		void GetIncludedServices(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result) override;
		void GetCharacteristics(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result) override;
		void GetDescriptors(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result) override;
		void ReadCharacteristic(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result) override;
		void WriteCharacteristic(int64_t address_args, int64_t handle_args, const std::vector<uint8_t> &value_args, const MyGATTCharacteristicWriteTypeArgs &type_args, std::function<void(std::optional<FlutterError> reply)> result) override;
		void SetCharacteristicNotifyState(int64_t address_args, int64_t handle_args, const MyGATTCharacteristicNotifyStateArgs &state_args, std::function<void(std::optional<FlutterError> reply)> result) override;
		void ReadDescriptor(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result) override;
		void WriteDescriptor(int64_t address_args, int64_t handle_args, const std::vector<uint8_t> &value_args, std::function<void(std::optional<FlutterError> reply)> result) override;

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

		winrt::fire_and_forget InitializeAsync(std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget ConnectAsync(int64_t address_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget GetServicesAsync(int64_t address_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget GetIncludedServicesAsync(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget GetCharacteristicsAsync(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget GetDescriptorsAsync(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result);
		winrt::fire_and_forget ReadCharacteristicAsync(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		winrt::fire_and_forget WriteCharacteristicAsync(int64_t address_args, int64_t handle_args, const std::vector<uint8_t> &value_args, const MyGATTCharacteristicWriteTypeArgs &type_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget SetCharacteristicNotifyStateAsync(int64_t address_args, int64_t handle_args, const MyGATTCharacteristicNotifyStateArgs &state_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget ReadDescriptorAsync(int64_t address_args, int64_t handle_args, const MyCacheModeArgs &mode_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result);
		winrt::fire_and_forget WriteDescriptorAsync(int64_t address_args, int64_t handle_args, const std::vector<uint8_t> &value_args, std::function<void(std::optional<FlutterError> reply)> result);

		void OnDisconnected(int64_t address_args);

		winrt::Windows::Devices::Bluetooth::BluetoothLEDevice &RetrieveDevice(int64_t address_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService &RetrieveService(int64_t address_args, int64_t handle_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic &RetrieveCharacteristic(int64_t address, int64_t handle_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor &RetrieveDescriptor(int64_t address_args, int64_t handle_args);

		MyBluetoothLowEnergyStateArgs RadioStateToArgs(const winrt::Windows::Devices::Radios::RadioState &state);
		MyAdvertisementTypeArgs AdvertisementTypeToArgs(const winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementType &type);
		MyConnectionStateArgs ConnectionStatusToArgs(const winrt::Windows::Devices::Bluetooth::BluetoothConnectionStatus &status);
		MyManufacturerSpecificDataArgs ManufacturerDataToArgs(const winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEManufacturerData &manufacturer_data);
		MyAdvertisementArgs AdvertisementToArgs(const winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisement &advertisement);
		MyGATTServiceArgs ServiceToArgs(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDeviceService &service);
		MyGATTCharacteristicArgs CharacteristicToArgs(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristic &characteristic);
		flutter::EncodableList CharacteristicPropertiesToArgs(winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties properties);
		MyGATTDescriptorArgs DescriptorToArgs(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattDescriptor &descriptor);
		std::string GUIDToArgs(const winrt::guid &guid);

		winrt::Windows::Devices::Bluetooth::BluetoothCacheMode ArgsToCacheMode(const MyCacheModeArgs &mode_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteOption ArgsToWriteOption(const MyGATTCharacteristicWriteTypeArgs &type_args);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattClientCharacteristicConfigurationDescriptorValue ArgsToCCCDescriptorValue(const MyGATTCharacteristicNotifyStateArgs &state_args);
	};
}

#endif // !PIGEON_MY_CENTRAL_MANAGER_API_H_
