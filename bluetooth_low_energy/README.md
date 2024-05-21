# bluetooth_low_energy

A Flutter plugin for controlling the bluetooth low energy, supports central and peripheral roles.

## CentralManager

|API|Android|iOS|macOS|Windows|Linux|
|:-|:-:|:-:|:-:|:-:|:-:|
|logLevel|✅|✅|✅|✅|✅|
|state|✅|✅|✅|✅|✅|
|stateChanged|✅|✅|✅|✅|✅|
|authorize|✅|||||
|showAppSettings|✅|✅||||
|discovered|✅|✅|✅|✅|✅|
|connectionStateChanged|✅|✅|✅|✅|✅|
|mtuChanged|✅|||✅||
|characteristicNotified|✅|✅|✅|✅|✅|
|startDiscovery|✅|✅|✅|✅|✅|
|stopDiscovery|✅|✅|✅|✅|✅|
|retrieveConnectedPeripherals|✅|✅|✅||✅|
|connect|✅|✅|✅|✅|✅|
|disconnect|✅|✅|✅|✅|✅|
|requestMTU|✅|||||
|getMaximumWriteLength|✅|✅|✅|✅|✅|
|readRSSI|✅|✅|✅||✅|
|readCharacteristic|✅|✅|✅|✅|✅|
|writeCharacteristic|✅|✅|✅|✅|✅|
|setCharacteristicNotifyState|✅|✅|✅|✅|✅|
|readDescriptor|✅|✅|✅|✅|✅|
|writeDescriptor|✅|✅|✅|✅|✅|

## PeripheralManager

|API|Android|iOS|macOS|Windows|Linux|
|:-|:-:|:-:|:-:|:-:|:-:|
|logLevel|✅|✅|✅|✅||
|state|✅|✅|✅|✅||
|stateChanged|✅|✅|✅|✅||
|authorize|✅|||||
|showAppSettings|✅|✅||||
|connectionStateChanged|✅|||||
|mtuChanged|✅|||✅||
|characteristicReadRequested|✅|✅|✅|✅||
|characteristicWriteRequested|✅|✅|✅|✅||
|characteristicNotifyStateChanged|✅|✅|✅|✅||
|descriptorReadRequested|✅|||✅||
|descriptorWriteRequested|✅|||✅||
|addService|✅|✅|✅|✅||
|removeService|✅|✅|✅|✅||
|removeAllServices|✅|✅|✅|✅||
|startAdvertising|✅|✅|✅|✅||
|stopAdvertising|✅|✅|✅|✅||
|getMaximumNotifyLength|✅|✅|✅|✅||
|respondReadRequestWithValue|✅|✅|✅|✅||
|respondReadRequestWithError|✅|✅|✅|✅||
|respondWriteRequest|✅|✅|✅|✅||
|respondWriteRequestWithError|✅|✅|✅|✅||
|notifyCharacteristic|✅|✅|✅|✅||

## Getting Started

Add `bluetooth_low_energy` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

``` YAML
dependencies:
  bluetooth_low_energy: ^<latest-version>
```

*Note:* Bluetooth Low Energy doesn't work on emulators, so use physical devices which has bluetooth features for development.

### Android

Make sure you have a `minSdk` with 21 or higher in your `android/app/build.gradle` file.

### iOS and macOS

According to Apple's [documents](https://developer.apple.com/documentation/corebluetooth/), you must include the [`NSBluetoothAlwaysUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription) on or after iOS 13, and include the [`NSBluetoothPeripheralUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothperipheralusagedescription) key before iOS 13.

When use bluetooth or other hardwares on macOS, developers need to [configure the app sandbox](https://developer.apple.com/documentation/xcode/configuring-the-macos-app-sandbox#Enable-access-to-restricted-resources).

*Note:* The `PeripheralManager#startAdvertising` only support `name` and `serviceUUIDs`, see [the startAdvertising document](https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising).

## Migrations

* [Migrate from 5.0.0 to 6.0.0][1]

[1]: docs/migrations/migration-v6.md
