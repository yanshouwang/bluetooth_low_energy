class Log {
  final DateTime time;
  final String type;
  final String message;

  Log({required this.type, required this.message}) : time = DateTime.now();
}
