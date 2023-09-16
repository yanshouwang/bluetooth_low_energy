import 'dart:typed_data';

import 'advertisement.dart';
import 'bluetooth_low_energy_manager.dart';
import 'central.dart';
import 'event_args.dart';
import 'gatt_characteristic.dart';
import 'gatt_service.dart';

/// An object that manages and advertises peripheral services exposed by this app.
abstract class PeripheralManager extends BluetoothLowEnergyManager {
  /// Tells that the peripheral manager received a characteristic’s notify changed.
  Stream<NotifyGattCharacteristicCommandEventArgs>
      get notifyCharacteristicCommandReceived;

  /// Tells that the local peripheral received an Attribute Protocol (ATT) read request for a characteristic with a dynamic value.
  Stream<ReadGattCharacteristicCommandEventArgs>
      get readCharacteristicCommandReceived;

  /// Tells that the local peripheral device received an Attribute Protocol (ATT) write request for a characteristic with a dynamic value.
  Stream<WriteGattCharacteristicCommandEventArgs>
      get writeCharacteristicCommandReceived;

  Future<void> addService(GattService service);
  Future<void> removeService(GattService service);
  Future<void> removeAllServices();
  Future<void> startAdvertising(Advertisement advertisement);
  Future<void> stopAdvertising();
  Future<void> sendReadCharacteristicReply(
    Central central,
    GattCharacteristic characteristic,
    int status,
    Uint8List value,
  );
  Future<void> sendWriteCharacteristicReply(
    Central central,
    GattCharacteristic characteristic,
    int status,
  );
  Future<void> sendCharacteristicValueChanged(
    Central central,
    GattCharacteristic characteristic,
    Uint8List value,
  );
}
