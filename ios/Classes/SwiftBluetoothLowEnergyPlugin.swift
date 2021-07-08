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
        let message = try! Message(serializedData: call.arguments as! Data)
        let category = message.category
        if category != .bluetoothAvailable && category != .bluetoothState && !central.opened {
            let error = FlutterError(code: "Central closed.", message: nil, details: nil)
            result(error)
        } else {
            switch category {
            case .bluetoothAvailable:
                result(central.state != .unsupported)
                break
            case .bluetoothState:
                result(central.opened)
                break
            case .centralStartDiscovery:
                let withServices = message.startDiscoveryArguments.services.map { CBUUID(string: $0) }
                central.scanForPeripherals(withServices: withServices, options: nil)
                break
            case .centralStopDiscovery:
                break
            case .centralConnect:
                break
            case .gattDisconnect:
                break
            case .gattCharacteristicRead:
                break
            case .gattCharacteristicWrite:
                break
            case .gattCharacteristicNotify:
                break
            case .gattDescriptorRead:
                break
            case .gattDescriptorWrite:
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        }
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
        let opened = central.opened
        if self.opened != nil && self.opened != opened {
            let message = try! Message.with {
                $0.category = .bluetoothState
                $0.state = opened
            }.serializedData()
            events?(message)
        }
        self.opened = opened
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var advertisements = Data()
        for key in advertisementData.keys {
            switch key {
            case CBAdvertisementDataLocalNameKey:
                let name = advertisementData[key] as! String
                let data = name.data(using: .utf8)!
                let length = UInt8(data.count) + 1
                advertisements.append(length)
                advertisements.append(0x09)
                advertisements.append(data)
                break
            case CBAdvertisementDataManufacturerDataKey:
                let data = advertisementData[key] as! Data
                let length = UInt8(data.count) + 1
                advertisements.append(length)
                advertisements.append(0xff)
                advertisements.append(data)
                break
            case CBAdvertisementDataServiceDataKey:
                let serviceData = advertisementData[key] as! [CBUUID: Data]
                
                break
            case CBAdvertisementDataServiceUUIDsKey:
                let serviceUUIDs = advertisementData[key] as! [CBUUID]
                
                break
            case CBAdvertisementDataOverflowServiceUUIDsKey:
                let serviceUUIDs = advertisementData[key] as! [CBUUID]
                
                break
            case CBAdvertisementDataTxPowerLevelKey:
                let txPowerLevel = advertisementData[key] as! UInt8
                
                break
            case CBAdvertisementDataIsConnectable:
                let connectable = advertisementData[key] as! Uint8
                advertisements.append(2)
                advertisements.append(0xaa)
                advertisements.append(connectable)
                break
            case CBAdvertisementDataSolicitedServiceUUIDsKey:
                let solicitedServiceUUIDs = advertisementData[key] as! [CBUUID]
                
                break
            default:
                break
            }
        }
        let discovery = Discovery.with {
            $0.uuid = peripheral.identifier.uuidString
            $0.rssi = RSSI.int32Value
            $0.advertisements = advertisements
        }
        let message = try! Message.with {
            $0.category = .centralDiscovered
            $0.discovery = discovery
        }.serializedData()
        events?(message)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
}

extension CBCentralManager {
    var opened: Bool { state == .poweredOn }
}
