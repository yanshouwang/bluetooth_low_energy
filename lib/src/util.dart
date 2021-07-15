import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

import 'message.pb.dart';

const namespace = 'yanshouwang.dev/bluetooth_low_energy';
const method = MethodChannel('$namespace/method');
const event = EventChannel('$namespace/event');
const equality = ListEquality<int>();

final stream =
    event.receiveBroadcastStream().map((event) => Message.fromBuffer(event));
