# bluetooth_low_energy

A Flutter plugin for controlling the bluetooth low energy.

## Features

### CentralManager

- [x] Get/Listen the state of the central manager.
- [x] Listen connection state cahgned.
- [x] Listen GATT characteristic notified.
- [x] Start/Stop discovery.
- [x] Connect/Disconnect peripherals.
- [x] Read RSSI of peripherals.
- [x] Discover GATT.
- [x] Read/Write GATT characteristics.
- [x] Set GATT characteristics notify state.
- [x] Read/Write GATT descriptors.

### PeripheralManager

- [x] Get/Listen the state of the peripheral manager.
- [x] Listen GATT characteristic read/written/notifyStateChanged.
- [x] Add/Remove/Clear service(s).
- [x] Start/Stop advertising.
- [x] Read/Write(Notify) GATT characteristics.

## Getting Started

Add `bluetooth_low_energy` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

```
dependencies:
  bluetooth_low_energy: ^<latest-version>
```

Remember to call `await CentralManager.setUp()` and `await PeripheralManager.setUp()` before use any apis of this plugin.

*Note:* Bluetooth Low Energy doesn't work on emulators, so use physical devices which has bluetooth features for development.

### Android

Make sure you have a `miniSdkVersion` with 21 or higher in your `android/app/build.gradle` file.

### iOS and macOS

According to Apple's [documents](https://developer.apple.com/documentation/corebluetooth/), you must include the [`NSBluetoothAlwaysUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription) on or after iOS 13, and include the [`NSBluetoothPeripheralUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothperipheralusagedescription) key before iOS 13.

*Note:* The `PeripheralManager#startAdvertising` only support `name` and `serviceUUIDs`, see [the startAdvertising document](https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising)

### Linux

PeripheralManager is not implemented because the `bluez` plugin doesn't support this yet, see [How to use bluez to act as bluetooth peripheral](https://github.com/canonical/bluez.dart/issues/85)

### Windows

PeripheralManager is not implemented, it will be implemented in the future.

*Note:* The `CentralManager#readRSSI` method is not implemented on windows(windows doesn't support read RSSI after connected), avoid call this when running on windows devices.
