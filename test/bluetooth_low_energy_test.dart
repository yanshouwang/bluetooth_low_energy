import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy/src/channels.dart' as util;
import 'package:bluetooth_low_energy/src/messages.dart' as messages;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final method = MethodChannel(util.methodChannel.name);
  final event = MethodChannel(util.eventChannel.name);
  final calls = <MethodCall>[];
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    calls.clear();
    method.setMockMethodCallHandler((call) async {
      calls.add(call);
      final command = messages.Command.fromBuffer(call.arguments);
      switch (command.category) {
        case messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE:
          return messages.BluetoothState.BLUETOOTH_STATE_POWERED_ON.value;
        case messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_START_DISCOVERY:
          return null;
        case messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY:
          return null;
        case messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT:
          final descriptors = [
            messages.GattDescriptor(
              indexedUuid: '0',
              uuid: '2900',
            ),
          ];
          final characteristics = [
            messages.GattCharacteristic(
              indexedUuid: '0',
              uuid: '2A00',
              descriptors: descriptors,
              canRead: true,
              canWrite: true,
              canWriteWithoutResponse: true,
              canNotify: true,
            ),
          ];
          final services = [
            messages.GattService(
              indexedUuid: '0',
              uuid: '1800',
              characteristics: characteristics,
            ),
          ];
          final gatt = messages.GATT(
            indexedUuid: '0',
            maximumWriteLength: 20,
            services: services,
          );
          return gatt.writeToBuffer();
        case messages.CommandCategory.COMMAND_CATEGORY_GATT_DISCONNECT:
          return null;
        case messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_READ:
          return [0x01, 0x02, 0x03, 0x04, 0x05];
        case messages
            .CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_WRITE:
          return null;
        case messages
            .CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_NOTIFY:
          return null;
        case messages.CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_READ:
          return [0x05, 0x04, 0x03, 0x02, 0x01];
        case messages.CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_WRITE:
          return null;
        default:
          throw UnimplementedError();
      }
    });
    event.setMockMethodCallHandler((call) async {
      switch (call.method) {
        case 'listen':
          final state = messages.Event(
            category:
                messages.EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED,
            bluetoothStateChangedArguments:
                messages.BluetoothStateChangedArguments(
              state: messages.BluetoothState.BLUETOOTH_STATE_POWERED_OFF,
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(state),
            (data) {},
          );
          final discovery = messages.Event(
            category: messages.EventCategory.EVENT_CATEGORY_CENTRAL_DISCOVERED,
            centralDiscoveredArguments: messages.CentralDiscoveredArguments(
              discovery: messages.PeripheralDiscovery(
                uuid: 'AABB',
                rssi: -50,
                advertisements: [
                  0x07,
                  0xff,
                  0xff,
                  0xee,
                  0xdd,
                  0xcc,
                  0xbb,
                  0xaa,
                ],
                connectable: true,
              ),
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(discovery),
            (data) {},
          );
          final connectionLost = messages.Event(
            category:
                messages.EventCategory.EVENT_CATEGORY_GATT_CONNECTION_LOST,
            gattConnectionLostArguments: messages.GattConnectionLostArguments(
              indexedUuid: '0',
              error: 'Connection lost.',
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(connectionLost),
            (data) {},
          );
          final characteristicValue = messages.Event(
            category: messages
                .EventCategory.EVENT_CATEGORY_GATT_CHARACTERISTIC_VALUE_CHANGED,
            characteristicValueChangedArguments:
                messages.GattCharacteristicValueChangedArguments(
              indexedGattUuid: '0',
              indexedServiceUuid: '0',
              indexedUuid: '0',
              value: [0x0A, 0x0B, 0x0C, 0x0D, 0x0E],
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(characteristicValue),
            (data) {},
          );
          break;
        case 'cancel':
          return null;
        default:
          throw UnimplementedError();
      }
    });
  });
  tearDown(() {
    method.setMockMethodCallHandler(null);
    event.setMockMethodCallHandler(null);
  });

  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE}',
    () async {
      final actual = await central.getState();
      expect(actual, BluetoothState.poweredOn);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED}',
    () async {
      final actual = await central.stateChanged.first;
      expect(actual, BluetoothState.poweredOff);
    },
  );
  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_START_DISCOVERY}',
    () async {
      final services = [UUID('1800'), UUID('1801')];
      await central.startDiscovery(uuids: services);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_CENTRAL_START_DISCOVERY,
              centralStartDiscoveryArguments:
                  messages.CentralStartDiscoveryArguments(
                uuids: services.map((uuid) => uuid.name),
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY}',
    () async {
      await central.stopDiscovery();
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.EventCategory.EVENT_CATEGORY_CENTRAL_DISCOVERED}',
    () async {
      final discovery = await central.discovered.first;
      final uuid = UUID('AABB');
      expect(discovery.uuid, uuid);
      const rssi = -50;
      expect(discovery.rssi, rssi);
      final advertisements = {
        0xff: [0xff, 0xee, 0xdd, 0xcc, 0xbb, 0xaa],
      };
      expect(discovery.advertisements, advertisements);
      const connectable = true;
      expect(discovery.connectable, connectable);
    },
  );
  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT}',
    () async {
      final uuid = UUID('AABB');
      final actual = await central.connect(uuid);
      expect(actual.maximumWriteLength, 20);
      expect(actual.services.length, 1);
      final service = actual.services.values.first;
      expect(service.uuid, UUID('1800'));
      expect(service.characteristics.length, 1);
      final characteristic = service.characteristics.values.first;
      expect(characteristic.uuid, UUID('2A00'));
      expect(characteristic.descriptors.length, 1);
      expect(characteristic.canRead, true);
      expect(characteristic.canWrite, true);
      expect(characteristic.canWriteWithoutResponse, true);
      expect(characteristic.canNotify, true);
      final descriptor = characteristic.descriptors.values.first;
      expect(descriptor.uuid, UUID('2900'));
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_GATT_DISCONNECT}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      await gatt.disconnect();
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_GATT_DISCONNECT,
              gattDisconnectArguments: messages.GattDisconnectArguments(
                indexedUuid: '0',
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.EventCategory.EVENT_CATEGORY_GATT_CONNECTION_LOST}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      final actual = await gatt.connectionLost.first;
      final matcher = Exception('Connection lost.');
      expect('$actual', '$matcher');
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_READ}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final actual = await characteristic.read();
      expect(actual, [0x01, 0x02, 0x03, 0x04, 0x05]);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_READ,
              characteristicReadArguments:
                  messages.GattCharacteristicReadArguments(
                indexedGattUuid: '0',
                indexedServiceUuid: '0',
                indexedUuid: '0',
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_WRITE}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final value = Uint8List.fromList([0x01, 0x02, 0x03, 0x04, 0x05]);
      await characteristic.write(value, withoutResponse: true);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_WRITE,
              characteristicWriteArguments:
                  messages.GattCharacteristicWriteArguments(
                indexedGattUuid: '0',
                indexedServiceUuid: '0',
                indexedUuid: '0',
                value: value,
                withoutResponse: true,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_NOTIFY}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      await characteristic.notify(true);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_GATT_CHARACTERISTIC_NOTIFY,
              characteristicNotifyArguments:
                  messages.GattCharacteristicNotifyArguments(
                indexedGattUuid: '0',
                indexedServiceUuid: '0',
                indexedUuid: '0',
                state: true,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.EventCategory.EVENT_CATEGORY_GATT_CHARACTERISTIC_VALUE_CHANGED}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final value = await characteristic.valueChanged.first;
      expect(value, [0x0A, 0x0B, 0x0C, 0x0D, 0x0E]);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_READ}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final descriptor = characteristic.descriptors.values.first;
      final actual = await descriptor.read();
      expect(actual, [0x05, 0x04, 0x03, 0x02, 0x01]);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_READ,
              descriptorReadArguments: messages.GattDescriptorReadArguments(
                indexedGattUuid: '0',
                indexedServiceUuid: '0',
                indexedCharacteristicUuid: '0',
                indexedUuid: '0',
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${messages.CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_WRITE}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final descriptor = characteristic.descriptors.values.first;
      final value = Uint8List.fromList([0x01, 0x02, 0x03, 0x04, 0x05]);
      await descriptor.write(value);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_GATT_DESCRIPTOR_WRITE,
              descriptorWriteArguments: messages.GattDescriptorWriteArguments(
                indexedGattUuid: '0',
                indexedServiceUuid: '0',
                indexedCharacteristicUuid: '0',
                indexedUuid: '0',
                value: value,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
}
