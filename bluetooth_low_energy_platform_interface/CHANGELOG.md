## 7.0.0-dev.4

* Add `BluetoothLowEnergyPlugin` class.
* Add `BluetoothLowEnergyPlugin#createCentralManager` method.
* Add `BluetoothLowEnergyPlugin#createPeripheralManager` method.
* Add `CentralManager#requestConnectionPriority` method.
* Add `ConnectionPriority` enum.
* Add `abstract` modifier to `Central` class.
* Add `abstract` modifier to `Peripheral` class.
* Add `abstract` modifier to `EventArgs` class.
* Add `PlatformInterface` to platform classes.
* Move `CentralManager#discoverGATT` to `CentralManager#discoverServices`.
* Move `central` argument of `PeripheralManager#notifyCharacteristic` to optional `centrals` argument.
* Move `BluetoothLowEnergyManager#state` property to `BluetoothLowEnergyManager#getState()` method.
* Remove `PlatformBluetoothLowEnergyManager` class.
* Remove `PlatformCentralManager` class.
* Remove `peripheral` argument from `GATTCharacteristicNotifiedEventArgs`.
* Remove `PlatformPeripheralManager` class.

## 7.0.0-dev.0

* Add `BluetoothLowEnergyManager#nameChanged` event.
* Add `BluetoothLowEnergyManager#getName` method.
* Add `BluetoothLowEnergyManager#setName` method.
* Remove the unnecessary `peripheral` argument from `CentralManger#readCharacteristic` method.
* Remove the unnecessary `peripheral` argument from `CentralManger#writeCharacteristic` method.
* Remove the unnecessary `peripheral` argument from `CentralManger#setCharacteristicNotifyState` method.
* Remove the unnecessary `peripheral` argument from `CentralManger#readDescriptor` method.
* Remove the unnecessary `peripheral` argument from `CentralManger#writeDescriptor` method.
* Add `includeDeviceName` and `includeTXPowerLevel` arguments to `PeripheralManager#startAdvertising` method.
* Move the `central` argument in `PeripheralManger#notifyCharacteristic` method to name argument.

## 6.0.0

* Add `BluetoothLowEnergyManager#authorize` method.
* Add `BluetoothLowEnergyManager#showAppSettings` method.
* Add `CentralManager#mtuChanged` event.
* [Add optional `serviceUUIDs` argument to the `CentralManager#startDiscovery` method.](https://github.com/yanshouwang/bluetooth_low_energy/issues/53)
* [Add `CentralManager#retrieveConnectedPeripherals` method.](https://github.com/yanshouwang/bluetooth_low_energy/issues/61)
* Add `CentralManager#getMaximumWriteLength` method.
* Add `PeripheralManager#connectionStateChanged` event.
* Add `PeripheralManager#mtuChanged` event.
* Add `PeripheralManager#characteristicReadRequested` event.
* Add `PeripheralManager#characteristicWriteRequested` event.
* Add `PeripheralManager#descriptorReadRequested` event.
* Add `PeripheralManager#descriptorWriteRequested` event.
* Add `PeripheralManager#getMaximumNotifyLength` method.
* Add `PeripheralManager#respondReadRequestWithValue` method.
* Add `PeripheralManager#respondReadRequestWithError` method.
* Add `PeripheralManager#respondWriteRequest` method.
* Add `PeripheralManager#respondWriteRequestWithError` method.
* Move the type of `Advertisement#manufacturerSpecificData` to `List<ManufacturerSpecificData>`.
* Move `BluetoothLowEnergyManager#getState` to `BluetoothLowEnergyManager#state`.
* Move `PeripheralManager#clearServices` to `PeripheralManager#removeAllServices`.
* Remove `PeripheralManager#characteristicRead` event.
* Remove `PeripheralManager#characteristicWritten` event.


## 6.0.0-dev.19

* Add `int` type to `UUID#fromAddress`.
* Move the type of `Advertisement#manufacturerSpecificData` to `List<ManufacturerSpecificData>`.

## 6.0.0-dev.18

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

## 6.0.0-dev.17

* Remove `Uint8List#trimGATT` method.

## 6.0.0-dev.16

* Add `GATTService.isPrimary` field.
* Add `peripheral` argument to all methods.

## 6.0.0-dev.15

* Add `GATTReadRequest` class.
* Add `GATTWriteRequest` class.
* Remove `ConnectionStateChangedEventArgs` class.
* Remove `MTUChangedEventArgs` class.
* Remove `GATTRequest` class.
* Remove `GATTDescriptorRequest` class.
* Remove `GATTDescriptorReadRequest` class.
* Remove `GATTDescriptorWriteRequest` class.
* Remove `GATTCharacteristicRequest` class.
* Remove `GATTCharacteristicReadRequest` class.
* Remove `GATTCharacteristicWriteRequest` class.

## 6.0.0-dev.14

* Fix errors.

## 6.0.0-dev.13

* Add `MutableGATTDescriptor#permissions` field.
* Fix errors.

## 6.0.0-dev.12

* Add `GATTDescriptorReadRequestedEventArgs` class.
* Add `GATTDescriptorWriteRequestedEventArgs` class.
* Add `GATTRequest` class.
* Add `GATTDescriptorRequest` class.
* Add `GATTDescriptorReadRequest` class.
* Add `GATTDescriptorWriteRequest` class.
* Add `PeripheralManager#descriptorReadRequested` event.
* Add `PeripheralManager#descriptorWriteRequested` event.
* Add `PeripheralManager#respondDescriptorReadRequestWithValue` method.
* Add `PeripheralManager#respondDescriptorReadRequestWithError` method.
* Add `PeripheralManager#respondDescriptorWriteRequest` method.
* Add `PeripheralManager#respondDescriptorWriteRequestWithError` method.
* Fix errors.

## 6.0.0-dev.11

* Add `ConnectionStateChangedEventArgs` class.
* Add `MTUChangedEventArgs` class.
* Add `CentralConnectionStateChangedEventArgs` class.
* Add `GATTCharacteristicReadRequestedEventArgs` class.
* Add `GATTCharacteristicWriteRequestedEventArgs` class.
* Add `CentralManager#getMaximumWriteLength` method.
* Add `PeripheralManager#connectionStateChanged` event.
* Add `PeripheralManager#characteristicReadRequested` event.
* Add `PeripheralManager#characteristicWriteRequested` event.
* Add `PeripheralManager#getMaximumNotifyLength` method.
* Add `PeripheralManager#respondCharacteristicReadRequestWithValue` method.
* Add `PeripheralManager#respondCharacteristicReadRequestWithError` method.
* Add `PeripheralManager#respondCharacteristicWriteRequest` method.
* Add `PeripheralManager#respondCharacteristicWriteRequestWithError` method.
* Add `ImmutableGATTCharacteristic` class.
* Add `GATTCharacteristicRequest` class.
* Add `GATTCharacteristicReadRequest` class.
* Add `GATTCharacteristicWriteRequest` class.
* Add `GATTCharacteristicPermission` enum.
* Add `GATTError` enum.
* Move `PeripheralManager#clearServices` to `PeripheralManager#removeAllServices`.
* Move `BaseBluetoothLowEnergyManager` to `PlatformBluetoothLowEnergyManager`.
* Move `BaseCentralManager` to `PlatformCentralManager`.
* Move `BasePeripheralManager` to `PlatformPeripheralManager`.
* Move `BaseGATTAttribute` to `GATTAttribute`.
* Move `BaseGATTDescriptor` to `GATTDescriptor`.
* Move `BaseGATTCharacteristic` to `GATTCharacteristic`.
* Move `BaseGATTService` to `GATTService`.
* Move `MutableGATTDescriptor` to `ImmutableGATTCharacteristic`.
* Remove `GATTCharacteristicReadEventArgs` class.
* Remove `GATTCharacteristicWrittenEventArgs` class.
* Remove `PeripheralManager#characteristicRead` event.
* Remove `PeripheralManager#characteristicWritten` event.
* Remove `MutableGATTService`.

## 6.0.0-dev.10

* Fix bugs.

## 6.0.0-dev.9

* Add `BluetoothLowEnergyManager#authorize` method.
* Add `BluetoothLowEnergyManager#showAppSettings` method.

## 6.0.0-dev.8

* Remove `logLevel` argument from the `CentralManager` construstor.
* Remove `logLevel` argument from the `PeripheralManager` construstor.

## 6.0.0-dev.7

* Add `logLevel` argument to the `CentralManager` construstor.
* Add `logLevel` argument to the `PeripheralManager` construstor.

## 6.0.0-dev.6

* Move `ConnectionStateChangedEventArgs` to `PeripheralConnectionStateChangedEventArgs`.
* Move `MTUChangedEventArgs` to `PeripheralMTUChangedEventArgs`.
* Add `ConnectionState` enum.
* Add `CentralMTUChangedEventArgs` class.
* Add `PeripheralManager#mtuChanged` event.

## 6.0.0-dev.5

* Use new capitalization rules.

## 6.0.0-dev.4

* Add `CentralManager#mtuChanged` event.
* Add modifiers to all classes.
* Use new capitalization rules.

## 6.0.0-dev.3

* Remove `abstract` keyword from `Central` class.
* Remove `abstract` keyword from `Peripheral` class.

## 6.0.0-dev.2

* Remove `BluetoothLowEnergyManager#authorize` method.
* Move `BluetoothLowEnergyManager#getState` to `BluetoothLowEnergyManager#state`.

## 6.0.0-dev.1

* Migrate `hybrid_core` to `hybrid_logging`.

## 6.0.0-dev.0

* [Add `CentralManager#retrieveConnectedPeripherals` method.](https://github.com/yanshouwang/bluetooth_low_energy/issues/61)
* [Add optional `serviceUUIDs` argument to the `CentralManager#startDiscovery` method.](https://github.com/yanshouwang/bluetooth_low_energy/issues/53)
* Optimize project structure.

## 5.0.2

* Revert GATT characteristic's `descriptors` arguments to required.

## 5.0.1

* Change GATT characteristic and descriptor's `value` arguments to optional.
* Change GATT characteristic's `descriptors` arguments to optional.

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


## 5.0.0-dev.10

* Fix `Uint8List#trimGATT` throws when the value is not exceeded 512 bytes.

## 5.0.0-dev.9

* Add `PeripheralManager#characteristicRead`.

## 5.0.0-dev.8

* Add `PeripheralManager#readCharacteristic`.
* Move `PeripheralManager#notifyCharacteristic` to `PeripheralManager#writeCharacteristic`.

## 5.0.0-dev.7

* Remove `GattCharacteristicReadEventArgs`.
* Remove `PeripheralManager#characteristicRead`.

## 5.0.0-dev.6

* Remove the final modifier form `MyGattCharacteristic#value` and `MyGattDescriptor#value` and trim by 512 bytes.

## 5.0.0-dev.5

* Move `CentralManager#state` to `CentralManager#getState()`.
* Move `PeripheralStateChangedEventArgs` to `ConnectionStateChangedEventArgs`.
* Move `GattCharacteristicValueChangedEventArgs` to `GattCharacteristicNotifiedEventArgs`.
* Move `CentralManager#peripheralStateChanged` to `CentralManager#connectionStateChanged`.
* Move `CentralManager#characteristicValueChanged` to `CentralManager#characteristicNotified`.
* Move `CentralManager#notifyCharacteristic` to `CentralManager#setCharacteristicNotifyState`.
* Remove `ReadGattCharacteristicCommandEventArgs` and `WriteGattCharacteristicCommandEventArgs`.
* Move `NotifyGattCharacteristicCommandEventArgs` to `GattCharacteristicNotifyStateChangedEventArgs`.
* Remove `PeripheralManager#readCharacteristicCommandReceived` and `PeripheralManager#writeCharacteristicCommandReceived`.
* Add `PeripheralManager#characteristicRead` and `PeripheralManager#characteristicWritten`.
* Move `PeripheralManager#notifyCharacteristicCommandReceived` to `PeripheralManager#characteristicNotifyStateChanged`.
* Remove `PeripheralManager#sendReadCharacteristicReply` and `PeripheralManager#sendWriteCharacteristicReply`.
* Add `GattCharacteristicReadEventArgs` and `GattCharacteristicWrittenEventArgs`.
* Move `PeripheralManager#notifyCharacteristicValueChanged` to `PeripheralManager#notifyCharacteristic`.
* Remove `MyCentralManager` and `MyPeripheralManager`.

## 5.0.0-dev.4

* Optimize `MyGattService` and `MyGattCharacteristic`.

## 5.0.0-dev.3

* Remove `CentralManager#getMaximumWriteLength` method.
* Remove `PeripheralManager#getMaximumWriteLength` method.

## 5.0.0-dev.2

* Add `UUID#fromAddress` constructor.
* Override `hashCode` and `==` of `MyCentral` and `MyPeripheral`.

## 5.0.0-dev.1

* Add `MyBluetoothLowEnergyPeer` and `MyGattAttribute`.
* Remove `MyObject` base class.
* Use `LoggerProvider` instead of custom logger.

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
