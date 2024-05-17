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
    private let api: MyPeripheralManagerFlutterAPI
    private let peripheralManager: CBPeripheralManager
    
    private lazy var peripheralManagerDelegate = MyPeripheralManagerDelegate(peripheralManager: self)
    
    private var servicesArgs: [Int: MyMutableGATTServiceArgs]
    private var characteristicsArgs: [Int: MyMutableGATTCharacteristicArgs]
    private var descriptorsArgs: [Int: MyMutableGATTDescriptorArgs]
    
    private var centrals: [String: CBCentral]
    private var services: [Int64: CBMutableService]
    private var characteristics: [Int64: CBMutableCharacteristic]
    private var descriptors: [Int64: CBMutableDescriptor]
    private var requests: [Int64: CBATTRequest]
    
    private var addServiceCompletion: ((Result<Void, Error>) -> Void)?
    private var startAdvertisingCompletion: ((Result<Void, Error>) -> Void)?
    
    init(messenger: FlutterBinaryMessenger) {
        api = MyPeripheralManagerFlutterAPI(binaryMessenger: messenger)
        peripheralManager = CBPeripheralManager()
        
        servicesArgs = [:]
        characteristicsArgs = [:]
        descriptorsArgs = [:]
        
        centrals = [:]
        services = [:]
        characteristics = [:]
        descriptors = [:]
        requests = [:]
        
        addServiceCompletion = nil
        startAdvertisingCompletion = nil
    }
    
    func initialize() throws {
        if(peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        
        servicesArgs.removeAll()
        characteristicsArgs.removeAll()
        descriptorsArgs.removeAll()
        
        centrals.removeAll()
        services.removeAll()
        characteristics.removeAll()
        descriptors.removeAll()
        requests.removeAll()
        
        addServiceCompletion = nil
        startAdvertisingCompletion = nil
        
        if peripheralManager.delegate == nil {
            peripheralManager.delegate = peripheralManagerDelegate
        }
        didUpdateState(peripheral: peripheralManager)
    }
    
    func addService(serviceArgs: MyMutableGATTServiceArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let service = try addServiceArgs(serviceArgs)
            peripheralManager.add(service)
            addServiceCompletion = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeService(hashCodeArgs: Int64) throws {
        guard let service = services[hashCodeArgs] else {
            throw MyError.illegalArgument
        }
        guard let serviceArgs = servicesArgs[service.hash] else {
            throw MyError.illegalArgument
        }
        peripheralManager.remove(service)
        try removeServiceArgs(serviceArgs)
    }
    
    func removeAllServices() throws {
        peripheralManager.removeAllServices()
        
        services.removeAll()
        characteristics.removeAll()
        descriptors.removeAll()
        
        servicesArgs.removeAll()
        characteristicsArgs.removeAll()
        descriptors.removeAll()
    }
    
    func startAdvertising(advertisementArgs: MyAdvertisementArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        let advertisement = advertisementArgs.toAdvertisement()
        peripheralManager.startAdvertising(advertisement)
        startAdvertisingCompletion = completion
    }
    
    func stopAdvertising() throws {
        peripheralManager.stopAdvertising()
    }
    
    func getMaximumNotifyLength(uuidArgs: String) throws -> Int64 {
        guard let central = centrals[uuidArgs] else {
            throw MyError.illegalArgument
        }
        let maximumNotifyLength = central.maximumUpdateValueLength
        let maximumNotifyLengthArgs = maximumNotifyLength.toInt64()
        return maximumNotifyLengthArgs
    }
    
    func respond(hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData?, errorArgs: MyATTErrorArgs) throws {
        guard let request = requests.removeValue(forKey: hashCodeArgs) else {
            throw MyError.illegalArgument
        }
        if valueArgs != nil {
            request.value = valueArgs!.data
        }
        let error = errorArgs.toError()
        peripheralManager.respond(to: request, withResult: error)
    }
    
    func updateValue(hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, uuidsArgs: [String]?) throws -> Bool {
        let centrals = try uuidsArgs?.map { uuidArgs in
            guard let central = self.centrals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            return central
        }
        guard let characteristic = characteristics[hashCodeArgs] else {
            throw MyError.illegalArgument
        }
        let value = valueArgs.data
        let updated = peripheralManager.updateValue(value, for: characteristic, onSubscribedCentrals: centrals)
        return updated
    }
    
    func didUpdateState(peripheral: CBPeripheralManager) {
        let state = peripheral.state
        let stateArgs = state.toArgs()
        api.onStateChanged(stateArgs: stateArgs) { _ in }
    }
    
    func didAdd(peripheral: CBPeripheralManager, service: CBService, error: Error?) {
        guard let completion = addServiceCompletion else {
            return
        }
        addServiceCompletion = nil
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didStartAdvertising(peripheral: CBPeripheralManager, error: Error?) {
        guard let completion = startAdvertisingCompletion else {
            return
        }
        startAdvertisingCompletion = nil
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
        centrals[centralArgs.uuidArgs] = central
        let characteristic = request.characteristic
        guard let characteristicArgs = characteristicsArgs[characteristic.hash] else {
            peripheralManager.respond(to: request, withResult: .attributeNotFound)
            return
        }
        let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
        let value = request.value
        let valueArgs = value == nil ? nil : FlutterStandardTypedData(bytes: value!)
        let offsetArgs = request.offset.toInt64()
        let requestArgs = MyATTRequestArgs(hashCodeArgs: hashCodeArgs, centralArgs: centralArgs, characteristicHashCodeArgs: characteristicHashCodeArgs, valueArgs: valueArgs, offsetArgs: offsetArgs)
        requests[hashCodeArgs] = request
        api.didReceiveRead(requestArgs: requestArgs) { _ in }
    }
    
    func didReceiveWrite(peripheral: CBPeripheralManager, requests: [CBATTRequest]) {
        var requestsArgs = [MyATTRequestArgs]()
        for request in requests {
            let hashCodeArgs = request.hash.toInt64()
            let central = request.central
            let centralArgs = central.toArgs()
            centrals[centralArgs.uuidArgs] = central
            let characteristic = request.characteristic
            guard let characteristicArgs = characteristicsArgs[characteristic.hash] else {
                peripheralManager.respond(to: request, withResult: .attributeNotFound)
                return
            }
            let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            let value = request.value
            let valueArgs = value == nil ? nil : FlutterStandardTypedData(bytes: value!)
            let offsetArgs = request.offset.toInt64()
            let requestArgs = MyATTRequestArgs(hashCodeArgs: hashCodeArgs, centralArgs: centralArgs, characteristicHashCodeArgs: characteristicHashCodeArgs, valueArgs: valueArgs, offsetArgs: offsetArgs)
            requestsArgs.append(requestArgs)
        }
        guard let request = requests.first else {
            return
        }
        guard let requestArgs = requestsArgs.first else {
            return
        }
        self.requests[requestArgs.hashCodeArgs] = request
        api.didReceiveWrite(requestsArgs: requestsArgs) { _ in }
    }
    
    func didSubscribeTo(peripheral: CBPeripheralManager, central: CBCentral, characteristic: CBCharacteristic) {
        let centralArgs = central.toArgs()
        centrals[centralArgs.uuidArgs] = central
        let hashCode = characteristic.hash
        guard let characteristicArgs = characteristicsArgs[hashCode] else {
            return
        }
        let hashCodeArgs = characteristicArgs.hashCodeArgs
        let stateArgs = true
        api.onCharacteristicNotifyStateChanged(centralArgs: centralArgs, hashCodeArgs: hashCodeArgs, stateArgs: stateArgs) { _ in }
    }
    
    func didUnsubscribeFrom(peripheral: CBPeripheralManager, central: CBCentral, characteristic: CBCharacteristic) {
        let centralArgs = central.toArgs()
        centrals[centralArgs.uuidArgs] = central
        let hashCode = characteristic.hash
        guard let characteristicArgs = characteristicsArgs[hashCode] else {
            return
        }
        let hashCodeArgs = characteristicArgs.hashCodeArgs
        let stateArgs = false
        api.onCharacteristicNotifyStateChanged(centralArgs: centralArgs, hashCodeArgs: hashCodeArgs, stateArgs: stateArgs) { _ in }
    }
    
    func isReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        api.isReady() { _ in }
    }
    
    private func addServiceArgs(_ serviceArgs: MyMutableGATTServiceArgs) throws -> CBMutableService {
        let service = serviceArgs.toService()
        servicesArgs[service.hash] = serviceArgs
        services[serviceArgs.hashCodeArgs] = service
        var includedServices = [CBService]()
        let includedServicesArgs = serviceArgs.includedServicesArgs
        for args in includedServicesArgs {
            guard let includedServiceArgs = args else {
                throw MyError.illegalArgument
            }
            let includedService = try addServiceArgs(includedServiceArgs)
            self.servicesArgs[includedService.hash] = includedServiceArgs
            self.services[includedServiceArgs.hashCodeArgs] = includedService
            includedServices.append(includedService)
        }
        service.includedServices = includedServices
        var characteristics = [CBMutableCharacteristic]()
        let characteristicsArgs = serviceArgs.characteristicsArgs
        for args in characteristicsArgs {
            guard let characteristicArgs = args else {
                throw MyError.illegalArgument
            }
            let characteristic = characteristicArgs.toCharacteristic()
            self.characteristicsArgs[characteristic.hash] = characteristicArgs
            self.characteristics[characteristicArgs.hashCodeArgs] = characteristic
            characteristics.append(characteristic)
            var descriptors = [CBMutableDescriptor]()
            let descriptorsArgs = characteristicArgs.descriptorsArgs
            for args in descriptorsArgs {
                guard let descriptorArgs = args else {
                    continue
                }
                let descriptor = descriptorArgs.toDescriptor()
                self.descriptorsArgs[descriptor.hash] = descriptorArgs
                self.descriptors[descriptorArgs.hashCodeArgs] = descriptor
                descriptors.append(descriptor)
            }
            characteristic.descriptors = descriptors
        }
        service.characteristics = characteristics
        return service
    }
    
    private func removeServiceArgs(_ serviceArgs: MyMutableGATTServiceArgs) throws {
        for args in serviceArgs.includedServicesArgs {
            guard let includedServiceArgs = args else {
                throw MyError.illegalArgument
            }
            try removeServiceArgs(includedServiceArgs)
        }
        for args in serviceArgs.characteristicsArgs {
            guard let characteristicArgs = args else {
                throw MyError.illegalArgument
            }
            for args in characteristicArgs.descriptorsArgs {
                guard let descriptorArgs = args else {
                    throw MyError.illegalArgument
                }
                guard let descriptor = descriptors.removeValue(forKey: descriptorArgs.hashCodeArgs) else {
                    throw MyError.illegalArgument
                }
                descriptorsArgs.removeValue(forKey: descriptor.hash)
            }
            guard let characteristic = characteristics.removeValue(forKey: characteristicArgs.hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            characteristicsArgs.removeValue(forKey: characteristic.hash)
        }
        guard let service = services.removeValue(forKey: serviceArgs.hashCodeArgs) else {
            throw MyError.illegalArgument
        }
        servicesArgs.removeValue(forKey: service.hash)
    }
}
