import 'api.g.dart';

class ScanCallbackApi extends ScanCallbackHostApi
    implements ScanCallbackFlutterApi {
  @override
  void onBatchScanResults(List<int?> resultHashCodes) {
    // TODO: implement onBatchScanResults
  }

  @override
  void onScanFailed(int errorCode) {
    // TODO: implement onScanFailed
  }

  @override
  void onScanResult(int callbackType, int resultHashCode) {
    // TODO: implement onScanResult
  }
}
