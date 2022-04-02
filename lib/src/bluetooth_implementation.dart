import 'dart:async';
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
import 'discovery.dart';
import 'uuid.dart';

const equality = ListEquality<int>();

class $Bluetooth implements Bluetooth {
  late final StreamController<BluetoothState> stateChangedController;
  late StreamSubscription<BluetoothState>? stateChangedSubscription;

  $Bluetooth() {
    stateChangedController = StreamController<BluetoothState>.broadcast(
      onListen: () {
        stateChangedSubscription = eventStream.where((event) {
          return event.category ==
              messages.EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED;
        }).map((event) {
          final value = event.bluetoothStateChangedArguments.state.value;
          return BluetoothState.values[value];
        }).listen(
          (state) => stateChangedController.add(state),
          onError: (error, stack) =>
              stateChangedController.addError(error, stack),
          onDone: () => stateChangedController.close(),
        );
        final command = messages.Command(
          category: messages
              .CommandCategory.COMMAND_CATEGORY_BLUETOOTH_LISTEN_STATE_CHANGED,
        );
        methodChannel.invoke(command).catchError((error, stack) {
          stateChangedController.addError(error, stack);
        });
      },
      onCancel: () {
        final command = messages.Command(
          category: messages
              .CommandCategory.COMMAND_CATEGORY_BLUETOOTH_CANCEL_STATE_CHANGED,
        );
        methodChannel
            .invoke(command)
            .whenComplete(() => stateChangedSubscription?.cancel());
      },
    );
  }

  @override
  Future<void> authorize() {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_AUTHORIZE,
    );
    return methodChannel.invoke(command);
  }

  @override
  Future<BluetoothState> getState() {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE,
    );
    return methodChannel.invoke(command).then((reply) {
      final state = reply!.bluetoothGetStateArguments.state;
      return BluetoothState.values[state.value];
    });
  }

  @override
  Stream<BluetoothState> get stateChanged => stateChangedController.stream;
}

class $Central extends $Bluetooth implements Central {
  @override
  Stream<Discovery> startDiscovery({List<UUID>? uuids}) {
    late final StreamController<Discovery> controller;
    late final StreamSubscription<Discovery> subscription;
    controller = StreamController<Discovery>.broadcast(
      onListen: () {
        subscription = eventStream.where((event) {
          return event.category ==
              messages.EventCategory.EVENT_CATEGORY_CENTRAL_DISCOVERED;
        }).map((event) {
          final discovery = event.centralDiscoveredArguments.discovery;
          return $Discovery.fromMessage(discovery);
        }).listen(
          (discovery) => controller.add(discovery),
          onError: (error, stack) => controller.addError(error, stack),
          onDone: () => controller.close(),
        );
        final command = messages.Command(
          category:
              messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_START_DISCOVERY,
          centralStartDiscoveryArguments:
              messages.CentralStartDiscoveryCommandArguments(
            uuids: uuids?.map((uuid) => uuid.name),
          ),
        );
        methodChannel.invoke(command).catchError((error, stack) {
          controller.addError(error, stack);
        });
      },
      onCancel: () {
        final command = messages.Command(
          category:
              messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY,
        );
        methodChannel.invoke(command).catchError((error, stack) {
          controller.addError(error, stack);
        });
        subscription.cancel();
      },
    );
    return controller.stream;
  }

  @override
  Future<GATT> connect(
    UUID uuid, {
    required void Function(int errorCode) onConnectionLost,
  }) {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
      centralConnectArguments: messages.CentralConnectCommandArguments(
        uuid: uuid.name,
      ),
    );
    return methodChannel.invoke(command).then((reply) {
      final gatt = reply!.centralConnectArguments.gatt;
      final subscription = eventStream
          .where((event) {
            return event.category ==
                    messages
                        .EventCategory.EVENT_CATEGORY_GATT_CONNECTION_LOST &&
                event.gattConnectionLostArguments.id == gatt.id;
          })
          .map((event) => event.gattConnectionLostArguments.errorCode)
          .listen((errorCode) => onConnectionLost(errorCode));
      return $GATT.fromMessage(gatt, subscription);
    });
  }
}

class $Discovery implements Discovery {
  @override
  final UUID uuid;
  @override
  final int rssi;
  @override
  final Map<int, Uint8List> advertisements;
  @override
  final bool connectable;

  $Discovery(
    this.uuid,
    this.rssi,
    this.advertisements,
    this.connectable,
  );

  factory $Discovery.fromMessage(messages.Discovery discovery) {
    final uuid = $UUID.fromString(discovery.uuid);
    final rssi = discovery.rssi;
    final advertisements = <int, Uint8List>{};
    var start = 0;
    while (start < discovery.advertisements.length) {
      final length = discovery.advertisements[start++];
      if (length == 0) break;
      final end = start + length;
      final key = discovery.advertisements[start++];
      final elements = discovery.advertisements.sublist(start, end);
      final value = Uint8List.fromList(elements);
      start = end;
      advertisements[key] = value;
    }
    final connectable = discovery.connectable;
    return $Discovery(uuid, rssi, advertisements, connectable);
  }
}

class $UUID implements UUID {
  @override
  final Uint8List value;
  @override
  final String name;
  @override
  final int hashCode;

  $UUID(this.name, this.value) : hashCode = equality.hash(value);

  $UUID.fromName(String name) : this(name, name.value);

  $UUID.fromString(String uuidString) : this.fromName(uuidString.name);

  @override
  String toString() => name;

  @override
  bool operator ==(other) {
    return other is UUID && equality.equals(other.value, value);
  }
}

class $GATT implements GATT {
  final String id;
  @override
  final int maximumWriteLength;
  @override
  final Map<UUID, GattService> services;
  final StreamSubscription<int> subscription;

  $GATT(this.id, this.maximumWriteLength, this.services, this.subscription);

  factory $GATT.fromMessage(
    messages.GATT gatt,
    StreamSubscription<int> subscription,
  ) {
    final id = gatt.id;
    final maximumWriteLength = gatt.maximumWriteLength;
    final services = <UUID, GattService>{
      for (var service in gatt.services)
        $UUID.fromString(service.uuid): $GattService.fromMessage(id, service)
    };
    return $GATT(id, maximumWriteLength, services, subscription);
  }

  @override
  Future<void> disconnect() {
    subscription.cancel();
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_GATT_DISCONNECT,
      gattDisconnectArguments: messages.GattDisconnectCommandArguments(
        id: id,
      ),
    );
    return methodChannel.invoke(command);
  }
}

class $GattService implements GattService {
  final String gattId;
  final String id;
  @override
  final UUID uuid;
  @override
  final Map<UUID, GattCharacteristic> characteristics;

  $GattService(
    this.gattId,
    this.id,
    this.uuid,
    this.characteristics,
  );

  factory $GattService.fromMessage(
    String gattId,
    messages.GattService service,
  ) {
    final id = service.id;
    final uuid = $UUID.fromString(service.uuid);
    final characteristics = {
      for (var characteristic in service.characteristics)
        $UUID.fromString(characteristic.uuid):
            $GattCharacteristic.fromMessage(gattId, id, characteristic)
    };
    return $GattService(gattId, id, uuid, characteristics);
  }
}

class $GattCharacteristic implements GattCharacteristic {
  final String gattId;
  final String serviceId;
  final String id;
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
    this.gattId,
    this.serviceId,
    this.id,
    this.uuid,
    this.canRead,
    this.canWrite,
    this.canWriteWithoutResponse,
    this.canNotify,
    this.descriptors,
  );

  factory $GattCharacteristic.fromMessage(
    String gattId,
    String serviceId,
    messages.GattCharacteristic characteristic,
  ) {
    final id = characteristic.id;
    final uuid = $UUID.fromString(characteristic.uuid);
    final canRead = characteristic.canRead;
    final canWrite = characteristic.canWrite;
    final canWriteWithoutResponse = characteristic.canWriteWithoutResponse;
    final canNotify = characteristic.canNotify;
    final descriptors = {
      for (var descriptor in characteristic.descriptors)
        $UUID.fromString(descriptor.uuid): $GattDescriptor.fromMessage(
          gattId,
          serviceId,
          id,
          descriptor,
        )
    };
    return $GattCharacteristic(
      gattId,
      serviceId,
      id,
      uuid,
      canRead,
      canWrite,
      canWriteWithoutResponse,
      canNotify,
      descriptors,
    );
  }

  @override
  Future<Uint8List> read() {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_READ,
      characteristicReadArguments: messages.CharacteristicReadCommandArguments(
        gattId: gattId,
        serviceId: serviceId,
        id: id,
      ),
    );
    return methodChannel.invoke(command).then((reply) {
      final elements = reply!.characteristicReadArguments.value;
      return Uint8List.fromList(elements);
    });
  }

  @override
  Future<void> write(Uint8List value, {bool withoutResponse = false}) {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_WRITE,
      characteristicWriteArguments:
          messages.CharacteristicWriteCommandArguments(
        gattId: gattId,
        serviceId: serviceId,
        id: id,
        value: value,
        withoutResponse: withoutResponse,
      ),
    );
    return methodChannel.invoke(command);
  }

  StreamController<Uint8List>? notifiedController;

  @override
  Stream<Uint8List> get notify {
    late final StreamController<Uint8List> controller;
    late final StreamSubscription<Uint8List> subscription;
    final notifiedController = this.notifiedController;
    if (notifiedController == null) {
      controller = StreamController<Uint8List>.broadcast(
        onListen: () {
          subscription = eventStream.where((event) {
            return event.category ==
                    messages
                        .EventCategory.EVENT_CATEGORY_CHARACTERISTIC_NOTIFIED &&
                event.characteristicNotifiedArguments.gattId == gattId &&
                event.characteristicNotifiedArguments.serviceId == serviceId &&
                event.characteristicNotifiedArguments.id == id;
          }).map((event) {
            final elements = event.characteristicNotifiedArguments.value;
            return Uint8List.fromList(elements);
          }).listen(
            (value) => controller.add(value),
            onError: (error, stack) => controller.addError(error, stack),
            onDone: () => controller.close(),
          );
          final command = messages.Command(
            category:
                messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_NOTIFY,
            characteristicNotifyArguments:
                messages.CharacteristicNotifyCommandArguments(
              gattId: gattId,
              serviceId: serviceId,
              id: id,
            ),
          );
          methodChannel.invoke(command).catchError((error, stack) {
            controller.addError(error, stack);
          });
        },
        onCancel: () {
          final command = messages.Command(
            category: messages
                .CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_CANCEL_NOTIFY,
            characteristicCancelNotifyArguments:
                messages.CharacteristicCancelNotifyCommandArguments(
              gattId: gattId,
              serviceId: serviceId,
              id: id,
            ),
          );
          methodChannel
              .invoke(command)
              .whenComplete(() => subscription.cancel());
        },
      );
      this.notifiedController = controller;
    } else {
      controller = notifiedController;
    }
    return controller.stream;
  }
}

class $GattDescriptor implements GattDescriptor {
  final String gattId;
  final String serviceId;
  final String characteristicId;
  final String id;
  @override
  final UUID uuid;

  $GattDescriptor(
    this.gattId,
    this.serviceId,
    this.characteristicId,
    this.id,
    this.uuid,
  );

  factory $GattDescriptor.fromMessage(
    String gattId,
    String serviceId,
    String characteristicId,
    messages.GattDescriptor descriptor,
  ) {
    final id = descriptor.id;
    final uuid = $UUID.fromString(descriptor.uuid);
    return $GattDescriptor(
      gattId,
      serviceId,
      characteristicId,
      id,
      uuid,
    );
  }

  @override
  Future<Uint8List> read() {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_DESCRIPTOR_READ,
      descriptorReadArguments: messages.DescriptorReadCommandArguments(
        gattId: gattId,
        serviceId: serviceId,
        characteristicId: characteristicId,
        id: id,
      ),
    );
    return methodChannel.invoke(command).then((reply) {
      final elements = reply!.descriptorReadArguments.value;
      return Uint8List.fromList(elements);
    });
  }

  @override
  Future<void> write(Uint8List value) {
    final command = messages.Command(
      category: messages.CommandCategory.COMMAND_CATEGORY_DESCRIPTOR_WRITE,
      descriptorWriteArguments: messages.DescriptorWriteCommandArguments(
        gattId: gattId,
        serviceId: serviceId,
        characteristicId: characteristicId,
        id: id,
        value: value,
      ),
    );
    return methodChannel.invoke(command);
  }
}

extension on String {
  String get name {
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

  Uint8List get value {
    final from = RegExp(r'-');
    final encoded = replaceAll(from, '');
    final elements = hex.decode(encoded);
    return Uint8List.fromList(elements);
  }
}
