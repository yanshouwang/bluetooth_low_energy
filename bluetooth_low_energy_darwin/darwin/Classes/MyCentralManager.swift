//
//  MyCentralController.swift
//  bluetooth_low_energy_ios
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import CoreBluetooth
#if os(macOS)
import FlutterMacOS
#else
import Flutter
#endif

class MyCentralManager: MyCentralManagerHostApi {
    init(_ binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }
    
    private let binaryMessenger: FlutterBinaryMessenger
    private let centralManager = CBCentralManager()

    private lazy var myApi = MyCentralManagerFlutterApi(binaryMessenger: binaryMessenger)
    private lazy var myCentralManagerDelegate = MyCentralManagerDelegate(self)
    private lazy var myPeripheralDelegate = MyPeripheralDelegate(self)
    
    private var peripherals = [Int64: CBPeripheral]()
    private var services = [Int64: CBService]()
    private var characteristics = [Int64: CBCharacteristic]()
    private var descriptors = [Int64: CBDescriptor]()
    
    private var myPeripherals = [Int: MyPeripheralArgs]()
    private var myServicesOfMyPeripherals = [Int64: [MyGattServiceArgs]]()
    private var myServices = [Int: MyGattServiceArgs]()
    private var myCharacteristics = [Int: MyGattCharacteristicArgs]()
    private var myDescriptors = [Int: MyGattDescriptorArgs]()
    
    private var setUpCompletion: ((Result<MyCentralManagerArgs, Error>) -> Void)?
    private var connectCompletions = [Int64: (Result<Void, Error>) -> Void]()
    private var disconnectCompletions = [Int64: (Result<Void, Error>) -> Void]()
    private var readRssiCompletions = [Int64: (Result<Int64, Error>) -> Void]()
    private var discoverGattCompletions = [Int64: (Result<[MyGattServiceArgs], Error>) -> Void]()
    private var unfinishedServices = [Int64: [CBService]]()
    private var unfinishedCharacteristics = [Int64: [CBCharacteristic]]()
    private var readCharacteristicCompletions = [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]()
    private var writeCharacteristicCompletions = [Int64: (Result<Void, Error>) -> Void]()
    private var notifyCharacteristicCompletions = [Int64: (Result<Void, Error>) -> Void]()
    private var readDescriptorCompletions = [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]()
    private var writeDescriptorCompletions = [Int64: (Result<Void, Error>) -> Void]()
    
    func setUp(completion: @escaping (Result<MyCentralManagerArgs, Error>) -> Void) {
        do {
            if setUpCompletion != nil {
                throw MyError.illegalState
            }
            try tearDown()
            centralManager.delegate = myCentralManagerDelegate
            if centralManager.state == .unknown {
                setUpCompletion = completion
            } else {
                let myStateArgs = centralManager.state.toMyArgs()
                let myStateNumber = Int64(myStateArgs.rawValue)
                let myArgs = MyCentralManagerArgs(myStateNumber: myStateNumber)
                completion(.success(myArgs))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func tearDown() throws {
        if(centralManager.isScanning) {
            centralManager.stopScan()
        }
        for peripheral in peripherals.values {
            if peripheral.state != .disconnected {
                centralManager.cancelPeripheralConnection(peripheral)
            }
        }
        peripherals.removeAll()
        services.removeAll()
        characteristics.removeAll()
        descriptors.removeAll()
        myPeripherals.removeAll()
        myServicesOfMyPeripherals.removeAll()
        myServices.removeAll()
        myCharacteristics.removeAll()
        myDescriptors.removeAll()
        setUpCompletion = nil
        connectCompletions.removeAll()
        disconnectCompletions.removeAll()
        readRssiCompletions.removeAll()
        discoverGattCompletions.removeAll()
        unfinishedServices.removeAll()
        unfinishedCharacteristics.removeAll()
        readCharacteristicCompletions.removeAll()
        writeCharacteristicCompletions.removeAll()
        notifyCharacteristicCompletions.removeAll()
        readDescriptorCompletions.removeAll()
        writeDescriptorCompletions.removeAll()
    }
    
    func startDiscovery() throws {
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        centralManager.scanForPeripherals(withServices: nil, options: options)
    }
    
    func stopDiscovery() throws {
        centralManager.stopScan()
    }
    
    func connect(myPeripheralHashCode: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = connectCompletions[myPeripheralHashCode]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[myPeripheralHashCode] else {
                throw MyError.illegalArgument
            }
            centralManager.connect(peripheral)
            connectCompletions[myPeripheralHashCode] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func disconnect(myPeripheralHashCode: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = disconnectCompletions[myPeripheralHashCode]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[myPeripheralHashCode] else {
                throw MyError.illegalArgument
            }
            centralManager.cancelPeripheralConnection(peripheral)
            disconnectCompletions[myPeripheralHashCode] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func getMaximumWriteLength(myPeripheralHashCode: Int64, myTypeNumber: Int64) throws -> Int64 {
        guard let peripheral = peripherals[myPeripheralHashCode] else {
            throw MyError.illegalArgument
        }
        let myTypeRawValue = Int(myTypeNumber)
        guard let myTypeArgs = MyGattCharacteristicWriteTypeArgs(rawValue: myTypeRawValue) else {
            throw MyError.illegalArgument
        }
        let type = myTypeArgs.toWriteType()
        let maximumWriteLength = peripheral.maximumWriteValueLength(for: type)
        let myMaximumWriteLength = Int64(maximumWriteLength)
        return myMaximumWriteLength
    }
    
    func readRSSI(myPeripheralHashCode: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        do {
            let unfinishedCompletion = readRssiCompletions[myPeripheralHashCode]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[myPeripheralHashCode] else {
                throw MyError.illegalArgument
            }
            peripheral.readRSSI()
            readRssiCompletions[myPeripheralHashCode] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverGATT(myPeripheralHashCode: Int64, completion: @escaping (Result<[MyGattServiceArgs], Error>) -> Void) {
        do {
            let unfinishedCompletion = discoverGattCompletions[myPeripheralHashCode]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[myPeripheralHashCode] else {
                throw MyError.illegalArgument
            }
            peripheral.discoverServices(nil)
            discoverGattCompletions[myPeripheralHashCode] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readCharacteristic(myPeripheralHashCode: Int64, myCharacteristicHashCode: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let unfinishedCompletion = readCharacteristicCompletions[myCharacteristicHashCode]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[myPeripheralHashCode] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = characteristics[myCharacteristicHashCode] else {
                throw MyError.illegalArgument
            }
            peripheral.readValue(for: characteristic)
            readCharacteristicCompletions[myCharacteristicHashCode] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeCharacteristic(myPeripheralHashCode: Int64, myCharacteristicHashCode: Int64, myValue: FlutterStandardTypedData, myTypeNumber: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = writeCharacteristicCompletions[myCharacteristicHashCode]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[myPeripheralHashCode] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = characteristics[myCharacteristicHashCode] else {
                throw MyError.illegalArgument
            }
            let data = myValue.data
            let myTypeRawValue = Int(myTypeNumber)
            guard let myTypeArgs = MyGattCharacteristicWriteTypeArgs(rawValue: myTypeRawValue) else {
                throw MyError.illegalArgument
            }
            let type = myTypeArgs.toWriteType()
            peripheral.writeValue(data, for: characteristic, type: type)
            writeCharacteristicCompletions[myCharacteristicHashCode] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func notifyCharacteristic(myPeripheralHashCode: Int64, myCharacteristicHashCode: Int64, myState: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = notifyCharacteristicCompletions[myCharacteristicHashCode]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[myPeripheralHashCode] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = characteristics[myCharacteristicHashCode] else {
                throw MyError.illegalArgument
            }
            peripheral.setNotifyValue(myState, for: characteristic)
            notifyCharacteristicCompletions[myCharacteristicHashCode] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readDescriptor(myPeripheralHashCode: Int64, myDescriptorHashCode: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let unfinishedCompletion = readDescriptorCompletions[myDescriptorHashCode]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[myPeripheralHashCode] else {
                throw MyError.illegalArgument
            }
            guard let descriptor = descriptors[myDescriptorHashCode] else {
                throw MyError.illegalArgument
            }
            peripheral.readValue(for: descriptor)
            readDescriptorCompletions[myDescriptorHashCode] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeDescriptor(myPeripheralHashCode: Int64, myDescriptorHashCode: Int64, myValue: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = writeDescriptorCompletions[myDescriptorHashCode]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[myPeripheralHashCode] else {
                throw MyError.illegalArgument
            }
            guard let descriptor = descriptors[myDescriptorHashCode] else {
                throw MyError.illegalArgument
            }
            let data = myValue.data
            peripheral.writeValue(data, for: descriptor)
            writeDescriptorCompletions[myDescriptorHashCode] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func didUpdateState(_ state: CBManagerState) {
        if state != .unknown && setUpCompletion != nil {
            let myStateArgs = state.toMyArgs()
            let myStateNumber = Int64(myStateArgs.rawValue)
            let myArgs = MyCentralManagerArgs(myStateNumber: myStateNumber)
            setUpCompletion!(.success(myArgs))
            setUpCompletion = nil
        }
        let myStateArgs = state.toMyArgs()
        let myStateNumber = Int64(myStateArgs.rawValue)
        myApi.onStateChanged(myStateNumber: myStateNumber) {}
    }
    
    
    func didDiscover(_ peripheral: CBPeripheral, _ advertisementData: [String : Any], _ rssi: NSNumber) {
        let myPeripheral = peripheral.toMyArgs()
        let peripheralHashCode = peripheral.hash
        let myPeripheralHashCode = myPeripheral.myHashCode
        peripheral.delegate = myPeripheralDelegate
        peripherals[myPeripheralHashCode] = peripheral
        myPeripherals[peripheralHashCode] = myPeripheral
        let myRSSI = rssi.int64Value
        let myName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        let manufacturerSpecificData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
        var myManufacturerSpecificData = [Int64: FlutterStandardTypedData]()
        if manufacturerSpecificData != nil {
            do {
                guard let data = manufacturerSpecificData else {
                    throw MyError.illegalArgument
                }
                guard data.count >= 2 else {
                    throw MyError.illegalArgument
                }
                let key = Int64(data[0]) | (Int64(data[1]) << 8)
                let bytes = data.count > 2 ? data[2...data.count-1] : Data()
                let value = FlutterStandardTypedData(bytes: bytes)
                myManufacturerSpecificData[key] = value
            } catch {
                myManufacturerSpecificData = [:]
            }
        }
        let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
        let myServiceUUIDs = serviceUUIDs.map { uuid in uuid.uuidString }
        let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] ?? [:]
        let myServiceDataEntries = serviceData.map { (uuid, data) in
            let key = uuid.uuidString
            let value = FlutterStandardTypedData(bytes: data)
            return (key, value)
        }
        let myServiceData = [String?: FlutterStandardTypedData?](uniqueKeysWithValues: myServiceDataEntries)
        let myAdvertisementArgs = MyAdvertisementArgs(myName: myName, myManufacturerSpecificData: myManufacturerSpecificData, myServiceUUIDs: myServiceUUIDs, myServiceData: myServiceData)
        myApi.onDiscovered(myPeripheralArgs: myPeripheral, myRSSI: myRSSI, myAdvertisementArgs: myAdvertisementArgs) {}
    }
    
    func didConnect(_ peripheral: CBPeripheral) {
        let hashCode = peripheral.hash
        guard let myPeripheral = myPeripherals[hashCode] else {
            return
        }
        let myHashCode = myPeripheral.myHashCode
        let completion = connectCompletions.removeValue(forKey: myHashCode)
        completion?(.success(()))
        myApi.onPeripheralStateChanged(myPeripheralArgs: myPeripheral, myState: true) {}
    }
    
    func didFailToConnect(_ peripheral: CBPeripheral, _ error: Error?) {
        let hashCode = peripheral.hash
        guard let myPeripheral = myPeripherals[hashCode] else {
            return
        }
        let myHashCode = myPeripheral.myHashCode
        let completion = connectCompletions.removeValue(forKey: myHashCode)
        completion?(.failure(error ?? MyError.unknown))
    }
    
    func didDisconnectPeripheral(_ peripheral: CBPeripheral, _ error: Error?) {
        let peripheralHashCode = peripheral.hash
        guard let myPeripheral = myPeripherals[peripheralHashCode] else {
            return
        }
        let myPeripheralHashCode = myPeripheral.myHashCode
        let readRssiCompletion = readRssiCompletions.removeValue(forKey: myPeripheralHashCode)
        readRssiCompletion?(.failure(error ?? MyError.unknown))
        let discoverGattCompletion = discoverGattCompletions.removeValue(forKey: myPeripheralHashCode)
        discoverGattCompletion?(.failure(error ?? MyError.unknown))
        unfinishedServices.removeValue(forKey: myPeripheralHashCode)
        unfinishedCharacteristics.removeValue(forKey: myPeripheralHashCode)
        let myServices = myServicesOfMyPeripherals[myPeripheralHashCode] ?? []
        for myService in myServices {
            let myCharacteristics = myService.myCharacteristicArgses.map { args in args! }
            for myCharacteristic in myCharacteristics {
                let myCharacteristicHashCode = myCharacteristic.myHashCode
                let readCharacteristicCompletion = readCharacteristicCompletions.removeValue(forKey: myCharacteristicHashCode)
                let writeCharacteristicCompletion = writeCharacteristicCompletions.removeValue(forKey: myCharacteristicHashCode)
                let notifyCharacteristicCompletion = notifyCharacteristicCompletions.removeValue(forKey: myCharacteristicHashCode)
                readCharacteristicCompletion?(.failure(error ?? MyError.unknown))
                writeCharacteristicCompletion?(.failure(error ?? MyError.unknown))
                notifyCharacteristicCompletion?(.failure(error ?? MyError.unknown))
                let myDescriptors = myCharacteristic.myDescriptorArgses.map { args in args! }
                for myDescriptor in myDescriptors {
                    let myDescriptorHashCode = myDescriptor.myHashCode
                    let readDescriptorCompletion = readDescriptorCompletions.removeValue(forKey: myDescriptorHashCode)
                    let writeDescriptorCompletion = writeDescriptorCompletions.removeValue(forKey: myDescriptorHashCode)
                    readDescriptorCompletion?(.failure(error ?? MyError.unknown))
                    writeDescriptorCompletion?(.failure(error ?? MyError.unknown))
                }
            }
        }
        myApi.onPeripheralStateChanged(myPeripheralArgs: myPeripheral, myState: false) {}
        guard let completion = disconnectCompletions.removeValue(forKey: myPeripheralHashCode) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didReadRSSI(_ peripheral: CBPeripheral, _ rssi: NSNumber, _ error: Error?) {
        let hashCode = peripheral.hash
        guard let myPeripheral = myPeripherals[hashCode] else {
            return
        }
        let myHashCode = myPeripheral.myHashCode
        guard let completion = readRssiCompletions.removeValue(forKey: myHashCode) else {
            return
        }
        if error == nil {
            let myRSSI = rssi.int64Value
            completion(.success((myRSSI)))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverServices(_ peripheral: CBPeripheral, _ error: Error?) {
        let hashCode = peripheral.hash
        guard let myPeripheral = myPeripherals[hashCode] else {
            return
        }
        let myHashCode = myPeripheral.myHashCode
        if error == nil {
            var services = peripheral.services ?? []
            if services.isEmpty {
                didDiscoverGATT(peripheral, error)
            } else {
                let service = services.removeFirst()
                unfinishedServices[myHashCode] = services
                peripheral.discoverCharacteristics(nil, for: service)
            }
        } else {
            didDiscoverGATT(peripheral, error)
        }
    }
    
    func didDiscoverCharacteristics(_ peripheral: CBPeripheral, _ service: CBService, _ error: Error?) {
        let hashCode = peripheral.hash
        guard let myPeripheral = myPeripherals[hashCode] else {
            return
        }
        let myHashCode = myPeripheral.myHashCode
        if error == nil {
            var characteristics = service.characteristics ?? []
            if characteristics.isEmpty {
                var services = unfinishedServices.removeValue(forKey: myHashCode) ?? []
                if services.isEmpty {
                    didDiscoverGATT(peripheral, error)
                } else {
                    let service = services.removeFirst()
                    unfinishedServices[myHashCode] = services
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            } else {
                let characteristic = characteristics.removeFirst()
                unfinishedCharacteristics[myHashCode] = characteristics
                peripheral.discoverDescriptors(for: characteristic)
            }
        } else {
            didDiscoverGATT(peripheral, error)
        }
    }
    
    func didDiscoverDescriptors(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) {
        let hashCode = peripheral.hash
        guard let myPeripheral = myPeripherals[hashCode] else {
            return
        }
        let myHashCode = myPeripheral.myHashCode
        if error == nil {
            var characteristics = unfinishedCharacteristics.removeValue(forKey: myHashCode) ?? []
            if (characteristics.isEmpty) {
                var services = unfinishedServices.removeValue(forKey: myHashCode) ?? []
                if services.isEmpty {
                    didDiscoverGATT(peripheral, error)
                } else {
                    let service = services.removeFirst()
                    unfinishedServices[myHashCode] = services
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            } else {
                let characteristic = characteristics.removeFirst()
                unfinishedCharacteristics[myHashCode] = characteristics
                peripheral.discoverDescriptors(for: characteristic)
            }
        } else {
            didDiscoverGATT(peripheral, error)
        }
    }
    
    private func didDiscoverGATT(_ peripheral: CBPeripheral, _ error: Error?) {
        let peripheralHashCode = peripheral.hash
        guard let myPeripheral = myPeripherals[peripheralHashCode] else {
            return
        }
        let myPeripheralhashCode = myPeripheral.myHashCode
        guard let completion = discoverGattCompletions.removeValue(forKey: myPeripheralhashCode) else {
            return
        }
        if error == nil {
            let services = peripheral.services ?? []
            var myServices = [MyGattServiceArgs]()
            for service in services {
                let characteristics = service.characteristics ?? []
                var myCharacteristics = [MyGattCharacteristicArgs]()
                for characteristic in characteristics {
                    let descriptors = characteristic.descriptors ?? []
                    var myDescriptors = [MyGattDescriptorArgs]()
                    for descriptor in descriptors {
                        let myDescriptor = descriptor.toMyArgs()
                        let descriptorHashCode = descriptor.hash
                        let myDescriptorHashCode = myDescriptor.myHashCode
                        self.descriptors[myDescriptorHashCode] = descriptor
                        self.myDescriptors[descriptorHashCode] = myDescriptor
                        myDescriptors.append(myDescriptor)
                    }
                    let myCharacteristic = characteristic.toMyArgs(myDescriptors)
                    let characteristicHashCode = characteristic.hash
                    let myCharacteristicHashCode = myCharacteristic.myHashCode
                    self.characteristics[myCharacteristicHashCode] = characteristic
                    self.myCharacteristics[characteristicHashCode] = myCharacteristic
                    myCharacteristics.append(myCharacteristic)
                }
                let myService = service.toMyArgs(myCharacteristics)
                let serviceHashCode = service.hash
                let myServiceHashCode = myService.myHashCode
                self.services[myServiceHashCode] = service
                self.myServices[serviceHashCode] = myService
                myServices.append(myService)
            }
            myServicesOfMyPeripherals[myPeripheralhashCode] = myServices
            completion(.success((myServices)))
        } else {
            completion(.failure(error!))
            unfinishedServices.removeValue(forKey: myPeripheralhashCode)
            unfinishedCharacteristics.removeValue(forKey: myPeripheralhashCode)
        }
    }
    
    func didUpdateCharacteristicValue(_ characteristic: CBCharacteristic, _ error: Error?) {
        let hashCode = characteristic.hash
        guard let myCharacteristic = myCharacteristics[hashCode] else {
            return
        }
        let myHashCode = myCharacteristic.myHashCode
        guard let completion = readCharacteristicCompletions.removeValue(forKey: myHashCode) else {
            let value = characteristic.value ?? Data()
            let myValue = FlutterStandardTypedData(bytes: value)
            myApi.onCharacteristicValueChanged(myCharacteristicArgs: myCharacteristic, myValue: myValue) {}
            return
        }
        if error == nil {
            let value = characteristic.value ?? Data()
            let myValue = FlutterStandardTypedData(bytes: value)
            completion(.success(myValue))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didWriteCharacteristicValue(_ characteristic: CBCharacteristic, _ error: Error?) {
        let hashCode = characteristic.hash
        guard let myCharacteristic = myCharacteristics[hashCode] else {
            return
        }
        let myHashCode = myCharacteristic.myHashCode
        guard let completion = writeCharacteristicCompletions.removeValue(forKey: myHashCode) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateNotificationState(_ characteristic: CBCharacteristic, _ error: Error?) {
        let hashCode = characteristic.hash
        guard let myCharacteristic = myCharacteristics[hashCode] else {
            return
        }
        let myHashCode = myCharacteristic.myHashCode
        guard let completion = notifyCharacteristicCompletions.removeValue(forKey: myHashCode) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateDescriptorValue(_ descriptor: CBDescriptor, _ error: Error?) {
        let hashCode = descriptor.hash
        guard let myDescriptor = myDescriptors[hashCode] else {
            return
        }
        let myHashCode = myDescriptor.myHashCode
        guard let completion = readDescriptorCompletions.removeValue(forKey: myHashCode) else {
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
        let hashCode = descriptor.hash
        guard let myDescriptor = myDescriptors[hashCode] else {
            return
        }
        let myHashCode = myDescriptor.myHashCode
        guard let completion = writeDescriptorCompletions.removeValue(forKey: myHashCode) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
}
