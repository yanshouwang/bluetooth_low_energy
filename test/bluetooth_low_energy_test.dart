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
      if (call.method == proto.MessageCategory.BLUETOOTH_STATE.name) {
        return proto.BluetoothState.POWERED_OFF.value;
      } else if (call.method ==
          proto.MessageCategory.CENTRAL_START_DISCOVERY.name) {
        return null;
      } else if (call.method ==
          proto.MessageCategory.CENTRAL_STOP_DISCOVERY.name) {
        return null;
      } else if (call.method == proto.MessageCategory.CENTRAL_CONNECT.name) {
        final descriptors = [
          proto.GattDescriptor(
            id: 4000,
            uuid: '2900',
          ),
        ];
        final characteristics = [
          proto.GattCharacteristic(
            id: 3000,
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
            id: 2000,
            uuid: '1800',
            characteristics: characteristics,
          ),
        ];
        final gatt = proto.GATT(
          id: 1000,
          mtu: 23,
          services: services,
        );
        return gatt.writeToBuffer();
      } else if (call.method == proto.MessageCategory.GATT_DISCONNECT.name) {
        return null;
      } else if (call.method ==
          proto.MessageCategory.GATT_CHARACTERISTIC_READ.name) {
        return [0x01, 0x02, 0x03, 0x04, 0x05];
      } else if (call.method ==
          proto.MessageCategory.GATT_CHARACTERISTIC_WRITE.name) {
        return null;
      } else if (call.method ==
          proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY.name) {
        return null;
      } else if (call.method ==
          proto.MessageCategory.GATT_DESCRIPTOR_READ.name) {
        return [0x05, 0x04, 0x03, 0x02, 0x01];
      } else if (call.method ==
          proto.MessageCategory.GATT_DESCRIPTOR_WRITE.name) {
        return null;
      } else {
        throw UnimplementedError();
      }
    });
    event.setMockMethodCallHandler((call) async {
      switch (call.method) {
        case 'listen':
          final state = proto.Message(
            category: proto.MessageCategory.BLUETOOTH_STATE,
            state: proto.BluetoothState.POWERED_ON,
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
              address: 'aa:bb:cc:dd:ee:ff',
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
            connectionLost: proto.ConnectionLost(
              id: 1000,
              errorCode: 19,
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
              id: 3000,
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
      final matcher = BluetoothState.poweredOff;
      expect(actual, matcher);
      expect(
        calls,
        [
          isMethodCall(
            proto.MessageCategory.BLUETOOTH_STATE.name,
            arguments: null,
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.BLUETOOTH_STATE} EVENT',
    () async {
      final actual = await central.stateChanged.first;
      final matcher = BluetoothState.poweredOn;
      expect(actual, matcher);
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
            proto.MessageCategory.CENTRAL_START_DISCOVERY.name,
            arguments: proto.StartDiscoveryArguments(
              services: services.map((uuid) => uuid.name),
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
            proto.MessageCategory.CENTRAL_STOP_DISCOVERY.name,
            arguments: null,
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.CENTRAL_DISCOVERED} EVENT',
    () async {
      final actual = await central.discovered.first;
      final address = MAC('aa:bb:cc:dd:ee:ff');
      expect(actual.address, address);
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
      final address = MAC('aa:bb:cc:dd:ee:ff');
      final actual = await central.connect(address);
      expect(actual.mtu, 23);
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
            proto.MessageCategory.CENTRAL_CONNECT.name,
            arguments: proto.ConnectArguments(
              address: address.name,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_DISCONNECT}',
    () async {
      final address = MAC('aa:bb:cc:dd:ee:ff');
      final gatt = await central.connect(address);
      await gatt.disconnect();
      expect(
        calls,
        [
          isMethodCall(
            proto.MessageCategory.CENTRAL_CONNECT.name,
            arguments: proto.ConnectArguments(
              address: address.name,
            ).writeToBuffer(),
          ),
          isMethodCall(
            proto.MessageCategory.GATT_DISCONNECT.name,
            arguments: proto.GattDisconnectArguments(
              address: address.name,
              id: 1000,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_CONNECTION_LOST}',
    () async {
      final address = MAC('aa:bb:cc:dd:ee:ff');
      final gatt = await central.connect(address);
      final actual = await gatt.connectionLost.first;
      expect(actual, 19);
    },
  );
  test(
    '${proto.MessageCategory.GATT_CHARACTERISTIC_READ}',
    () async {
      final address = MAC('aa:bb:cc:dd:ee:ff');
      final gatt = await central.connect(address);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final actual = await characteristic.read();
      expect(actual, [0x01, 0x02, 0x03, 0x04, 0x05]);
      expect(
        calls,
        [
          isMethodCall(
            proto.MessageCategory.CENTRAL_CONNECT.name,
            arguments: proto.ConnectArguments(
              address: address.name,
            ).writeToBuffer(),
          ),
          isMethodCall(
            proto.MessageCategory.GATT_CHARACTERISTIC_READ.name,
            arguments: proto.GattCharacteristicReadArguments(
              address: address.name,
              serviceUuid: service.uuid.name,
              uuid: characteristic.uuid.name,
              id: 3000,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_CHARACTERISTIC_WRITE}',
    () async {
      final address = MAC('aa:bb:cc:dd:ee:ff');
      final gatt = await central.connect(address);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final value = [0x01, 0x02, 0x03, 0x04, 0x05];
      await characteristic.write(value, withoutResponse: true);
      expect(
        calls,
        [
          isMethodCall(
            proto.MessageCategory.CENTRAL_CONNECT.name,
            arguments: proto.ConnectArguments(
              address: address.name,
            ).writeToBuffer(),
          ),
          isMethodCall(
            proto.MessageCategory.GATT_CHARACTERISTIC_WRITE.name,
            arguments: proto.GattCharacteristicWriteArguments(
              address: address.name,
              serviceUuid: service.uuid.name,
              uuid: characteristic.uuid.name,
              id: 3000,
              value: value,
              withoutResponse: true,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY}',
    () async {
      final address = MAC('aa:bb:cc:dd:ee:ff');
      final gatt = await central.connect(address);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      await characteristic.notify(true);
      expect(
        calls,
        [
          isMethodCall(
            proto.MessageCategory.CENTRAL_CONNECT.name,
            arguments: proto.ConnectArguments(
              address: address.name,
            ).writeToBuffer(),
          ),
          isMethodCall(
            proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY.name,
            arguments: proto.GattCharacteristicNotifyArguments(
              address: address.name,
              serviceUuid: service.uuid.name,
              uuid: characteristic.uuid.name,
              id: 3000,
              state: true,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_CHARACTERISTIC_NOTIFY} EVENT',
    () async {
      final address = MAC('aa:bb:cc:dd:ee:ff');
      final gatt = await central.connect(address);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final value = await characteristic.valueChanged.first;
      expect(value, [0x0A, 0x0B, 0x0C, 0x0D, 0x0E]);
    },
  );
  test(
    '${proto.MessageCategory.GATT_DESCRIPTOR_READ}',
    () async {
      final address = MAC('aa:bb:cc:dd:ee:ff');
      final gatt = await central.connect(address);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final descriptor = characteristic.descriptors.values.first;
      final actual = await descriptor.read();
      expect(actual, [0x05, 0x04, 0x03, 0x02, 0x01]);
      expect(
        calls,
        [
          isMethodCall(
            proto.MessageCategory.CENTRAL_CONNECT.name,
            arguments: proto.ConnectArguments(
              address: address.name,
            ).writeToBuffer(),
          ),
          isMethodCall(
            proto.MessageCategory.GATT_DESCRIPTOR_READ.name,
            arguments: proto.GattDescriptorReadArguments(
              address: address.name,
              serviceUuid: service.uuid.name,
              characteristicUuid: characteristic.uuid.name,
              uuid: descriptor.uuid.name,
              id: 4000,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
  test(
    '${proto.MessageCategory.GATT_DESCRIPTOR_WRITE}',
    () async {
      final address = MAC('aa:bb:cc:dd:ee:ff');
      final gatt = await central.connect(address);
      final service = gatt.services.values.first;
      final characteristic = service.characteristics.values.first;
      final descriptor = characteristic.descriptors.values.first;
      final value = [0x01, 0x02, 0x03, 0x04, 0x05];
      await descriptor.write(value);
      expect(
        calls,
        [
          isMethodCall(
            proto.MessageCategory.CENTRAL_CONNECT.name,
            arguments: proto.ConnectArguments(
              address: address.name,
            ).writeToBuffer(),
          ),
          isMethodCall(
            proto.MessageCategory.GATT_DESCRIPTOR_WRITE.name,
            arguments: proto.GattDescriptorWriteArguments(
              address: address.name,
              serviceUuid: service.uuid.name,
              characteristicUuid: characteristic.uuid.name,
              uuid: descriptor.uuid.name,
              id: 4000,
              value: value,
            ).writeToBuffer(),
          ),
        ],
      );
    },
  );
}
