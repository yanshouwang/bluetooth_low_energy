#include "my_central_manager.h"

namespace bluetooth_low_energy_windows
{
	MyCentralManager::MyCentralManager()
	{
		watcher = BluetoothLEAdvertisementWatcher();
		watcher_token = std::nullopt;
	}

	MyCentralManager::~MyCentralManager() {}

	void MyCentralManager::SetUp(std::function<void(ErrorOr<MyCentralManagerArgs> reply)> result)
	{
		auto watching = watcher_token.has_value();
		if (watching)
		{
			watcher.Received(watcher_token);
		}
		watcher_token = watcher.Received([](BluetoothLEAdvertisementWatcher watcher, BluetoothLEAdvertisementReceivedEventArgs eventArgs) {
			auto rssi = eventArgs.RawSignalStrengthInDBm();
		});
	}

	std::optional<FlutterError> MyCentralManager::StartDiscovery()
	{
		watcher.Start();
		return std::nullopt;
	}

	std::optional<FlutterError> MyCentralManager::StopDiscovery()
	{
		watcher.Stop();
		return std::nullopt;
	}

	void MyCentralManager::Connect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	void MyCentralManager::Disconnect(int64_t peripheral_hash_code_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	ErrorOr<int64_t> MyCentralManager::GetMaximumWriteLength(int64_t peripheral_hash_code_args, int64_t type_number_args)
	{
		return ErrorOr<int64_t>(20);
	}

	void MyCentralManager::ReadRSSI(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<int64_t> reply)> result)
	{
	}

	void MyCentralManager::DiscoverGATT(int64_t peripheral_hash_code_args, std::function<void(ErrorOr<flutter::EncodableList> reply)> result)
	{
	}

	void MyCentralManager::ReadCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result)
	{
	}

	void MyCentralManager::WriteCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, const std::vector<uint8_t> &value_args, int64_t type_number_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	void MyCentralManager::NotifyCharacteristic(int64_t peripheral_hash_code_args, int64_t characteristic_hash_code_args, bool state_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}

	void MyCentralManager::ReadDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, std::function<void(ErrorOr<std::vector<uint8_t>> reply)> result)
	{
	}

	void MyCentralManager::WriteDescriptor(int64_t peripheral_hash_code_args, int64_t descriptor_hash_code_args, const std::vector<uint8_t> &value_args, std::function<void(std::optional<FlutterError> reply)> result)
	{
	}
}