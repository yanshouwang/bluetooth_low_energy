import UIKit
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

public class BluetoothLowEnergyDarwin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()
        let centralController = MyCentralController(binaryMessenger)
        MyCentralControllerHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: centralController)
    }
}
