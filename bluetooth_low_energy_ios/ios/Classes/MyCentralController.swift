//
//  MyCentralController.swift
//  bluetooth_low_energy_ios
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import Flutter
import CoreBluetooth

class MyCentralController: MyCentralControllerHostApi {
    init(_ binaryMessenger: FlutterBinaryMessenger) {
        myApi = MyCentralControllerFlutterApi(binaryMessenger: binaryMessenger)
    }
    
    private let myApi: MyCentralControllerFlutterApi
    private lazy var myCentralManagerDelegate = MyCentralManagerDelegate(self)
    private lazy var myPeripheralDelegate = MyPeripheralDelegate(self)
    private let centralManager = CBCentralManager()
    
    private var peripherals = [Int: CBPeripheral]()
    private var services = [Int: CBService]()
    private var characteristics = [Int: CBCharacteristic]()
    private var descriptors = [Int: CBDescriptor]()
    
    var setUpCompletion: ((Result<MyCentralControllerArgs, Error>) -> Void)?
    var connectCompletions = [Int: (Result<Void, Error>) -> Void]()
    var disconnectCompletions = [Int: (Result<Void, Error>) -> Void]()
    var discoverGattCompletions = [Int: (Result<Void, Error>) -> Void]()
    var unfinishedServices = [Int: [CBService]]()
    var unfinishedCharacteristics = [Int: [CBCharacteristic]]()
    var readCharacteristicCompletions = [Int: (Result<FlutterStandardTypedData, Error>) -> Void]()
    var writeCharacteristicCompletions = [Int: (Result<Void, Error>) -> Void]()
    var notifyCharacteristicCompletions = [Int: (Result<Void, Error>) -> Void]()
    var readDescriptorCompletions = [Int: (Result<FlutterStandardTypedData, Error>) -> Void]()
    var writeDescriptorCompletions = [Int: (Result<Void, Error>) -> Void]()
    
    func setUp(completion: @escaping (Result<MyCentralControllerArgs, Error>) -> Void) {
        do {
            let unfinishedCompletion = setUpCompletion
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            centralManager.delegate = myCentralManagerDelegate
            if centralManager.state == .unknown {
                setUpCompletion = completion
            } else {
                let myStateArgs = centralManager.state.toMyArgs()
                let myStateNumber = Int64(myStateArgs.rawValue)
                let myArgs = MyCentralControllerArgs(myStateNumber: myStateNumber)
                completion(.success(myArgs))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func tearDown() throws {
        centralManager.delegate = nil
        if(centralManager.isScanning) {
            centralManager.stopScan()
        }
        for peripheral in peripherals.values {
            peripheral.delegate = nil
            if peripheral.state != .disconnected {
                centralManager.cancelPeripheralConnection(peripheral)
            }
        }
        peripherals.removeAll()
        services.removeAll()
        characteristics.removeAll()
        descriptors.removeAll()
    }
    
    func startDiscovery() throws {
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        centralManager.scanForPeripherals(withServices: nil, options: options)
    }
    
    func stopDiscovery() throws {
        centralManager.stopScan()
    }
    
    func connect(myPeripheralKey: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheralKey = Int(myPeripheralKey)
            let unfinishedCompletion = connectCompletions[peripheralKey]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralKey] else {
                throw MyError.illegalArgument
            }
            centralManager.connect(peripheral)
            connectCompletions[peripheralKey] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func disconnect(myPeripheralKey: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheralKey = Int(myPeripheralKey)
            let unfinishedCompletion = disconnectCompletions[peripheralKey]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralKey] else {
                throw MyError.illegalArgument
            }
            centralManager.cancelPeripheralConnection(peripheral)
            disconnectCompletions[peripheralKey] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverGATT(myPeripheralKey: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheralKey = Int(myPeripheralKey)
            let unfinishedCompletion = discoverGattCompletions[peripheralKey]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralKey] else {
                throw MyError.illegalArgument
            }
            peripheral.discoverServices(nil)
            discoverGattCompletions[peripheralKey] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func getServices(myPeripheralKey: Int64) throws -> [MyGattServiceArgs] {
        let peripheralKey = Int(myPeripheralKey)
        guard let peripheral = peripherals[peripheralKey] else {
            throw MyError.illegalArgument
        }
        let services = peripheral.services ?? []
        return services.map { service in
            let serviceKey = service.hash
            if self.services[serviceKey] == nil {
                self.services[serviceKey] = service
            }
            return service.toMyArgs()
        }
    }
    
    func getCharacteristics(myServiceKey: Int64) throws -> [MyGattCharacteristicArgs] {
        let serviceKey = Int(myServiceKey)
        guard let service = services[serviceKey] else {
            throw MyError.illegalArgument
        }
        let characteristics = service.characteristics ?? []
        return characteristics.map { characteristic in
            let characteristicKey = characteristic.hash
            if self.characteristics[characteristicKey] == nil {
                self.characteristics[characteristicKey] = characteristic
            }
            return characteristic.toMyArgs()
        }
    }
    
    func getDescriptors(myCharacteristicKey: Int64) throws -> [MyGattDescriptorArgs] {
        let characteristicKey = Int(myCharacteristicKey)
        guard let characteristic = characteristics[characteristicKey] else {
            throw MyError.illegalArgument
        }
        let descritors = characteristic.descriptors ?? []
        return descritors.map { descriptor in
            let descriptorKey = descriptor.hash
            if self.descriptors[descriptorKey] == nil {
                self.descriptors[descriptorKey] = descriptor
            }
            return descriptor.toMyArgs()
        }
    }
    
    func readCharacteristic(myPeripheralKey: Int64, myCharacteristicKey: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let peripheralKey = Int(myPeripheralKey)
            guard let peripheral = peripherals[peripheralKey] else {
                throw MyError.illegalArgument
            }
            let characteristicKey = Int(myCharacteristicKey)
            guard let characteristic = characteristics[characteristicKey] else {
                throw MyError.illegalArgument
            }
            let unfinishedCompletion = readCharacteristicCompletions[characteristicKey]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            peripheral.readValue(for: characteristic)
            readCharacteristicCompletions[characteristicKey] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeCharacteristic(myPeripheralKey: Int64, myCharacteristicKey: Int64, value: FlutterStandardTypedData, myTypeNumber: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheralKey = Int(myPeripheralKey)
            guard  let peripheral = peripherals[peripheralKey] else {
                throw MyError.illegalArgument
            }
            let characteristicKey = Int(myCharacteristicKey)
            guard let characteristic = characteristics[characteristicKey] else {
                throw MyError.illegalArgument
            }
            let data = value.data
            let myTypeRawValue = Int(myTypeNumber)
            guard let myTypeArgs = MyGattCharacteristicWriteTypeArgs(rawValue: myTypeRawValue) else {
                throw MyError.illegalArgument
            }
            let type = myTypeArgs.toType()
            let unfinishedCompletion = writeCharacteristicCompletions[characteristicKey]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            peripheral.writeValue(data, for: characteristic, type: type)
            writeCharacteristicCompletions[characteristicKey] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func notifyCharacteristic(myPeripheralKey: Int64, myCharacteristicKey: Int64, state: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheralKey = Int(myPeripheralKey)
            guard let peripheral = peripherals[peripheralKey] else {
                throw MyError.illegalArgument
            }
            let characteristicKey = Int(myCharacteristicKey)
            guard let characteristic = characteristics[characteristicKey] else {
                throw MyError.illegalArgument
            }
            let unfinishedCompletion = notifyCharacteristicCompletions[characteristicKey]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            peripheral.setNotifyValue(state, for: characteristic)
            notifyCharacteristicCompletions[characteristicKey] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readDescriptor(myPeripheralKey: Int64, myDescriptorKey: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let peripheralKey = Int(myPeripheralKey)
            guard let peripheral = peripherals[peripheralKey] else {
                throw MyError.illegalArgument
            }
            let descriptorKey = Int(myDescriptorKey)
            guard let descriptor = descriptors[descriptorKey] else {
                throw MyError.illegalArgument
            }
            let unfinishedCompletion = readDescriptorCompletions[descriptorKey]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            peripheral.readValue(for: descriptor)
            readDescriptorCompletions[descriptorKey] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeDescriptor(myPeripheralKey: Int64, myDescriptorKey: Int64, value: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheralKey = Int(myPeripheralKey)
            guard let peripheral = peripherals[peripheralKey] else {
                throw MyError.illegalArgument
            }
            let descriptorKey = Int(myDescriptorKey)
            guard let descriptor = descriptors[descriptorKey] else {
                throw MyError.illegalArgument
            }
            let data = value.data
            let unfinishedCompletion = writeDescriptorCompletions[descriptorKey]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            peripheral.writeValue(data, for: descriptor)
            writeDescriptorCompletions[descriptorKey] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func didUpdateState(_ state: CBManagerState) {
        let completion = setUpCompletion
        if state != .unknown && completion != nil {
            let myStateArgs = state.toMyArgs()
            let myStateNumber = Int64(myStateArgs.rawValue)
            let myArgs = MyCentralControllerArgs(myStateNumber: myStateNumber)
            completion!(.success(myArgs))
            setUpCompletion = nil
        }
        let myStateArgs = state.toMyArgs()
        let myStateNumber = Int64(myStateArgs.rawValue)
        myApi.onStateChanged(myStateNumber: myStateNumber) {}
    }
    
    
    func didDiscover(_ peripheral: CBPeripheral, _ advertisementData: [String : Any], _ rssiNumber: NSNumber) {
        let peripheralKey = peripheral.hash
        if peripherals[peripheralKey] == nil {
            peripheral.delegate = myPeripheralDelegate
            peripherals[peripheralKey] = peripheral
        }
        let myPeripheralArgs = peripheral.toMyArgs()
        let rssi = rssiNumber.int64Value
        let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        let rawManufacturerSpecificData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
        var manufacturerSpecificData = [Int64: FlutterStandardTypedData]()
        if rawManufacturerSpecificData != nil {
            do {
                guard let data = rawManufacturerSpecificData else {
                    throw MyError.illegalArgument
                }
                guard data.count >= 2 else {
                    throw MyError.illegalArgument
                }
                let key = Int64(data[0]) | (Int64(data[1]) << 8)
                let bytes = data.count > 2 ? data[2...data.count-1] : Data()
                let value = FlutterStandardTypedData(bytes: bytes)
                manufacturerSpecificData[key] = value
            } catch {
                manufacturerSpecificData = [:]
            }
        }
        let rawServiceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
        let serviceUUIDs = rawServiceUUIDs.map { uuid in uuid.uuidString }
        let rawServiceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] ?? [:]
        let elements = rawServiceData.map { (uuid, data) in
            let key = uuid.uuidString
            let value = FlutterStandardTypedData(bytes: data)
            return (key, value)
        }
        let serviceData = [String?: FlutterStandardTypedData?](uniqueKeysWithValues: elements)
        let myAdvertisementArgs = MyAdvertisementArgs(name: name, manufacturerSpecificData: manufacturerSpecificData, serviceUUIDs: serviceUUIDs, serviceData: serviceData)
        myApi.onDiscovered(myPeripheralArgs: myPeripheralArgs, rssi: rssi, myAdvertisementArgs: myAdvertisementArgs) {}
    }
    
    func didConnect(_ peripheral: CBPeripheral) {
        let peripheralKey = peripheral.hash
        let myPeripheralKey = Int64(peripheralKey)
        myApi.onPeripheralStateChanged(myPeripheralKey: myPeripheralKey, state: true) {}
        guard let completion = connectCompletions.removeValue(forKey: peripheralKey) else {
            return
        }
        completion(.success(()))
    }
    
    func didFailToConnect(_ peripheral: CBPeripheral, _ error: Error?) {
        let peripheralKey = peripheral.hash
        guard let completion = connectCompletions.removeValue(forKey: peripheralKey) else {
            return
        }
        completion(.failure(error ?? MyError.unknown))
    }
    
    func didDisconnectPeripheral(_ peripheral: CBPeripheral, _ error: Error?) {
        let peripheralKey = peripheral.hash
        let myPeripheralKey = Int64(peripheralKey)
        let discoverGattCompletion = discoverGattCompletions.removeValue(forKey: peripheralKey)
        if discoverGattCompletion != nil {
            discoverGattCompletion!(.failure(error ?? MyError.illegalState))
        }
        let services = peripheral.services ?? []
        for service in services {
            let characteristics = service.characteristics ?? []
            for characteristic in characteristics {
                let characteristicKey = characteristic.hash
                let readCharacteristicCompletion = readCharacteristicCompletions.removeValue(forKey: characteristicKey)
                let writeCharacteristicCompletion = writeCharacteristicCompletions.removeValue(forKey: characteristicKey)
                if readCharacteristicCompletion != nil {
                    readCharacteristicCompletion!(.failure(MyError.illegalState))
                }
                if writeCharacteristicCompletion != nil {
                    writeCharacteristicCompletion!(.failure(MyError.illegalState))
                }
                let descriptors = characteristic.descriptors ?? []
                for descriptor in descriptors {
                    let descriptorKey = descriptor.hash
                    let readDescriptorCompletion = readDescriptorCompletions.removeValue(forKey: descriptorKey)
                    let writeDescriptorCompletion = writeDescriptorCompletions.removeValue(forKey: descriptorKey)
                    if readDescriptorCompletion != nil {
                        readDescriptorCompletion!(.failure(MyError.illegalState))
                    }
                    if writeDescriptorCompletion != nil {
                        writeDescriptorCompletion!(.failure(MyError.illegalState))
                    }
                }
            }
        }
        myApi.onPeripheralStateChanged(myPeripheralKey: myPeripheralKey, state: false) {}
        guard let completion = disconnectCompletions.removeValue(forKey: peripheralKey) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    
    func didDiscoverServices(_ peripheral: CBPeripheral, _ error: Error?) {
        let peripheralKey = peripheral.hash
        guard let completion = discoverGattCompletions[peripheralKey] else {
            return
        }
        if error == nil {
            var services = peripheral.services ?? []
            if services.isEmpty {
                discoverGattCompletions.removeValue(forKey: peripheralKey)
                completion(.success(()))
            } else {
                let service = services.removeFirst()
                unfinishedServices[peripheralKey] = services
                peripheral.discoverCharacteristics(nil, for: service)
            }
        } else {
            discoverGattCompletions.removeValue(forKey: peripheralKey)
            completion(.failure(error!))
        }
    }
    
    func didDiscoverCharacteristics(_ peripheral: CBPeripheral, _ service: CBService, _ error: Error?) {
        let peripheralKey = peripheral.hash
        guard let completion = discoverGattCompletions[peripheralKey] else {
            return
        }
        if error == nil {
            var characteristics = service.characteristics ?? []
            if characteristics.isEmpty {
                var services = unfinishedServices.removeValue(forKey: peripheralKey) ?? []
                if services.isEmpty {
                    discoverGattCompletions.removeValue(forKey: peripheralKey)
                    completion(.success(()))
                } else {
                    let service = services.removeFirst()
                    unfinishedServices[peripheralKey] = services
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            } else {
                let characteristic = characteristics.removeFirst()
                unfinishedCharacteristics[peripheralKey] = characteristics
                peripheral.discoverDescriptors(for: characteristic)
            }
        } else {
            discoverGattCompletions.removeValue(forKey: peripheralKey)
            unfinishedServices.removeValue(forKey: peripheralKey)
            completion(.failure(error!))
        }
    }
    
    func didDiscoverDescriptors(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) {
        let peripheralKey = peripheral.hash
        guard let completion = discoverGattCompletions[peripheralKey] else {
            return
        }
        if error == nil {
            var characteristics = unfinishedCharacteristics.removeValue(forKey: peripheralKey) ?? []
            if (characteristics.isEmpty) {
                var services = unfinishedServices.removeValue(forKey: peripheralKey) ?? []
                if services.isEmpty {
                    discoverGattCompletions.removeValue(forKey: peripheralKey)
                    completion(.success(()))
                } else {
                    let service = services.removeFirst()
                    unfinishedServices[peripheralKey] = services
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            } else {
                let characteristic = characteristics.removeFirst()
                unfinishedCharacteristics[peripheralKey] = characteristics
                peripheral.discoverDescriptors(for: characteristic)
            }
        } else {
            discoverGattCompletions.removeValue(forKey: peripheralKey)
            unfinishedServices.removeValue(forKey: peripheralKey)
            unfinishedCharacteristics.removeValue(forKey: peripheralKey)
            completion(.failure(error!))
        }
    }
    
    func didUpdateCharacteristicValue(_ characteristic: CBCharacteristic, _ error: Error?) {
        let characteristicKey = characteristic.hash
        guard let completion = readCharacteristicCompletions.removeValue(forKey: characteristicKey) else {
            let myCharacteristicKey = Int64(characteristicKey)
            let rawValue = characteristic.value ?? Data()
            let value = FlutterStandardTypedData(bytes: rawValue)
            myApi.onCharacteristicValueChanged(myCharacteristicKey: myCharacteristicKey, value: value) {}
            return
        }
        if error == nil {
            let rawValue = characteristic.value ?? Data()
            let value = FlutterStandardTypedData(bytes: rawValue)
            completion(.success(value))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didWriteCharacteristicValue(_ characteristic: CBCharacteristic, _ error: Error?) {
        let characteristicKey = characteristic.hash
        guard let completion = writeCharacteristicCompletions.removeValue(forKey: characteristicKey) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateNotificationState(_ characteristic: CBCharacteristic, _ error: Error?) {
        let characteristicKey = characteristic.hash
        guard let completion = notifyCharacteristicCompletions.removeValue(forKey: characteristicKey) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateDescriptorValue(_ descriptor: CBDescriptor, _ error: Error?) {
        let descriptorKey = descriptor.hash
        guard let completion = readDescriptorCompletions.removeValue(forKey: descriptorKey) else {
            return
        }
        if error == nil {
            // TODO: Need to confirm wheather the corresponding descriptor type and value is correct.
            let value: FlutterStandardTypedData
            let rawValue = descriptor.value
            do {
                switch descriptor.uuid.uuidString {
                case CBUUIDCharacteristicExtendedPropertiesString:
                    fallthrough
                case CBUUIDClientCharacteristicConfigurationString:
                    fallthrough
                case CBUUIDServerCharacteristicConfigurationString:
                    guard let rawNumber = rawValue as? NSNumber else {
                        throw MyError.illegalArgument
                    }
                    value = FlutterStandardTypedData(bytes: rawNumber.data)
                case CBUUIDCharacteristicUserDescriptionString:
                    fallthrough
                case CBUUIDCharacteristicAggregateFormatString:
                    guard let rawString = rawValue as? String else {
                        throw MyError.illegalArgument
                    }
                    value = FlutterStandardTypedData(bytes: rawString.data)
                case CBUUIDCharacteristicFormatString:
                    guard let rawData = rawValue as? Data else {
                        throw MyError.illegalArgument
                    }
                    value = FlutterStandardTypedData(bytes: rawData)
                case CBUUIDL2CAPPSMCharacteristicString:
                    guard let rawU16 = rawValue as? UInt16 else {
                        throw MyError.illegalArgument
                    }
                    value = FlutterStandardTypedData(bytes: rawU16.data)
                default:
                    throw MyError.illegalArgument
                }
            } catch {
                value = FlutterStandardTypedData()
            }
            completion(.success((value)))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didWriteDescriptorValue(_ descriptor: CBDescriptor, _ error: Error?) {
        let descriptorKey = descriptor.hash
        guard let completion = writeDescriptorCompletions.removeValue(forKey: descriptorKey) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
}

extension CBManagerState {
    func toMyArgs() -> MyCentralStateArgs {
        switch self {
        case .unauthorized:
            return .unauthorized
        case .poweredOff:
            return .poweredOff
        case .poweredOn:
            return .poweredOn
        default:
            return .unsupported
        }
    }
}

extension CBPeripheral {
    func toMyArgs() -> MyPeripheralArgs {
        let key = Int64(hash)
        let uuid = identifier.uuidString
        return MyPeripheralArgs(key: key, uuid: uuid)
    }
}

extension CBService {
    func toMyArgs() -> MyGattServiceArgs {
        let key = Int64(hash)
        let uuid = uuid.uuidString
        return MyGattServiceArgs(key: key, uuid: uuid)
    }
}

extension CBCharacteristic {
    func toMyArgs() -> MyGattCharacteristicArgs {
        let key = Int64(hash)
        let uuid = uuid.uuidString
        let myPropertyArgses = properties.toMyArgses()
        let myPropertyNumbers = myPropertyArgses.map { myPropertyArgs in Int64(myPropertyArgs.rawValue) }
        return MyGattCharacteristicArgs(key: key, uuid: uuid, myPropertyNumbers: myPropertyNumbers)
    }
}

extension CBDescriptor {
    func toMyArgs() -> MyGattDescriptorArgs {
        let key = Int64(hash)
        let uuid = uuid.uuidString
        return MyGattDescriptorArgs(key: key, uuid: uuid)
    }
}

extension CBCharacteristicProperties {
    func toMyArgses() -> [MyGattCharacteristicPropertyArgs] {
        var myPropertyArgs = [MyGattCharacteristicPropertyArgs]()
        if contains(.read) {
            myPropertyArgs.append(.read)
        }
        if contains(.write) {
            myPropertyArgs.append(.write)
        }
        if contains(.writeWithoutResponse) {
            myPropertyArgs.append(.writeWithoutResponse)
        }
        if contains(.notify) {
            myPropertyArgs.append(.notify)
        }
        if contains(.indicate) {
            myPropertyArgs.append(.indicate)
        }
        return myPropertyArgs
    }
}

extension MyGattCharacteristicWriteTypeArgs {
    func toType() -> CBCharacteristicWriteType {
        switch self {
        case .withResponse:
            return .withResponse
        case .withoutResponse:
            return .withoutResponse
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
