abstract class MyObject {
  final int? myHashCode;

  MyObject({this.myHashCode});

  @override
  int get hashCode => myHashCode ?? super.hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyObject && other.hashCode == hashCode;
  }
}
