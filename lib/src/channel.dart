import 'package:flutter/services.dart';

const namespace = 'yanshouwang.dev/bluetooth_low_energy';
const method = MethodChannel('$namespace/method');
const event = EventChannel('$namespace/event');
final stream = event.receiveBroadcastStream();
