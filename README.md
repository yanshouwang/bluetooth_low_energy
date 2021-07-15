# Bluetooth Low Energy

A bluetooth low energy plugin for flutter, which can be used to develope central role apps.

## Features

### Central APIs
- [x] Discover advertisements.
- [x] Connect/Disconnect to GATTs.
- [x] Read/Write/Notify characteristics.
- [x] Read/Write descriptors.

### Peripheral APIs
- [ ] Add/Send advertisements.
- [ ] Add services
- [ ] Add/Listen/Write characteristics
- [ ] Add/Listen/Write descriptors.
- [ ] Listen GATT connect/disconnect events.

## Getting Started

Add `bluetooth_low_energy` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

```
dependencies:
  bluetooth_low_energy: ^<latest-version>
```

*Note*: Bluetooth Low Energy doesn't work on Android emulators, so use physical devices which has bluetooth features for development.

### Android

Make sure you have a `miniSdkVersion` with 21 or higher in your `android/app/build.gradle` file, now we only support Android 5.0 or above.

### iOS

Make sure you have a minimum deployment target of 9.0 or above, you can uncomment the first line `platform :ios, '9.0'` in your iOS project's `Podfile`.

## Issues

- Not support peripheral APIs for now.
