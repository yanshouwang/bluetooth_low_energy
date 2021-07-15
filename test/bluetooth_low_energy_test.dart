import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy/src/util.dart' as util;
import 'package:bluetooth_low_energy/src/message.pb.dart' as proto;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final method = MethodChannel('${util.method.name}');
  final event = MethodChannel('${util.event.name}');
  final calls = <MethodCall>[];
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    calls.clear();
    method.setMockMethodCallHandler((call) async {
      calls.add(call);
      final message = proto.Message.fromBuffer(call.arguments);
      switch (message.category) {
        case proto.MessageCategory.BLUETOOTH_STATE:
          return proto.BluetoothState.POWERED_ON.value;
        case proto.MessageCategory.CENTRAL_START_DISCOVERY:
          return null;
        case proto.MessageCategory.CENTRAL_STOP_DISCOVERY:
          return null;
        case proto.MessageCategory.CENTRAL_CONNECT:
          final descriptors = [
            proto.GattDescriptor(
              key: '0',
              uuid: '2900',
            ),
          ];
          final characteristics = [
            proto.GattCharacteristic(
              key: '0',
              uuid: '2A00',
              descriptors: descriptors,
              canRead: true,
              canWrite: true,
              canWriteWithoutResponse: true,
              canNotify: true,
            ),
          ];
          final services = [
            proto.GattService(
              key: '0',
              uuid: '1800',
              characteristics: characteristics,
            ),
          ];
          final gatt = proto.GATT(
            key: '0',
            maximumWriteLength: 20,
            services: services,
          );
          return gatt.writeToBuffer();
        case proto.MessageCategory.GATT_DISCONNECT:
          return null;
        case proto.MessageCategory.GATT_CHARACTERISTIC_READ:
          return [0x01, 0x02, 0x03, 0x04, 0x05];
        case proto.MessageCategory.GATT_CHARACTERISTIC_WRITE:
          return null;
        case proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY:
          return null;
        case proto.MessageCategory.GATT_DESCRIPTOR_READ:
          return [0x05, 0x04, 0x03, 0x02, 0x01];
        case proto.MessageCategory.GATT_DESCRIPTOR_WRITE:
          return null;
        default:
          throw UnimplementedError();
      }
    });
    event.setMockMethodCallHandler((call) async {
      switch (call.method) {
        case 'listen':
          final state = proto.Message(
            category: proto.MessageCategory.BLUETOOTH_STATE,
            state: proto.BluetoothState.POWERED_OFF,
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(state),
            (data) {},
          );
          final discovery = proto.Message(
            category: proto.MessageCategory.CENTRAL_DISCOVERED,
            discovery: proto.Discovery(
              uuid: 'AABB',
              rssi: -50,
              advertisements: [0x07, 0xff, 0xff, 0xee, 0xdd, 0xcc, 0xbb, 0xaa],
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(discovery),
            (data) {},
          );
          final connectionLost = proto.Message(
            category: proto.MessageCategory.GATT_CONNECTION_LOST,
            connectionLost: proto.GattConnectionLost(
              key: '0',
              error: 'Connection lost.',
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(connectionLost),
            (data) {},
          );
          final characteristicValue = proto.Message(
            category: proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY,
            characteristicValue: proto.GattCharacteristicValue(
              gattKey: '0',
              serviceKey: '0',
              key: '0',
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
    '${proto.MessageCategory.BLUETOOTH_STATE}',
    () async {
      final actual = await central.state;
      expect(actual, BluetoothState.poweredOn);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.BLUETOOTH_STATE,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.BLUETOOTH_STATE} EVENT',
    () async {
      final actual = await central.stateChanged.first;
      expect(actual, BluetoothState.poweredOff);
    },
  );
  test(
    '${proto.MessageCategory.CENTRAL_START_DISCOVERY}',
    () async {
      final services = [UUID('1800'), UUID('1801')];
      await central.startDiscovery(services: services);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_START_DISCOVERY,
              startDiscoveryArguments: proto.StartDiscoveryArguments(
                services: services.map((uuid) => uuid.name),
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.CENTRAL_STOP_DISCOVERY}',
    () async {
      await central.stopDiscovery();
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_STOP_DISCOVERY,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.CENTRAL_DISCOVERED} EVENT',
    () async {
      final actual = await central.discovered.first;
      final uuid = UUID('AABB');
      expect(actual.uuid, uuid);
      final rssi = -50;
      expect(actual.rssi, rssi);
      final advertisements = {
        0xff: [0xff, 0xee, 0xdd, 0xcc, 0xbb, 0xaa],
      };
      expect(actual.advertisements, advertisements);
    },
  );
  test(
    '${proto.MessageCategory.CENTRAL_CONNECT}',
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
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_CONNECT,
              connectArguments: proto.ConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_DISCONNECT}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      await gatt.disconnect();
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_CONNECT,
              connectArguments: proto.ConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.GATT_DISCONNECT,
              disconnectArguments: proto.GattDisconnectArguments(key: '0'),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_CONNECTION_LOST}',
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
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_CONNECT,
              connectArguments: proto.ConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_CHARACTERISTIC_READ}',
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
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_CONNECT,
              connectArguments: proto.ConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.GATT_CHARACTERISTIC_READ,
              characteristicReadArguments:
                  proto.GattCharacteristicReadArguments(
                gattKey: '0',
                serviceKey: '0',
                key: '0',
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_CHARACTERISTIC_WRITE}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final value = [0x01, 0x02, 0x03, 0x04, 0x05];
      await characteristic.write(value, withoutResponse: true);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_CONNECT,
              connectArguments: proto.ConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.GATT_CHARACTERISTIC_WRITE,
              characteristicWriteArguments:
                  proto.GattCharacteristicWriteArguments(
                gattKey: '0',
                serviceKey: '0',
                key: '0',
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
    '${proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY}',
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
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_CONNECT,
              connectArguments: proto.ConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY,
              characteristicNotifyArguments:
                  proto.GattCharacteristicNotifyArguments(
                gattKey: '0',
                serviceKey: '0',
                key: '0',
                state: true,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY} EVENT',
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
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_CONNECT,
              connectArguments: proto.ConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_DESCRIPTOR_READ}',
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
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_CONNECT,
              connectArguments: proto.ConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.GATT_DESCRIPTOR_READ,
              descriptorReadArguments: proto.GattDescriptorReadArguments(
                gattKey: '0',
                serviceKey: '0',
                characteristicKey: '0',
                key: '0',
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_DESCRIPTOR_WRITE}',
    () async {
      final uuid = UUID('AABB');
      final gatt = await central.connect(uuid);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final descriptor = characteristic.descriptors.values.first;
      final value = [0x01, 0x02, 0x03, 0x04, 0x05];
      await descriptor.write(value);
      expect(
        calls,
        [
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.CENTRAL_CONNECT,
              connectArguments: proto.ConnectArguments(
                uuid: uuid.name,
              ),
            ).writeToBuffer(),
          ),
          isMethodCall(
            '',
            arguments: proto.Message(
              category: proto.MessageCategory.GATT_DESCRIPTOR_WRITE,
              descriptorWriteArguments: proto.GattDescriptorWriteArguments(
                gattKey: '0',
                serviceKey: '0',
                characteristicKey: '0',
                key: '0',
                value: value,
              ),
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
}
