import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy/src/channels.dart' as util;
import 'package:bluetooth_low_energy/src/messages.dart' as messages;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final methodChannel = MethodChannel(util.methodChannel.name);
  final eventChannel = MethodChannel(util.eventChannel.name);
  final calls = <MethodCall>[];
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    methodChannel.setMockMethodCallHandler((call) async {
      calls.add(call);
      final command = messages.Command.fromBuffer(call.arguments);
      switch (command.category) {
        case messages.CommandCategory.COMMAND_CATEGORY_BLUETOOTH_GET_STATE:
          return messages.Reply(
            bluetoothGetStateArguments:
                messages.BluetoothGetStateReplyArguments(
              state: messages.BluetoothState.BLUETOOTH_STATE_POWERED_ON,
            ),
          ).writeToBuffer();
        case messages
            .CommandCategory.COMMAND_CATEGORY_BLUETOOTH_LISTEN_STATE_CHANGED:
          final event = messages.Event(
            category:
                messages.EventCategory.EVENT_CATEGORY_BLUETOOTH_STATE_CHANGED,
            bluetoothStateChangedArguments:
                messages.BluetoothStateChangedEventArguments(
              state: messages.BluetoothState.BLUETOOTH_STATE_POWERED_OFF,
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            eventChannel.name,
            eventChannel.codec.encodeSuccessEnvelope(event),
            (data) {},
          );
          return null;
        case messages
            .CommandCategory.COMMAND_CATEGORY_BLUETOOTH_CANCEL_STATE_CHANGED:
          return null;
        case messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_START_DISCOVERY:
          final event = messages.Event(
            category: messages.EventCategory.EVENT_CATEGORY_CENTRAL_DISCOVERED,
            centralDiscoveredArguments:
                messages.CentralDiscoveredEventArguments(
              discovery: messages.Discovery(
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
            eventChannel.name,
            eventChannel.codec.encodeSuccessEnvelope(event),
            (data) {},
          );
          return null;
        case messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_STOP_DISCOVERY:
          return null;
        case messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT:
          final descriptors = [
            messages.GattDescriptor(
              id: '0',
              uuid: '2900',
            ),
          ];
          final characteristics = [
            messages.GattCharacteristic(
              id: '0',
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
              id: '0',
              uuid: '1800',
              characteristics: characteristics,
            ),
          ];
          final gatt = messages.GATT(
            id: '0',
            maximumWriteLength: 20,
            services: services,
          );
          return messages.Reply(
            centralConnectArguments: messages.CentralConnectReplyArguments(
              gatt: gatt,
            ),
          ).writeToBuffer();
        case messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_READ:
          return messages.Reply(
            characteristicReadArguments:
                messages.CharacteristicReadReplyArguments(
              value: [0x01, 0x02, 0x03, 0x04, 0x05],
            ),
          ).writeToBuffer();
        case messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_WRITE:
          return null;
        case messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_NOTIFY:
          final event = messages.Event(
            category:
                messages.EventCategory.EVENT_CATEGORY_CHARACTERISTIC_NOTIFIED,
            characteristicNotifiedArguments:
                messages.CharacteristicNotifiedEventArguments(
              gattId: '0',
              serviceId: '0',
              id: '0',
              value: [0x0A, 0x0B, 0x0C, 0x0D, 0x0E],
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            eventChannel.name,
            eventChannel.codec.encodeSuccessEnvelope(event),
            (data) {},
          );
          return null;
        case messages
            .CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_CANCEL_NOTIFY:
          return null;
        case messages.CommandCategory.COMMAND_CATEGORY_DESCRIPTOR_READ:
          return messages.Reply(
            descriptorReadArguments: messages.DescriptorReadReplyArguments(
              value: [0x05, 0x04, 0x03, 0x02, 0x01],
            ),
          ).writeToBuffer();
        case messages.CommandCategory.COMMAND_CATEGORY_DESCRIPTOR_WRITE:
          return null;
        default:
          throw UnimplementedError();
      }
    });
    eventChannel.setMockMethodCallHandler((call) {
      switch (call.method) {
        case 'listen':
        case 'cancel':
        default:
          return null;
      }
    });
  });
  tearDown(() {
    methodChannel.setMockMethodCallHandler(null);
    eventChannel.setMockMethodCallHandler(null);
    calls.clear();
  });

  test(
    'Bluetooth#getState',
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
    'Bluetooth#stateChanged',
    () async {
      final actual = await central.stateChanged.first;
      expect(actual, BluetoothState.poweredOff);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages.CommandCategory
                  .COMMAND_CATEGORY_BLUETOOTH_LISTEN_STATE_CHANGED,
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages.CommandCategory
                  .COMMAND_CATEGORY_BLUETOOTH_CANCEL_STATE_CHANGED,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    'Central#discover',
    () async {
      final services = [UUID('1800'), UUID('1801')];
      final discovery = await central.discover(uuids: services).first;
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
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_CENTRAL_START_DISCOVERY,
              centralStartDiscoveryArguments:
                  messages.CentralStartDiscoveryCommandArguments(
                uuids: services.map((uuid) => uuid.name),
              ),
            ).writeToBuffer(),
          ),
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
    'Central#connect',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(
        uuid,
        onConnectionLost: (errorCode) {},
      );
      expect(gatt.maximumWriteLength, 20);
      expect(gatt.services.length, 1);
      final service = gatt.services.values.first;
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
              centralConnectArguments: messages.CentralConnectCommandArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    'GattCharacteritsic#read',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(
        uuid,
        onConnectionLost: (errorCode) {},
      );
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
              centralConnectArguments: messages.CentralConnectCommandArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_READ,
              characteristicReadArguments:
                  messages.CharacteristicReadCommandArguments(
                gattId: '0',
                serviceId: '0',
                id: '0',
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    'GattCharacteritsic#write',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(
        uuid,
        onConnectionLost: (errorCode) {},
      );
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
              centralConnectArguments: messages.CentralConnectCommandArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_WRITE,
              characteristicWriteArguments:
                  messages.CharacteristicWriteCommandArguments(
                gattId: '0',
                serviceId: '0',
                id: '0',
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
    'GattCharacteritsic#notified',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(
        uuid,
        onConnectionLost: (errorCode) {},
      );
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final value = await characteristic.notified.first;
      expect(value, [0x0A, 0x0B, 0x0C, 0x0D, 0x0E]);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_CENTRAL_CONNECT,
              centralConnectArguments: messages.CentralConnectCommandArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages
                  .CommandCategory.COMMAND_CATEGORY_CHARACTERISTIC_NOTIFY,
              characteristicNotifyArguments:
                  messages.CharacteristicNotifyCommandArguments(
                gattId: '0',
                serviceId: '0',
                id: '0',
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category: messages.CommandCategory
                  .COMMAND_CATEGORY_CHARACTERISTIC_CANCEL_NOTIFY,
              characteristicCancelNotifyArguments:
                  messages.CharacteristicCancelNotifyCommandArguments(
                gattId: '0',
                serviceId: '0',
                id: '0',
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    'GattDescriptor#read',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(
        uuid,
        onConnectionLost: (errorCode) {},
      );
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
              centralConnectArguments: messages.CentralConnectCommandArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_DESCRIPTOR_READ,
              descriptorReadArguments: messages.DescriptorReadCommandArguments(
                gattId: '0',
                serviceId: '0',
                characteristicId: '0',
                id: '0',
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    'GattDescriptor#write',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(
        uuid,
        onConnectionLost: (errorCode) {},
      );
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
              centralConnectArguments: messages.CentralConnectCommandArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: messages.Command(
              category:
                  messages.CommandCategory.COMMAND_CATEGORY_DESCRIPTOR_WRITE,
              descriptorWriteArguments:
                  messages.DescriptorWriteCommandArguments(
                gattId: '0',
                serviceId: '0',
                characteristicId: '0',
                id: '0',
                value: value,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
}
