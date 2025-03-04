import 'package:bluetooth_low_energy_android/src/bluetooth_low_energy_android.g.dart'
    as api;
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

base mixin BluetoothLowEnergyManagerImpl on BluetoothLowEnergyManager {
  api.BluetoothLowEnergyAndroidPlugin get bluetoothLowEnergyAndroidPlugin;
  Future<api.PackageManager> get packageManager;
  Future<api.BluetoothAdapter> get adapter;

  api.Context get context => bluetoothLowEnergyAndroidPlugin.applicationContext;

  Future<api.Activity?> getActivity() =>
      bluetoothLowEnergyAndroidPlugin.getActivity();

  api.Permission get permission;

  @override
  // TODO: implement stateChanged
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
      throw UnimplementedError();

  @override
  // TODO: implement nameChanged
  Stream<NameChangedEvent> get nameChanged => throw UnimplementedError();

  @override
  Future<BluetoothLowEnergyState> getState() async {
    final packageManager = await context.getPackageManager();
    final hasBluetoothLowEnergy = await packageManager
        .hasSystemFeature(api.FeatureArgs.bluetoothLowEnergy);
    if (hasBluetoothLowEnergy) {
      final isGranted =
          await api.ContextCompat.checkSelfPermission(context, permission);
      if (isGranted) {
        final adapter = await this.adapter;
        final stateArgs = await adapter.getState();
      } else {
        return BluetoothLowEnergyState.unauthorized;
      }
    } else {
      return BluetoothLowEnergyState.unsupported;
    }
  }

  @override
  Future<bool> authorize() {
    // TODO: implement authorize
    throw UnimplementedError();
  }

  @override
  Future<void> showAppSettings() {
    // TODO: implement showAppSettings
    throw UnimplementedError();
  }

  @override
  Future<String> getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  Future<void> setName(String name) {
    // TODO: implement setName
    throw UnimplementedError();
  }

  @override
  Future<void> turnOn() {
    // TODO: implement turnOn
    throw UnimplementedError();
  }

  @override
  Future<void> turnOff() {
    // TODO: implement turnOff
    throw UnimplementedError();
  }
}
