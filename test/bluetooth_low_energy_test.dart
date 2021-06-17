import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy/src/mac.dart';
import 'package:bluetooth_low_energy/src/util.dart' as util;
import 'package:bluetooth_low_energy/src/message.pb.dart' as proto;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final method = MethodChannel('${util.method.name}');
  final event = MethodChannel('${util.event.name}');
  final calls = <MethodCall>[];
  final central = Central();

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
        return null;
      } else {
        throw UnimplementedError();
      }
    });
    event.setMockMethodCallHandler((call) async {
      switch (call.method) {
        case 'listen':
          // BLUETOOTH_MANAGER_STATE
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
          // CENTRAL_MANAGER_DISCOVERED
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
          break;
        case 'cancel':
        default:
          return null;
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
          arguments: proto.DiscoverArguments(
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

  test('${proto.MessageCategory.CENTRAL_CONNECT}', () async {
    final address = MAC('aa:bb:cc:dd:ee:ff');
    final actual = await central.connect(address);
    expect(actual.address, address);
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
}
