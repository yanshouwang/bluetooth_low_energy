import Flutter
import UIKit
import CoreBluetooth

let NAMESAPCE = "yanshouwang.dev/bluetooth_low_energy"

typealias MessageCategory = Dev_Yanshouwang_BluetoothLowEnergy_MessageCategory
typealias Message = Dev_Yanshouwang_BluetoothLowEnergy_Message
typealias BluetoothState = Dev_Yanshouwang_BluetoothLowEnergy_BluetoothState
typealias StartDiscoveryArguments = Dev_Yanshouwang_BluetoothLowEnergy_StartDiscoveryArguments
typealias Discovery = Dev_Yanshouwang_BluetoothLowEnergy_Discovery
typealias GATT = Dev_Yanshouwang_BluetoothLowEnergy_GATT
typealias GattService = Dev_Yanshouwang_BluetoothLowEnergy_GattService
typealias GattCharacteristic = Dev_Yanshouwang_BluetoothLowEnergy_GattCharacteristic
typealias GattDescriptor = Dev_Yanshouwang_BluetoothLowEnergy_GattDescriptor
typealias GattConnectionLost = Dev_Yanshouwang_BluetoothLowEnergy_GattConnectionLost

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
    
    let central: CBCentralManager
    var oldState: BluetoothState? = nil
    
    public override init() {
        central = CBCentralManager()
        super.init()
        central.delegate = self
    }
    
    // Need to keep a strong reference when connect to a peripheral.
    lazy var connects = [UUID: FlutterResult]()
    lazy var peripherals = [Int: CBPeripheral]()
    lazy var disconnects = [Int: FlutterResult]()
    
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
        let arguments = call.arguments as! FlutterStandardTypedData
        let message = try! Message(serializedData: arguments.data)
        switch message.category {
        case .bluetoothState:
            result(central.bluetoothState.rawValue)
        case .centralStartDiscovery:
            let withServices = message.startDiscoveryArguments.services.map { CBUUID(string: $0) }
            let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            central.scanForPeripherals(withServices: withServices, options: options)
            result(nil)
        case .centralStopDiscovery:
            central.stopScan()
            result(nil)
        case .centralConnect:
            let arguments = message.connectArguments
            let uuid = UUID(uuidString: arguments.uuid)!
            let connect = connects[uuid]
            if connect != nil {
                let error = FlutterError(code: "Already in connecting state.", message: nil, details: nil)
                result(error)
            } else {
                let peripheral = central.retrievePeripherals(withIdentifiers: [uuid]).first!
                connects[uuid] = result
                let id = peripheral.hash
                peripherals[id] = peripheral
                central.connect(peripheral, options: nil)
            }
        case .gattDisconnect:
            let arguments = message.disconnectArguments
            let id = Int(arguments.id)
            let disconnect = disconnects[id]
            if disconnect != nil {
                let error = FlutterError(code: "Already in disconnecting state.", message: nil, details: nil)
                result(error)
            } else {
                let peripheral = peripherals.removeValue(forKey: id)!
                disconnects[id] = result
                central.cancelPeripheralConnection(peripheral)
            }
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
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.events = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        events = nil
        return nil
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let newState = central.bluetoothState
        if newState == oldState {
            return
        } else if oldState == nil {
            oldState = newState
        } else {
            oldState = newState
            let message = try! Message.with {
                $0.category = .bluetoothState
                $0.state = newState
            }.serializedData()
            events?(message)
        }
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
        peripherals.removeValue(forKey: peripheral.hash)
        let connect = connects.removeValue(forKey: peripheral.identifier)!
        let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
        connect(error)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripherals.removeValue(forKey: peripheral.hash)
        let connect = connects.removeValue(forKey: peripheral.identifier)
        let disconnect = disconnects.removeValue(forKey: peripheral.hash)
        if connect != nil {
            let error = FlutterError(code: "GATT disconnected.", message: nil, details: nil)
            connect!(error)
        } else if disconnect != nil {
            disconnect!(nil)
        } else {
            let id32 = NSNumber(value: hash).int32Value
            let connectionLost = GattConnectionLost.with {
                $0.id = id32
                $0.error = error!.localizedDescription
            }
            let message = try! Message.with {
                $0.category = MessageCategory.gattConnectionLost
                $0.connectionLost = connectionLost
            }.serializedData()
            events?(message)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error == nil {
            let service = peripheral.services?.first(where: { $0.characteristics == nil })
            peripheral.discoverCharacteristics(nil, for: service!)
        } else {
            central.cancelPeripheralConnection(peripheral)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error == nil {
            let characteristic = service.characteristics?.first(where: { $0.descriptors == nil })
            if characteristic != nil {
                peripheral.discoverDescriptors(for: characteristic!)
            }
        } else {
            central.cancelPeripheralConnection(peripheral)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if error == nil {
            let service = characteristic.service
            let nextCharacteristic = service.characteristics?.first(where: { $0.descriptors == nil })
            if nextCharacteristic == nil {
                let nextService = peripheral.services?.first(where: { $0.characteristics == nil })
                if nextService == nil {
                    let connect = connects.removeValue(forKey: peripheral.identifier)!
                    let gatt = try! peripheral.gatt.serializedData()
                    connect(gatt)
                } else {
                    peripheral.discoverCharacteristics(nil, for: nextService!)
                }
            } else {
                peripheral.discoverDescriptors(for: nextCharacteristic!)
            }
        } else {
            central.cancelPeripheralConnection(peripheral)
        }
    }
}

extension CBCentralManager {
    var bluetoothState: BluetoothState {
        switch state {
        case .unknown:
            return .unsupported
        case .resetting:
            return .unsupported
        case .unsupported:
            return .unsupported
        case .unauthorized:
            return .unsupported
        case .poweredOff:
            return .poweredOff
        case .poweredOn:
            return .poweredOn
        default:
            return .UNRECOGNIZED(-1)
        }
    }
}

extension CBPeripheral {
    var gatt: GATT {
        let id32 = NSNumber(value: hash).int32Value
        let maximumWriteLengthWithResponse = maximumWriteValueLength(for: .withResponse)
        let maximumWriteLengthWithoutResponse = maximumWriteValueLength(for: .withoutResponse)
        let maximumWriteLength = min(maximumWriteLengthWithResponse, maximumWriteLengthWithoutResponse)
        let maximumWriteLength32 = NSNumber(value: maximumWriteLength).int32Value
        let gattServices = services?.map({ $0.gattService })
        return GATT.with {
            $0.id = id32
            $0.maximumWriteLength = maximumWriteLength32
            $0.services = gattServices!
        }
    }
}

extension CBService {
    var gattService: GattService {
        let id32 = NSNumber(value: hash).int32Value
        let uuidString = uuid.uuidString
        let gattCharacteristics = characteristics?.map({ $0.gattCharacteristic })
        return GattService.with {
            $0.id = id32
            $0.uuid = uuidString
            $0.characteristics = gattCharacteristics!
        }
    }
}

extension CBCharacteristic {
    var gattCharacteristic: GattCharacteristic {
        let id32 = NSNumber(value: hash).int32Value
        let uuidString = uuid.uuidString
        let canRead = properties.contains(.read)
        let canWrite = properties.contains(.write)
        let canWriteWithoutResponse = properties.contains(.writeWithoutResponse)
        let canNotify = properties.contains(.notify)
        let gattDescriptors = descriptors?.map({ $0.gattDescriptor })
        return GattCharacteristic.with {
            $0.id = id32
            $0.uuid = uuidString
            $0.canRead = canRead
            $0.canWrite = canWrite
            $0.canWriteWithoutResponse = canWriteWithoutResponse
            $0.canNotify = canNotify
            $0.descriptors = gattDescriptors!
        }
    }
}

extension CBDescriptor {
    var gattDescriptor: GattDescriptor {
        let id32 = NSNumber(value: hash).int32Value
        let uuidString = uuid.uuidString
        return GattDescriptor.with {
            $0.id = id32
            $0.uuid = uuidString
        }
    }
}
