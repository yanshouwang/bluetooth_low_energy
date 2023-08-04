import 'package:bluetooth_low_energy_android/src/intent.dart';

import 'broadcast_receiver.dart';
import 'my_object.dart';

class MyBroadcastReceiver extends MyObject implements BroadcastReceiver {
  MyBroadcastReceiver(super.hashCode);

  @override
  // TODO: implement onReceive
  Stream<Intent> get onReceive => throw UnimplementedError();
}
