part of bluetooth_low_energy;

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

  _MAC(String name) : this.nameValue(name.toLowerCase(), name.valueOfMAC);

  _MAC.nameValue(this.name, this.value) : hashCode = equality.hash(value);

  @override
  String toString() => name;

  @override
  bool operator ==(other) => other is MAC && other.hashCode == hashCode;
}
