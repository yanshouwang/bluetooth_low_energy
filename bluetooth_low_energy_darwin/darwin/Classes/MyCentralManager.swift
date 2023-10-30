//
//  MyCentralController.swift
//  bluetooth_low_energy_ios
//
//  Created by 闫守旺 on 2023/8/13.
//

import Foundation
import CoreBluetooth

#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

class MyCentralManager: MyCentralManagerHostApi {
    init(_ binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }
    
    private let binaryMessenger: FlutterBinaryMessenger
    private let centralManager = CBCentralManager()

    private lazy var api = MyCentralManagerFlutterApi(binaryMessenger: binaryMessenger)
    private lazy var centralManagerDelegate = MyCentralManagerDelegate(self)
    private lazy var peripheralDelegate = MyPeripheralDelegate(self)
    
    private var peripherals = [Int64: CBPeripheral]()
    private var services = [Int64: CBService]()
    private var characteristics = [Int64: CBCharacteristic]()
    private var descriptors = [Int64: CBDescriptor]()
    
    private var peripheralsArgs = [Int: MyPeripheralArgs]()
    private var servicesArgsOfPeripheralsArgs = [Int64: [MyGattServiceArgs]]()
    private var servicesArgs = [Int: MyGattServiceArgs]()
    private var characteristicsArgs = [Int: MyGattCharacteristicArgs]()
    private var descriptorsArgs = [Int: MyGattDescriptorArgs]()
    
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
            centralManager.delegate = centralManagerDelegate
            if centralManager.state == .unknown {
                setUpCompletion = completion
            } else {
                let stateArgs = centralManager.state.toArgs()
                let stateNumberArgs = Int64(stateArgs.rawValue)
                let args = MyCentralManagerArgs(stateNumberArgs: stateNumberArgs)
                completion(.success(args))
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
        peripheralsArgs.removeAll()
        servicesArgsOfPeripheralsArgs.removeAll()
        servicesArgs.removeAll()
        characteristicsArgs.removeAll()
        descriptorsArgs.removeAll()
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
    
    func connect(peripheralHashCodeArgs: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = connectCompletions[peripheralHashCodeArgs]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            centralManager.connect(peripheral)
            connectCompletions[peripheralHashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func disconnect(peripheralHashCodeArgs: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = disconnectCompletions[peripheralHashCodeArgs]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            centralManager.cancelPeripheralConnection(peripheral)
            disconnectCompletions[peripheralHashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func getMaximumWriteLength(peripheralHashCodeArgs: Int64, typeNumberArgs: Int64) throws -> Int64 {
        guard let peripheral = peripherals[peripheralHashCodeArgs] else {
            throw MyError.illegalArgument
        }
        let typeRawValue = Int(typeNumberArgs)
        guard let typeArgs = MyGattCharacteristicWriteTypeArgs(rawValue: typeRawValue) else {
            throw MyError.illegalArgument
        }
        let type = typeArgs.toWriteType()
        let maximumWriteLength = try peripheral.maximumWriteValueLength(for: type).coerceIn(20, 512)
        let maximumWriteLengthArgs = Int64(maximumWriteLength)
        return maximumWriteLengthArgs
    }
    
    func readRSSI(peripheralHashCodeArgs: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        do {
            let unfinishedCompletion = readRssiCompletions[peripheralHashCodeArgs]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            peripheral.readRSSI()
            readRssiCompletions[peripheralHashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverGATT(peripheralHashCodeArgs: Int64, completion: @escaping (Result<[MyGattServiceArgs], Error>) -> Void) {
        do {
            let unfinishedCompletion = discoverGattCompletions[peripheralHashCodeArgs]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            peripheral.discoverServices(nil)
            discoverGattCompletions[peripheralHashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readCharacteristic(peripheralHashCodeArgs: Int64, characteristicHashCodeArgs: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let unfinishedCompletion = readCharacteristicCompletions[characteristicHashCodeArgs]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = characteristics[characteristicHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            peripheral.readValue(for: characteristic)
            readCharacteristicCompletions[characteristicHashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeCharacteristic(peripheralHashCodeArgs: Int64, characteristicHashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, typeNumberArgs: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = writeCharacteristicCompletions[characteristicHashCodeArgs]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = characteristics[characteristicHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            let data = valueArgs.data
            let typeRawValue = Int(typeNumberArgs)
            guard let typeArgs = MyGattCharacteristicWriteTypeArgs(rawValue: typeRawValue) else {
                throw MyError.illegalArgument
            }
            let type = typeArgs.toWriteType()
            peripheral.writeValue(data, for: characteristic, type: type)
            if type == .withResponse {
                writeCharacteristicCompletions[characteristicHashCodeArgs] = completion
            } else {
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func notifyCharacteristic(peripheralHashCodeArgs: Int64, characteristicHashCodeArgs: Int64, stateArgs: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = notifyCharacteristicCompletions[characteristicHashCodeArgs]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = characteristics[characteristicHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            let enabled = stateArgs
            peripheral.setNotifyValue(enabled, for: characteristic)
            notifyCharacteristicCompletions[characteristicHashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readDescriptor(peripheralHashCodeArgs: Int64, descriptorHashCodeArgs: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let unfinishedCompletion = readDescriptorCompletions[descriptorHashCodeArgs]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            guard let descriptor = descriptors[descriptorHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            peripheral.readValue(for: descriptor)
            readDescriptorCompletions[descriptorHashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeDescriptor(peripheralHashCodeArgs: Int64, descriptorHashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let unfinishedCompletion = writeDescriptorCompletions[descriptorHashCodeArgs]
            if unfinishedCompletion != nil {
                throw MyError.illegalState
            }
            guard let peripheral = peripherals[peripheralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            guard let descriptor = descriptors[descriptorHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            let data = valueArgs.data
            peripheral.writeValue(data, for: descriptor)
            writeDescriptorCompletions[descriptorHashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func didUpdateState() {
        let state = centralManager.state
        let stateArgs = state.toArgs()
        let stateNumberArgs = Int64(stateArgs.rawValue)
        if state != .unknown && setUpCompletion != nil {
            let args = MyCentralManagerArgs(stateNumberArgs: stateNumberArgs)
            setUpCompletion!(.success(args))
            setUpCompletion = nil
        }
        api.onStateChanged(stateNumberArgs: stateNumberArgs) {_ in }
    }
    
    func didDiscover(_ peripheral: CBPeripheral, _ advertisementData: [String : Any], _ rssi: NSNumber) {
        let peripheralArgs = peripheral.toArgs()
        let peripheralHashCode = peripheral.hash
        let peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        peripheral.delegate = peripheralDelegate
        peripherals[peripheralHashCodeArgs] = peripheral
        peripheralsArgs[peripheralHashCode] = peripheralArgs
        let rssiArgs = rssi.int64Value
        let advertisementArgs = advertisementData.toAdvertisementArgs()
        api.onDiscovered(peripheralArgs: peripheralArgs, rssiArgs: rssiArgs, advertisementArgs: advertisementArgs) {_ in }
    }
    
    func didConnect(_ peripheral: CBPeripheral) {
        let peripheralHashCode = peripheral.hash
        guard let peripheralArgs = peripheralsArgs[peripheralHashCode] else {
            return
        }
        let peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        let stateArgs = true
        api.onPeripheralStateChanged(peripheralArgs: peripheralArgs, stateArgs: stateArgs) {_ in }
        guard let completion = connectCompletions.removeValue(forKey: peripheralHashCodeArgs) else {
            return
        }
        completion(.success(()))
    }
    
    func didFailToConnect(_ peripheral: CBPeripheral, _ error: Error?) {
        let peripheralHashCode = peripheral.hash
        guard let peripheralArgs = peripheralsArgs[peripheralHashCode] else {
            return
        }
        let peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        let completion = connectCompletions.removeValue(forKey: peripheralHashCodeArgs)
        completion?(.failure(error ?? MyError.unknown))
    }
    
    func didDisconnectPeripheral(_ peripheral: CBPeripheral, _ error: Error?) {
        let peripheralHashCode = peripheral.hash
        guard let peripheralArgs = peripheralsArgs[peripheralHashCode] else {
            return
        }
        let peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        let readRssiCompletion = readRssiCompletions.removeValue(forKey: peripheralHashCodeArgs)
        readRssiCompletion?(.failure(error ?? MyError.unknown))
        let discoverGattCompletion = discoverGattCompletions.removeValue(forKey: peripheralHashCodeArgs)
        discoverGattCompletion?(.failure(error ?? MyError.unknown))
        unfinishedServices.removeValue(forKey: peripheralHashCodeArgs)
        unfinishedCharacteristics.removeValue(forKey: peripheralHashCodeArgs)
        let servicesArgs = servicesArgsOfPeripheralsArgs.removeValue(forKey: peripheralHashCodeArgs) ?? []
        for serviceArgs in servicesArgs {
            let serviceHashCodeArgs = serviceArgs.hashCodeArgs
            let service = services.removeValue(forKey: serviceHashCodeArgs)!
            let serviceHashCode = service.hash
            self.servicesArgs.removeValue(forKey: serviceHashCode)
            let characteristicsArgs = serviceArgs.characteristicsArgs.map { args in args! }
            for characteristicArgs in characteristicsArgs {
                let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
                let characteristic = characteristics.removeValue(forKey: characteristicHashCodeArgs)!
                let characteristicHashCode = characteristic.hash
                self.characteristicsArgs.removeValue(forKey: characteristicHashCode)
                let readCharacteristicCompletion = readCharacteristicCompletions.removeValue(forKey: characteristicHashCodeArgs)
                let writeCharacteristicCompletion = writeCharacteristicCompletions.removeValue(forKey: characteristicHashCodeArgs)
                let notifyCharacteristicCompletion = notifyCharacteristicCompletions.removeValue(forKey: characteristicHashCodeArgs)
                readCharacteristicCompletion?(.failure(error ?? MyError.unknown))
                writeCharacteristicCompletion?(.failure(error ?? MyError.unknown))
                notifyCharacteristicCompletion?(.failure(error ?? MyError.unknown))
                let descriptorsArgs = characteristicArgs.descriptorsArgs.map { args in args! }
                for descriptorArgs in descriptorsArgs {
                    let descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                    let descriptor = descriptors.removeValue(forKey: descriptorHashCodeArgs)!
                    let descriptorHashCode = descriptor.hash
                    self.descriptorsArgs.removeValue(forKey: descriptorHashCode)
                    let readDescriptorCompletion = readDescriptorCompletions.removeValue(forKey: descriptorHashCodeArgs)
                    let writeDescriptorCompletion = writeDescriptorCompletions.removeValue(forKey: descriptorHashCodeArgs)
                    readDescriptorCompletion?(.failure(error ?? MyError.unknown))
                    writeDescriptorCompletion?(.failure(error ?? MyError.unknown))
                }
            }
        }
        let stateArgs = false
        api.onPeripheralStateChanged(peripheralArgs: peripheralArgs, stateArgs: stateArgs) {_ in }
        guard let completion = disconnectCompletions.removeValue(forKey: peripheralHashCodeArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didReadRSSI(_ peripheral: CBPeripheral, _ rssi: NSNumber, _ error: Error?) {
        let peripheralHashCode = peripheral.hash
        guard let peripheralArgs = peripheralsArgs[peripheralHashCode] else {
            return
        }
        let peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        guard let completion = readRssiCompletions.removeValue(forKey: peripheralHashCodeArgs) else {
            return
        }
        if error == nil {
            let rssiArgs = rssi.int64Value
            completion(.success((rssiArgs)))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverServices(_ peripheral: CBPeripheral, _ error: Error?) {
        let peripheralHashCode = peripheral.hash
        guard let peripheralArgs = peripheralsArgs[peripheralHashCode] else {
            return
        }
        let peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        if error == nil {
            var services = peripheral.services ?? []
            if services.isEmpty {
                didDiscoverGATT(peripheral, error)
            } else {
                let service = services.removeFirst()
                unfinishedServices[peripheralHashCodeArgs] = services
                peripheral.discoverCharacteristics(nil, for: service)
            }
        } else {
            didDiscoverGATT(peripheral, error)
        }
    }
    
    func didDiscoverCharacteristics(_ peripheral: CBPeripheral, _ service: CBService, _ error: Error?) {
        let peripheralHashCode = peripheral.hash
        guard let peripheralArgs = peripheralsArgs[peripheralHashCode] else {
            return
        }
        let peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        if error == nil {
            var characteristics = service.characteristics ?? []
            if characteristics.isEmpty {
                var services = unfinishedServices.removeValue(forKey: peripheralHashCodeArgs) ?? []
                if services.isEmpty {
                    didDiscoverGATT(peripheral, error)
                } else {
                    let service = services.removeFirst()
                    unfinishedServices[peripheralHashCodeArgs] = services
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            } else {
                let characteristic = characteristics.removeFirst()
                unfinishedCharacteristics[peripheralHashCodeArgs] = characteristics
                peripheral.discoverDescriptors(for: characteristic)
            }
        } else {
            didDiscoverGATT(peripheral, error)
        }
    }
    
    func didDiscoverDescriptors(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) {
        let peripheralHashCode = peripheral.hash
        guard let peripheralArgs = peripheralsArgs[peripheralHashCode] else {
            return
        }
        let peripheralHashCodeArgs = peripheralArgs.hashCodeArgs
        if error == nil {
            var characteristics = unfinishedCharacteristics.removeValue(forKey: peripheralHashCodeArgs) ?? []
            if (characteristics.isEmpty) {
                var services = unfinishedServices.removeValue(forKey: peripheralHashCodeArgs) ?? []
                if services.isEmpty {
                    didDiscoverGATT(peripheral, error)
                } else {
                    let service = services.removeFirst()
                    unfinishedServices[peripheralHashCodeArgs] = services
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            } else {
                let characteristic = characteristics.removeFirst()
                unfinishedCharacteristics[peripheralHashCodeArgs] = characteristics
                peripheral.discoverDescriptors(for: characteristic)
            }
        } else {
            didDiscoverGATT(peripheral, error)
        }
    }
    
    private func didDiscoverGATT(_ peripheral: CBPeripheral, _ error: Error?) {
        let peripheralHashCode = peripheral.hash
        guard let peripheralArgs = peripheralsArgs[peripheralHashCode] else {
            return
        }
        let peripheralhashCodeArgs = peripheralArgs.hashCodeArgs
        guard let completion = discoverGattCompletions.removeValue(forKey: peripheralhashCodeArgs) else {
            return
        }
        if error == nil {
            let services = peripheral.services ?? []
            var servicesArgs = [MyGattServiceArgs]()
            for service in services {
                let characteristics = service.characteristics ?? []
                var characteristicsArgs = [MyGattCharacteristicArgs]()
                for characteristic in characteristics {
                    let descriptors = characteristic.descriptors ?? []
                    var descriptorsArgs = [MyGattDescriptorArgs]()
                    for descriptor in descriptors {
                        let descriptorArgs = descriptor.toArgs()
                        let descriptorHashCode = descriptor.hash
                        let descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                        self.descriptors[descriptorHashCodeArgs] = descriptor
                        self.descriptorsArgs[descriptorHashCode] = descriptorArgs
                        descriptorsArgs.append(descriptorArgs)
                    }
                    let characteristicArgs = characteristic.toArgs(descriptorsArgs)
                    let characteristicHashCode = characteristic.hash
                    let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
                    self.characteristics[characteristicHashCodeArgs] = characteristic
                    self.characteristicsArgs[characteristicHashCode] = characteristicArgs
                    characteristicsArgs.append(characteristicArgs)
                }
                let serviceArgs = service.toArgs(characteristicsArgs)
                let serviceHashCode = service.hash
                let servcieHashCodeArgs = serviceArgs.hashCodeArgs
                self.services[servcieHashCodeArgs] = service
                self.servicesArgs[serviceHashCode] = serviceArgs
                servicesArgs.append(serviceArgs)
            }
            servicesArgsOfPeripheralsArgs[peripheralhashCodeArgs] = servicesArgs
            completion(.success((servicesArgs)))
        } else {
            completion(.failure(error!))
            unfinishedServices.removeValue(forKey: peripheralhashCodeArgs)
            unfinishedCharacteristics.removeValue(forKey: peripheralhashCodeArgs)
        }
    }
    
    func didUpdateCharacteristicValue(_ characteristic: CBCharacteristic, _ error: Error?) {
        let characteristicHashCode = characteristic.hash
        guard let characteristicArgs = characteristicsArgs[characteristicHashCode] else {
            return
        }
        let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
        guard let completion = readCharacteristicCompletions.removeValue(forKey: characteristicHashCodeArgs) else {
            let value = characteristic.value ?? Data()
            let valueArgs = FlutterStandardTypedData(bytes: value)
            api.onCharacteristicValueChanged(characteristicArgs: characteristicArgs, valueArgs: valueArgs) {_ in }
            return
        }
        if error == nil {
            let value = characteristic.value ?? Data()
            let valueArgs = FlutterStandardTypedData(bytes: value)
            completion(.success(valueArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didWriteCharacteristicValue(_ characteristic: CBCharacteristic, _ error: Error?) {
        let characteristicHashCode = characteristic.hash
        guard let characteristicArgs = characteristicsArgs[characteristicHashCode] else {
            return
        }
        let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
        guard let completion = writeCharacteristicCompletions.removeValue(forKey: characteristicHashCodeArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateNotificationState(_ characteristic: CBCharacteristic, _ error: Error?) {
        let characteristicHashCode = characteristic.hash
        guard let characteristicArgs = characteristicsArgs[characteristicHashCode] else {
            return
        }
        let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
        guard let completion = notifyCharacteristicCompletions.removeValue(forKey: characteristicHashCodeArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateDescriptorValue(_ descriptor: CBDescriptor, _ error: Error?) {
        let descriptorHashCode = descriptor.hash
        guard let descriptorArgs = descriptorsArgs[descriptorHashCode] else {
            return
        }
        let descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
        guard let completion = readDescriptorCompletions.removeValue(forKey: descriptorHashCodeArgs) else {
            return
        }
        if error == nil {
            // TODO: Need to confirm wheather the corresponding descriptor type and value is correct.
            let valueArgs: FlutterStandardTypedData
            let value = descriptor.value
            do {
                switch descriptor.uuid.uuidString {
                case CBUUIDCharacteristicExtendedPropertiesString:
                    fallthrough
                case CBUUIDClientCharacteristicConfigurationString:
                    fallthrough
                case CBUUIDServerCharacteristicConfigurationString:
                    guard let numberValue = value as? NSNumber else {
                        throw MyError.illegalArgument
                    }
                    valueArgs = FlutterStandardTypedData(bytes: numberValue.data)
                case CBUUIDCharacteristicUserDescriptionString:
                    fallthrough
                case CBUUIDCharacteristicAggregateFormatString:
                    guard let stringValue = value as? String else {
                        throw MyError.illegalArgument
                    }
                    valueArgs = FlutterStandardTypedData(bytes: stringValue.data)
                case CBUUIDCharacteristicFormatString:
                    guard let bytes = value as? Data else {
                        throw MyError.illegalArgument
                    }
                    valueArgs = FlutterStandardTypedData(bytes: bytes)
                case CBUUIDL2CAPPSMCharacteristicString:
                    guard let uint16Value = value as? UInt16 else {
                        throw MyError.illegalArgument
                    }
                    valueArgs = FlutterStandardTypedData(bytes: uint16Value.data)
                default:
                    throw MyError.illegalArgument
                }
            } catch {
                valueArgs = FlutterStandardTypedData()
            }
            completion(.success((valueArgs)))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didWriteDescriptorValue(_ descriptor: CBDescriptor, _ error: Error?) {
        let descriptorHashCode = descriptor.hash
        guard let descriptorArgs = descriptorsArgs[descriptorHashCode] else {
            return
        }
        let descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
        guard let completion = writeDescriptorCompletions.removeValue(forKey: descriptorHashCodeArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
}
