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
    private let _api: MyCentralManagerFlutterApi
    private let _centralManager: CBCentralManager
    
    private lazy var _centralManagerDelegate = MyCentralManagerDelegate(centralManager: self)
    private lazy var _peripheralDelegate = MyPeripheralDelegate(centralManager: self)
    
    private var _peripherals: [String: CBPeripheral]
    private var _services: [String: [Int64: CBService]]
    private var _characteristics: [String: [Int64: CBCharacteristic]]
    private var _descriptors: [String: [Int64: CBDescriptor]]
    
    private var _setUpCompletion: ((Result<MyCentralManagerArgs, Error>) -> Void)?
    private var _connectCompletions: [String: (Result<Void, Error>) -> Void]
    private var _disconnectCompletions: [String: (Result<Void, Error>) -> Void]
    private var _readRssiCompletions: [String: (Result<Int64, Error>) -> Void]
    private var _discoverServicesCompletions: [String: (Result<[MyGattServiceArgs], Error>) -> Void]
    private var _discoverCharacteristicsCompletions: [String: [Int64: (Result<[MyGattCharacteristicArgs], Error>) -> Void]]
    private var _discoverDescriptorsCompletions: [String: [Int64: (Result<[MyGattDescriptorArgs], Error>) -> Void]]
    private var _readCharacteristicCompletions: [String: [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]]
    private var _writeCharacteristicCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    private var _notifyCharacteristicCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    private var _readDescriptorCompletions: [String: [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]]
    private var _writeDescriptorCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    
    init(messenger: FlutterBinaryMessenger) {
        _api = MyCentralManagerFlutterApi(binaryMessenger: messenger)
        _centralManager = CBCentralManager()
        
        _peripherals = [:]
        _services = [:]
        _characteristics = [:]
        _descriptors = [:]
        
        _setUpCompletion = nil
        _connectCompletions = [:]
        _disconnectCompletions = [:]
        _readRssiCompletions = [:]
        _discoverServicesCompletions = [:]
        _discoverCharacteristicsCompletions = [:]
        _discoverDescriptorsCompletions = [:]
        _readCharacteristicCompletions = [:]
        _writeCharacteristicCompletions = [:]
        _notifyCharacteristicCompletions = [:]
        _readDescriptorCompletions = [:]
        _writeDescriptorCompletions = [:]
    }
    
    func setUp(completion: @escaping (Result<MyCentralManagerArgs, Error>) -> Void) {
        _clearState()
        if _centralManager.delegate == nil {
            _centralManager.delegate = _centralManagerDelegate
        }
        if _centralManager.state == .unknown {
            _setUpCompletion = completion
        } else {
            let stateArgs = _centralManager.state.toArgs()
            let stateNumberArgs = stateArgs.rawValue.toArgs()
            let args = MyCentralManagerArgs(stateNumberArgs: stateNumberArgs)
            completion(.success(args))
        }
    }
    
    func startDiscovery() throws {
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        _centralManager.scanForPeripherals(withServices: nil, options: options)
    }
    
    func stopDiscovery() throws {
        _centralManager.stopScan()
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
    
    func getMaximumWriteValueLength(uuidArgs: String, typeNumberArgs: Int64) throws -> Int64 {
        guard let peripheral = _peripherals[uuidArgs] else {
            throw MyError.illegalArgument
        }
        let typeNumber = typeNumberArgs.toInt()
        guard let typeArgs = MyGattCharacteristicWriteTypeArgs(rawValue: typeNumber) else {
            throw MyError.illegalArgument
        }
        let type = typeArgs.toWriteType()
        let maximumWriteValueLength = peripheral.maximumWriteValueLength(for: type)
        let maximumWriteValueLengthArgs = maximumWriteValueLength.toArgs()
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
    
    func discoverServices(uuidArgs: String, completion: @escaping (Result<[MyGattServiceArgs], Error>) -> Void) {
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
    
    func discoverCharacteristics(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[MyGattCharacteristicArgs], Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let service = _retrieveService(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            peripheral.discoverCharacteristics(nil, for: service)
            var completions = _discoverCharacteristicsCompletions.getOrPut(uuidArgs) { [:] }
            completions[hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverDescriptors(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[MyGattDescriptorArgs], Error>) -> Void){
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = _retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            peripheral.discoverDescriptors(for: characteristic)
            var completions = _discoverDescriptorsCompletions.getOrPut(uuidArgs) { [:] }
            completions[hashCodeArgs] = completion
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
            var completions = _readCharacteristicCompletions.getOrPut(uuidArgs) { [:] }
            completions[hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeCharacteristic(uuidArgs: String, hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, typeNumberArgs: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = _retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            let data = valueArgs.data
            let typeNumber = typeNumberArgs.toInt()
            guard let typeArgs = MyGattCharacteristicWriteTypeArgs(rawValue: typeNumber) else {
                throw MyError.illegalArgument
            }
            let type = typeArgs.toWriteType()
            peripheral.writeValue(data, for: characteristic, type: type)
            if type == .withResponse {
                var completions = _writeCharacteristicCompletions.getOrPut(uuidArgs) { [:] }
                completions[hashCodeArgs] = completion
            } else {
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func notifyCharacteristic(uuidArgs: String, hashCodeArgs: Int64, stateArgs: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let peripheral = _peripherals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            guard let characteristic = _retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            let enabled = stateArgs
            peripheral.setNotifyValue(enabled, for: characteristic)
            var completions = _notifyCharacteristicCompletions.getOrPut(uuidArgs) { [:] }
            completions[hashCodeArgs] = completion
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
            var completions = _readDescriptorCompletions.getOrPut(uuidArgs) { [:] }
            completions[hashCodeArgs] = completion
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
            var completions = _writeDescriptorCompletions.getOrPut(uuidArgs) { [:] }
            completions[hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func didUpdateState(central: CBCentralManager) {
        let state = central.state
        let stateArgs = state.toArgs()
        let stateNumberArgs = stateArgs.rawValue.toArgs()
        _api.onStateChanged(stateNumberArgs: stateNumberArgs) {_ in }
        guard state != .unknown else {
            return
        }
        guard let completion = _setUpCompletion else {
            return
        }
        _setUpCompletion = nil
        let args = MyCentralManagerArgs(stateNumberArgs: stateNumberArgs)
        completion(.success(args))
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
        let uuidArgs = peripheral.identifier.toArgs()
        let stateArgs = true
        _api.onPeripheralStateChanged(uuidArgs: uuidArgs, stateArgs: stateArgs) {_ in }
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
        let uuidArgs = peripheral.identifier.toArgs()
        _services.removeValue(forKey: uuidArgs)
        _characteristics.removeValue(forKey: uuidArgs)
        _descriptors.removeValue(forKey: uuidArgs)
        let errorNotNil = error ?? MyError.unknown
        let readRssiCompletion = _readRssiCompletions.removeValue(forKey: uuidArgs)
        readRssiCompletion?(.failure(errorNotNil))
        let discoverServicesCompletion = _discoverServicesCompletions.removeValue(forKey: uuidArgs)
        discoverServicesCompletion?(.failure(errorNotNil))
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
        let notifyCharacteristicCompletions = _notifyCharacteristicCompletions.removeValue(forKey: uuidArgs)
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
        let stateArgs = false
        _api.onPeripheralStateChanged(uuidArgs: uuidArgs, stateArgs: stateArgs) {_ in }
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
            let elements = services.flatMap { service in
                let hashCodeArgs = service.hash.toArgs()
                return [hashCodeArgs: service]
            }
            var items = _services[uuidArgs]
            if items == nil {
                _services[uuidArgs] = Dictionary(uniqueKeysWithValues: elements)
            } else {
                items!.merge(elements) { service1, service2 in service2 }
            }
            completion(.success(servicesArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverCharacteristics(peripheral: CBPeripheral, service: CBService, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = service.hash.toArgs()
        guard var completions = _discoverCharacteristicsCompletions[uuidArgs] else {
            return
        }
        guard let completion = completions.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            let characteristics = service.characteristics ?? []
            let characteristicsArgs = characteristics.map { characteristic in characteristic.toArgs() }
            let elements = characteristics.flatMap { characteristic in
                let hashCodeArgs = characteristic.hash.toArgs()
                return [hashCodeArgs: characteristic]
            }
            var items = _characteristics[uuidArgs]
            if items == nil {
                _characteristics[uuidArgs] = Dictionary(uniqueKeysWithValues: elements)
            } else {
                items!.merge(elements) { characteristic1, characteristic2 in characteristic2 }
            }
            completion(.success(characteristicsArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverDescriptors(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = characteristic.hash.toArgs()
        guard var completions = _discoverDescriptorsCompletions[uuidArgs] else {
            return
        }
        guard let completion = completions.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            let descriptors = characteristic.descriptors ?? []
            let descriptorsArgs = descriptors.map { descriptor in descriptor.toArgs() }
            let elements = descriptors.flatMap { descriptor in
                let hashCodeArgs = descriptor.hash.toArgs()
                return [hashCodeArgs: descriptor]
            }
            var items = _descriptors[uuidArgs]
            if items == nil {
                _descriptors[uuidArgs] = Dictionary(uniqueKeysWithValues: elements)
            } else {
                items!.merge(elements) { descriptor1, descriptor2 in descriptor2 }
            }
            completion(.success(descriptorsArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didUpdateCharacteristicValue(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = characteristic.hash.toArgs()
        let value = characteristic.value ?? Data()
        let valueArgs = FlutterStandardTypedData(bytes: value)
        var completions = _readCharacteristicCompletions[uuidArgs]
        guard let completion = completions?.removeValue(forKey: hashCodeArgs) else {
            _api.onCharacteristicValueChanged(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs, valueArgs: valueArgs) {_ in }
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
        let hashCodeArgs = characteristic.hash.toArgs()
        guard var completions = _writeCharacteristicCompletions[uuidArgs] else {
            return
        }
        guard let completion = completions.removeValue(forKey: hashCodeArgs) else {
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
        let hashCodeArgs = characteristic.hash.toArgs()
        guard var completions = _notifyCharacteristicCompletions[uuidArgs] else {
            return
        }
        guard let completion = completions.removeValue(forKey: hashCodeArgs) else {
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
        let hashCodeArgs = descriptor.hash.toArgs()
        guard var completions = _readDescriptorCompletions[uuidArgs] else {
            return
        }
        guard let completion = completions.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            // TODO: confirm the corresponding descriptor types and values are correct.
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
    
    func didWriteDescriptorValue(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = descriptor.hash.toArgs()
        guard var completions = _writeDescriptorCompletions[uuidArgs] else {
            return
        }
        guard let completion = completions.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    private func _clearState() {
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
        
        _setUpCompletion = nil
        _connectCompletions.removeAll()
        _disconnectCompletions.removeAll()
        _readRssiCompletions.removeAll()
        _discoverServicesCompletions.removeAll()
        _discoverCharacteristicsCompletions.removeAll()
        _discoverDescriptorsCompletions.removeAll()
        _readCharacteristicCompletions.removeAll()
        _writeCharacteristicCompletions.removeAll()
        _notifyCharacteristicCompletions.removeAll()
        _readDescriptorCompletions.removeAll()
        _writeDescriptorCompletions.removeAll()
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
