## 5.0.1

* Fix the [`CentralManager#discoverGATT`, `CentralManager#readCharacteristic` and `CentralManager#readDescriptor` issue](https://github.com/yanshouwang/bluetooth_low_energy/issues/42) caused by cache mode.

## 5.0.0

* Add implementation of `CentralManagerApi`.

## 5.0.0-dev.7

* Optimize project structure.

## 5.0.0-dev.6

* Remove the fragment logic form `CentralManager#writeCharacteristic`.

## 5.0.0-dev.5

* Add implementation of `CentralManagerApi`.

## 5.0.0-dev.4

* Add event logs.
* Update dependency.
* Optimize instances' retrieve speed.
* Optimize example.
* Fix the issue that `CentralManager#connect` returns fake connection.

## 5.0.0-dev.3

* Update interface to 5.0.0-dev.4.

## 5.0.0-dev.2

* Optimize CentralManager's cache.
* Remove AdvertiserView form example.

## 5.0.0-dev.1

* Implement the `CentralManager` api.

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
