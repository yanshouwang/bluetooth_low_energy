## 4.0.0

* Remove `BluetoothLowEnergy` class.
* Update `CentralManger` to extends `PlatformInterface`.
* Update `PeripheralManager` to extends `PlatformInterface`.
* Update `README.md`.
* Change some `PeripheralManager` methods' arguments to required optional arguments.
* Move `AdvertiseData` class to `Advertisement` class.
* Remove `BluetoothLowEnergyError` class.
* Add `MyCentralManager` and `MyPeripheralManager` abstract classes.
* Add `LogController` interface to `BluetoothLowEnergyManager`.
* Fix issues.

## 4.0.0-dev.12

* Update `log_service` dependency.

## 4.0.0-dev.11

* Use `log_service` instead of `logging` to simplify project structure.

## 4.0.0-dev.10

* Fix the issue that messages were logged twice and other logger's messages were also logged by this logger.

## 4.0.0-dev.9

* Remove `Logger`, use `logging` package instead.
* Add `SetUp` interface class and `MySetUp` mixin.
* Add `LoggerController` interface class and `MyLoggerController` mixin.
* Update `CentralManager` to implements `SetUp` and `LoggerController`.
* Update `PeripheralManager` to implements `SetUp` and `LoggerController`.

## 4.0.0-dev.8

* Remove `BluetoothLowEnergyError`, use `PlatformException` instead.
* Add `MyCentralManager` and `MyPeripheralManager` abstract classes.
* Optimize project's structure.

## 4.0.0-dev.7

* Remove `Logger.level` filed, as the level of `logging` package is a global option, which can be changed by anyone.

## 4.0.0-dev.6

* Move `AdvertiseData` class to `Advertisement` class.

## 4.0.0-dev.5

* Fix export error.

## 4.0.0-dev.4

* Optimize project's structure.

## 4.0.0-dev.3

* Change some `PeripheralManager` methods' arguments to required optional arguments.

## 4.0.0-dev.2

* Add `Logger` class.

## 4.0.0-dev.1

* Remove `BluetoothLowEnergy` class.
* Update `CentralManger` to extends `PlatformInterface`.
* Update `PeripheralManager` to extends `PlatformInterface`.
* Update `README.md`.

## 3.0.0

* Add `PeripheralManager` api.
* Add `CentralManager#readRSSI` method.
* Add `CentralManager.instance` api.
* Add `PeripheralManager.instance` api.
* Move `CentralController` to `CentralManager`.
* Move `CentralState` to `BluetoothLowEnergyState`.
* Move `CentralDiscoveredEventArgs` to `DiscoveredEventArgs`.
* Move `Advertisement` class to `AdvertiseData` class.
* Move `setUp` method from `BluetoothLowEnergy` class to `BluetoothLowEnergyManger` class.
* Change the type of `manufacturerSpecificData` from `Map<int, Uint8List>` to `ManufacturerSpecificData`.
* [Fix the issue that `UUID.fromString()` throw FormatException with 32 bits UUID string.](https://github.com/yanshouwang/bluetooth_low_energy/issues/13)
* Fix known issues.

## 3.0.0-dev.5

* Move `Advertisement` class to `AdvertiseData` class.

## 3.0.0-dev.4

* Fix issues.

## 3.0.0-dev.3

* [Fix the issue that `UUID.fromString()` throw FormatException with 32 bits UUID string.](https://github.com/yanshouwang/bluetooth_low_energy/issues/13)
* Change the type of `manufacturerSpecificData` from `Map<int, Uint8List>` to `ManufacturerSpecificData`.

## 3.0.0-dev.2

* Move `setUp` method from `BluetoothLowEnergy` class to `BluetoothLowEnergyManger` class.
* Add `CentralManager.instance` api.
* Add `PeripheralManager.instance` api.

## 3.0.0-dev.1

* Add `PeripheralManager` api.
* Add `CentralManager#readRSSI` method.
* Move `CentralController` to `CentralManager`.
* Move `CentralState` to `BluetoothLowEnergyState`.
* Move `CentralDiscoveredEventArgs` to `DiscoveredEventArgs`.

## 2.2.0

* Add `GattCharacteristicWriteType` argument to `CentralController#getMaximumWriteLength` method.

## 2.1.0

* Bump version.

## 2.0.5

* Optimize project structure.

## 2.0.4

* Add `CentralController#getMaximumWriteLength` method.

## 2.0.3

* `Android` Migrate to Android 13.
* `Android` Fix the issuce that receive wrong values caused by unsafe memory, see https://developer.android.com/reference/android/bluetooth/BluetoothGattCallback#onCharacteristicChanged(android.bluetooth.BluetoothGatt,%20android.bluetooth.BluetoothGattCharacteristic)

## 2.0.2

* Combine iOS and macOS projects.
* Optimize project structure.

## 2.0.1

* Fix the issue that GATTs is cleared after peripheral disconnected on iOS and macOS.
* Fix the issue that create UUID form peripheral's address failed on Linux.
* Fix the issue that instance match failed on Linux.

## 2.0.0

* Rewrite the whole project with federated plugins.
* Support macOS and Linux.
