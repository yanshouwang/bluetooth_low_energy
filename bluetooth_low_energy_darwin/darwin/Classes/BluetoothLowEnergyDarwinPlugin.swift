#if os(iOS)
import Flutter
import UIKit
#elseif os(macOS)
import Cocoa
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

public class BluetoothLowEnergyDarwinPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
#if os(iOS)
        let messenger = registrar.messenger()
#elseif os(macOS)
        let messenger = registrar.messenger
#else
#error("Unsupported platform.")
#endif
        let centralManagerImpl = MyCentralManager(messenger: messenger)
        let peripheralManagerImpl = PeripheralManagerImpl(messenger: messenger)
        CentralManagerHostAPISetup.setUp(binaryMessenger: messenger, api: centralManagerImpl)
        PeripheralManagerHostAPISetup.setUp(binaryMessenger: messenger, api: peripheralManagerImpl)
    }
}
