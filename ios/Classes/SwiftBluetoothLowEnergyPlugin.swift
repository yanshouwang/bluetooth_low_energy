import Flutter
import UIKit
import CoreBluetooth

let NAMESAPCE = "yanshouwang.dev/bluetooth_low_energy"

typealias MessageCategory = Dev_Yanshouwang_BluetoothLowEnergy_MessageCategory
typealias Message = Dev_Yanshouwang_BluetoothLowEnergy_Message
typealias StartDiscoveryArguments = Dev_Yanshouwang_BluetoothLowEnergy_StartDiscoveryArguments
typealias Discovery = Dev_Yanshouwang_BluetoothLowEnergy_Discovery

public class SwiftBluetoothLowEnergyPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, CBCentralManagerDelegate {
    var events: FlutterEventSink? = nil
    var opened: Bool? = nil
    
    lazy var central = CBCentralManager(delegate: self, queue: nil)
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftBluetoothLowEnergyPlugin()
        let messenger = registrar.messenger()
        let method = FlutterMethodChannel(name: "\(NAMESAPCE)/method", binaryMessenger: messenger)
        registrar.addMethodCallDelegate(instance, channel: method)
        let event = FlutterEventChannel(name: "\(NAMESAPCE)/event", binaryMessenger: messenger)
        event.setStreamHandler(instance)
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        debugPrint("on detach from engine.")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        let category = call.category
//        if category != .bluetoothAvailable && category != .bluetoothState && !central.opened {
//            let error = FlutterError(code: "Central closed.", message: nil, details: nil)
//            result(error)
//        } else {
//            switch category {
//            case .bluetoothAvailable:
//                result(central.state != .unsupported)
//                break
//            case .bluetoothState:
//                result(central.opened)
//                break
//            case .centralStartDiscovery:
//                let withServices = call.startDiscoveryArguments.withServices
//                central.scanForPeripherals(withServices: withServices, options: nil)
//                break
//            case .centralStopDiscovery:
//                break
//            case .centralConnect:
//                break
//            case .gattDisconnect:
//                break
//            case .gattCharacteristicRead:
//                break
//            case .gattCharacteristicWrite:
//                break
//            case .gattCharacteristicNotify:
//                break
//            case .gattDescriptorRead:
//                break
//            case .gattDescriptorWrite:
//                break
//            default:
//                result(FlutterMethodNotImplemented)
//            }
//        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.events = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        events = nil
        return nil
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        let opened = central.opened
//        if self.opened != nil && self.opened != opened {
//            let event = try! Message.with {
//                $0.category = .bluetoothState
//                $0.state = opened
//            }.serializedData()
//            events?(event)
//        }
//        self.opened = opened
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        let advertisements = advertisementData[""]
//        Message().value.
//
//        let discovery = Discovery.with {
//            $0.address = peripheral.identifier.uuidString
//            $0.rssi = RSSI.int32Value
//            $0.advertisements = advertisementData
//        }
//        let event = try! Message.with {
//            $0.category = .centralDiscovered
//            $0.discovery = discovery
//        }.serializedData()
//        events?(event)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
}

//extension FlutterMethodCall {
//    var category: Dev_Yanshouwang_BluetoothLowEnergy_MessageCategory {
//        switch method {
//        case "BLUETOOTH_AVAILABLE":
//            return .bluetoothAvailable
//        case "BLUETOOTH_STATE":
//            return .bluetoothState
//        case "CENTRAL_START_DISCOVERY":
//            return .centralStartDiscovery
//        case "CENTRAL_STOP_DISCOVERY":
//            return .centralStopDiscovery
//        case "CENTRAL_DISCOVERED":
//            return .centralDiscovered
//        case "CENTRAL_CONNECT":
//            return .centralConnect
//        case "GATT_DISCONNECT":
//            return .gattDisconnect
//        case "GATT_CONNECTION_LOST":
//            return .gattConnectionLost
//        case "GATT_CHARACTERISTIC_READ":
//            return .gattCharacteristicRead
//        case "GATT_CHARACTERISTIC_WRITE":
//            return .gattCharacteristicWrite
//        case "GATT_DESCRIPTOR_READ":
//            return .gattDescriptorRead
//        case "GATT_DESCRIPTOR_WRITE":
//            return .gattDescriptorWrite
//        default:
//            return MessageCategory.UNRECOGNIZED(-1)
//        }
//    }
//
//    var startDiscoveryArguments: StartDiscoveryArguments { try! StartDiscoveryArguments(serializedData: arguments as! Data) }
//}
//
//extension CBCentralManager {
//    var opened: Bool { state == .poweredOn }
//}
//
//extension StartDiscoveryArguments {
//    var withServices: [CBUUID] { services.map { CBUUID(string: $0) } }
//}
