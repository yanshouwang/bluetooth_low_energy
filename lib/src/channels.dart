import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'messages.dart';

const namespace = 'yanshouwang.dev/bluetooth_low_energy';
const methodChannel = MethodChannel('$namespace/method');
const eventChannel = EventChannel('$namespace/event');

final eventStream = eventChannel
    .receiveBroadcastStream()
    .cast<Uint8List>()
    .map((elements) => Event.fromBuffer(elements));

extension MethodChannelX on MethodChannel {
  Future<T?> invokeCommand<T>(Command command) {
    final arguments = command.writeToBuffer();
    return invokeMethod<T>('', arguments);
  }

  Future<List<T>?> invokeListCommand<T>(Command command) {
    final arguments = command.writeToBuffer();
    return invokeListMethod<T>('', arguments);
  }

  Future<Map<K, V>?> invokeMapCommand<K, V>(Command command) {
    final arguments = command.writeToBuffer();
    return invokeMapMethod<K, V>('', arguments);
  }
}
