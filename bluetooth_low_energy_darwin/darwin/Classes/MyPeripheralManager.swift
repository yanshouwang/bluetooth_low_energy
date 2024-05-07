//
//  MyPeripheralManager.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/10/7.
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

class MyPeripheralManager: MyPeripheralManagerHostAPI {
    private let _api: MyPeripheralManagerFlutterAPI
    private let _peripheralManager: CBPeripheralManager
    
    private lazy var _peripheralManagerDelegate = MyPeripheralManagerDelegate(peripheralManager: self)
    
    private var _servicesArgs: [Int: MyMutableGATTServiceArgs]
    private var _characteristicsArgs: [Int: MyMutableGATTCharacteristicArgs]
    private var _descriptorsArgs: [Int: MyMutableGATTDescriptorArgs]
    
    private var _centrals: [String: CBCentral]
    private var _services: [Int64: CBMutableService]
    private var _characteristics: [Int64: CBMutableCharacteristic]
    private var _descriptors: [Int64: CBMutableDescriptor]
    private var _requests: [Int64: CBATTRequest]
    
    private var _addServiceCompletion: ((Result<Void, Error>) -> Void)?
    private var _startAdvertisingCompletion: ((Result<Void, Error>) -> Void)?
    
    init(messenger: FlutterBinaryMessenger) {
        _api = MyPeripheralManagerFlutterAPI(binaryMessenger: messenger)
        _peripheralManager = CBPeripheralManager()
        
        _servicesArgs = [:]
        _characteristicsArgs = [:]
        _descriptorsArgs = [:]
        
        _centrals = [:]
        _services = [:]
        _characteristics = [:]
        _descriptors = [:]
        _requests = [:]
        
        _addServiceCompletion = nil
        _startAdvertisingCompletion = nil
    }
    
    func initialize() throws {
        if(_peripheralManager.isAdvertising) {
            _peripheralManager.stopAdvertising()
        }
        
        _servicesArgs.removeAll()
        _characteristicsArgs.removeAll()
        _descriptorsArgs.removeAll()
        
        _centrals.removeAll()
        _services.removeAll()
        _characteristics.removeAll()
        _descriptors.removeAll()
        _requests.removeAll()
        
        _addServiceCompletion = nil
        _startAdvertisingCompletion = nil
        
        if _peripheralManager.delegate == nil {
            _peripheralManager.delegate = _peripheralManagerDelegate
        }
        didUpdateState(peripheral: _peripheralManager)
    }
    
    func addService(serviceArgs: MyMutableGATTServiceArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        let service = serviceArgs.toService()
        var characteristics = [CBMutableCharacteristic]()
        let characteristicsArgs = serviceArgs.characteristicsArgs
        for args in characteristicsArgs {
            guard let characteristicArgs = args else {
                continue
            }
            let characteristic = characteristicArgs.toCharacteristic()
            characteristics.append(characteristic)
            var descriptors = [CBMutableDescriptor]()
            let descriptorsArgs = characteristicArgs.descriptorsArgs
            for args in descriptorsArgs {
                guard let descriptorArgs = args else {
                    continue
                }
                let descriptor = descriptorArgs.toDescriptor()
                descriptors.append(descriptor)
                let descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                let descriptorHashCode = descriptor.hash
                _descriptorsArgs[descriptorHashCode] = descriptorArgs
                _descriptors[descriptorHashCodeArgs] = descriptor
            }
            characteristic.descriptors = descriptors
            let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            let characteristicHashCode = characteristic.hash
            _characteristicsArgs[characteristicHashCode] = characteristicArgs
            _characteristics[characteristicHashCodeArgs] = characteristic
        }
        service.characteristics = characteristics
        let serviceHashCodeArgs = serviceArgs.hashCodeArgs
        let serviceHashCode = service.hash
        _servicesArgs[serviceHashCode] = serviceArgs
        _services[serviceHashCodeArgs] = service
        _peripheralManager.add(service)
        _addServiceCompletion = completion
    }
    
    func removeService(hashCodeArgs: Int64) throws {
        guard let service = _services.removeValue(forKey: hashCodeArgs) else {
            throw MyError.illegalArgument
        }
        _peripheralManager.remove(service)
        let hashCode = service.hash
        guard let serviceArgs = _servicesArgs.removeValue(forKey: hashCode) else {
            throw MyError.illegalArgument
        }
        for args in serviceArgs.characteristicsArgs {
            guard let characteristicArgs = args else {
                continue
            }
            let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            guard let characteristic = _characteristics.removeValue(forKey: characteristicHashCodeArgs) else {
                throw MyError.illegalArgument
            }
            let characteristicHashCode = characteristic.hash
            _characteristicsArgs.removeValue(forKey: characteristicHashCode)
            for args in characteristicArgs.descriptorsArgs {
                guard let descriptorArgs = args else {
                    continue
                }
                let descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                guard let descriptor = _descriptors.removeValue(forKey: descriptorHashCodeArgs) else {
                    throw MyError.illegalArgument
                }
                let descriptorHashCode = descriptor.hash
                _descriptorsArgs.removeValue(forKey: descriptorHashCode)
            }
        }
    }
    
    func clearServices() throws {
        _peripheralManager.removeAllServices()
        
        _services.removeAll()
        _characteristics.removeAll()
        _descriptors.removeAll()
        
        _servicesArgs.removeAll()
        _characteristicsArgs.removeAll()
        _descriptors.removeAll()
    }
    
    func startAdvertising(advertisementArgs: MyAdvertisementArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        let advertisement = advertisementArgs.toAdvertisement()
        _peripheralManager.startAdvertising(advertisement)
        _startAdvertisingCompletion = completion
    }
    
    func stopAdvertising() throws {
        _peripheralManager.stopAdvertising()
    }
    
    func maximumUpdateValueLength(uuidArgs: String) throws -> Int64 {
        guard let central = _centrals[uuidArgs] else {
            throw MyError.illegalArgument
        }
        let maximumUpdateValueLength = central.maximumUpdateValueLength
        let maximumUpdateValueLengthArgs = maximumUpdateValueLength.toInt64()
        return maximumUpdateValueLengthArgs
    }
    
    func respond(hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData?, errorNumberArgs: Int64) throws {
        guard let request = _requests.removeValue(forKey: hashCodeArgs) else {
            throw MyError.illegalArgument
        }
        if valueArgs != nil {
            request.value = valueArgs?.data
        }
        let errorArgsNumber = errorNumberArgs.toInt()
        guard let errorArgs = MyATTErrorArgs(rawValue: errorArgsNumber) else {
            throw MyError.illegalArgument
        }
        let error = errorArgs.toError()
        _peripheralManager.respond(to: request, withResult: error)
    }
    
    func updateValue(hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, uuidsArgs: [String]?) throws -> Bool {
        let centrals = try uuidsArgs?.map { uuidArgs in
            guard let central = _centrals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            return central
        }
        guard let characteristic = _characteristics[hashCodeArgs] else {
            throw MyError.illegalArgument
        }
        let value = valueArgs.data
        let updated = _peripheralManager.updateValue(value, for: characteristic, onSubscribedCentrals: centrals)
        return updated
    }
    
    func didUpdateState(peripheral: CBPeripheralManager) {
        let state = peripheral.state
        let stateArgs = state.toArgs()
        let stateNumberArgs = stateArgs.rawValue.toInt64()
        _api.onStateChanged(stateNumberArgs: stateNumberArgs) { _ in }
    }
    
    func didAdd(peripheral: CBPeripheralManager, service: CBService, error: Error?) {
        guard let completion = _addServiceCompletion else {
            return
        }
        _addServiceCompletion = nil
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didStartAdvertising(peripheral: CBPeripheralManager, error: Error?) {
        guard let completion = _startAdvertisingCompletion else {
            return
        }
        _startAdvertisingCompletion = nil
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didReceiveRead(peripheral: CBPeripheralManager, request: CBATTRequest) {
        let hashCodeArgs = request.hash.toInt64()
        let central = request.central
        let centralArgs = central.toArgs()
        _centrals[centralArgs.uuidArgs] = central
        let characteristic = request.characteristic
        guard let characteristicArgs = _characteristicsArgs[characteristic.hash] else {
            _peripheralManager.respond(to: request, withResult: .attributeNotFound)
            return
        }
        let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
        let value = request.value
        let valueArgs = value == nil ? nil : FlutterStandardTypedData(bytes: value!)
        let offsetArgs = request.offset.toInt64()
        let requestArgs = MyATTRequestArgs(hashCodeArgs: hashCodeArgs, centralArgs: centralArgs, characteristicHashCodeArgs: characteristicHashCodeArgs, offsetArgs: offsetArgs)
        _requests[hashCodeArgs] = request
        _api.didReceiveRead(requestArgs: requestArgs) { _ in }
    }
    
    func didReceiveWrite(peripheral: CBPeripheralManager, requests: [CBATTRequest]) {
        var requestsArgs = [MyATTRequestArgs]()
        for request in requests {
            let hashCodeArgs = request.hash.toInt64()
            let central = request.central
            let centralArgs = central.toArgs()
            _centrals[centralArgs.uuidArgs] = central
            let characteristic = request.characteristic
            guard let characteristicArgs = _characteristicsArgs[characteristic.hash] else {
                _peripheralManager.respond(to: request, withResult: .attributeNotFound)
                return
            }
            let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            let value = request.value
            let valueArgs = value == nil ? nil : FlutterStandardTypedData(bytes: value!)
            let offsetArgs = request.offset.toInt64()
            let requestArgs = MyATTRequestArgs(hashCodeArgs: hashCodeArgs, centralArgs: centralArgs, characteristicHashCodeArgs: characteristicHashCodeArgs, offsetArgs: offsetArgs)
            requestsArgs.append(requestArgs)
        }
        guard let request = requests.first else {
            return
        }
        guard let requestArgs = requestsArgs.first else {
            return
        }
        _requests[requestArgs.hashCodeArgs] = request
        _api.didReceiveWrite(requestsArgs: requestsArgs) { _ in }
    }
    
    func didSubscribeTo(peripheral: CBPeripheralManager, central: CBCentral, characteristic: CBCharacteristic) {
        let centralArgs = central.toArgs()
        _centrals[centralArgs.uuidArgs] = central
        let hashCode = characteristic.hash
        guard let characteristicArgs = _characteristicsArgs[hashCode] else {
            return
        }
        let hashCodeArgs = characteristicArgs.hashCodeArgs
        let stateArgs = true
        _api.onCharacteristicNotifyStateChanged(centralArgs: centralArgs, hashCodeArgs: hashCodeArgs, stateArgs: stateArgs) { _ in }
    }
    
    func didUnsubscribeFrom(peripheral: CBPeripheralManager, central: CBCentral, characteristic: CBCharacteristic) {
        let centralArgs = central.toArgs()
        _centrals[centralArgs.uuidArgs] = central
        let hashCode = characteristic.hash
        guard let characteristicArgs = _characteristicsArgs[hashCode] else {
            return
        }
        let hashCodeArgs = characteristicArgs.hashCodeArgs
        let stateArgs = false
        _api.onCharacteristicNotifyStateChanged(centralArgs: centralArgs, hashCodeArgs: hashCodeArgs, stateArgs: stateArgs) { _ in }
    }
    
    func isReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        _api.isReady() { _ in }
    }
}
