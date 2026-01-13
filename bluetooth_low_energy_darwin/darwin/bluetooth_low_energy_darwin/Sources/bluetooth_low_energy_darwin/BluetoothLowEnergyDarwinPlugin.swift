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
        let instance = BluetoothLowEnergyDarwinPlugin(with: registrar)
        registrar.publish(instance)
    }
    
    private var mCentralManager: CentralManagerImpl?
    private var mPeripheralManager: PeripheralManagerImpl?
    
    init(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger
        let centralManager = CentralManagerImpl(messenger)
        let peripheralManager = PeripheralManagerImpl(messenger)
        CentralManagerHostApiSetup.setUp(binaryMessenger: messenger, api: centralManager)
        PeripheralManagerHostApiSetup.setUp(binaryMessenger: messenger, api: peripheralManager)
        self.mCentralManager = centralManager
        self.mPeripheralManager = peripheralManager
    }
    
    public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
        let messenger = registrar.messenger
        CentralManagerHostApiSetup.setUp(binaryMessenger: messenger, api: nil)
        PeripheralManagerHostApiSetup.setUp(binaryMessenger: messenger, api: nil)
        self.mCentralManager = nil
        self.mPeripheralManager = nil
    }
}

#if os(iOS)
extension FlutterPluginRegistrar {
    var messenger: FlutterBinaryMessenger { return self.messenger() }
}
#endif
