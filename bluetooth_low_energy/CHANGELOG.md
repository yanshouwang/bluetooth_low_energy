## 2.0.5

- Add `CentralController#getMaximumWriteLength` method.

## 2.0.3

- `Android` Migrate to Android 13.
- `Android` Fix the issuce that receive wrong values caused by unsafe memory, see https://developer.android.com/reference/android/bluetooth/BluetoothGattCallback#onCharacteristicChanged(android.bluetooth.BluetoothGatt,%20android.bluetooth.BluetoothGattCharacteristic)

## 2.0.2

- Combine iOS and macOS projects.
- Optimize project structure.

## 2.0.1

- Fix the issue that GATTs is cleared after peripheral disconnected on iOS and macOS.
- Fix the issue that create UUID form peripheral's address failed on Linux.
- Fix the issue that instance match failed on Linux.

## 2.0.0

- Rewrite the whole project with federated plugins.
- Support macOS and Linux.

## 1.1.0

- Fix the crash by onMtuChanged called multi-times on Android.
- Fix the finalizer doesn't work issue.
- Make some break changes.

## 1.0.0

- Upgrade to flutter 3.x.
- Rewrite the whole project with pigeon.

## 0.1.0

- Add implementations on iOS.
- Combine available and state for Bluetooth.
- Add connectable for Discovery.
- Add maximumWriteLength for GATT.

## 0.0.2

- Fix connect blocked when bluetooth closed.
- Fix wrong repository url.
- Move all example files to main.dart.

## 0.0.1

- Add central APIs.
- Add implementations on Android.
- Add example.
- Add test.
