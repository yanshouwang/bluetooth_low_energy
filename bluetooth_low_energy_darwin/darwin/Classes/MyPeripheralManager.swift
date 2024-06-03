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
    private let mAPI: MyPeripheralManagerFlutterAPI
    private let mPeripheralManager: CBPeripheralManager
    
    private lazy var mPeripheralManagerDelegate = MyPeripheralManagerDelegate(peripheralManager: self)
    
    private var mServicesArgs: [Int: MyMutableGATTServiceArgs]
    private var mCharacteristicsArgs: [Int: MyMutableGATTCharacteristicArgs]
    private var mDescriptorsArgs: [Int: MyMutableGATTDescriptorArgs]
    
    private var mCentrals: [String: CBCentral]
    private var mServices: [Int64: CBMutableService]
    private var mCharacteristics: [Int64: CBMutableCharacteristic]
    private var mDescriptors: [Int64: CBMutableDescriptor]
    private var mRequests: [Int64: CBATTRequest]
    
    private var mAddServiceCompletion: ((Result<Void, Error>) -> Void)?
    private var mStartAdvertisingCompletion: ((Result<Void, Error>) -> Void)?
    
    init(messenger: FlutterBinaryMessenger) {
        mAPI = MyPeripheralManagerFlutterAPI(binaryMessenger: messenger)
        mPeripheralManager = CBPeripheralManager()
        
        mServicesArgs = [:]
        mCharacteristicsArgs = [:]
        mDescriptorsArgs = [:]
        
        mCentrals = [:]
        mServices = [:]
        mCharacteristics = [:]
        mDescriptors = [:]
        mRequests = [:]
        
        mAddServiceCompletion = nil
        mStartAdvertisingCompletion = nil
    }
    
    func initialize() throws {
        if(mPeripheralManager.isAdvertising) {
            mPeripheralManager.stopAdvertising()
        }
        
        mServicesArgs.removeAll()
        mCharacteristicsArgs.removeAll()
        mDescriptorsArgs.removeAll()
        
        mCentrals.removeAll()
        mServices.removeAll()
        mCharacteristics.removeAll()
        mDescriptors.removeAll()
        mRequests.removeAll()
        
        mAddServiceCompletion = nil
        mStartAdvertisingCompletion = nil
        
        if mPeripheralManager.delegate == nil {
            mPeripheralManager.delegate = mPeripheralManagerDelegate
        }
        didUpdateState(peripheral: mPeripheralManager)
    }
    
    func addService(serviceArgs: MyMutableGATTServiceArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let service = try addServiceArgs(serviceArgs)
            mPeripheralManager.add(service)
            mAddServiceCompletion = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeService(hashCodeArgs: Int64) throws {
        guard let service = mServices[hashCodeArgs] else {
            throw MyError.illegalArgument
        }
        guard let serviceArgs = mServicesArgs[service.hash] else {
            throw MyError.illegalArgument
        }
        mPeripheralManager.remove(service)
        try removeServiceArgs(serviceArgs)
    }
    
    func removeAllServices() throws {
        mPeripheralManager.removeAllServices()
        
        mServices.removeAll()
        mCharacteristics.removeAll()
        mDescriptors.removeAll()
        
        mServicesArgs.removeAll()
        mCharacteristicsArgs.removeAll()
        mDescriptors.removeAll()
    }
    
    func startAdvertising(advertisementArgs: MyAdvertisementArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        let advertisement = advertisementArgs.toAdvertisement()
        mPeripheralManager.startAdvertising(advertisement)
        mStartAdvertisingCompletion = completion
    }
    
    func stopAdvertising() throws {
        mPeripheralManager.stopAdvertising()
    }
    
    func getMaximumNotifyLength(uuidArgs: String) throws -> Int64 {
        guard let central = mCentrals[uuidArgs] else {
            throw MyError.illegalArgument
        }
        let maximumNotifyLength = central.maximumUpdateValueLength
        let maximumNotifyLengthArgs = maximumNotifyLength.toInt64()
        return maximumNotifyLengthArgs
    }
    
    func respond(hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData?, errorArgs: MyATTErrorArgs) throws {
        guard let request = mRequests.removeValue(forKey: hashCodeArgs) else {
            throw MyError.illegalArgument
        }
        if valueArgs != nil {
            request.value = valueArgs!.data
        }
        let error = errorArgs.toError()
        mPeripheralManager.respond(to: request, withResult: error)
    }
    
    func updateValue(hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, uuidsArgs: [String]?) throws -> Bool {
        let centrals = try uuidsArgs?.map { uuidArgs in
            guard let central = self.mCentrals[uuidArgs] else {
                throw MyError.illegalArgument
            }
            return central
        }
        guard let characteristic = mCharacteristics[hashCodeArgs] else {
            throw MyError.illegalArgument
        }
        let value = valueArgs.data
        let updated = mPeripheralManager.updateValue(value, for: characteristic, onSubscribedCentrals: centrals)
        return updated
    }
    
    func didUpdateState(peripheral: CBPeripheralManager) {
        let state = peripheral.state
        let stateArgs = state.toArgs()
        mAPI.onStateChanged(stateArgs: stateArgs) { _ in }
    }
    
    func didAdd(peripheral: CBPeripheralManager, service: CBService, error: Error?) {
        guard let completion = mAddServiceCompletion else {
            return
        }
        mAddServiceCompletion = nil
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didStartAdvertising(peripheral: CBPeripheralManager, error: Error?) {
        guard let completion = mStartAdvertisingCompletion else {
            return
        }
        mStartAdvertisingCompletion = nil
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
        mCentrals[centralArgs.uuidArgs] = central
        let characteristic = request.characteristic
        guard let characteristicArgs = mCharacteristicsArgs[characteristic.hash] else {
            mPeripheralManager.respond(to: request, withResult: .attributeNotFound)
            return
        }
        let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
        let value = request.value
        let valueArgs = value == nil ? nil : FlutterStandardTypedData(bytes: value!)
        let offsetArgs = request.offset.toInt64()
        let requestArgs = MyATTRequestArgs(hashCodeArgs: hashCodeArgs, centralArgs: centralArgs, characteristicHashCodeArgs: characteristicHashCodeArgs, valueArgs: valueArgs, offsetArgs: offsetArgs)
        mRequests[hashCodeArgs] = request
        mAPI.didReceiveRead(requestArgs: requestArgs) { _ in }
    }
    
    func didReceiveWrite(peripheral: CBPeripheralManager, requests: [CBATTRequest]) {
        var requestsArgs = [MyATTRequestArgs]()
        for request in requests {
            let hashCodeArgs = request.hash.toInt64()
            let central = request.central
            let centralArgs = central.toArgs()
            mCentrals[centralArgs.uuidArgs] = central
            let characteristic = request.characteristic
            guard let characteristicArgs = mCharacteristicsArgs[characteristic.hash] else {
                mPeripheralManager.respond(to: request, withResult: .attributeNotFound)
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
        self.mRequests[requestArgs.hashCodeArgs] = request
        mAPI.didReceiveWrite(requestsArgs: requestsArgs) { _ in }
    }
    
    func didSubscribeTo(peripheral: CBPeripheralManager, central: CBCentral, characteristic: CBCharacteristic) {
        let centralArgs = central.toArgs()
        mCentrals[centralArgs.uuidArgs] = central
        let hashCode = characteristic.hash
        guard let characteristicArgs = mCharacteristicsArgs[hashCode] else {
            return
        }
        let hashCodeArgs = characteristicArgs.hashCodeArgs
        let stateArgs = true
        mAPI.onCharacteristicNotifyStateChanged(centralArgs: centralArgs, hashCodeArgs: hashCodeArgs, stateArgs: stateArgs) { _ in }
    }
    
    func didUnsubscribeFrom(peripheral: CBPeripheralManager, central: CBCentral, characteristic: CBCharacteristic) {
        let centralArgs = central.toArgs()
        mCentrals[centralArgs.uuidArgs] = central
        let hashCode = characteristic.hash
        guard let characteristicArgs = mCharacteristicsArgs[hashCode] else {
            return
        }
        let hashCodeArgs = characteristicArgs.hashCodeArgs
        let stateArgs = false
        mAPI.onCharacteristicNotifyStateChanged(centralArgs: centralArgs, hashCodeArgs: hashCodeArgs, stateArgs: stateArgs) { _ in }
    }
    
    func isReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        mAPI.isReady() { _ in }
    }
    
    private func addServiceArgs(_ serviceArgs: MyMutableGATTServiceArgs) throws -> CBMutableService {
        let service = serviceArgs.toService()
        mServicesArgs[service.hash] = serviceArgs
        mServices[serviceArgs.hashCodeArgs] = service
        var includedServices = [CBService]()
        let includedServicesArgs = serviceArgs.includedServicesArgs
        for args in includedServicesArgs {
            guard let includedServiceArgs = args else {
                throw MyError.illegalArgument
            }
            let includedService = try addServiceArgs(includedServiceArgs)
            self.mServicesArgs[includedService.hash] = includedServiceArgs
            self.mServices[includedServiceArgs.hashCodeArgs] = includedService
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
            self.mCharacteristicsArgs[characteristic.hash] = characteristicArgs
            self.mCharacteristics[characteristicArgs.hashCodeArgs] = characteristic
            characteristics.append(characteristic)
            var descriptors = [CBMutableDescriptor]()
            let descriptorsArgs = characteristicArgs.descriptorsArgs
            for args in descriptorsArgs {
                guard let descriptorArgs = args else {
                    continue
                }
                let descriptor = descriptorArgs.toDescriptor()
                self.mDescriptorsArgs[descriptor.hash] = descriptorArgs
                self.mDescriptors[descriptorArgs.hashCodeArgs] = descriptor
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
                guard let descriptor = mDescriptors.removeValue(forKey: descriptorArgs.hashCodeArgs) else {
                    throw MyError.illegalArgument
                }
                mDescriptorsArgs.removeValue(forKey: descriptor.hash)
            }
            guard let characteristic = mCharacteristics.removeValue(forKey: characteristicArgs.hashCodeArgs) else {
                throw MyError.illegalArgument
            }
            mCharacteristicsArgs.removeValue(forKey: characteristic.hash)
        }
        guard let service = mServices.removeValue(forKey: serviceArgs.hashCodeArgs) else {
            throw MyError.illegalArgument
        }
        mServicesArgs.removeValue(forKey: service.hash)
    }
}
