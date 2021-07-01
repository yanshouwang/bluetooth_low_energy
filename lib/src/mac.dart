part of bluetooth_low_energy;

/// TO BE DONE.
abstract class MAC {
  /// TO BE DONE.
  List<int> get value;

  /// TO BE DONE.
  String get name;

  /// TO BE DONE.
  factory MAC(String str) => _MAC(str);
}

class _MAC implements MAC {
  @override
  final String name;
  @override
  final List<int> value;
  @override
  final int hashCode;

  _MAC(String str) : this.name(str.nameOfMAC);

  _MAC.name(String name) : this.nameValue(name, name.valueOfMAC);

  _MAC.nameValue(this.name, this.value) : hashCode = equality.hash(value);

  @override
  String toString() => name;

  @override
  bool operator ==(other) => other is MAC && other.hashCode == hashCode;
}
