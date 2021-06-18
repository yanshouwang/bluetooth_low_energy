part of bluetooth_low_energy;

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

  _UUID(String str) : this.name(str.nameOfUUID);

  _UUID.name(String name) : this.nameValue(name, name.valueOfUUID);

  _UUID.nameValue(this.name, this.value) : hashCode = equality.hash(value);

  @override
  String toString() => name;

  @override
  bool operator ==(other) => other is UUID && other.hashCode == hashCode;
}
