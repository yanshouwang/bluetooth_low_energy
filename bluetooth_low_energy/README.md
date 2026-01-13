# bluetooth_low_energy

A Flutter plugin for controlling the bluetooth low energy, supports central and peripheral roles.

## CentralManager

|API|Android|iOS|macOS|Windows|Linux|
|:-|:-:|:-:|:-:|:-:|:-:|
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
|getPeripheral|✅|||||
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
|getCentral|✅|||||
|retrieveConnectedCentrals|✅|||||
|disconnect|✅|||||
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

Make sure you have a `minSdk` with 24 or higher in your `android/app/build.gradle` file.

[Set up bluetooth permissions][2] in the `AndroidManifest.xml` file.

### iOS and macOS

According to the [Apple's documents][3], you must include the [`NSBluetoothAlwaysUsageDescription`][4] on or after iOS 13, and include the [`NSBluetoothPeripheralUsageDescription`][5] key before iOS 13.

When use bluetooth or other hardwares on macOS, developers need to [configure the app sandbox][6].

*Note:* The `PeripheralManager#startAdvertising` only support `name` and `serviceUUIDs`, see the [Apple's document][7].

### Winodows

*Note:* The `PeripheralManager#startAdvertising` not support `name`, see the [Microsoft's document][8].

### Linux

The `PeripheralManager` API is not implemented since the [`bluez`][9] didn't support this feature yet.

## Migrations

* [Migrate from 5.x to 6.x][10]

## Sponsors

If you find this open-source project is helpful, consider to be a sponsor on GitHub Sponsors. Your support will help me dedicate more time on the open-source community.

* [Alipay](https://sponsors.zeekr.dev/#/alipay)
* [WeChat Pay](https://sponsors.zeekr.dev/#/wechat-pay)
* [Bitcoin Wallet](https://sponsors.zeekr.dev/#/bitcoin-wallet)

<!-- TODO: Save this list to database and show this in the sponsors.zeekr.dev -->
### Sponsors Details

|Date|Sponsor|Amount|
|:---:|:---:|:---:|
|2025.1.1|[Jeff-Lawson][11]|0.01177286BTC|

[1]: https://docs.flutter.dev/packages-and-plugins/using-packages
[2]: https://developer.android.com/develop/connectivity/bluetooth/bt-permissions
[3]: https://developer.apple.com/documentation/corebluetooth
[4]: https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription
[5]: https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothperipheralusagedescription
[6]: https://developer.apple.com/documentation/xcode/configuring-the-macos-app-sandbox#Enable-access-to-restricted-resources
[7]: https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising
[8]: https://learn.microsoft.com/en-us/uwp/api/windows.devices.bluetooth.advertisement.bluetoothleadvertisementpublisher.advertisement?view=winrt-22621
[9]: https://github.com/canonical/bluez.dart
[10]: doc/migrations/migration-v6.md
[11]: https://github.com/Jeff-Lawson