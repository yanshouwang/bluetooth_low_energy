import Flutter
import UIKit

public class BluetoothLowEnergyiOS: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()
        let centralController = MyCentralController(binaryMessenger)
        MyCentralControllerHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: centralController)
    }
}
