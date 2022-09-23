import 'impl.dart';

abstract class BluetoothLowEnergyException implements Exception {
  String get message;

  factory BluetoothLowEnergyException({required String message}) {
    return MyBluetoothLowEnergyException(message: message);
  }
}
