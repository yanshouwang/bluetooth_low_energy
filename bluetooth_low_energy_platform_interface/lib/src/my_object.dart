abstract class MyObject {
  final int? _hashCode;

  MyObject({int? hashCode}) : _hashCode = hashCode;

  @override
  int get hashCode => _hashCode ?? super.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyObject && other.hashCode == hashCode;
  }
}
