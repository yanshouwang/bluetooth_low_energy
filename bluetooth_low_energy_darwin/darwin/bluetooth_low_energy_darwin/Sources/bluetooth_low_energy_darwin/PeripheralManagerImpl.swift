//
//  PeripheralManagerImpl.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/10/7.
//

import CoreBluetooth
import Foundation

#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

class PeripheralManagerImpl: PeripheralManagerHostApi {
    private let mApi: PeripheralManagerFlutterApi
    
    private lazy var mPeripheralManager = CBPeripheralManager()
    private lazy var mPeripheralManagerDelegate = CBPeripheralManagerDelegateImpl(self)
    
    private var mServicesArgs: [Int: MutableGATTServiceArgs]
    private var mCharacteristicsArgs: [Int: MutableGATTCharacteristicArgs]
    private var mDescriptorsArgs: [Int: MutableGATTDescriptorArgs]
    
    private var mCentrals: [String: CBCentral]
    private var mServices: [Int64: CBMutableService]
    private var mCharacteristics: [Int64: CBMutableCharacteristic]
    private var mDescriptors: [Int64: CBMutableDescriptor]
    private var mRequests: [Int64: CBATTRequest]
    
    private var mAddServiceCompletion: ((Result<Void, Error>) -> Void)?
    private var mStartAdvertisingCompletion: ((Result<Void, Error>) -> Void)?
    
    init(_ messenger: FlutterBinaryMessenger) {
        self.mApi = PeripheralManagerFlutterApi(binaryMessenger: messenger)
        
        self.mServicesArgs = [:]
        self.mCharacteristicsArgs = [:]
        self.mDescriptorsArgs = [:]
        
        self.mCentrals = [:]
        self.mServices = [:]
        self.mCharacteristics = [:]
        self.mDescriptors = [:]
        self.mRequests = [:]
        
        self.mAddServiceCompletion = nil
        self.mStartAdvertisingCompletion = nil
    }
    
    func initialize() throws {
        if self.mPeripheralManager.isAdvertising { self.mPeripheralManager.stopAdvertising() }
        
        self.mServicesArgs.removeAll()
        self.mCharacteristicsArgs.removeAll()
        self.mDescriptorsArgs.removeAll()
        
        self.mCentrals.removeAll()
        self.mServices.removeAll()
        self.mCharacteristics.removeAll()
        self.mDescriptors.removeAll()
        self.mRequests.removeAll()
        
        self.mAddServiceCompletion = nil
        self.mStartAdvertisingCompletion = nil
        
        self.mPeripheralManager.delegate = self.mPeripheralManagerDelegate
    }
    
    func getState() throws -> BluetoothLowEnergyStateArgs {
        let state = self.mPeripheralManager.state
        let stateArgs = state.toArgs()
        return stateArgs
    }
    
    func showAppSettings(completion: @escaping (Result<Void, any Error>) -> Void) {
#if os(iOS)
        do {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { throw BluetoothLowEnergyError.illegalArgument }
            UIApplication.shared.open(url) { success in
                if success { completion(.success(())) }
                else { completion(.failure(BluetoothLowEnergyError.unknown)) }
            }
        } catch {
            completion(.failure(error))
        }
#else
        completion(.failure(BluetoothLowEnergyError.unsupported))
#endif
    }
    
    func addService(serviceArgs: MutableGATTServiceArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let service = try self.addServiceArgs(serviceArgs)
            self.mPeripheralManager.add(service)
            self.mAddServiceCompletion = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeService(hashCodeArgs: Int64) throws {
        guard let service = self.mServices[hashCodeArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        guard let serviceArgs = self.mServicesArgs[service.hash] else { throw BluetoothLowEnergyError.illegalArgument }
        self.mPeripheralManager.remove(service)
        try self.removeServiceArgs(serviceArgs)
    }
    
    func removeAllServices() throws {
        self.mPeripheralManager.removeAllServices()
        
        self.mServices.removeAll()
        self.mCharacteristics.removeAll()
        self.mDescriptors.removeAll()
        
        self.mServicesArgs.removeAll()
        self.mCharacteristicsArgs.removeAll()
        self.mDescriptors.removeAll()
    }
    
    func startAdvertising(advertisementArgs: AdvertisementArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        let advertisement = advertisementArgs.toAdvertisement()
        self.mPeripheralManager.startAdvertising(advertisement)
        self.mStartAdvertisingCompletion = completion
    }
    
    func stopAdvertising() throws {
        self.mPeripheralManager.stopAdvertising()
    }
    
    func getMaximumNotifyLength(uuidArgs: String) throws -> Int64 {
        guard let central = self.mCentrals[uuidArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        let maximumNotifyLength = central.maximumUpdateValueLength
        let maximumNotifyLengthArgs = maximumNotifyLength.toInt64()
        return maximumNotifyLengthArgs
    }
    
    func respond(hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData?, errorArgs: ATTErrorArgs) throws {
        guard let request = self.mRequests.removeValue(forKey: hashCodeArgs) else { throw BluetoothLowEnergyError.illegalArgument }
        if valueArgs != nil { request.value = valueArgs!.data }
        let error = errorArgs.toError()
        self.mPeripheralManager.respond(to: request, withResult: error)
    }
    
    func updateValue(hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, uuidsArgs: [String]?) throws -> Bool {
        let centrals = try uuidsArgs?.map { uuidArgs in
            guard let central = self.mCentrals[uuidArgs] else { throw BluetoothLowEnergyError.illegalArgument }
            return central
        }
        guard let characteristic = self.mCharacteristics[hashCodeArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        let value = valueArgs.data
        let updated = self.mPeripheralManager.updateValue(value, for: characteristic, onSubscribedCentrals: centrals)
        return updated
    }
    
    func didUpdateState(peripheral: CBPeripheralManager) {
        let state = peripheral.state
        let stateArgs = state.toArgs()
        self.mApi.onStateChanged(stateArgs: stateArgs) { _ in }
    }
    
    func didAdd(peripheral: CBPeripheralManager, service: CBService, error: Error?) {
        guard let completion = self.mAddServiceCompletion else { return }
        self.mAddServiceCompletion = nil
        if error == nil { completion(.success(())) }
        else { completion(.failure(error!)) }
    }
    
    func didStartAdvertising(peripheral: CBPeripheralManager, error: Error?) {
        guard let completion = self.mStartAdvertisingCompletion else {
            return
        }
        self.mStartAdvertisingCompletion = nil
        if error == nil { completion(.success(())) }
        else { completion(.failure(error!)) }
    }
    
    func didReceiveRead(peripheral: CBPeripheralManager, request: CBATTRequest) {
        let hashCodeArgs = request.hash.toInt64()
        let central = request.central
        let centralArgs = central.toArgs()
        self.mCentrals[centralArgs.uuidArgs] = central
        let characteristic = request.characteristic
        guard let characteristicArgs = self.mCharacteristicsArgs[characteristic.hash] else {
            self.mPeripheralManager.respond(to: request, withResult: .attributeNotFound)
            return
        }
        let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
        let value = request.value
        let valueArgs = value == nil ? nil : FlutterStandardTypedData(bytes: value!)
        let offsetArgs = request.offset.toInt64()
        let requestArgs = ATTRequestArgs(hashCodeArgs: hashCodeArgs, centralArgs: centralArgs, characteristicHashCodeArgs: characteristicHashCodeArgs, valueArgs: valueArgs, offsetArgs: offsetArgs)
        self.mRequests[hashCodeArgs] = request
        self.mApi.didReceiveRead(requestArgs: requestArgs) { _ in }
    }
    
    func didReceiveWrite(peripheral: CBPeripheralManager, requests: [CBATTRequest]) {
        var requestsArgs = [ATTRequestArgs]()
        for request in requests {
            let hashCodeArgs = request.hash.toInt64()
            let central = request.central
            let centralArgs = central.toArgs()
            self.mCentrals[centralArgs.uuidArgs] = central
            let characteristic = request.characteristic
            guard let characteristicArgs = self.mCharacteristicsArgs[characteristic.hash] else {
                self.mPeripheralManager.respond(to: request, withResult: .attributeNotFound)
                return
            }
            let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            let value = request.value
            let valueArgs = value == nil ? nil : FlutterStandardTypedData(bytes: value!)
            let offsetArgs = request.offset.toInt64()
            let requestArgs = ATTRequestArgs(hashCodeArgs: hashCodeArgs, centralArgs: centralArgs, characteristicHashCodeArgs: characteristicHashCodeArgs, valueArgs: valueArgs, offsetArgs: offsetArgs)
            requestsArgs.append(requestArgs)
        }
        guard let request = requests.first else { return }
        guard let requestArgs = requestsArgs.first else { return }
        self.mRequests[requestArgs.hashCodeArgs] = request
        self.mApi.didReceiveWrite(requestsArgs: requestsArgs) { _ in }
    }
    
    func didSubscribeTo(peripheral: CBPeripheralManager, central: CBCentral, characteristic: CBCharacteristic) {
        let centralArgs = central.toArgs()
        self.mCentrals[centralArgs.uuidArgs] = central
        let hashCode = characteristic.hash
        guard let characteristicArgs = self.mCharacteristicsArgs[hashCode] else { return }
        let hashCodeArgs = characteristicArgs.hashCodeArgs
        let stateArgs = true
        self.mApi.onCharacteristicNotifyStateChanged(centralArgs: centralArgs, hashCodeArgs: hashCodeArgs, stateArgs: stateArgs) { _ in }
    }
    
    func didUnsubscribeFrom(peripheral: CBPeripheralManager, central: CBCentral, characteristic: CBCharacteristic) {
        let centralArgs = central.toArgs()
        self.mCentrals[centralArgs.uuidArgs] = central
        let hashCode = characteristic.hash
        guard let characteristicArgs = self.mCharacteristicsArgs[hashCode] else { return }
        let hashCodeArgs = characteristicArgs.hashCodeArgs
        let stateArgs = false
        self.mApi.onCharacteristicNotifyStateChanged(centralArgs: centralArgs, hashCodeArgs: hashCodeArgs, stateArgs: stateArgs) { _ in }
    }
    
    func isReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        self.mApi.isReady { _ in }
    }
    
    private func addServiceArgs(_ serviceArgs: MutableGATTServiceArgs) throws -> CBMutableService {
        let service = serviceArgs.toService()
        self.mServicesArgs[service.hash] = serviceArgs
        self.mServices[serviceArgs.hashCodeArgs] = service
        var includedServices = [CBService]()
        let includedServicesArgs = serviceArgs.includedServicesArgs
        for includedServiceArgs in includedServicesArgs {
            let includedService = try addServiceArgs(includedServiceArgs)
            self.mServicesArgs[includedService.hash] = includedServiceArgs
            self.mServices[includedServiceArgs.hashCodeArgs] = includedService
            includedServices.append(includedService)
        }
        service.includedServices = includedServices
        var characteristics = [CBMutableCharacteristic]()
        let characteristicsArgs = serviceArgs.characteristicsArgs
        for characteristicArgs in characteristicsArgs {
            let characteristic = characteristicArgs.toCharacteristic()
            self.mCharacteristicsArgs[characteristic.hash] = characteristicArgs
            self.mCharacteristics[characteristicArgs.hashCodeArgs] = characteristic
            characteristics.append(characteristic)
            var descriptors = [CBMutableDescriptor]()
            let descriptorsArgs = characteristicArgs.descriptorsArgs
            for descriptorArgs in descriptorsArgs {
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
    
    private func removeServiceArgs(_ serviceArgs: MutableGATTServiceArgs) throws {
        for includedServiceArgs in serviceArgs.includedServicesArgs {
            try self.removeServiceArgs(includedServiceArgs)
        }
        for characteristicArgs in serviceArgs.characteristicsArgs {
            for descriptorArgs in characteristicArgs.descriptorsArgs {
                guard let descriptor = self.mDescriptors.removeValue(forKey: descriptorArgs.hashCodeArgs) else { throw BluetoothLowEnergyError.illegalArgument }
                self.mDescriptorsArgs.removeValue(forKey: descriptor.hash)
            }
            guard let characteristic = self.mCharacteristics.removeValue(forKey: characteristicArgs.hashCodeArgs) else { throw BluetoothLowEnergyError.illegalArgument }
            self.mCharacteristicsArgs.removeValue(forKey: characteristic.hash)
        }
        guard let service = self.mServices.removeValue(forKey: serviceArgs.hashCodeArgs) else { throw BluetoothLowEnergyError.illegalArgument }
        self.mServicesArgs.removeValue(forKey: service.hash)
    }
}
