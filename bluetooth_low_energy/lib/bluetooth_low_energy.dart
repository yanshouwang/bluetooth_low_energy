/// A Flutter plugin for controlling the bluetooth low energy, supports central
/// and peripheral apis.
library;

export 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart'
    hide
        PlatformBluetoothLowEnergyManager,
        PlatformCentralManager,
        PlatformPeripheralManager,
        MutableGATTCharacteristic,
        ImmutableGATTCharacteristic,
        MutableGATTDescriptor,
        ImmutableGATTDescriptor;
