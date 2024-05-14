import 'package:intl/intl.dart';

class Log {
  final DateTime time;
  final String message;

  Log(this.message) : time = DateTime.now();

  @override
  String toString() {
    final formatter = DateFormat.Hms();
    final time = formatter.format(this.time);
    return '[$time]: $message';
  }
}
