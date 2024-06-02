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

Add `bluetooth_low_energy` as a [dependency in your pubspec.yaml file][2].

``` YAML
dependencies:
  bluetooth_low_energy: ^<latest-version>
```

*Note:* Bluetooth Low Energy doesn't work on emulators, so use physical devices which has bluetooth features for development.

### Android

Make sure you have a `minSdk` with 21 or higher in your `android/app/build.gradle` file.

### iOS and macOS

According to the [Apple's documents][3], you must include the [`NSBluetoothAlwaysUsageDescription`][4] on or after iOS 13, and include the [`NSBluetoothPeripheralUsageDescription`][5] key before iOS 13.

When use bluetooth or other hardwares on macOS, developers need to [configure the app sandbox][6].

*Note:* The `PeripheralManager#startAdvertising` only support `name` and `serviceUUIDs`, see the [Apple's document][7].

### Winodows

*Note:* The `PeripheralManager#startAdvertising` not support `name`, see the [Microsoft's document][8].

### Linux

The `PeripheralManager` API is not implemented since the [`bluez`][9] didn't support this feature yet.

## Migrations

* [Migrate from 5.0.0 to 6.0.0][1]

[1]: docs/migrations/migration-v6.md
[2]: https://docs.flutter.dev/packages-and-plugins/using-packages
[3]: https://developer.apple.com/documentation/corebluetooth
[4]: https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription
[5]: https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothperipheralusagedescription
[6]: https://developer.apple.com/documentation/xcode/configuring-the-macos-app-sandbox#Enable-access-to-restricted-resources
[7]: https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising
[8]: https://learn.microsoft.com/en-us/uwp/api/windows.devices.bluetooth.advertisement.bluetoothleadvertisementpublisher.advertisement?view=winrt-22621
[9]: https://github.com/canonical/bluez.dart