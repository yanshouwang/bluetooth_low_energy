class Log {
  final DateTime time;
  final LogType type;
  final List<int> value;

  Log(this.time, this.type, this.value);

  factory Log.typeValue(LogType type, List<int> value) {
    final time = DateTime.now();
    return Log(time, type, value);
  }

  factory Log.read(List<int> value) => Log.typeValue(LogType.read, value);
  factory Log.write(List<int> value) => Log.typeValue(LogType.write, value);
  factory Log.notify(List<int> value) => Log.typeValue(LogType.notify, value);
}

enum LogType {
  read,
  write,
  notify,
}

extension LogX on LogType {
  String get display {
    switch (this) {
      case LogType.read:
        return '读取';
      case LogType.write:
        return '写入';
      case LogType.notify:
        return '通知';
      default:
        throw ArgumentError.value(this);
    }
  }
}
