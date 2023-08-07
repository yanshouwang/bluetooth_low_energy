import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';

import 'my_api.dart';
import 'my_gatt_characteristic.dart';
import 'my_gatt_descriptor.dart';
import 'my_gatt_service.dart';
import 'my_object.dart';

class MyCentralController extends MyObject implements CentralController {
  MyCentralController(super.hashCode);

  @override
  Stream<CentralControllerStateChangedEventArgs> get stateChanged =>
      myCentralControllerApi.stateChanged
          .where((eventArgs) => eventArgs.controller == this);

  @override
  Stream<CentralControllerDiscoveredEventArgs> get discovered =>
      myCentralControllerApi.discovered
          .where((eventArgs) => eventArgs.controller == this);

  @override
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged =>
      myCentralControllerApi.peripheralStateChanged
          .where((eventArgs) => eventArgs.controller == this);

  @override
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged =>
          myCentralControllerApi.characteristicValueChanged
              .where((eventArgs) => eventArgs.controller == this);

  @override
  Future<CentralControllerState> getState() async {
    final rawState = await myCentralControllerApi.getState(hashCode);
    return CentralControllerState.values[rawState];
  }

  @override
  Future<void> startDiscovery() {
    return myCentralControllerApi.startDiscovery(hashCode);
  }

  @override
  Future<void> stopDiscovery() {
    return myCentralControllerApi.stopDiscovery(hashCode);
  }

  @override
  Future<void> connect(Peripheral peripheral) {
    return myCentralControllerApi.connect(hashCode, peripheral.hashCode);
  }

  @override
  void disconnect(Peripheral peripheral) {
    myCentralControllerApi.disconnect(hashCode, peripheral.hashCode).ignore();
  }

  @override
  Future<List<GattService>> discoverServices(Peripheral peripheral) async {
    final hashCodes = await myCentralControllerApi.discoverServices(
      hashCode,
      peripheral.hashCode,
    );
    return hashCodes
        .whereType<int>()
        .map((hashCode) => MyGattService(hashCode))
        .toList();
  }

  @override
  Future<List<GattCharacteristic>> discoverCharacteristics(
    GattService service,
  ) async {
    final hashCodes = await myCentralControllerApi.discoverCharacteristics(
      hashCode,
      service.hashCode,
    );
    return hashCodes
        .whereType<int>()
        .map((hashCode) => MyGattCharacteristic(hashCode))
        .toList();
  }

  @override
  Future<List<GattDescriptor>> discoverDescriptors(
    GattCharacteristic characteristic,
  ) async {
    final hashCodes = await myCentralControllerApi.discoverDescriptors(
      hashCode,
      characteristic.hashCode,
    );
    return hashCodes
        .whereType<int>()
        .map((hashCode) => MyGattDescriptor(hashCode))
        .toList();
  }

  @override
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic) {
    return myCentralControllerApi.readCharacteristic(
      hashCode,
      characteristic.hashCode,
    );
  }

  @override
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  }) {
    return myCentralControllerApi.writeCharacteristic(
      hashCode,
      characteristic.hashCode,
      value,
      type.index,
    );
  }

  @override
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  }) {
    return myCentralControllerApi.notifyCharacteristic(
      hashCode,
      characteristic.hashCode,
      state,
    );
  }

  @override
  Future<Uint8List> readDescriptor(GattDescriptor descriptor) {
    return myCentralControllerApi.readDescriptor(hashCode, descriptor.hashCode);
  }

  @override
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  }) {
    return myCentralControllerApi.writeDescriptor(
      hashCode,
      descriptor.hashCode,
      value,
    );
  }
}
