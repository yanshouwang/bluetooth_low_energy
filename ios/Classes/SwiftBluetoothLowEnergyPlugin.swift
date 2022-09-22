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
        
        items[KEY_CENTRAL_MANAGER_FLUTTER_API] = PigeonCentralManagerFlutterApi(binaryMessenger: binaryMessenger)
        items[KEY_PERIPHERAL_FLUTTER_API] = PigeonPeripheralFlutterApi(binaryMessenger: binaryMessenger)
        items[KEY_GATT_CHARACTERISTIC_FLUTTER_API] = PigeonGattCharacteristicFlutterApi(binaryMessenger: binaryMessenger)
    }
}

let BLUETOOTH_LOW_ENERGY_ERROR = "BLUETOOTH_LOW_ENERGY_ERROR"
let KEY_CENTRAL_MANAGER_FLUTTER_API = "KEY_CENTRAL_MANAGER_FLUTTER_API"
let KEY_PERIPHERAL_FLUTTER_API = "KEY_PERIPHERAL_FLUTTER_API"
let KEY_GATT_CHARACTERISTIC_FLUTTER_API = "KEY_GATT_CHARACTERISTIC_FLUTTER_API"
let KEY_AUTHORIZE_COMPLETION = "KEY_AUTHORIZE_COMPLETION"
let KEY_STATE_OBSERVER = "KEY_STATE_OBSERVER"
let KEY_CONNECT_COMPLETION = "KEY_CONNECT_COMPLETION"
let KEY_DISCONNECT_COMPLETION = "KEY_DISCONNECT_COMPLETION"
let KEY_DISCOVER_SERVICES_COMPLETION = "KEY_DISCOVER_SERVICES_COMPLETION"
let KEY_DISCOVER_CHARACTERISTICS_COMPLETION = "KEY_DISCOVER_CHARACTERISTICS_COMPLETION"
let KEY_DISCOVER_DESCRIPTORS_COMPLETION = "KEY_DISCOVER_DESCRIPTORS_COMPLETION"
let KEY_READ_COMPLETION = "KEY_READ_COMPLETION"
let KEY_WRITE_COMPLETION = "KEY_WRITE_COMPLETION"
let KEY_SET_NOTIFY_COMPLETION = "KEY_SET_NOTIFY_COMPLETION"

var items = [String: Any]()
var instances =  [NSNumber: NSObject]()
var identifiers = [NSObject: NSNumber]()

let central = CBCentralManager(delegate: centralManagerDelegate, queue: nil)
let centralManagerDelegate = MyCentralManagerDelegate()
let peripheralDelegate = MyPeripheralDelegate()

let centralHostApi = MyCentralManagerHostApi()
let peripherialHostApi = MyPeripheralHostApi()
let serviceHostApi = MyGattServiceHostApi()
let characteristicHostApi = MyGattCharacteristicHostApi()
let descriptorHostApi = MyGattDescriptorHostApi()

var centralFlutterApi: PigeonCentralManagerFlutterApi { return items[KEY_CENTRAL_MANAGER_FLUTTER_API] as! PigeonCentralManagerFlutterApi }
var peripheralFlutterApi: PigeonPeripheralFlutterApi { return items[KEY_PERIPHERAL_FLUTTER_API] as! PigeonPeripheralFlutterApi }
var characteristicFlutterApi: PigeonGattCharacteristicFlutterApi { return items[KEY_GATT_CHARACTERISTIC_FLUTTER_API] as! PigeonGattCharacteristicFlutterApi }

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

extension CBPeripheral {
    var maximumWriteLength: Int {
        let maximumWriteLengthWithResponse = maximumWriteValueLength(for: .withResponse)
        let maximumWriteLengthWithoutResponse = maximumWriteValueLength(for: .withoutResponse)
        let maximumWriteLength = min(maximumWriteLengthWithResponse, maximumWriteLengthWithoutResponse)
        return maximumWriteLength
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
