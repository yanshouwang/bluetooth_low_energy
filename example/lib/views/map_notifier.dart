import 'package:flutter/foundation.dart';

class MapNotifier<K, V> extends ValueNotifier<Map<K, V>> {
  MapNotifier(Map<K, V> value) : super(value);
}
