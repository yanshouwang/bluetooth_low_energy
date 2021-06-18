part of bluetooth_low_energy;

extension on String {
  List<int> get valueOfMAC {
    final exp = RegExp(
      r'^[0-9a-f]{2}(:[0-9a-f]{2}){5}$',
      multiLine: true,
      caseSensitive: false,
    );
    if (!exp.hasMatch(this)) {
      throw ArgumentError.value(this);
    }
    final from = RegExp(r':');
    final encoded = replaceAll(from, '');
    return hex.decode(encoded);
  }

  String get nameOfUUID {
    final upper = toUpperCase();
    final exp0 = RegExp(
      r'[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$',
      multiLine: true,
      caseSensitive: false,
    );
    if (exp0.hasMatch(upper)) {
      return upper;
    }
    final exp1 = RegExp(
      r'^[0-9A-F]{4}$',
      multiLine: true,
      caseSensitive: false,
    );
    if (exp1.hasMatch(upper)) {
      return '0000$upper-0000-1000-8000-00805F9B34FB';
    }
    throw ArgumentError.value(this);
  }

  List<int> get valueOfUUID {
    final from = RegExp(r'-');
    final encoded = replaceAll(from, '');
    return hex.decode(encoded);
  }

  MAC get conversionOfMAC => MAC(this);
}

extension on proto.BluetoothState {
  BluetoothState get conversion => BluetoothState.values[value];
}

extension on proto.Discovery {
  Discovery get conversion =>
      Discovery(address.conversionOfMAC, rssi, advertisements);
}
