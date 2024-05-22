#ifndef BLEW_MY_PERIPHERAL_MANAGER_H_
#define BLEW_MY_PERIPHERAL_MANAGER_H_

#include "winrt/Windows.Devices.Bluetooth.h"
#include "winrt/Windows.Devices.Bluetooth.Advertisement.h"
#include "winrt/Windows.Devices.Bluetooth.GenericAttributeProfile.h"
#include "winrt/Windows.Devices.Radios.h"
#include "winrt/Windows.Foundation.h"
#include "winrt/Windows.Foundation.Collections.h"
#include "winrt/Windows.Storage.Streams.h"

#include "my_api.g.h"
#include "my_exception.h"

namespace bluetooth_low_energy_windows
{
	class MyPeripheralManager : public MyPeripheralManagerHostAPI
	{
	public:
		MyPeripheralManager(flutter::BinaryMessenger* messenger);
		virtual ~MyPeripheralManager();

		// Disallow copy and assign.
		MyPeripheralManager(const MyPeripheralManager&) = delete;
		MyPeripheralManager& operator=(const MyPeripheralManager&) = delete;

		void Initialize(std::function<void(std::optional<FlutterError> reply)> result) override;
		ErrorOr<MyBluetoothLowEnergyStateArgs> GetState() override;
		void AddService(const MyMutableGATTServiceArgs& service_args, std::function<void(std::optional<FlutterError> reply)> result) override;
		std::optional<FlutterError> RemoveService(int64_t hash_code_args) override;
		std::optional<FlutterError> StartAdvertising(const MyAdvertisementArgs& advertisement_args) override;
		std::optional<FlutterError> StopAdvertising() override;
		ErrorOr<int64_t> GetMTU(int64_t address_args) override;
		std::optional<FlutterError> RespondReadRequestWithValue(int64_t address_args, int64_t hash_code_args, const std::vector<uint8_t>& value_args) override;
		std::optional<FlutterError> RespondReadRequestWithProtocolError(int64_t address_args, int64_t hash_code_args, const MyGATTProtocolErrorArgs& error_args) override;
		std::optional<FlutterError> RespondWriteRequest(int64_t address_args, int64_t hash_code_args) override;
		std::optional<FlutterError> RespondWriteRequestWithProtocolError(int64_t address_args, int64_t hash_code_args, const MyGATTProtocolErrorArgs& error_args) override;
		void NotifyValueAsync(const std::string& address_args, int64_t hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result) override;

	private:
		std::optional<MyPeripheralManagerFlutterAPI> api;
		std::optional<winrt::Windows::Devices::Bluetooth::Advertisement::BluetoothLEAdvertisementPublisher> publisher;
		std::optional<winrt::Windows::Devices::Bluetooth::BluetoothAdapter> adapter;
		std::optional<winrt::Windows::Devices::Radios::Radio> radio;
		std::map<int64_t, std::optional<winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSession>> sessions;
		std::optional<winrt::Windows::Devices::Radios::Radio::StateChanged_revoker> radio_state_changed_revoker;

		winrt::fire_and_forget FireAndForgetInitialize(std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget FireAndForgetAddService(const MyMutableGATTServiceArgs& service_args, std::function<void(std::optional<FlutterError> reply)> result);
		winrt::fire_and_forget FireAndForgetNotifyValueAsync(const std::string& address_args, int64_t hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError> reply)> result);

		winrt::Windows::Foundation::IAsyncAction CreateCharacteristicAsync(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalService& service, const MyMutableGATTCharacteristicArgs& characteristic_args);
		winrt::Windows::Foundation::IAsyncAction CreateDescriptorAsync(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattLocalCharacteristic& characteristic, const MyMutableGATTDescriptorArgs& descriptor_args);

		winrt::fire_and_forget FireAndForgetCharacteristicReadRequested(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs& event_args);
		winrt::fire_and_forget FireAndForgetCharacteristicWriteRequested(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs& event_args);
		winrt::fire_and_forget FireAndForgetDescriptorReadRequested(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattReadRequestedEventArgs& event_args);
		winrt::fire_and_forget FireAndForgetDescriptorWriteRequested(const int64_t hash_code_args, const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattWriteRequestedEventArgs& event_args);

		MyBluetoothLowEnergyStateArgs RadioStateToArgs(const winrt::Windows::Devices::Radios::RadioState& state);
		winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattCharacteristicProperties CharacteristicPropertyNumberValuesToProperties(const flutter::EncodableList property_number_values);
		flutter::EncodableValue SubscribedClientToArgs(const winrt::Windows::Devices::Bluetooth::GenericAttributeProfile::GattSubscribedClient& client);
	};

} // namespace bluetooth_low_energy_windows

#endif // BLEW_MY_PERIPHERAL_MANAGER_H_
