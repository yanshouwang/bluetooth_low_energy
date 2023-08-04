import 'api.dart';
import 'intent.dart';
import 'my_object.dart';

class MyIntent extends MyObject implements Intent {
  MyIntent(super.hashCode);

  @override
  Future<String?> getAction() {
    return intentApi.getAction(hashCode);
  }

  @override
  Future<int> getIntExtra(String name, int defaultValue) {
    return intentApi.getIntExtra(hashCode, name, defaultValue);
  }
}
