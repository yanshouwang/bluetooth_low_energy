import 'dart:async';

import 'package:bluetooth_low_energy_android/src/bluetooth_low_energy_android.g.dart'
    as api;
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

base mixin BluetoothLowEnergyManagerImpl on BluetoothLowEnergyManager {
  api.BluetoothLowEnergyAndroidPlugin get bluetoothLowEnergyAndroidPlugin;
  Future<api.PackageManager> get packageManager;
  Future<api.BluetoothAdapter> get adapter;

  api.Permission get permission;

  api.Context get context => bluetoothLowEnergyAndroidPlugin.applicationContext;
  Future<api.Activity?> get activity =>
      bluetoothLowEnergyAndroidPlugin.getActivity();
  int get requestCode => permission.index;

  @override
  // TODO: implement stateChanged
  Stream<BluetoothLowEnergyStateChangedEvent> get stateChanged =>
      throw UnimplementedError();

  @override
  // TODO: implement nameChanged
  Stream<NameChangedEvent> get nameChanged => throw UnimplementedError();

  @override
  Future<BluetoothLowEnergyState> getState() async {
    final packageManager = await this.packageManager;
    final hasBluetoothLowEnergy =
        await packageManager.hasSystemFeature(api.Feature.bluetoothLowEnergy);
    if (hasBluetoothLowEnergy) {
      final isGranted =
          await api.ContextCompat.checkSelfPermission(context, permission);
      if (isGranted) {
        final adapter = await this.adapter;
        final stateArgs = await adapter.getState();
        return stateArgs.obj;
      } else {
        return BluetoothLowEnergyState.unauthorized;
      }
    } else {
      return BluetoothLowEnergyState.unsupported;
    }
  }

  @override
  Future<String> getName() async {
    final adapter = await this.adapter;
    final name = await adapter.getName();
    return name;
  }

  @override
  Future<void> setName(String name) async {
    final adapter = await this.adapter;
    await adapter.setName(name);
    await nameChanged.first;
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

  Future<bool> _requestPermissions() async {
    final activity = await this.activity;
    if (activity == null) {
      throw ArgumentError.notNull();
    }
    final completer = Completer<bool>();
    final listener = api.RequestPermissionsResultListener(
      onRequestPermissionsResult: (_, requestCode, result) {
        if (requestCode != this.requestCode) {
          return;
        }
        completer.complete(result);
      },
    );
    await bluetoothLowEnergyAndroidPlugin
        .addRequestPermissionsResultListener(listener);
    try {
      await api.ActivityCompat.requestPermissions(
          activity, permission, requestCode);
      final isGranted = await completer.future;
      return isGranted;
    } finally {
      await bluetoothLowEnergyAndroidPlugin
          .removeRequestPermissionsResultListener(listener);
    }
  }
}

extension on api.BluetoothState {
  BluetoothLowEnergyState get obj {
    switch (this) {
      case api.BluetoothState.off:
        return BluetoothLowEnergyState.off;
      case api.BluetoothState.turningOn:
        return BluetoothLowEnergyState.turningOn;
      case api.BluetoothState.on:
        return BluetoothLowEnergyState.on;
      case api.BluetoothState.turningOff:
        return BluetoothLowEnergyState.turningOff;
    }
  }
}
