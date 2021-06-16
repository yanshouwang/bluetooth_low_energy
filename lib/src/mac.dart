import 'package:convert/convert.dart';

import 'util.dart';

abstract class MAC {
  List<int> get value;
  String get name;

  factory MAC(String str) => _MAC(str);
}

class _MAC implements MAC {
  @override
  final String name;
  @override
  final List<int> value;
  @override
  final int hashCode;

  _MAC(String name) : this.nameValue(name, name.value);

  _MAC.nameValue(this.name, this.value) : hashCode = equality.hash(value);

  @override
  String toString() => name;

  @override
  bool operator ==(other) => other is MAC && other.hashCode == hashCode;
}

extension on String {
  List<int> get value {
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
}
