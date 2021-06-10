import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy/src/channel.dart' as channel;
import 'package:bluetooth_low_energy/src/message.pb.dart' as message;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final method = MethodChannel('${channel.method.name}');
  final event = MethodChannel('${channel.event.name}');
  final calls = <MethodCall>[];

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    calls.clear();
    method.setMockMethodCallHandler((call) async {
      calls.add(call);
      if (call.method == message.MessageCategory.BLUETOOTH_MANAGER_STATE.name) {
        return message.BluetoothManagerState.POWERED_OFF.value;
      } else if (call.method ==
          message.MessageCategory.CENTRAL_MANAGER_START_DISCOVERY.name) {
        return null;
      } else if (call.method ==
          message.MessageCategory.CENTRAL_MANAGER_STOP_DISCOVERY.name) {
        return null;
      } else {
        throw UnimplementedError();
      }
    });
    event.setMockMethodCallHandler((call) async {
      switch (call.method) {
        case 'listen':
          final state = message.Message(
                  category: message.MessageCategory.BLUETOOTH_MANAGER_STATE,
                  state: message.BluetoothManagerState.POWERED_ON)
              .writeToBuffer();
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(channel.event.name,
                  channel.event.codec.encodeSuccessEnvelope(state), (data) {});
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

  test('${message.MessageCategory.BLUETOOTH_MANAGER_STATE}', () async {
    final actual = await CentralManager().state;
    final matcher = BluetoothManagerState.poweredOff;
    expect(actual, matcher);
    expect(
      calls,
      [
        isMethodCall(
          message.MessageCategory.BLUETOOTH_MANAGER_STATE.name,
          arguments: null,
        ),
      ],
    );
  });

  test('${message.MessageCategory.BLUETOOTH_MANAGER_STATE} EVENT', () async {
    final actual = await CentralManager().stateChanged.first;
    final matcher = BluetoothManagerState.poweredOn;
    expect(actual, matcher);
  });

  test('${message.MessageCategory.CENTRAL_MANAGER_START_DISCOVERY}', () async {
    final services = [UUID('1800'), UUID('1801')];
    await CentralManager().startDiscovery(services: services);
    expect(
      calls,
      [
        isMethodCall(
          message.MessageCategory.CENTRAL_MANAGER_START_DISCOVERY.name,
          arguments: [UUID('1800').value, UUID('1801').value],
        ),
      ],
    );
  });

  test('${message.MessageCategory.CENTRAL_MANAGER_STOP_DISCOVERY}', () async {
    await CentralManager().stopDiscovery();
    expect(
      calls,
      [
        isMethodCall(
          message.MessageCategory.CENTRAL_MANAGER_STOP_DISCOVERY.name,
          arguments: null,
        ),
      ],
    );
  });
}
