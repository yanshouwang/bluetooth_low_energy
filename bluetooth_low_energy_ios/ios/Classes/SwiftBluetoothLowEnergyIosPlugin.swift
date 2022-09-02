import Flutter
import UIKit

public class SwiftBluetoothLowEnergyIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bluetooth_low_energy_ios", binaryMessenger: registrar.messenger())
    let instance = SwiftBluetoothLowEnergyIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}