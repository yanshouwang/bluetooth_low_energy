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
        let centralManager = MyCentralManager(binaryMessenger)
        let peripheralManager = MyPeripheralManager(binaryMessenger)
        MyCentralManagerHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: centralManager)
        MyPeripheralManagerHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: peripheralManager)
    }
}
