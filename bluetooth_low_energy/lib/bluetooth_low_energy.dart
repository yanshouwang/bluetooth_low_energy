/// A Flutter plugin for controlling the bluetooth low energy, supports central
/// and peripheral apis.
library;

export 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart'
    hide
        MyCentralManager,
        MyPeripheralManager,
        MyObject,
        MyCentral,
        MyPeripheral,
        MyGattService,
        MyGattCharacteristic,
        MyGattDescriptor;
