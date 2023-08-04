abstract class Intent {
  Future<String?> getAction();
  Future<int> getIntExtra(String name, int defaultValue);
}
