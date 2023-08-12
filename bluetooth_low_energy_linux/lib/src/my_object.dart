abstract class MyObject {
  @override
  final int hashCode;

  MyObject(Object instance) : hashCode = instance.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyObject && other.hashCode == hashCode;
  }
}
