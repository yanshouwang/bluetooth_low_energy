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
        let messenger = registrar.messenger()
#elseif os(macOS)
        let messenger = registrar.messenger
#else
#error("Unsupported platform.")
#endif
        let centralManager = MyCentralManager(messenger: messenger)
        let peripheralManager = MyPeripheralManager(messenger: messenger)
        MyCentralManagerHostApiSetup.setUp(binaryMessenger: messenger, api: centralManager)
        MyPeripheralManagerHostApiSetup.setUp(binaryMessenger: messenger, api: peripheralManager)
    }
}
