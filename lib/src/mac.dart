import 'package:collection/collection.dart';
import 'package:convert/convert.dart';

abstract class MAC {
  List<int> get value;
}

class _MAC implements MAC {
  final String s;
  @override
  final List<int> value;
  @override
  final int hashCode;

  _MAC(this.s) : value = hex.decode(s);

  _MAC.value(this.value)
      : s = hex.encode(value),
        hashCode = ListEquality<int>().hash(value);

  @override
  bool operator ==(other) => other is MAC && other.hashCode == hashCode;
}
