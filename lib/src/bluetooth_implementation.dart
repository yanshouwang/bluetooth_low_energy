import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:convert/convert.dart';

import 'bluetooth.dart';
import 'bluetooth_state.dart';
import 'central.dart';
import 'channels.dart';
import 'gatt.dart';
import 'gatt_service.dart';
import 'gatt_characteristic.dart';
import 'gatt_descriptor.dart';
import 'messages.dart' as messages;
import 'peripheral_discovery.dart';
import 'uuid.dart';

const uuidEquality = ListEquality<int>();

class $Bluetooth implements Bluetooth {
  @override
  Future<BluetoothState> getState() {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE,
    );
    return methodChannel
        .invokeCommand<int>(command)
        .then((value) => BluetoothState.values[value!]);
  }

  @override
  Stream<BluetoothState> get stateChanged {
    return eventStream
        .where((event) =>
            event.category ==
            messages.EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED)
        .map((event) => event.bluetoothStateChangedArguments.state.toState());
  }
}

class $Central extends $Bluetooth implements Central {
  @override
  Stream<PeripheralDiscovery> get discovered {
    return eventStream
        .where((event) =>
            event.category ==
            messages.EventCategory.EVENT_CATEGORY_CENTRAL_DISCOVERED)
        .map((event) =>
            event.centralDiscoveredArguments.discovery.toDiscovery());
  }

  @override
  Future<void> startDiscovery({List<UUID>? uuids}) {
    final command = messages.Command(
      category:
          messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_START_DISCOVERY,
      centralStartDiscoveryArguments: messages.CentralStartDiscoveryArguments(
        uuids: uuids?.map((uuid) => uuid.name),
      ),
    );
    return methodChannel.invokeCommand<void>(command);
  }

  @override
  Future<void> stopDiscovery() {
    final command = messages.Command(
      category:
          messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY,
    );
    return methodChannel.invokeCommand<void>(command);
  }

  @override
  Future<GATT> connect(UUID uuid) {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
      centralConnectArguments: messages.CentralConnectArguments(
        uuid: uuid.name,
      ),
    );
    return methodChannel
        .invokeListCommand<int>(command)
        .then((elements) => messages.GATT.fromBuffer(elements!).toGATT());
  }
}

class $PeripheralDiscovery implements PeripheralDiscovery {
  @override
  final UUID uuid;
  @override
  final int rssi;
  @override
  final Map<int, Uint8List> advertisements;
  @override
  final bool connectable;

  $PeripheralDiscovery(
    this.uuid,
    this.rssi,
    this.advertisements,
    this.connectable,
  );
}

class $UUID implements UUID {
  @override
  final Uint8List value;
  @override
  final String name;
  @override
  final int hashCode;

  $UUID(String uuidString) : this.name(uuidString.toUuidName());

  $UUID.name(String name) : this.nameValue(name, name.toUuidValue());

  $UUID.nameValue(this.name, this.value) : hashCode = uuidEquality.hash(value);

  @override
  String toString() => name;

  @override
  bool operator ==(other) => other is UUID && other.hashCode == hashCode;
}

class $GATT implements GATT {
  final String indexedUUID;
  @override
  final int maximumWriteLength;
  @override
  final Map<UUID, GattService> services;

  $GATT(this.indexedUUID, this.maximumWriteLength, this.services);

  @override
  Stream<Exception> get connectionLost => eventStream
      .where((event) =>
          event.category ==
              messages.EventCategory.EVENT_CATEGORY_GATT_CONNECTION_LOST &&
          event.gattConnectionLostArguments.indexedUuid == indexedUUID)
      .map((event) => Exception(event.gattConnectionLostArguments.error));

  @override
  Future<void> disconnect() {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_GATT_DISCONNECT,
      gattDisconnectArguments: messages.GattDisconnectArguments(
        indexedUuid: indexedUUID,
      ),
    );
    return methodChannel.invokeCommand<void>(command);
  }
}

class $GattService implements GattService {
  final String indexedGattUUID;
  final String indexedUUID;
  @override
  final UUID uuid;
  @override
  final Map<UUID, GattCharacteristic> characteristics;

  $GattService(
    this.indexedGattUUID,
    this.indexedUUID,
    this.uuid,
    this.characteristics,
  );
}

class $GattCharacteristic implements GattCharacteristic {
  final String indexedGattUUID;
  final String indexedServiceUUID;
  final String indexedUUID;
  @override
  final UUID uuid;
  @override
  final bool canRead;
  @override
  final bool canWrite;
  @override
  final bool canWriteWithoutResponse;
  @override
  final bool canNotify;
  @override
  final Map<UUID, GattDescriptor> descriptors;

  $GattCharacteristic(
    this.indexedGattUUID,
    this.indexedServiceUUID,
    this.indexedUUID,
    this.uuid,
    this.canRead,
    this.canWrite,
    this.canWriteWithoutResponse,
    this.canNotify,
    this.descriptors,
  );

  @override
  Stream<Uint8List> get valueChanged => eventStream
      .where((event) =>
          event.category ==
              messages.EventCategory
                  .EVENT_CATEGORY_GATT_CHARACTERISTIC_VALUE_CHANGED &&
          event.characteristicValueChangedArguments.indexedGattUuid ==
              indexedGattUUID &&
          event.characteristicValueChangedArguments.indexedServiceUuid ==
              indexedServiceUUID &&
          event.characteristicValueChangedArguments.indexedUuid == indexedUUID)
      .map((event) =>
          Uint8List.fromList(event.characteristicValueChangedArguments.value));

  @override
  Future<Uint8List> read() {
    final command = messages.Command(
      category:
          messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_READ,
      characteristicReadArguments: messages.GattCharacteristicReadArguments(
        indexedGattUuid: indexedGattUUID,
        indexedServiceUuid: indexedServiceUUID,
        indexedUuid: indexedUUID,
      ),
    );
    return methodChannel
        .invokeListCommand<int>(command)
        .then((elements) => Uint8List.fromList(elements!));
  }

  @override
  Future<void> write(Uint8List value, {bool withoutResponse = false}) {
    final command = messages.Command(
      category:
          messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_WRITE,
      characteristicWriteArguments: messages.GattCharacteristicWriteArguments(
        indexedGattUuid: indexedGattUUID,
        indexedServiceUuid: indexedServiceUUID,
        indexedUuid: indexedUUID,
        value: value,
        withoutResponse: withoutResponse,
      ),
    );
    return methodChannel.invokeCommand<void>(command);
  }

  @override
  Future<void> notify(bool state) {
    final command = messages.Command(
      category:
          messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_NOTIFY,
      characteristicNotifyArguments: messages.GattCharacteristicNotifyArguments(
        indexedGattUuid: indexedGattUUID,
        indexedServiceUuid: indexedServiceUUID,
        indexedUuid: indexedUUID,
        state: state,
      ),
    );
    return methodChannel.invokeCommand<void>(command);
  }
}

class $GattDescriptor implements GattDescriptor {
  final String indexedGattUUID;
  final String indexedServiceUUID;
  final String indexedCharacteristicUUID;
  final String indexedUUID;
  @override
  final UUID uuid;

  $GattDescriptor(
    this.indexedGattUUID,
    this.indexedServiceUUID,
    this.indexedCharacteristicUUID,
    this.indexedUUID,
    this.uuid,
  );

  @override
  Future<Uint8List> read() {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_READ,
      descriptorReadArguments: messages.GattDescriptorReadArguments(
        indexedGattUuid: indexedGattUUID,
        indexedServiceUuid: indexedServiceUUID,
        indexedCharacteristicUuid: indexedCharacteristicUUID,
        indexedUuid: indexedUUID,
      ),
    );
    return methodChannel
        .invokeListCommand<int>(command)
        .then((elements) => Uint8List.fromList(elements!));
  }

  @override
  Future<void> write(Uint8List value) {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_WRITE,
      descriptorWriteArguments: messages.GattDescriptorWriteArguments(
        indexedGattUuid: indexedGattUUID,
        indexedServiceUuid: indexedServiceUUID,
        indexedCharacteristicUuid: indexedCharacteristicUUID,
        indexedUuid: indexedUUID,
        value: value,
      ),
    );
    return methodChannel.invokeCommand<void>(command);
  }
}

extension on messages.BluetoothState {
  BluetoothState toState() => BluetoothState.values[value];
}

extension on messages.PeripheralDiscovery {
  PeripheralDiscovery toDiscovery() {
    final uuid = $UUID(this.uuid);
    final advertisements = <int, Uint8List>{};
    var start = 0;
    while (start < this.advertisements.length) {
      final length = this.advertisements[start++];
      if (length == 0) break;
      final end = start + length;
      final key = this.advertisements[start++];
      final elements = this.advertisements.sublist(start, end);
      final value = Uint8List.fromList(elements);
      start = end;
      advertisements[key] = value;
    }
    return $PeripheralDiscovery(uuid, rssi, advertisements, connectable);
  }
}

extension on messages.GATT {
  GATT toGATT() {
    final services = <UUID, GattService>{
      for (var service in this.services)
        $UUID(service.uuid): service.toGattService(indexedUuid)
    };
    return $GATT(indexedUuid, maximumWriteLength, services);
  }
}

extension on messages.GattService {
  GattService toGattService(String gattIndexedUUID) {
    final uuid = $UUID(this.uuid);
    final characteristics = {
      for (var characteristic in this.characteristics)
        $UUID(characteristic.uuid): characteristic.toGattCharacteristic(
          gattIndexedUUID,
          indexedUuid,
        )
    };
    return $GattService(gattIndexedUUID, indexedUuid, uuid, characteristics);
  }
}

extension on messages.GattCharacteristic {
  GattCharacteristic toGattCharacteristic(
    String gattIndexedUUID,
    String gattServiceIndexedUUID,
  ) {
    final uuid = $UUID(this.uuid);
    final descriptors = {
      for (var descriptor in this.descriptors)
        $UUID(descriptor.uuid): descriptor.toGattDescriptor(
          gattIndexedUUID,
          gattServiceIndexedUUID,
          indexedUuid,
        )
    };
    return $GattCharacteristic(
      gattIndexedUUID,
      gattServiceIndexedUUID,
      indexedUuid,
      uuid,
      canRead,
      canWrite,
      canWriteWithoutResponse,
      canNotify,
      descriptors,
    );
  }
}

extension on messages.GattDescriptor {
  GattDescriptor toGattDescriptor(
    String gattIndexedUUID,
    String gattServiceIndexedUUID,
    String gattCharacteristicIndexedUUID,
  ) {
    final uuid = $UUID(this.uuid);
    return $GattDescriptor(
      gattIndexedUUID,
      gattServiceIndexedUUID,
      gattCharacteristicIndexedUUID,
      indexedUuid,
      uuid,
    );
  }
}

extension on String {
  String toUuidName() {
    final lowerCase = toLowerCase();
    final exp0 = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    if (exp0.hasMatch(lowerCase)) {
      return lowerCase;
    }
    final exp1 = RegExp(
      r'^[0-9a-f]{4}$',
      caseSensitive: false,
    );
    if (exp1.hasMatch(lowerCase)) {
      return '0000$lowerCase-0000-1000-8000-00805f9b34fb';
    }
    throw ArgumentError.value(this);
  }

  Uint8List toUuidValue() {
    final from = RegExp(r'-');
    final encoded = replaceAll(from, '');
    final elements = hex.decode(encoded);
    return Uint8List.fromList(elements);
  }
}
