## 6.0.2

* `Android` [Use `isMultipleAdvertisementSupported` to check whether `PeripheralManager` is supported on this device.](https://github.com/yanshouwang/bluetooth_low_energy/issues/83).

## 6.0.1

* `Android` Fix the issue that [advertisement name is wrong when advertising](https://github.com/yanshouwang/bluetooth_low_energy/issues/62).

## 6.0.0

* [Add `CentralManager#retrieveConnectedPeripherals` method.](https://github.com/yanshouwang/bluetooth_low_energy/issues/61)
* [Add optional `serviceUUIDs` argument to the `CentralManager#startDiscovery` method.](https://github.com/yanshouwang/bluetooth_low_energy/issues/53)
* [Add `CentralManager#mtuChanged` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* [Add `PeripheralManager#mtuChanged` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* Add `BluetoothLowEnergyManager#authorize` method.
* Add `BluetoothLowEnergyManager#showAppSettings` method.
* [Add `CentralManager#requestMTU` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* [Add `CentralManager#getMaximumWriteLength` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* Add `PeripheralManager#connectionStateChanged` event.
* [Add `PeripheralManager#characteristicReadRequested` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#characteristicWriteRequested` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#descriptorReadRequested` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#descriptorWriteRequested` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#getMaximumNotifyLength` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* [Add `PeripheralManager#respondReadRequestWithValue` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondReadRequestWithError` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondWriteRequest` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondWriteRequestWithError` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* Add `ConnectionState` enum.
* Add `GATTService.isPrimary` field.
* Add `GATTService#includedServices` field.
* Add `MutableGATTCharacteristic#permissions` field.
* Add `MutableGATTDescriptor#permissions` field.
* Add `int` type to `UUID#fromAddress`.
* Move `CentralManger.instance` to factory constructor.
* Move `PeripheralManager.instance` to factory constructor.
* Move the type of `Advertisement#manufacturerSpecificData` to `List<ManufacturerSpecificData>`.
* Move `BluetoothLowEnergyManager#getState` to `BluetoothLowEnergyManager#state`.
* Move `PeripheralManager#clearServices` to `PeripheralManager#removeAllServices`.
* Remove `BluetoothLowEnergyManager#setUp` method.
* Remove `PeripheralManager#characteristicRead` event.
* Remove `PeripheralManager#characteristicWritten` event.
* Remove `PeripheralManager#readCharacteristic` method.
* Remove `PeripheralManager#writeCharacteristic` method.
* Fix the issue that [`Cannot access value of empty optional`](https://github.com/yanshouwang/bluetooth_low_energy/issues/63).
* Fix known issues.
* Rewrite example with MVVM.

## 6.0.0-dev.3

* Implement `CentralMananger#showAppSettings` on iOS.
* Implement `PeripheralManager#showAppSettings` on iOS.
* Fix known issues.

## 6.0.0-dev.2

* Add `int` type to `UUID#fromAddress`.
* Move the type of `Advertisement#manufacturerSpecificData` to `List<ManufacturerSpecificData>`.
* Rewrite example with MVVM.
* Fix known issues.

## 6.0.0-dev.1

* Add `PeripheralManager#respondReadRequestWithValue`.
* Add `PeripheralManager#respondReadRequestWithError`.
* Add `PeripheralManager#respondWriteRequest`.
* Add `PeripheralManager#respondWriteRequestWithError`.
* Remove `PeripheralManager#respondCharacteristicReadRequestWithValue`.
* Remove `PeripheralManager#respondCharacteristicReadRequestWithError`.
* Remove `PeripheralManager#respondCharacteristicWriteRequest`.
* Remove `PeripheralManager#respondCharacteristicWriteRequestWithError`.
* Remove `PeripheralManager#respondDescriptorReadRequestWithValue`.
* Remove `PeripheralManager#respondDescriptorReadRequestWithError`.
* Remove `PeripheralManager#respondDescriptorWriteRequest`.
* Remove `PeripheralManager#respondDescriptorWriteRequestWithError`.

## 6.0.0-dev.0

* [Add `CentralManager#retrieveConnectedPeripherals` method.](https://github.com/yanshouwang/bluetooth_low_energy/issues/61)
* [Add optional `serviceUUIDs` argument to the `CentralManager#startDiscovery` method.](https://github.com/yanshouwang/bluetooth_low_energy/issues/53)
* [Add `CentralManager#mtuChanged` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* [Add `PeripheralManager#mtuChanged` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* Add `BluetoothLowEnergyManager#authorize` method.
* Add `BluetoothLowEnergyManager#showAppSettings` method.
* [Add `CentralManager#requestMTU` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* [Add `CentralManager#getMaximumWriteLength` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* Add `PeripheralManager#connectionStateChanged` event.
* [Add `PeripheralManager#characteristicReadRequested` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#characteristicWriteRequested` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#descriptorReadRequested` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#descriptorWriteRequested` event](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#getMaximumNotifyLength` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/57).
* [Add `PeripheralManager#respondCharacteristicReadRequestWithValue` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondCharacteristicReadRequestWithError` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondCharacteristicWriteRequest` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondCharacteristicWriteRequestWithError` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondDescriptorReadRequestWithValue` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondDescriptorReadRequestWithError` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondDescriptorWriteRequest` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* [Add `PeripheralManager#respondDescriptorWriteRequestWithError` method](https://github.com/yanshouwang/bluetooth_low_energy/issues/45).
* Add `ConnectionState` enum.
* Add `GATTService.isPrimary` field.
* Add `GATTService#includedServices` field.
* Add `MutableGATTCharacteristic#permissions` field.
* Add `MutableGATTDescriptor#permissions` field.
* Move `BluetoothLowEnergyManager#getState` to `BluetoothLowEnergyManager#state`.
* Move `PeripheralManager#clearServices` to `PeripheralManager#removeAllServices`.
* Move `CentralManger.instance` to factory constructor.
* Move `PeripheralManager.instance` to factory constructor.
* Remove `BluetoothLowEnergyManager#setUp` method.
* Remove `GATTCharacteristicReadEventArgs` class.
* Remove `GATTCharacteristicWrittenEventArgs` class.
* Remove `PeripheralManager#characteristicRead` event.
* Remove `PeripheralManager#characteristicWritten` event.
* Remove `PeripheralManager#readCharacteristic` method.
* Remove `PeripheralManager#writeCharacteristic` method.
* Fix the issue that [`Cannot access value of empty optional`](https://github.com/yanshouwang/bluetooth_low_energy/issues/63).

## 5.0.7

* `Android` Fix the issue that [Advertisement resolve failed with `NullPointerException`](https://github.com/yanshouwang/bluetooth_low_energy/issues/59)

## 5.0.6

* `Android` Fix the issue that [throws when read the CCCD(Client Characteristic Config Descriptor, 0x2902)](https://github.com/yanshouwang/bluetooth_low_energy/issues/47).
* `Android` `iOS` Update characteristic's value when write by centrals.
* Implements new Api.

## 5.0.5

* `Windows` Fix the [`CentralManager#discoverGATT`, `CentralManager#readCharacteristic` and `CentralManager#readDescriptor` issue](https://github.com/yanshouwang/bluetooth_low_energy/issues/42) caused by cache mode.

## 5.0.4

* `iOS` Fix issues caused by CoW.

## 5.0.3

* `Android` Fix the wrong blutooth low energy state caused by multi permission requests at the same time.
* `Android` Fix the ConcurrentModificationException when `PeripheralManager#clearServices` is called.

## 5.0.2

* `iOS` Fix the issue that [discoverGATT failed](https://github.com/yanshouwang/bluetooth_low_energy/issues/36) caused by CoW.

## 5.0.1

* `iOS` Fix the issue that [completion was called duplicately](https://github.com/yanshouwang/bluetooth_low_energy/issues/36) caused by CoW.

## 5.0.0

* Now `CentralManager#writeCharacteristic` and `PeripheralManager#writeCharacteristic` will fragment the value automatically, the maximum write length is 512 bytes.
* Add implementation of `CentralManager` on windows platform.
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

## 5.0.0-dev.3

* Add logs on Linux platform.

## 5.0.0-dev.2

* Add default_package of windows in pubspec.yaml.

## 5.0.0-dev.1

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

## 4.0.0-dev.1

* Remove `BluetoothLowEnergy` class.
* Update `CentralManger` to static class.
* Update `PeripheralManager` to static class.
* Move `AdvertiseData` class to `Advertisement` class.
* Update `example`.

## 3.0.3

* `Android` Fix the issue [android device: requestMtu issue #22](https://github.com/yanshouwang/bluetooth_low_energy/issues/22)

## 3.0.2

* `Android` `iOS` Fix the issue that `getMaximumWriteLength` is wrong and coerce the value from 20 to 512.
* `Android` `iOS` Fix the issue that the peripheral manager response is wrong.
* `Android` Request MTU with 517 automatically.

## 3.0.1

* `Android` Clear cache when disconnected.
* `Android` Fix GATT server error aftter bluetooth reopened.
* `iOS` Fix the issue that write characteristic will never complete when write without response.
* `iOS` Fix the issue that write characteristic will never complete after disconnected.

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
