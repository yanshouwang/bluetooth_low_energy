import 'package:collection/collection.dart';
import 'package:convert/convert.dart';

/// A universally unique identifier, as defined by bluetooth standards.
abstract class UUID {
  List<int> get value;

  factory UUID(String s) => _UUID(s);
}

class _UUID implements UUID {
  final String full;
  @override
  final List<int> value;
  @override
  final int hashCode;

  _UUID(String s) : this.full(s.full);

  _UUID.full(String full) : this.create(full, full.value);

  _UUID.create(this.full, this.value)
      : hashCode = ListEquality<int>().hash(value);

  @override
  String toString() => full;

  @override
  bool operator ==(other) => other is UUID && other.hashCode == hashCode;
}

extension on String {
  String get full {
    final short = RegExp(
      r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      multiLine: true,
      caseSensitive: false,
    );
    if (short.hasMatch(this)) {
      return this;
    }
    final full = RegExp(
      r'^[0-9a-f]{4}$',
      multiLine: true,
      caseSensitive: false,
    );
    if (full.hasMatch(this)) {
      return '0000${this}-0000-1000-8000-00805F9B34FB';
    }
    throw ArgumentError.value(this);
  }

  List<int> get value {
    final from = RegExp(r'-');
    final encoded = replaceAll(from, '');
    return hex.decode(encoded);
  }
}
