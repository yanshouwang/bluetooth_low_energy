abstract class MyObject {
  @override
  final int hashCode;

  MyObject(this.hashCode);

  @override
  bool operator ==(Object other) {
    return other is MyObject && other.hashCode == hashCode;
  }
}
