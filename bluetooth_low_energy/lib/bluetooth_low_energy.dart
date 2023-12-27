/// A Flutter plugin for controlling the bluetooth low energy, supports central
/// and peripheral apis.
library bluetooth_low_energy;

export 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart'
    hide
        MyBluetoothLowEnergyPeer,
        MyCentral,
        MyPeripheral,
        MyGattAttribute,
        MyGattAttributeUint8List,
        MyGattDescriptor,
        MyGattCharacteristic,
        MyGattService;
