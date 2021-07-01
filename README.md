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

### Android

Make sure you have a `miniSdkVersion` with 21 or higher in your `android/app/build.gradle` file, now we only support Android 5.0 or above.

*Note*: Bluetooth Low Energy doesn't work on Android emulators, so use physical devices which has bluetooth features for development.

### iOS

TO BE DONE.

## Issues

- Only support Android for now, iOS will available as soon as possible.
- Only support central APIs for now.
