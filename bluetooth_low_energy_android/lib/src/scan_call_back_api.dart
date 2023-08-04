import 'api.g.dart';

class ScanCallbackApi extends ScanCallbackHostApi
    implements ScanCallbackFlutterApi {
  @override
  void onBatchScanResults(int hashCode, List<int?> resultHashCodes) {
    // TODO: implement onBatchScanResults
  }

  @override
  void onScanFailed(int hashCode, int errorCode) {
    // TODO: implement onScanFailed
  }

  @override
  void onScanResult(int hashCode, int callbackType, int resultHashCode) {
    // TODO: implement onScanResult
  }
}
