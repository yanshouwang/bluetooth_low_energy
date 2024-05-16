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

class MyCentralManager: MyCentralManagerHostAPI {
    private let _api: MyCentralManagerFlutterAPI
    private let _centralManager: CBCentralManager
    
    private lazy var _centralManagerDelegate = MyCentralManagerDelegate(centralManager: self)
    private lazy var _peripheralDelegate = MyPeripheralDelegate(centralManager: self)
    
    private var _peripherals: [String: CBPeripheral]
    private var _services: [String: [Int64: CBService]]
    private var _characteristics: [String: [Int64: CBCharacteristic]]
    private var _descriptors: [String: [Int64: CBDescriptor]]
    
    private var _connectCompletions: [String: (Result<Void, Error>) -> Void]
    private var _disconnectCompletions: [String: (Result<Void, Error>) -> Void]
    private var _readRssiCompletions: [String: (Result<Int64, Error>) -> Void]
    private var _discoverServicesCompletions: [String: (Result<[MyGATTServiceArgs], Error>) -> Void]
    private var _discoverIncludedServicesCompletions: [String: [Int64: (Result<[MyGATTServiceArgs], Error>) -> Void]]
    private var _discoverCharacteristicsCompletions: [String: [Int64: (Result<[MyGATTCharacteristicArgs], Error>) -> Void]]
    private var _discoverDescriptorsCompletions: [String: [Int64: (Result<[MyGATTDescriptorArgs], Error>) -> Void]]
    private var _readCharacteristicCompletions: [String: [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]]
    private var _writeCharacteristicCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    private var _setCharacteristicNotifyStateCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    private var _readDescriptorCompletions: [String: [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]]
    private var _writeDescriptorCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    
    init(messenger: FlutterBinaryMessenger) {
        _api = MyCentralManagerFlutterAPI(binaryMessenger: messenger)
        _centralManager = CBCentralManager()
        
        _peripherals = [:]
        _services = [:]
        _characteristics = [:]
        _descriptors = [:]
        
        _connectCompletions = [:]
        _disconnectCompletions = [:]
        _readRssiCompletions = [:]
        _discoverServicesCompletions = [:]
        _discoverIncludedServicesCompletions = [:]
        _discoverCharacteristicsCompletions = [:]
        _discoverDescriptorsCompletions = [:]
        _readCharacteristicCompletions = [:]
        _writeCharacteristicCompletions = [:]
        _setCharacteristicNotifyStateCompletions = [:]
        _readDescriptorCompletions = [:]
        _writeDescriptorCompletions = [:]
    }
    
    func initialize() throws {
        if(_centralManager.isScanning) {
            _centralManager.stopScan()
        }
        
        for peripheral in _peripherals.values {
            if peripheral.state != .disconnected {
                _centralManager.cancelPeripheralConnection(peripheral)
            }
        }
        
        _peripherals.removeAll()
        _services.removeAll()
        _characteristics.removeAll()
        _descriptors.removeAll()
        
        _connectCompletions.removeAll()
        _disconnectCompletions.removeAll()
        _readRssiCompletions.removeAll()
        _discoverServicesCompletions.removeAll()
        _discoverIncludedServicesCompletions.removeAll()
        _discoverCharacteristicsCompletions.removeAll()
        _discoverDescriptorsCompletions.removeAll()
        _readCharacteristicCompletions.removeAll()
        _writeCharacteristicCompletions.removeAll()
        _setCharacteristicNotifyStateCompletions.removeAll()
        _readDescriptorCompletions.removeAll()
        _writeDescriptorCompletions.removeAll()
        
        if _centralManager.delegate == nil {
            _centralManager.delegate = _centralManagerDelegate
        }
        didUpdateState(central: _centralManager)
    }
    
    func startDiscovery(serviceUUIDsArgs: [String]) throws {
        let serviceUUIDs = serviceUUIDsArgs.isEmpty ? nil : serviceUUIDsArgs.map { serviceUUIDArgs in serviceUUIDArgs.toCBUUID() }
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        _centralManager.scanForPeripherals(withServices: serviceUUIDs, options: options)
    }
    
    func stopDiscovery() throws {
        _centralManager.stopScan()
    }
    
    func retrieveConnectedPeripherals() throws -> [MyPeripheralArgs] {
        let peripherals = _centralManager.retrieveConnectedPeripherals(withServices: [])
        let peripheralsArgs = peripherals.map { peripheral in
            let peripheralArgs = peripheral.toArgs()
            let uuidArgs = peripheralArgs.uuidArgs
            if peripheral.delegate == nil {
                peripheral.delegate = _peripheralDelegate
            }
            _peripherals[uuidArgs] = peripheral
            return peripheralArgs
        }
        return peripheralsArgs
    }
    
    func connect(uuidArgs: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            _centralManager.connect(peripheral)
            _connectCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func disconnect(uuidArgs: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            _centralManager.cancelPeripheralConnection(peripheral)
            _disconnectCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func getMaximumWriteLength(uuidArgs: String, typeArgs: MyGATTCharacteristicWriteTypeArgs) throws -> Int64 {
        guard let peripheral = _peripherals[uuidArgs] else {
            throw MyError.illegalArgument
        }
        let type = typeArgs.toWriteType()
        let maximumWriteValueLength = peripheral.maximumWriteValueLength(for: type)
        let maximumWriteValueLengthArgs = maximumWriteValueLength.toInt64()
        return maximumWriteValueLengthArgs
    }
    
    func readRSSI(uuidArgs: String, completion: @escaping (Result<Int64, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            peripheral.readRSSI()
            _readRssiCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverServices(uuidArgs: String, completion: @escaping (Result<[MyGATTServiceArgs], Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            peripheral.discoverServices(nil)
            _discoverServicesCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverIncludedServices(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[MyGATTServiceArgs], Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let service = _retrieveService(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            peripheral.discoverIncludedServices(nil, for: service)
            _discoverIncludedServicesCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverCharacteristics(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[MyGATTCharacteristicArgs], Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let service = _retrieveService(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            peripheral.discoverCharacteristics(nil, for: service)
            _discoverCharacteristicsCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverDescriptors(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[MyGATTDescriptorArgs], Error>) -> Void){
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = _retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            peripheral.discoverDescriptors(for: characteristic)
            _discoverDescriptorsCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readCharacteristic(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = _retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            peripheral.readValue(for: characteristic)
            _readCharacteristicCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeCharacteristic(uuidArgs: String, hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, typeArgs: MyGATTCharacteristicWriteTypeArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = _retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            let data = valueArgs.data
            let type = typeArgs.toWriteType()
            peripheral.writeValue(data, for: characteristic, type: type)
            if type == .withResponse {
                _writeCharacteristicCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
            } else {
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func setCharacteristicNotifyState(uuidArgs: String, hashCodeArgs: Int64, stateArgs: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = _retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            let enabled = stateArgs
            peripheral.setNotifyValue(enabled, for: characteristic)
            _setCharacteristicNotifyStateCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readDescriptor(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let descriptor = _retrieveDescriptor(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            peripheral.readValue(for: descriptor)
            _readDescriptorCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeDescriptor(uuidArgs: String, hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let descriptor = _retrieveDescriptor(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            let data = valueArgs.data
            peripheral.writeValue(data, for: descriptor)
            _writeDescriptorCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func didUpdateState(central: CBCentralManager) {
        let state = central.state
        let stateArgs = state.toArgs()
        _api.onStateChanged(stateArgs: stateArgs) { _ in }
    }
    
    func didDiscover(central: CBCentralManager, peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        let rssiArgs = rssi.int64Value
        let advertisementArgs = advertisementData.toAdvertisementArgs()
        if peripheral.delegate == nil {
            peripheral.delegate = _peripheralDelegate
        }
        _peripherals[uuidArgs] = peripheral
        _api.onDiscovered(peripheralArgs: peripheralArgs, rssiArgs: rssiArgs, advertisementArgs: advertisementArgs) {_ in }
    }
    
    func didConnect(central: CBCentralManager, peripheral: CBPeripheral) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        let stateArgs = MyConnectionStateArgs.connected
        _api.onConnectionStateChanged(peripheralArgs: peripheralArgs, stateArgs: stateArgs) { _ in }
        guard let completion = _connectCompletions.removeValue(forKey: uuidArgs) else {
            return
        }
        completion(.success(()))
    }
    
    func didFailToConnect(central: CBCentralManager, peripheral: CBPeripheral, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        guard let completion = _connectCompletions.removeValue(forKey: uuidArgs) else {
            return
        }
        completion(.failure(error ?? MyError.unknown))
    }
    
    func didDisconnectPeripheral(central: CBCentralManager, peripheral: CBPeripheral, error: Error?) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        _services.removeValue(forKey: uuidArgs)
        _characteristics.removeValue(forKey: uuidArgs)
        _descriptors.removeValue(forKey: uuidArgs)
        let errorNotNil = error ?? MyError.unknown
        let readRssiCompletion = _readRssiCompletions.removeValue(forKey: uuidArgs)
        readRssiCompletion?(.failure(errorNotNil))
        let discoverServicesCompletion = _discoverServicesCompletions.removeValue(forKey: uuidArgs)
        discoverServicesCompletion?(.failure(errorNotNil))
        let discoverIncludedServicesCompletions = _discoverIncludedServicesCompletions.removeValue(forKey: uuidArgs)
        if discoverIncludedServicesCompletions != nil {
            let completions = discoverIncludedServicesCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let discoverCharacteristicsCompletions = _discoverCharacteristicsCompletions.removeValue(forKey: uuidArgs)
        if discoverCharacteristicsCompletions != nil {
            let completions = discoverCharacteristicsCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let discoverDescriptorsCompletions = _discoverDescriptorsCompletions.removeValue(forKey: uuidArgs)
        if discoverDescriptorsCompletions != nil {
            let completions = discoverDescriptorsCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let readCharacteristicCompletions = _readCharacteristicCompletions.removeValue(forKey: uuidArgs)
        if readCharacteristicCompletions != nil {
            let completions = readCharacteristicCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let writeCharacteristicCompletions = _writeCharacteristicCompletions.removeValue(forKey: uuidArgs)
        if writeCharacteristicCompletions != nil {
            let completions = writeCharacteristicCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let notifyCharacteristicCompletions = _setCharacteristicNotifyStateCompletions.removeValue(forKey: uuidArgs)
        if notifyCharacteristicCompletions != nil {
            let completions = notifyCharacteristicCompletions!.values
            for completioin in completions {
                completioin(.failure(errorNotNil))
            }
        }
        let readDescriptorCompletions = _readDescriptorCompletions.removeValue(forKey: uuidArgs)
        if readDescriptorCompletions != nil {
            let completions = readDescriptorCompletions!.values
            for completioin in completions {
                completioin(.failure(errorNotNil))
            }
        }
        let writeDescriptorCompletions = _writeDescriptorCompletions.removeValue(forKey: uuidArgs)
        if writeDescriptorCompletions != nil {
            let completions = writeDescriptorCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let stateArgs = MyConnectionStateArgs.disconnected
        _api.onConnectionStateChanged(peripheralArgs: peripheralArgs, stateArgs: stateArgs) { _ in }
        guard let completion = _disconnectCompletions.removeValue(forKey: uuidArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didReadRSSI(peripheral: CBPeripheral, rssi: NSNumber, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        guard let completion = _readRssiCompletions.removeValue(forKey: uuidArgs) else {
            return
        }
        if error == nil {
            let rssiArgs = rssi.int64Value
            completion(.success((rssiArgs)))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverServices(peripheral: CBPeripheral, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        guard let completion = _discoverServicesCompletions.removeValue(forKey: uuidArgs) else {
            return
        }
        if error == nil {
            let services = peripheral.services ?? []
            let servicesArgs = services.map { service in service.toArgs() }
            let values = services.flatMap { service in
                let hashCodeArgs = service.hash.toInt64()
                return [hashCodeArgs: service]
            }
            _services[uuidArgs, default: [:]].merge(values) { value1, value2 in value2 }
            completion(.success(servicesArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverIncludedServices(peripheral: CBPeripheral, service: CBService, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = service.hash.toInt64()
        guard let completion = _discoverIncludedServicesCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            let services = service.includedServices ?? []
            let servicesArgs = services.map { service in service.toArgs() }
            let values = services.flatMap { service in
                let hashCodeArgs = service.hash.toInt64()
                return [hashCodeArgs: service]
            }
            _services[uuidArgs, default: [:]].merge(values) { value1, value2 in value2 }
            completion(.success(servicesArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverCharacteristics(peripheral: CBPeripheral, service: CBService, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = service.hash.toInt64()
        guard let completion = _discoverCharacteristicsCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            let characteristics = service.characteristics ?? []
            let characteristicsArgs = characteristics.map { characteristic in characteristic.toArgs() }
            let values = characteristics.flatMap { characteristic in
                let hashCodeArgs = characteristic.hash.toInt64()
                return [hashCodeArgs: characteristic]
            }
            _characteristics[uuidArgs, default: [:]].merge(values) { value1, value2 in value2 }
            completion(.success(characteristicsArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverDescriptors(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = characteristic.hash.toInt64()
        guard let completion = _discoverDescriptorsCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            let descriptors = characteristic.descriptors ?? []
            let descriptorsArgs = descriptors.map { descriptor in descriptor.toArgs() }
            let values = descriptors.flatMap { descriptor in
                let hashCodeArgs = descriptor.hash.toInt64()
                return [hashCodeArgs: descriptor]
            }
            _descriptors[uuidArgs, default: [:]].merge(values) { value1, value2 in value2 }
            completion(.success(descriptorsArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateCharacteristicValue(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        let characteristicArgs = characteristic.toArgs()
        let hashCodeArgs = characteristicArgs.hashCodeArgs
        let value = characteristic.value ?? Data()
        let valueArgs = FlutterStandardTypedData(bytes: value)
        guard let completion = _readCharacteristicCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            _api.onCharacteristicNotified(peripheralArgs: peripheralArgs, characteristicArgs: characteristicArgs, valueArgs: valueArgs) { _ in }
            return
        }
        if error == nil {
            completion(.success(valueArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didWriteCharacteristicValue(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = characteristic.hash.toInt64()
        guard let completion = _writeCharacteristicCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateCharacteristicNotificationState(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = characteristic.hash.toInt64()
        guard let completion = _setCharacteristicNotifyStateCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateDescriptorValue(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = descriptor.hash.toInt64()
        guard let completion = _readDescriptorCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            let valueArgs: FlutterStandardTypedData
            switch descriptor.value {
            case let bytes as Data:
                valueArgs = FlutterStandardTypedData(bytes: bytes)
            case let value as String:
                let bytes = value.data(using: .utf8) ?? Data()
                valueArgs = FlutterStandardTypedData(bytes: bytes)
            case let value as UInt16:
                let bytes = value.data
                valueArgs = FlutterStandardTypedData(bytes: bytes)
            case let value as NSNumber:
                let bytes = withUnsafeBytes(of: value) { elements in Data(elements) }
                valueArgs = FlutterStandardTypedData(bytes: bytes)
            default:
                valueArgs = FlutterStandardTypedData()
            }
            completion(.success((valueArgs)))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didWriteDescriptorValue(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = descriptor.hash.toInt64()
        guard let completion = _writeDescriptorCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    private func _retrieveService(uuidArgs: String, hashCodeArgs: Int64) -> CBService? {
        guard let services = _services[uuidArgs] else {
            return nil
        }
        return services[hashCodeArgs]
    }
    
    private func _retrieveCharacteristic(uuidArgs: String, hashCodeArgs: Int64) -> CBCharacteristic? {
        guard let characteristics = _characteristics[uuidArgs] else {
            return nil
        }
        return characteristics[hashCodeArgs]
    }
    
    private func _retrieveDescriptor(uuidArgs: String, hashCodeArgs: Int64) -> CBDescriptor? {
        guard let descriptors = _descriptors[uuidArgs] else {
            return nil
        }
        return descriptors[hashCodeArgs]
    }
}
