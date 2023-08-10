import 'package:bluetooth_low_energy_android/src/my_central_controller.dart';

final instanceManager = MyInstanceManager._();

class MyInstanceManager {
  final Finalizer<int> _finalizer;

  MyInstanceManager._()
      : _finalizer = Finalizer((hashCode) => centralController.free(hashCode));

  void attach(Object instance) {
    _finalizer.attach(instance, instance.hashCode);
  }
}
