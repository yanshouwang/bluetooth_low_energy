import Flutter
import UIKit
import CoreBluetooth

public class SwiftBluetoothLowEnergyPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()
        
        PigeonCentralManagerHostApiSetup(binaryMessenger, centralHostApi)
        PigeonPeripheralHostApiSetup(binaryMessenger, peripherialHostApi)
        PigeonGattServiceHostApiSetup(binaryMessenger, serviceHostApi)
        PigeonGattCharacteristicHostApiSetup(binaryMessenger, characteristicHostApi)
        PigeonGattDescriptorHostApiSetup(binaryMessenger, descriptorHostApi)
        
        instances[KEY_CENTRAL_MANAGER_FLUTTER_API] = PigeonCentralManagerFlutterApi(binaryMessenger: binaryMessenger)
        instances[KEY_PERIPHERAL_FLUTTER_API] = PigeonPeripheralFlutterApi(binaryMessenger: binaryMessenger)
        instances[KEY_GATT_CHARACTERISTIC_FLUTTER_API] = PigeonGattCharacteristicFlutterApi(binaryMessenger: binaryMessenger)
    }
}

let BLUETOOTH_LOW_ENERGY_ERROR = "BLUETOOTH_LOW_ENERGY_ERROR"
let KEY_CENTRAL_MANAGER_FLUTTER_API = "KEY_CENTRAL_MANAGER_FLUTTER_API"
let KEY_PERIPHERAL_FLUTTER_API = "KEY_PERIPHERAL_FLUTTER_API"
let KEY_GATT_CHARACTERISTIC_FLUTTER_API = "KEY_GATT_CHARACTERISTIC_FLUTTER_API"
let KEY_STATE_NUMBER = "KEY_STATE_NUMBER"
let KEY_COUNT = "KEY_COUNT"
let KEY_PERIPHERAL = "KEY_PERIPHERAL"
let KEY_SERVICE = "KEY_SERVICE"
let KEY_CHARACTERISTIC = "KEY_CHARACTERISTIC"
let KEY_DESCRIPTOR = "KEY_DESCRIPTOR"
let KEY_AUTHORIZE_COMPLETION = "KEY_AUTHORIZE_COMPLETION"
let KEY_CONNECT_COMPLETION = "KEY_CONNECT_COMPLETION"
let KEY_DISCONNECT_COMPLETION = "KEY_DISCONNECT_COMPLETION"
let KEY_DISCOVER_SERVICES_COMPLETION = "KEY_DISCOVER_SERVICES_COMPLETION"
let KEY_DISCOVER_CHARACTERISTICS_COMPLETION = "KEY_DISCOVER_CHARACTERISTICS_COMPLETION"
let KEY_DISCOVER_DESCRIPTORS_COMPLETION = "KEY_DISCOVER_DESCRIPTORS_COMPLETION"
let KEY_READ_COMPLETION = "KEY_READ_COMPLETION"
let KEY_WRITE_COMPLETION = "KEY_WRITE_COMPLETION"
let KEY_SET_NOTIFY_COMPLETION = "KEY_SET_NOTIFY_COMPLETION"

var instances =  [String: Any]()

let central = CBCentralManager(delegate: centralManagerDelegate, queue: nil)
let centralManagerDelegate = MyCentralManagerDelegate()
let peripheralDelegate = MyPeripheralDelegate()

let centralHostApi = MyCentralManagerHostApi()
let peripherialHostApi = MyPeripheralHostApi()
let serviceHostApi = MyGattServiceHostApi()
let characteristicHostApi = MyGattCharacteristicHostApi()
let descriptorHostApi = MyGattDescriptorHostApi()

var centralFlutterApi: PigeonCentralManagerFlutterApi { return instances[KEY_CENTRAL_MANAGER_FLUTTER_API] as! PigeonCentralManagerFlutterApi }
var peripheralFlutterApi: PigeonPeripheralFlutterApi { return instances[KEY_PERIPHERAL_FLUTTER_API] as! PigeonPeripheralFlutterApi }
var characteristicFlutterApi: PigeonGattCharacteristicFlutterApi { return instances[KEY_GATT_CHARACTERISTIC_FLUTTER_API] as! PigeonGattCharacteristicFlutterApi }

func register(_ id:String) -> [String:Any] {
    var items = instances[id] as? [String: Any] ?? [String: Any]()
    var count = items[KEY_COUNT] as? Int ?? 0
    count += 1
    items[KEY_COUNT] = count
    // This is a copy on write.
    instances[id] = items
    debugPrint("register: \(id)")
    return items
}

func unregister(_ id: String) {
    var items = instances[id] as! [String: Any]
    var count = items[KEY_COUNT] as! Int
    count -= 1
    items[KEY_COUNT] = count
    if count < 1 {
        instances.removeValue(forKey: id)
        debugPrint("unregister: \(id)")
    } else {
        // This is a copy on write.
        instances[id] = items
    }
}

extension CBCentralManager {
    var stateNumber: Int {
        if state == .unsupported {
            return Proto_BluetoothState.unsupported.rawValue
        } else if state == .poweredOn {
            return Proto_BluetoothState.poweredOn.rawValue
        } else {
            return Proto_BluetoothState.poweredOff.rawValue
        }
    }
}

extension NSNumber {
    var data: Data {
        var source = self
        return Data(bytes: &source, count: MemoryLayout<NSNumber>.size)
    }
}

extension String {
    var data: Data {
        return data(using: String.Encoding.utf8)!
    }
}

extension UInt16 {
    var data: Data {
        var source = self
        return Data(bytes: &source, count: MemoryLayout<UInt16>.size)
    }
}
