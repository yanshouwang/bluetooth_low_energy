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
      } else if (call.method == proto.MessageCategory.CENTRAL_SCANNING.name) {
        return true;
      } else if (call.method == proto.MessageCategory.CENTRAL_CONNECT.name) {
        final descriptors = [
          proto.GattDescriptor(uuid: '2900'),
        ];
        final characteristics = [
          proto.GattCharacteristic(
            uuid: '2A00',
            descriptors: descriptors,
            canRead: true,
            canWrite: false,
            canWriteWithoutResponse: false,
            canNotify: false,
          ),
        ];
        final services = [
          proto.GattService(uuid: '1800', characteristics: characteristics),
        ];
        final gatt = proto.GATT(mtu: 23, services: services);
        return gatt.writeToBuffer();
      } else if (call.method == proto.MessageCategory.GATT_DISCONNECT.name) {
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
              advertisements: {
                0xff: [0xff, 0xee, 0xdd, 0xcc, 0xbb, 0xaa],
              },
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(discovery),
            (data) {},
          );
          final scanning = proto.Message(
            category: proto.MessageCategory.CENTRAL_SCANNING,
            scanning: true,
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(scanning),
            (data) {},
          );
          final connectionLostArguments = proto.Message(
            category: proto.MessageCategory.GATT_CONNECTION_LOST,
            connectionLostArguments: proto.ConnectionLostArguments(
              address: 'aa:bb:cc:dd:ee:ff',
              errorCode: 19,
            ),
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            event.name,
            event.codec.encodeSuccessEnvelope(connectionLostArguments),
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

  test('${proto.MessageCategory.BLUETOOTH_STATE}', () async {
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
  });

  test('${proto.MessageCategory.BLUETOOTH_STATE} EVENT', () async {
    final actual = await central.stateChanged.first;
    final matcher = BluetoothState.poweredOn;
    expect(actual, matcher);
  });

  test('${proto.MessageCategory.CENTRAL_START_DISCOVERY}', () async {
    final services = [UUID('1800'), UUID('1801')];
    await central.startDiscovery(services: services);
    expect(
      calls,
      [
        isMethodCall(
          proto.MessageCategory.CENTRAL_START_DISCOVERY.name,
          arguments: proto.DiscoveryArguments(
            services: services.map((uuid) => uuid.name),
          ).writeToBuffer(),
        ),
      ],
    );
  });

  test('${proto.MessageCategory.CENTRAL_STOP_DISCOVERY}', () async {
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
  });

  test('${proto.MessageCategory.CENTRAL_DISCOVERED} EVENT', () async {
    final actual = await central.discovered.first;
    final address = MAC('aa:bb:cc:dd:ee:ff');
    expect(actual.address, address);
    final rssi = -50;
    expect(actual.rssi, rssi);
    final advertisements = {
      0xff: [0xff, 0xee, 0xdd, 0xcc, 0xbb, 0xaa],
    };
    expect(actual.advertisements, advertisements);
  });

  test('${proto.MessageCategory.CENTRAL_SCANNING}', () async {
    final actual = await central.scanning;
    final matcher = true;
    expect(actual, matcher);
    expect(
      calls,
      [
        isMethodCall(
          proto.MessageCategory.CENTRAL_SCANNING.name,
          arguments: null,
        ),
      ],
    );
  });

  test('${proto.MessageCategory.CENTRAL_SCANNING} EVENT', () async {
    final actual = await central.scanningChanged.first;
    final matcher = true;
    expect(actual, matcher);
  });

  test('${proto.MessageCategory.CENTRAL_CONNECT}', () async {
    final address = MAC('aa:bb:cc:dd:ee:ff');
    final actual = await central.connect(address);
    expect(actual.address, address);
    expect(actual.mtu, 23);
    expect(actual.services.length, 1);
    final service = actual.services[0];
    expect(service.uuid, UUID('1800'));
    expect(service.characteristics.length, 1);
    final characteristic = service.characteristics[0];
    expect(characteristic.uuid, UUID('2A00'));
    expect(characteristic.descriptors.length, 1);
    expect(characteristic.canRead, true);
    expect(characteristic.canWrite, false);
    expect(characteristic.canWriteWithoutResponse, false);
    expect(characteristic.canNotify, false);
    final descriptor = characteristic.descriptors[0];
    expect(descriptor.uuid, UUID('2900'));
    expect(
      calls,
      [
        isMethodCall(
          proto.MessageCategory.CENTRAL_CONNECT.name,
          arguments: address.name,
        ),
      ],
    );
  });

  test('${proto.MessageCategory.GATT_DISCONNECT}', () async {
    final address = MAC('aa:bb:cc:dd:ee:ff');
    final gatt = await central.connect(address);
    await gatt.disconnect();
    expect(
      calls,
      [
        isMethodCall(
          proto.MessageCategory.CENTRAL_CONNECT.name,
          arguments: address.name,
        ),
        isMethodCall(
          proto.MessageCategory.GATT_DISCONNECT.name,
          arguments: address.name,
        ),
      ],
    );
  });

  test('${proto.MessageCategory.GATT_CONNECTION_LOST}', () async {
    final address = MAC('aa:bb:cc:dd:ee:ff');
    final gatt = await central.connect(address);
    final actual = await gatt.connectionLost.first;
    expect(actual, 19);
  });
}
