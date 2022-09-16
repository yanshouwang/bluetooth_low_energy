import 'bluetooth_low_energy_impl.dart';
import 'api.dart';
import 'pigeon.dart';

class BluetoothLowEnergyPlugin {
  static void registerWith() {
    // Registers the central manager API.
    final centralManagerApi = MyCentralManagerApi();
    CentralManagerFlutterApi.setup(centralManagerApi);
    CentralManagerApi.instance = centralManagerApi;
    // Registers the peripheral API.
    final peripheralApi = MyPeripheralApi();
    PeripheralFlutterApi.setup(peripheralApi);
    PeripheralApi.instance = peripheralApi;
    // Registers the GATT service API.
    final gattServiceApi = MyGattServiceApi();
    GattServiceApi.instance = gattServiceApi;
    // Registers the GATT characteristic API.
    final gattCharacteristicApi = MyGattCharacteristicApi();
    GattCharacteristicFlutterApi.setup(gattCharacteristicApi);
    GattCharacteristicApi.instance = MyGattCharacteristicApi();
    // Registers the GATT descriptor API.
    final gattDescriptorApi = MyGattDescriptorApi();
    GattDescriptorApi.instance = gattDescriptorApi;
  }
}

class BluetoothLowEnergyPluginAndroid {
  static void registerWith() {
    BluetoothLowEnergyPlugin.registerWith();
  }
}

class BluetoothLowEnergyPluginIOS {
  static void registerWith() {
    BluetoothLowEnergyPlugin.registerWith();
  }
}
