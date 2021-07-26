import 'package:flutter/foundation.dart';

class ListNotifier<T> extends ValueNotifier<List<T>> {
  ListNotifier(List<T> value) : super(value);
}
