# bluetooth_low_energy

A Flutter plugin for controlling the bluetooth low energy.

## Features

### CentralController
- [x] Get/Listen central state.
- [x] Start/Stop discovery.
- [x] Connect/Disconnect peripherals.
- [x] Discover GATT.
- [x] Get GATT services.
- [x] Get GATT characteristics.
- [x] Get GATT descriptors.
- [x] Read/Write/Notify GATT characteristics.
- [x] Read/Write GATT descriptors.

## Getting Started

Add `bluetooth_low_energy` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

```
dependencies:
  bluetooth_low_energy: ^<latest-version>
```

*Note*: Bluetooth Low Energy doesn't work on emulators, so use physical devices which has bluetooth features for development.

### Android

Make sure you have a `miniSdkVersion` with 21 or higher in your `android/app/build.gradle` file.

### iOS

According to Apple's [documents](https://developer.apple.com/documentation/corebluetooth/), you must include the [`NSBluetoothAlwaysUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription) on or after iOS 13, and include the [`NSBluetoothPeripheralUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothperipheralusagedescription) key before iOS 13.
