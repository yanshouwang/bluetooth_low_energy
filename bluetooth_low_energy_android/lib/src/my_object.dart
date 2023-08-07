import 'my_api.dart';

final _finalizer = Finalizer<int>((hashCode) {
  myInstanceManagerApi.free(hashCode);
});

abstract class MyObject {
  final int _hashCode;

  MyObject(int hashCode) : _hashCode = hashCode {
    _finalizer.attach(this, hashCode);
  }

  @override
  int get hashCode => _hashCode;

  @override
  bool operator ==(Object other) {
    return other is MyObject && other.hashCode == hashCode;
  }
}
