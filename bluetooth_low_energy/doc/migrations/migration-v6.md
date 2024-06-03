# Migrate form 5.x to 6.x


## Capitalization Rules

* `GattCharacteristicNotifiedEventArgs` -> `GATTCharacteristicNotifiedEventArgs`
* `GattAttribute` -> `GATTAttribute`
* `GattDescriptor` -> `GATTDescriptor`
* `GattCharacteristic` -> `GATTCharacteristic `
* `GattCharacteristicProperty` -> `GATTCharacteristicProperty`
* `GattCharacteristicWriteType` -> `GATTCharacteristicWriteType`
* `GattService` -> `GATTService`
* `GattCharacteristicNotifyStateChangedEventArgs` -> `GATTCharacteristicNotifyStateChangedEventArgs`

## CentralManager

1. Use the factory method to get the instance.

``` Dart
// 5.x
// final centralManager = CentralManager.instance;
// 6.x
final centralManager = CentralManager();
```

2. The `setUp` method is removed.

``` Dart
// 5.x
// await centralManager.setUp();
```

3. Authorize manually on Android.

``` Dart
// The authorize method is no longer called automatically on Android 
// after 6.x, listen the stateChanged stream and call the authorize
// method when the state is unauthorized.
final stateChangedSubscription = centralManager.stateChanged.listen((eventArgs) async {
    final state = eventArgs.state;
    if (Platform.isAndroid && state == BluetoothLowEnergyState.unauthorized) {
        await centralManager.authorize();
    }
    this.state.value = state;
});
```

4. The type of `manufacturerSpecificData` in `Advertisement` changed from `ManufacturerSpecificData` to `List<ManufacturerSpecificData>`.

``` Dart
// 5.x
final manufacturerSpecificData = advertisement.manufacturerSpecificData; // ManufacturerSpecificData
// 6.0
final manufacturerSpecificData = advertisement.manufacturerSpecificData; // List<ManufacturerSpecificData>
```

5. Request MTU manually on Android.

``` Dart
// The mtu is no longer requested automatically on Android
// after 6.x, call the requestMTU method after connected.
await centralManager.connect(peripheral);
services.value = await centralManager.discoverGATT(peripheral);
if (Platform.isAndroid) {
    await centralManager.requestMTU(
        peripheral,
        mtu: 517,
    );
}
```

6. Fragment the value manually when write characteristics.

``` Dart
// The value is no longer fragmented automatically after
// 6.x, fragment the value with the maximum write length.
final fragmentSize = await centralManager.getMaximumWriteLength(
    peripheral,
    type: type,
);
var start = 0;
while (start < value.length) {
    final end = start + fragmentSize;
    final fragmentedValue = end < value.length
        ? value.sublist(start, end)
        : value.sublist(start);
    await centralManager.writeCharacteristic(
        peripheral,
        characteristic,
        value: fragmentedValue,
        type: type,
    );
    start = end;
}
```

## PeripheralManager


1. Use the factory method to get the instance.

``` Dart
// 5.x
// final peripheralManager = PeripheralManager.instance;
// 6.x
final peripheralManager = PeripheralManager();
```

2. The `setUp` method is removed.

``` Dart
// 5.x
// await peripheralManager.setUp();
```

3. Authorize manually on Android.

``` Dart
// The authorize method is no longer called automatically on Android 
// after 6.x, listen the stateChanged stream and call the authorize
// method when the state is unauthorized.
final stateChangedSubscription = peripheralManager.stateChanged.listen((eventArgs) async {
    final state = eventArgs.state;
    if (Platform.isAndroid && state == BluetoothLowEnergyState.unauthorized) {
        await peripheralManager.authorize();
    }
    this.state.value = state;
});
```

4. Use the factory methods to create GATTService and GATTDescriptor.

``` Dart
// 5.x
// final service = GattService(
//     uuid: serviceUUID,
//     characteristics: [
//         GattCharacteristic(
//             uuid: characteristicUUID,
//             properties: [
//                 GattCharacteristicProperty.read,
//                 GattCharacteristicProperty.write,
//                 GattCharacteristicProperty.writeWithoutResponse,
//                 GattCharacteristicProperty.notify,
//                 GattCharacteristicProperty.indicate,
//             ],
//             value: characteristicValue,
//             descriptors: [
//                 GattDescriptor(
//                     uuid: descriptorUUID,
//                     value: descriptorValue, 
//                 ),
//             ],
//         ),
//       ],
//     );
// 6.x
final service = GATTService(
    uuid: serviceUUID,
    characteristics: [
        GATTCharacteristic.immutable(
            uuid: immutableCharacteristicUUID,
            value: immutableCharacteristicValue,
            descriptors: [
                GATTDescriptor.immutable(
                    uuid: immutableDescriptorUUID,
                    value: immutableDescriptorValue,
                ),
            ]
        ),
        GATTCharacteristic.mutable(
            uuid: mutableCharacteristicUUID,
            properties: [
                GATTCharacteristicProperty.read,
                GATTCharacteristicProperty.write,
                GATTCharacteristicProperty.writeWithoutResponse,
                GATTCharacteristicProperty.notify,
                GATTCharacteristicProperty.indicate,
            ],
            permissions: [
                GATTCharacteristicPermission.read,
                GATTCharacteristicPermission.write,
            ],
            descriptors: [
                // This is not supported on iOS and macOS.
                GATTDescriptor.mutable(
                    uuid: mutableDescriptorUUID,
                    permissions: [
                        GATTCharacteristicPermission.read,
                        GATTCharacteristicPermission.write,
                        ],
                ),
            ]
        ),
    ],
);
```

5. The type of `manufacturerSpecificData` in `Advertisement` changed from `ManufacturerSpecificData` to `List<ManufacturerSpecificData>`.

``` Dart
// 5.x
final advertisement = Advertisement(
    manufacturerSpecificData: ManufacturerSpecificData(
        id: 0x2e19,
        data: Uint8List.fromList([0x01, 0x02, 0x03]),
    ),
);
// 6.x
final advertisement = Advertisement(
    manufacturerSpecificData: [
        ManufacturerSpecificData(
            id: 0x2e19,
            data: Uint8List.fromList([0x01, 0x02, 0x03]),
        ),
    ],
);
```

6. Respond read and write requests manually.

``` Dart
// The read and write requests are no longer responded automatically 
// after 6.x, listen the characteristicReadRequested,
// characteristicWriteRequested, descriptorReadRequested and
// descriptorWriteRequested, then respond the requests.

// 5.x
// final characteristicReadSubscription = PeripheralManager.instance.characteristicRead.listen((eventArgs) async {
// });
// final characteristicWrittenSubscription = PeripheralManager.instance.characteristicWritten.listen((eventArgs) // async {
// });

// 6.x
// These streams are only available when the characteristic is mutable.
final characteristicReadRequestedSubscription = peripheralManager.characteristicReadRequested.listen((eventArgs) async {
    final central = eventArgs.central;
    final characteristic = eventArgs.characteristic;
    final request = eventArgs.request;
    final offset = request.offset;
    final trimmedValue = value.sublist(offset);
    await peripheralManager.respondReadRequestWithValue(
        request,
        value: trimmedValue,
    );
});
final characteristicWriteRequestedSubscription = peripheralManager.characteristicWriteRequested.listen((eventArgs) async {
    final central = eventArgs.central;
    final characteristic = eventArgs.characteristic;
    final request = eventArgs.request;
    final offset = request.offset;
    final value = request.value;
    await peripheralManager.respondWriteRequest(request);
});
```

7. Fragment the value manually when notify characteristics.

``` Dart
// The value is no longer fragmented automatically after
// 6.x, fragment the value with the maximum notify length.
final fragmentSize = await peripheralManager.getMaximumNotifyLength(
    peripheral,
    type: type,
);
var start = 0;
while (start < value.length) {
    final end = start + fragmentSize;
    final fragmentedValue = end < value.length
        ? value.sublist(start, end)
        : value.sublist(start);
    await peripheralManager.notifyCharacteristic(
        central,
        characteristic,
        value: value,
        );
    start = end;
}
```
