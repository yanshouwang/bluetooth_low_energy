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

Add `bluetooth_low_energy` as a [dependency][1] in your pubspec.yaml file.

``` YAML
dependencies:
  bluetooth_low_energy: ^<latest-version>
```

*Note:* Bluetooth Low Energy doesn't work on emulators, so use physical devices which has bluetooth features for development.

### Android

Make sure you have a `minSdk` with 21 or higher in your `android/app/build.gradle` file.

### iOS and macOS

According to the [Apple's documents][2], you must include the [`NSBluetoothAlwaysUsageDescription`][3] on or after iOS 13, and include the [`NSBluetoothPeripheralUsageDescription`][4] key before iOS 13.

When use bluetooth or other hardwares on macOS, developers need to [configure the app sandbox][5].

*Note:* The `PeripheralManager#startAdvertising` only support `name` and `serviceUUIDs`, see the [Apple's document][6].

### Winodows

*Note:* The `PeripheralManager#startAdvertising` not support `name`, see the [Microsoft's document][7].

### Linux

The `PeripheralManager` API is not implemented since the [`bluez`][8] didn't support this feature yet.

## Migrations

* [Migrate from 5.x to 6.x][9]

## Sponsors

If you find this open-source project is helpful, consider to be a sponsor on GitHub Sponsors. Your support will help me dedicate more time on the open-source community.

* [Alipay](https://sponsors.zeekr.dev/#/alipay)
* [WeChat Pay](https://sponsors.zeekr.dev/#/wechat-pay)
* [Bitcoin Wallet](https://sponsors.zeekr.dev/#/bitcoin-wallet)

<!-- TODO: Save this list to database and show this in the sponsors.zeekr.dev -->
### Sponsors Details

|Date|Sponsor|Amount|
|:---:|:---:|:---:|
|2025.1.1|[Jeff-Lawson][10]|0.01177286BTC|

[1]: https://docs.flutter.dev/packages-and-plugins/using-packages
[2]: https://developer.apple.com/documentation/corebluetooth
[3]: https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription
[4]: https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothperipheralusagedescription
[5]: https://developer.apple.com/documentation/xcode/configuring-the-macos-app-sandbox#Enable-access-to-restricted-resources
[6]: https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising
[7]: https://learn.microsoft.com/en-us/uwp/api/windows.devices.bluetooth.advertisement.bluetoothleadvertisementpublisher.advertisement?view=winrt-22621
[8]: https://github.com/canonical/bluez.dart
[9]: doc/migrations/migration-v6.md
[10]: https://github.com/Jeff-Lawson