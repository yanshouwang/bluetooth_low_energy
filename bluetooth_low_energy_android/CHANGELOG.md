## 6.0.0-dev.2

* Implement new APIs.

## 6.0.0-dev.1

* Add `CentralManager#mtuChanged` event.
* Add `PeripheralManager#mtuChanged` event.
* Add `BluetoothLowEnergyManager.authorize()` method.
* Add `BluetoothLowEnergyManager.showAppSettings()` method.
* Add modifiers to all classes.
* Use new capitalization rules.
* Make it possible to change the `logLevel` before `initialize()`.

## 6.0.0-dev.0

* Add `serviceUUIDs` argument to `CentralManager#startDiscovery` method.
* Add `CentralManager#requestMTU` method.
* Add `CentralManager#retrieveConnectedPeripherals` method.
* Move `BluetoothLowEnergyManager#getState` to `BluetoothLowEnergyManager#state`.
* Move `CentralManger.instance` to factory constructor.
* Move `PeripheralManager.instance` to factory constructor.
* Remove `BluetoothLowEnergyManager#setUp` method.

## 5.0.5

* Fix the issue that [Advertisement resolve failed with `NullPointerException`](https://github.com/yanshouwang/bluetooth_low_energy/issues/59)

## 5.0.4

* Change flutter minimum version to 3.0.0.

## 5.0.3

* Fix the issue that [throws when read the CCCD(Client Characteristic Config Descriptor, 0x2902)](https://github.com/yanshouwang/bluetooth_low_energy/issues/47).
* Update characteristic's value when write by centrals.
* Implements new Api.

## 5.0.2

* Fix the ConcurrentModificationException when `PeripheralManager#clearServices` is called.
* Fix the `CentralManager#setUp` and `PeripheralManager#setUp` were blocked.

## 5.0.1

* Fix the wrong blutooth low energy state caused by multi permission requests at the same time.

## 5.0.0

* Now `CentralManager#writeCharacteristic` and `PeripheralManager#writeCharacteristic` will fragment the value automatically, the maximum write length is 512 bytes.
* Add `UUID#fromAddress` constructor.
* Add `GattCharacteristicReadEventArgs` and `GattCharacteristicWrittenEventArgs`.
* Add `PeripheralManager#characteristicRead` and `PeripheralManager#characteristicWritten`.
* Add `PeripheralManager#readCharacteristic`.
* Remove `CentralManager#getMaximumWriteLength` method.
* Remove `PeripheralManager#getMaximumWriteLength` method.
* Remove `ReadGattCharacteristicCommandEventArgs` and `WriteGattCharacteristicCommandEventArgs`.
* Remove `PeripheralManager#readCharacteristicCommandReceived` and `PeripheralManager#writeCharacteristicCommandReceived`.
* Remove `PeripheralManager#sendReadCharacteristicReply` and `PeripheralManager#sendWriteCharacteristicReply`.
* Move `CentralManager#state` to `CentralManager#getState()`.
* Move `PeripheralStateChangedEventArgs` to `ConnectionStateChangedEventArgs`.
* Move `CentralManager#peripheralStateChanged` to `CentralManager#connectionStateChanged`.
* Move `GattCharacteristicValueChangedEventArgs` to `GattCharacteristicNotifiedEventArgs`.
* Move `CentralManager#characteristicValueChanged` to `CentralManager#characteristicNotified`.
* Move `CentralManager#notifyCharacteristic` to `CentralManager#setCharacteristicNotifyState`.
* Move `PeripheralManager#notifyCharacteristicValueChanged` to `PeripheralManager#writeCharacteristic`.
* Move `NotifyGattCharacteristicCommandEventArgs` to `GattCharacteristicNotifyStateChangedEventArgs`.
* Move `PeripheralManager#notifyCharacteristicCommandReceived` to `PeripheralManager#characteristicNotifyStateChanged`.

## 5.0.0-dev.4

* Fix the issue that `PeripheralMananger#startAdvertising` throws after powered off.\
* Optimize project structure.

## 5.0.0-dev.3

* Implements new Api.

## 5.0.0-dev.2

* Optimize example.
* Add event logs.
* Fix the issue that PeripheralManager's service duplicated after hot reload.
* Fix the issue that `PeripheralManager#notifyCharacteristicChanged` lost data when value is larger then the MTU size.
* Optimize instances' retrieve speed.
* Update dependency.

## 5.0.0-dev.1

* Implement the `5.0.0` api.
* Optimize example.
* Remove `CentralManager#getMaximumWriteLength` method.
* Remove `PeripheralManager#getMaximumWriteLength` method.

## 4.0.0

* Remove `BluetoothLowEnergy` class.
* Update `CentralManger` to extends `PlatformInterface`.
* Update `PeripheralManager` to extends `PlatformInterface`.
* Change some `PeripheralManager` methods' arguments to required optional arguments.
* Move `AdvertiseData` class to `Advertisement` class.
* Remove `BluetoothLowEnergyError` class.
* Add `MyCentralManager` and `MyPeripheralManager` abstract classes.
* Add `LogController` interface to `BluetoothLowEnergyManager`.
* Fix issues.

## 4.0.0-dev.3

* Optimize project structure.

## 4.0.0-dev.2

* Optimize the import method of the `example`.

## 4.0.0-dev.1

* Remove `BluetoothLowEnergy` class.
* Update `CentralManger` to extends `PlatformInterface`.
* Update `PeripheralManager` to extends `PlatformInterface`.
* Move `AdvertiseData` class to `Advertisement` class.
* Remove `logging` dependency.
* Update `example`.

## 3.0.4

* Fix the issue [android device: requestMtu issue #22](https://github.com/yanshouwang/bluetooth_low_energy/issues/22)

## 3.0.3

* Fix the issue that `getMaximumWriteLength` is wrong and coerce the value from 20 to 512.

## 3.0.2

* Request MTU with 517 automatically.
* Fix the issue taht `CentralManager#getMaximumWriteLength` is wrong when write with response and coerce the value from 20 to 512.
* Fix the issue that the GATT server response is wrong.

## 3.0.1

* Clear cache when disconnected.
* Fix GATT server error aftter bluetooth reopened.

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

## 3.0.0-dev.6

* Add default `CCCD` to GATT characteristic for notify and indicate.
* Fix the issue that callbacks must run on ui thread.
* Change requested MTU from 512 to 517 when get the maximum write length of characteristic.

## 3.0.0-dev.5

* Fix the issue that the `BLUETOOTH_ADVERTISE` permission is not requested.

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

* Implement new api.

## 2.2.1

* Fix the issue that `CentralController#getMaximumWriteLength` may throw.

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
