#if os(iOS)
import Flutter
import UIKit
#elseif os(macOS)
import Cocoa
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

public class BluetoothLowEnergyDarwin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
#if os(iOS)
        let binaryMessenger = registrar.messenger()
#elseif os(macOS)
        let binaryMessenger = registrar.messenger
#else
#error("Unsupported platform.")
#endif
        let centralController = MyCentralController(binaryMessenger)
        MyCentralControllerHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: centralController)
    }
}
