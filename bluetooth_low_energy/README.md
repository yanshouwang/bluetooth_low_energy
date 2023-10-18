# bluetooth_low_energy

A Flutter plugin for controlling the bluetooth low energy.

## Features

### CentralManager

- [x] Set up the central manager.
- [x] Get/Listen the state of the central manager.
- [x] Start/Stop discovery.
- [x] Connect/Disconnect peripherals.
- [x] Get maximum write length of peripherals.
- [x] Read RSSI of peripherals.
- [x] Discover GATT.
- [x] Get GATT services.
- [x] Get GATT characteristics.
- [x] Get GATT descriptors.
- [x] Read/Write/Notify GATT characteristics.
- [x] Read/Write GATT descriptors.

### PeripheralManager

- [x] Set up the peripheral manager.
- [x] Get/Listen the state of the peripheral manager.
- [x] Add/Remove/Clear service(s).
- [x] Start/Stop advertising.
- [x] Get maximum write length of centrals.
- [x] Listen read/write/notify characteristic requests from centrals.
- [x] Send read/write characteristic replies to centrals.
- [x] Notify characteristic value changed to centrals.

## Getting Started

Add `bluetooth_low_energy` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

```
dependencies:
  bluetooth_low_energy: ^<latest-version>
```

Remember to call `await CentralController.setUp()` before use any apis of this plugin.

*Note:* Bluetooth Low Energy doesn't work on emulators, so use physical devices which has bluetooth features for development.

### Android

Make sure you have a `miniSdkVersion` with 21 or higher in your `android/app/build.gradle` file.

### iOS and macOS

According to Apple's [documents](https://developer.apple.com/documentation/corebluetooth/), you must include the [`NSBluetoothAlwaysUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription) on or after iOS 13, and include the [`NSBluetoothPeripheralUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothperipheralusagedescription) key before iOS 13.

*Note:* The `PeripheralManager#startAdvertising` only support `name` and `serviceUUIDs`, see [the startAdvertising document](https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising)

### Linux

Not tested enough, if you occured any problems, file an issue to let me know about it, i will fix it as soon as possible.

PeripheralManager api is not supported because the `bluez` plugin doesn't support this yet, see [How to use bluez to act as bluetooth peripheral](https://github.com/canonical/bluez.dart/issues/85)

### Windows

Not implemented yet but maybe someday or someone can use the `win32` api to implement this plugin_interface or someday the flutter team support C# on windows platform or someday I am familiar with C++ language...
