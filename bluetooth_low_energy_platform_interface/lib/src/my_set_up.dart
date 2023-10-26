import 'package:meta/meta.dart';

import 'set_up.dart';

mixin MySetUp implements SetUp {
  @override
  @mustCallSuper
  Future<void> setUp() async {}
}
