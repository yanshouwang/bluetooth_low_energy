#if os(macOS)
import Cocoa
import FlutterMacOS
#else
import Flutter
import UIKit
#endif

public class BluetoothLowEnergyDarwin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
#if os(macOS)
        let binaryMessenger = registrar.messenger
#else
        let binaryMessenger = registrar.messenger()
#endif
        let centralManager = MyCentralManager(binaryMessenger)
        MyCentralManagerHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: centralManager)
    }
}
