import 'dart:async';
import 'dart:typed_data';

import 'central_manager_state.dart';
import 'event_args.dart';
import 'gatt_characteristic.dart';
import 'gatt_characteristic_write_type.dart';
import 'gatt_descriptor.dart';
import 'gatt_service.dart';
import 'peripheral.dart';

abstract class CentralManager {
  Stream<CentralManagerStateChangedEventArgs> get stateChanged;
  Stream<DiscoveredEventArgs> get discovered;
  Stream<PeripheralStateChangedEventArgs> get peripheralStateChanged;
  Stream<GattCharacteristicValueChangedEventArgs>
      get characteristicValueChanged;

  Future<CentralManagerState> getState();
  Future<void> startDiscovery();
  Future<void> stopDiscovery();
  Future<void> connect(Peripheral peripheral);
  void disconnect(Peripheral peripheral);
  Future<void> discoverServices(Peripheral peripheral);
  Future<List<GattService>> getServices(Peripheral peripheral);
  Future<List<GattCharacteristic>> getCharacteristics(GattService service);
  Future<List<GattDescriptor>> getDescriptors(
    GattCharacteristic characteristic,
  );
  Future<Uint8List> readCharacteristic(GattCharacteristic characteristic);
  Future<void> writeCharacteristic(
    GattCharacteristic characteristic, {
    required Uint8List value,
    required GattCharacteristicWriteType type,
  });
  Future<void> notifyCharacteristic(
    GattCharacteristic characteristic, {
    required bool state,
  });
  Future<Uint8List> readDescriptor(GattDescriptor descriptor);
  Future<void> writeDescriptor(
    GattDescriptor descriptor, {
    required Uint8List value,
  });
}
