## 3.0.2

* [Android, iOS] Fix the issue that `getMaximumWriteLength` is wrong and coerce the value from 20 to 512.
* [Android, iOS] Fix the issue that the peripheral manager response is wrong.
* [Android] Request MTU with 517 automatically.

## 3.0.1

* [Android] Clear cache when disconnected.
* [Android] Fix GATT server error aftter bluetooth reopened.
* [iOS] Fix the issue that write characteristic will never complete when write without response.
* [iOS] Fix the issue that write characteristic will never complete after disconnected.

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

## 3.0.0-dev.4

* Move `Advertisement` class to `AdvertiseData` class.
* Fix known issues.

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

## 2.2.1

* `Android` Fix the issue that `CentralController#getMaximumWriteLength` may throw.

## 2.2.0

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

## 1.1.0

* Fix the crash by onMtuChanged called multi-times on Android.
* Fix the finalizer doesn't work issue.
* Make some break changes.

## 1.0.0

* Upgrade to flutter 3.x.
* Rewrite the whole project with pigeon.

## 0.1.0

* Add implementations on iOS.
* Combine available and state for Bluetooth.
* Add connectable for Discovery.
* Add maximumWriteLength for GATT.

## 0.0.2

* Fix connect blocked when bluetooth closed.
* Fix wrong repository url.
* Move all example files to main.dart.

## 0.0.1

* Add central APIs.
* Add implementations on Android.
* Add example.
* Add test.
