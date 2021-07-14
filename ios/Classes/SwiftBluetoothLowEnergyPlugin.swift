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
typealias GattCharacteristicValue = Dev_Yanshouwang_BluetoothLowEnergy_GattCharacteristicValue

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
    
    lazy var peripherals = [Int32: CBPeripheral]()
    lazy var services = [Int32: CBService]()
    lazy var characteristics = [Int32: CBCharacteristic]()
    lazy var descriptors = [Int32: CBDescriptor]()
    
    lazy var connects = [CBPeripheral: FlutterResult]()
    lazy var disconnects = [CBPeripheral: FlutterResult]()
    lazy var characteristicReads = [CBCharacteristic: FlutterResult]()
    lazy var characteristicWrites = [CBCharacteristic: FlutterResult]()
    lazy var characteristicNotifies = [CBCharacteristic: FlutterResult]()
    lazy var descriptorReads = [CBDescriptor: FlutterResult]()
    lazy var descriptorWrites = [CBDescriptor: FlutterResult]()
    
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
        let command = try! Message(serializedData: arguments.data)
        switch command.category {
        case .bluetoothState:
            result(central.messageState.rawValue)
        case .centralStartDiscovery:
            let withServices = command.startDiscoveryArguments.services.map { CBUUID(string: $0) }
            let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            central.scanForPeripherals(withServices: withServices, options: options)
            result(nil)
        case .centralStopDiscovery:
            central.stopScan()
            result(nil)
        case .centralConnect:
            let uuid = UUID(uuidString: command.connectArguments.uuid)!
            let peripheral = central.retrievePeripherals(withIdentifiers: [uuid]).first!
            connects[peripheral] = result
            central.connect(peripheral, options: nil)
        case .gattDisconnect:
            let id = command.disconnectArguments.id
            let peripheral = peripherals[id]!
            disconnects[peripheral] = result
            central.cancelPeripheralConnection(peripheral)
        case .gattCharacteristicRead:
            let gattId = command.characteristicReadArguments.gattID
            let id = command.characteristicReadArguments.id
            let peripheral = peripherals[gattId]!
            let characteristic = characteristics[id]!
            characteristicReads[characteristic] = result
            peripheral.readValue(for: characteristic)
        case .gattCharacteristicWrite:
            let gattId = command.characteristicWriteArguments.gattID
            let id = command.characteristicWriteArguments.id
            let value = command.characteristicWriteArguments.value
            let type: CBCharacteristicWriteType = command.characteristicWriteArguments.withoutResponse ? .withoutResponse : .withResponse
            let peripheral = peripherals[gattId]!
            let characteristic = characteristics[id]!
            characteristicWrites[characteristic] = result
            peripheral.writeValue(value, for: characteristic, type: type)
            break
        case .gattCharacteristicNotify:
            let gattId = command.characteristicNotifyArguments.gattID
            let id = command.characteristicNotifyArguments.id
            let state = command.characteristicNotifyArguments.state
            let peripheral = peripherals[gattId]!
            let characteristic = characteristics[id]!
            characteristicNotifies[characteristic] = result
            peripheral.setNotifyValue(state, for: characteristic)
            break
        case .gattDescriptorRead:
            let gattId = command.descriptorReadArguments.gattID
            let id = command.descriptorReadArguments.id
            let peripheral = peripherals[gattId]!
            let descriptor = descriptors[id]!
            descriptorReads[descriptor] = result
            peripheral.readValue(for: descriptor)
            break
        case .gattDescriptorWrite:
            let gattId = command.descriptorWriteArguments.gattID
            let id = command.descriptorWriteArguments.id
            let value = command.descriptorWriteArguments.value
            let peripheral = peripherals[gattId]!
            let descriptor = descriptors[id]!
            descriptorWrites[descriptor] = result
            peripheral.writeValue(value, for: descriptor)
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
        let newState = central.messageState
        if newState == oldState {
            return
        } else if oldState == nil {
            oldState = newState
        } else {
            oldState = newState
            let event = try! Message.with {
                $0.category = .bluetoothState
                $0.state = newState
            }.serializedData()
            events?(event)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Can't analyze complete raw advertisements on iOS.
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
        let event = try! Message.with {
            $0.category = .centralDiscovered
            $0.discovery = discovery
        }.serializedData()
        events?(event)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let connect = connects.removeValue(forKey: peripheral)!
        let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
        connect(error)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if connects.keys.contains(peripheral) {
            let connect = connects.removeValue(forKey: peripheral)!
            let error = FlutterError(code: "GATT disconnected.", message: nil, details: nil)
            connect(error)
        } else {
            // TODO: services can't reach after disconnected.
            for service in peripheral.services! {
                for characteristic in service.characteristics! {
                    for descriptor in characteristic.descriptors! {
                        _ = descriptors.remove(value: descriptor)
                    }
                    _ = characteristics.remove(value: characteristic)
                }
                _ = services.remove(value: service)
            }
            let key = peripherals.remove(value: peripheral)
            if disconnects.keys.contains(peripheral) {
                let disconnect = disconnects.removeValue(forKey: peripheral)!
                disconnect(nil)
            } else {
                let connectionLost = GattConnectionLost.with {
                    $0.id = key
                    $0.error = error!.localizedDescription
                }
                let event = try! Message.with {
                    $0.category = MessageCategory.gattConnectionLost
                    $0.connectionLost = connectionLost
                }.serializedData()
                events?(event)
            }
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
            let nextCharacteristic = characteristic.service.characteristics?.first(where: { $0.descriptors == nil })
            if nextCharacteristic == nil {
                let nextService = peripheral.services?.first(where: { $0.characteristics == nil })
                if nextService == nil {
                    let peripheralKey = peripherals.add(value: peripheral)
                    var messageServices = [GattService]()
                    for service in peripheral.services! {
                        let serviceKey = self.services.add(value: service)
                        var messageCharacteristics = [GattCharacteristic]()
                        for characteristic in service.characteristics! {
                            let characteristicKey = characteristics.add(value: characteristic)
                            var messageDescriptors = [GattDescriptor]()
                            for descriptor in characteristic.descriptors! {
                                let descriptorKey = descriptors.add(value: descriptor)
                                let messageDescriptor = GattDescriptor.with {
                                    $0.id = descriptorKey
                                    $0.uuid = descriptor.uuid.uuidString
                                }
                                messageDescriptors.append(messageDescriptor)
                            }
                            let messageCharacteristic = GattCharacteristic.with {
                                $0.id = characteristicKey
                                $0.uuid = characteristic.uuid.uuidString
                                $0.canRead = characteristic.properties.contains(.read)
                                $0.canWrite = characteristic.properties.contains(.write)
                                $0.canWriteWithoutResponse = characteristic.properties.contains(.writeWithoutResponse)
                                $0.canNotify = characteristic.properties.contains(.notify)
                                $0.descriptors = messageDescriptors
                            }
                            messageCharacteristics.append(messageCharacteristic)
                        }
                        let messageService = GattService.with {
                            $0.id = serviceKey
                            $0.uuid = service.uuid.uuidString
                            $0.characteristics = messageCharacteristics
                        }
                        messageServices.append(messageService)
                    }
                    let reply = try! GATT.with {
                        $0.id = peripheralKey
                        $0.maximumWriteLength = peripheral.maximumWriteLength
                        $0.services = messageServices
                    }.serializedData()
                    let connect = connects.removeValue(forKey: peripheral)!
                    connect(reply)
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
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let read = characteristicReads.removeValue(forKey: characteristic)
        if read == nil {
            let key = characteristics.first(where: { $1 === characteristic })!.key
            let characteristicValue = GattCharacteristicValue.with {
                $0.id = key
                $0.value = characteristic.value!
            }
            let event = try! Message.with {
                $0.category = .gattCharacteristicNotify
                $0.characteristicValue = characteristicValue
            }.serializedData()
            events?(event)
        } else if error == nil {
            read!(characteristic.value!)
        } else {
            let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
            read!(error)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        let write = characteristicWrites.removeValue(forKey: characteristic)!
        if error == nil {
            write(nil)
        } else {
            let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
            write(error)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        let notify = characteristicNotifies[characteristic]!
        if error == nil {
            notify(nil)
        } else {
            let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
            notify(error)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        let read = descriptorReads[descriptor]!
        if error == nil {
            read(descriptor.value!)
        } else {
            let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
            read(error)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        let write = descriptorWrites[descriptor]!
        if error == nil {
            write(nil)
        } else {
            let error = FlutterError(code: error!.localizedDescription, message: nil, details: nil)
            write(error)
        }
    }
}

extension CBCentralManager {
    var messageState: BluetoothState {
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
    var maximumWriteLength: Int32 {
        let maximumWriteLengthWithResponse = maximumWriteValueLength(for: .withResponse)
        let maximumWriteLengthWithoutResponse = maximumWriteValueLength(for: .withoutResponse)
        // TODO: Is this two length the same value?
        let maximumWriteLength = min(maximumWriteLengthWithResponse, maximumWriteLengthWithoutResponse)
        return Int32(maximumWriteLength)
    }
}

extension Dictionary where Key == Int32, Value : AnyObject {
    mutating func add(value: Value) -> Int32 {
        for key in 0...Int32.max {
            if keys.contains(key) {
                continue
            }
            self[key] = value
            return key
        }
        fatalError("Memory leak when add value.")
    }
    
    mutating func remove(value: Value) -> Int32 {
        let key = first(where: { $1 === value })!.key
        removeValue(forKey: key)
        return key
    }
}
