import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy/src/channel.dart' as channel;
import 'package:bluetooth_low_energy/src/mac.dart';
import 'package:bluetooth_low_energy/src/message.pb.dart' as proto;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final method = MethodChannel('${channel.method.name}');
  final event = MethodChannel('${channel.event.name}');
  final calls = <MethodCall>[];
  final manager = CentralManager();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    calls.clear();
    method.setMockMethodCallHandler((call) async {
      calls.add(call);
      if (call.method == proto.MessageCategory.BLUETOOTH_MANAGER_STATE.name) {
        return proto.BluetoothManagerState.POWERED_OFF.value;
      } else if (call.method ==
          proto.MessageCategory.CENTRAL_MANAGER_START_DISCOVERY.name) {
        return null;
      } else if (call.method ==
          proto.MessageCategory.CENTRAL_MANAGER_STOP_DISCOVERY.name) {
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
            category: proto.MessageCategory.BLUETOOTH_MANAGER_STATE,
            state: proto.BluetoothManagerState.POWERED_ON,
          ).writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
            channel.event.name,
            channel.event.codec.encodeSuccessEnvelope(state),
            (data) {},
          );
          // CENTRAL_MANAGER_DISCOVERED
          final discovery = proto.Message(
            category: proto.MessageCategory.CENTRAL_MANAGER_DISCOVERED,
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
            channel.event.name,
            channel.event.codec.encodeSuccessEnvelope(discovery),
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

  test('${proto.MessageCategory.BLUETOOTH_MANAGER_STATE}', () async {
    final actual = await manager.state;
    final matcher = BluetoothManagerState.poweredOff;
    expect(actual, matcher);
    expect(
      calls,
      [
        isMethodCall(
          proto.MessageCategory.BLUETOOTH_MANAGER_STATE.name,
          arguments: null,
        ),
      ],
    );
  });

  test('${proto.MessageCategory.BLUETOOTH_MANAGER_STATE} EVENT', () async {
    final actual = await manager.stateChanged.first;
    final matcher = BluetoothManagerState.poweredOn;
    expect(actual, matcher);
  });

  test('${proto.MessageCategory.CENTRAL_MANAGER_START_DISCOVERY}', () async {
    final services = [UUID('1800'), UUID('1801')];
    await manager.startDiscovery(services: services);
    expect(
      calls,
      [
        isMethodCall(
          proto.MessageCategory.CENTRAL_MANAGER_START_DISCOVERY.name,
          arguments: [UUID('1800').value, UUID('1801').value],
        ),
      ],
    );
  });

  test('${proto.MessageCategory.CENTRAL_MANAGER_STOP_DISCOVERY}', () async {
    await manager.stopDiscovery();
    expect(
      calls,
      [
        isMethodCall(
          proto.MessageCategory.CENTRAL_MANAGER_STOP_DISCOVERY.name,
          arguments: null,
        ),
      ],
    );
  });

  test('${proto.MessageCategory.CENTRAL_MANAGER_DISCOVERED} EVENT', () async {
    final actual = await manager.discovered.first;
    final address = MAC('aa:bb:cc:dd:ee:ff');
    expect(actual.address, address);
    final rssi = -50;
    expect(actual.rssi, rssi);
    final advertisements = {
      0xff: [0xff, 0xee, 0xdd, 0xcc, 0xbb, 0xaa],
    };
    expect(actual.advertisements, advertisements);
  });
}
