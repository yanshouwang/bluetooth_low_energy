import 'package:flutter/widgets.dart';

typedef ListNotifier<T> = ValueNotifier<List<T>>;
typedef MapNotifier<K, V> = ValueNotifier<Map<K, V>>;

extension DateTimeX on DateTime {
  String get shortName {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    final ss = second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}

extension BuildContextX on BuildContext {
  T arguments<T extends Object?>() {
    return ModalRoute.of(this)!.settings.arguments as T;
  }
}
