import 'api.dart';
import 'intent.dart';
import 'my_broadcast_receiver.dart';

abstract class BroadcastReceiver {
  Stream<Intent> get onReceive;

  static Future<BroadcastReceiver> newInstance() async {
    final hashCode = await broadcastReceiverApi.newInstance();
    return MyBroadcastReceiver(hashCode);
  }
}
