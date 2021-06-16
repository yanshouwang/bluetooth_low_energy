import 'package:convert/convert.dart';

import 'util.dart';

/// A universally unique identifier, as defined by bluetooth standards.
abstract class UUID {
  List<int> get value;
  String get name;

  factory UUID(String str) => _UUID(str);
}

class _UUID implements UUID {
  @override
  final List<int> value;
  @override
  final String name;
  @override
  final int hashCode;

  _UUID(String str) : this.name(str.completion);

  _UUID.name(String name) : this.nameValue(name, name.value);

  _UUID.nameValue(this.name, this.value) : hashCode = equality.hash(value);

  @override
  String toString() => name;

  @override
  bool operator ==(other) => other is UUID && other.hashCode == hashCode;
}

extension on String {
  String get completion {
    final exp0 = RegExp(
      r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      multiLine: true,
      caseSensitive: false,
    );
    if (exp0.hasMatch(this)) {
      return this;
    }
    final exp1 = RegExp(
      r'^[0-9a-f]{4}$',
      multiLine: true,
      caseSensitive: false,
    );
    if (exp1.hasMatch(this)) {
      return '0000$this-0000-1000-8000-00805F9B34FB';
    }
    throw ArgumentError.value(this);
  }

  List<int> get value {
    final from = RegExp(r'-');
    final encoded = replaceAll(from, '');
    return hex.decode(encoded);
  }
}
