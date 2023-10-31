#ifndef PIGEON_MY_CENTRAL_MANAGER_API_H_
#define PIGEON_MY_CENTRAL_MANAGER_API_H_

#include "winrt/Windows.Devices.Bluetooth.h"
#include "winrt/Windows.Devices.Bluetooth.Advertisement.h"

#include "my_api.g.h"

using namespace winrt::Windows::Devices::Bluetooth;
using namespace winrt::Windows::Devices::Bluetooth::Advertisement;

namespace bluetooth_low_energy_windows {
	class MyCentralManager : public MyCentralManagerHostApi
	{
	public:
		MyCentralManager();
		virtual	~MyCentralManager();

		// 通过 MyCentralManagerHostApi 继承
		void SetUp(std::function<void(ErrorOr<MyCentralManagerArgs>reply)> result) override;

		std::optional<FlutterError> StartDiscovery() override;

		std::optional<FlutterError> StopDiscovery() override;

		void Connect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError>reply)> result) override;

		void Disconnect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError>reply)> result) override;

		ErrorOr<int64_t> GetMaximumWriteLength(int64_t peripheral_hash_code_args, int64_t type_number_args) override;

		void ReadRSSI(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<int64_t>reply)> result) override;

		void DiscoverGATT(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList>reply)> result) override;

		void ReadCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result) override;

		void WriteCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, const std::vector<uint8_t>& value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError>reply)> result) override;

		void NotifyCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, bool state_args, std::function<void(std::optional<FlutterError>reply)> result) override;

		void ReadDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>>reply)> result) override;

		void WriteDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, const std::vector<uint8_t>& value_args, std::function<void(std::optional<FlutterError>reply)> result) override;

	private:
		BluetoothLEAdvertisementWatcher watcher;
		std::optional<winrt::event_token> watcher_token;
	};

}

#endif // !PIGEON_MY_CENTRAL_MANAGER_API_H_

