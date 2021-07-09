import Flutter
import UIKit
import CoreBluetooth

let NAMESAPCE = "yanshouwang.dev/bluetooth_low_energy"

typealias MessageCategory = Dev_Yanshouwang_BluetoothLowEnergy_MessageCategory
typealias Message = Dev_Yanshouwang_BluetoothLowEnergy_Message
typealias StartDiscoveryArguments = Dev_Yanshouwang_BluetoothLowEnergy_StartDiscoveryArguments
typealias Discovery = Dev_Yanshouwang_BluetoothLowEnergy_Discovery

public class SwiftBluetoothLowEnergyPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, CBCentralManagerDelegate, CBPeripheralDelegate {
    let SHORTENED_LOCAL_NAME_TYPE = 0x08
    let COMPLETE_LOCAL_NAME_TYPE: UInt8 = 0x09
    let MANUFACTURER_SPECIFIC_DATA_TYPE: UInt8 = 0xff
    let SERVICE_DATA_16BIT_TYPE: UInt8 = 0x16
    let SERVICE_DATA_32BIT_TYPE: UInt8 = 0x20
    let SERVICE_DATA_128BIT_TYPE: UInt8 = 0x21
    let INCOMPLETE_SERVICE_UUIDS_16BIT_TYPE: UInt8 = 0x02
    let INCOMPLETE_SERVICE_UUIDS_32BIT_TYPE: UInt8 = 0x04
    let INCOMPLETE_SERVICE_UUIDS_128BIT_TYPE: UInt8 = 0x06
    let COMPLETE_SERVICE_UUIDS_16BIT_TYPE: UInt8 = 0x03
    let COMPLETE_SERVICE_UUIDS_32BIT_TYPE: UInt8 = 0x05
    let COMPLETE_SERVICE_UUIDS_128BIT_TYPE: UInt8 = 0x07
    let SOLICITTED_SERVICE_UUIDS_16BIT_TYPE: UInt8 = 0x14
    let SOLICITTED_SERVICE_UUIDS_32BIT_TYPE: UInt8 = 0x1f
    let SOLICITTED_SERVICE_UUIDS_128BIT_TYPE: UInt8 = 0x15
    let TX_POWER_LEVEL_TYPE: UInt8 = 0x0a
    
    var events: FlutterEventSink? = nil
    var opened: Bool? = nil
    
    lazy var central = CBCentralManager(delegate: self, queue: nil)
    lazy var connects = [UUID: FlutterResult]()
    
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
            let error = FlutterError(code: "Central is closed.", message: nil, details: nil)
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
                central.stopScan()
                break
            case .centralConnect:
                let uuid = UUID(uuidString: message.connectArguments.uuid)!
                let connect = connects[uuid]
                if connect != nil {
                    let error = FlutterError(code: "Already in connecting state.", message: nil, details: nil)
                    result(error)
                }
                let peripheral = central.retrievePeripherals(withIdentifiers: [uuid]).first!
                connects[uuid] = result
                central.connect(peripheral, options: nil)
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
        // We can't analyze the complete raw advertisements on iOS.
        var advertisements = Data()
        for key in advertisementData.keys {
            switch key {
            case CBAdvertisementDataLocalNameKey:
                let name = advertisementData[key] as! String
                let data = name.data(using: .utf8)!
                let length = UInt8(data.count) + 1
                advertisements.append(length)
                // TODO: We don't know is this a SHORTENED_LOCAL_NAME or COMPLETE_LOCAL_NAME
                // Just use COMPLETE_LOCAL_NAME as type
                advertisements.append(COMPLETE_LOCAL_NAME_TYPE)
                advertisements.append(data)
                break
            case CBAdvertisementDataManufacturerDataKey:
                let data = advertisementData[key] as! Data
                let length = UInt8(data.count) + 1
                advertisements.append(length)
                advertisements.append(MANUFACTURER_SPECIFIC_DATA_TYPE)
                advertisements.append(data)
                break
            case CBAdvertisementDataServiceDataKey:
                let serviceData = advertisementData[key] as! [CBUUID: Data]
                var data = Data()
                for item in serviceData {
                    data.append(item.key.data)
                    data.append(item.value)
                }
                let length = UInt8(data.count) + 1
                advertisements.append(length)
                // TODO: Need to know the real SERVICE_DATA_TYPE
                advertisements.append(SERVICE_DATA_128BIT_TYPE)
                advertisements.append(data)
                break
            case CBAdvertisementDataServiceUUIDsKey:
                let serviceUUIDs = advertisementData[key] as! [CBUUID]
                var data = Data()
                for serviceUUID in serviceUUIDs {
                    data.append(serviceUUID.data)
                }
                let length = UInt8(data.count) + 1
                advertisements.append(length)
                // TODO: Need to know the real SERVICE_UUIDS_TYPE
                advertisements.append(COMPLETE_SERVICE_UUIDS_128BIT_TYPE)
                advertisements.append(data)
                break
            case CBAdvertisementDataOverflowServiceUUIDsKey:
                // TODO: What is an OVERFLOW_SERVICE_UUIDS_TYPE?
                // Maybe INCOMPLETE_SERVICE_UUIDS?
                break
            case CBAdvertisementDataTxPowerLevelKey:
                let txPowerLevel = advertisementData[key] as! UInt8
                advertisements.append(2)
                advertisements.append(TX_POWER_LEVEL_TYPE)
                advertisements.append(txPowerLevel)
                break
            case CBAdvertisementDataIsConnectable:
                break
            case CBAdvertisementDataSolicitedServiceUUIDsKey:
                let serviceUUIDs = advertisementData[key] as! [CBUUID]
                var data = Data()
                for serviceUUID in serviceUUIDs {
                    data.append(serviceUUID.data)
                }
                let length = UInt8(data.count) + 1
                advertisements.append(length)
                // TODO: Need to know the real SOLICITED_SERVICE_UUIDS_TYPE
                advertisements.append(SOLICITTED_SERVICE_UUIDS_128BIT_TYPE)
                advertisements.append(data)
                break
            default:
                break
            }
        }
        let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool ?? false
        let discovery = Discovery.with {
            $0.uuid = peripheral.identifier.uuidString
            $0.rssi = RSSI.int32Value
            $0.advertisements = advertisements
            $0.connectable = connectable
        }
        let message = try! Message.with {
            $0.category = .centralDiscovered
            $0.discovery = discovery
        }.serializedData()
        events?(message)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let connect = connects.removeValue(forKey: peripheral.identifier)!
        let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
        connect(error)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if error == nil {
            
        } else {
            
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error == nil {
            for service in peripheral.services! {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        } else {
            central.cancelPeripheralConnection(peripheral)
            let connect = connects.removeValue(forKey: peripheral.identifier)!
            let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
            connect(error)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error == nil {
            for characteristic in service.characteristics! {
                peripheral.discoverDescriptors(for: characteristic)
            }
        } else {
            let connect = connects.removeValue(forKey: peripheral.identifier)!
            let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
            connect(error)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if error == nil {
            
        } else {
            let connect = connects.removeValue(forKey: peripheral.identifier)!
            let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
            connect(error)
        }
    }
}

extension CBCentralManager {
    var opened: Bool { state == .poweredOn }
}
