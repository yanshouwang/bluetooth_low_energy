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
    private let mAPI: MyCentralManagerFlutterAPI
    private let mCentralManager: CBCentralManager
    
    private lazy var mCentralManagerDelegate = MyCentralManagerDelegate(centralManager: self)
    private lazy var peripheralDelegate = MyPeripheralDelegate(centralManager: self)
    
    private var mPeripherals: [String: CBPeripheral]
    private var mServices: [String: [Int64: CBService]]
    private var mCharacteristics: [String: [Int64: CBCharacteristic]]
    private var mDescriptors: [String: [Int64: CBDescriptor]]
    
    private var mConnectCompletions: [String: (Result<Void, Error>) -> Void]
    private var mDisconnectCompletions: [String: (Result<Void, Error>) -> Void]
    private var mReadRSSICompletions: [String: (Result<Int64, Error>) -> Void]
    private var mDiscoverServicesCompletions: [String: (Result<[MyGATTServiceArgs], Error>) -> Void]
    private var mDiscoverIncludedServicesCompletions: [String: [Int64: (Result<[MyGATTServiceArgs], Error>) -> Void]]
    private var mDiscoverCharacteristicsCompletions: [String: [Int64: (Result<[MyGATTCharacteristicArgs], Error>) -> Void]]
    private var mDiscoverDescriptorsCompletions: [String: [Int64: (Result<[MyGATTDescriptorArgs], Error>) -> Void]]
    private var mReadCharacteristicCompletions: [String: [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]]
    private var mWriteCharacteristicCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    private var mSetCharacteristicNotifyStateCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    private var mReadDescriptorCompletions: [String: [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]]
    private var mWriteDescriptorCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    
    init(messenger: FlutterBinaryMessenger) {
        mAPI = MyCentralManagerFlutterAPI(binaryMessenger: messenger)
        mCentralManager = CBCentralManager()
        
        mPeripherals = [:]
        mServices = [:]
        mCharacteristics = [:]
        mDescriptors = [:]
        
        mConnectCompletions = [:]
        mDisconnectCompletions = [:]
        mReadRSSICompletions = [:]
        mDiscoverServicesCompletions = [:]
        mDiscoverIncludedServicesCompletions = [:]
        mDiscoverCharacteristicsCompletions = [:]
        mDiscoverDescriptorsCompletions = [:]
        mReadCharacteristicCompletions = [:]
        mWriteCharacteristicCompletions = [:]
        mSetCharacteristicNotifyStateCompletions = [:]
        mReadDescriptorCompletions = [:]
        mWriteDescriptorCompletions = [:]
    }
    
    func initialize() throws {
        if(mCentralManager.isScanning) {
            mCentralManager.stopScan()
        }
        
        for peripheral in mPeripherals.values {
            if peripheral.state != .disconnected {
                mCentralManager.cancelPeripheralConnection(peripheral)
            }
        }
        
        mPeripherals.removeAll()
        mServices.removeAll()
        mCharacteristics.removeAll()
        mDescriptors.removeAll()
        
        mConnectCompletions.removeAll()
        mDisconnectCompletions.removeAll()
        mReadRSSICompletions.removeAll()
        mDiscoverServicesCompletions.removeAll()
        mDiscoverIncludedServicesCompletions.removeAll()
        mDiscoverCharacteristicsCompletions.removeAll()
        mDiscoverDescriptorsCompletions.removeAll()
        mReadCharacteristicCompletions.removeAll()
        mWriteCharacteristicCompletions.removeAll()
        mSetCharacteristicNotifyStateCompletions.removeAll()
        mReadDescriptorCompletions.removeAll()
        mWriteDescriptorCompletions.removeAll()
        
        if mCentralManager.delegate == nil {
            mCentralManager.delegate = mCentralManagerDelegate
        }
        didUpdateState(central: mCentralManager)
    }
    
    func startDiscovery(serviceUUIDsArgs: [String]) throws {
        let serviceUUIDs = serviceUUIDsArgs.isEmpty ? nil : serviceUUIDsArgs.map { serviceUUIDArgs in serviceUUIDArgs.toCBUUID() }
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        mCentralManager.scanForPeripherals(withServices: serviceUUIDs, options: options)
    }
    
    func stopDiscovery() throws {
        mCentralManager.stopScan()
    }
    
    func retrieveConnectedPeripherals() throws -> [MyPeripheralArgs] {
        let peripherals = mCentralManager.retrieveConnectedPeripherals(withServices: [])
        let peripheralsArgs = peripherals.map { peripheral in
            let peripheralArgs = peripheral.toArgs()
            let uuidArgs = peripheralArgs.uuidArgs
            if peripheral.delegate == nil {
                peripheral.delegate = peripheralDelegate
            }
            self.mPeripherals[uuidArgs] = peripheral
            return peripheralArgs
        }
        return peripheralsArgs
    }
    
    func connect(uuidArgs: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            mCentralManager.connect(peripheral)
            mConnectCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func disconnect(uuidArgs: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            mCentralManager.cancelPeripheralConnection(peripheral)
            mDisconnectCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func getMaximumWriteLength(uuidArgs: String, typeArgs: MyGATTCharacteristicWriteTypeArgs) throws -> Int64 {
        let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
        let type = typeArgs.toWriteType()
        let maximumWriteLength = peripheral.maximumWriteValueLength(for: type)
        let maximumWriteLengthArgs = maximumWriteLength.toInt64()
        return maximumWriteLengthArgs
    }
    
    func readRSSI(uuidArgs: String, completion: @escaping (Result<Int64, Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            peripheral.readRSSI()
            mReadRSSICompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverServices(uuidArgs: String, completion: @escaping (Result<[MyGATTServiceArgs], Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            peripheral.discoverServices(nil)
            mDiscoverServicesCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverIncludedServices(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[MyGATTServiceArgs], Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            let service = try retrieveService(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.discoverIncludedServices(nil, for: service)
            mDiscoverIncludedServicesCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverCharacteristics(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[MyGATTCharacteristicArgs], Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            let service = try retrieveService(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.discoverCharacteristics(nil, for: service)
            mDiscoverCharacteristicsCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverDescriptors(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[MyGATTDescriptorArgs], Error>) -> Void){
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            let characteristic = try retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.discoverDescriptors(for: characteristic)
            mDiscoverDescriptorsCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readCharacteristic(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            let characteristic = try retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.readValue(for: characteristic)
            mReadCharacteristicCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeCharacteristic(uuidArgs: String, hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, typeArgs: MyGATTCharacteristicWriteTypeArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            let characteristic = try retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            let data = valueArgs.data
            let type = typeArgs.toWriteType()
            peripheral.writeValue(data, for: characteristic, type: type)
            if type == .withResponse {
                mWriteCharacteristicCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
            } else {
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func setCharacteristicNotifyState(uuidArgs: String, hashCodeArgs: Int64, stateArgs: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            let characteristic = try retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            let enabled = stateArgs
            peripheral.setNotifyValue(enabled, for: characteristic)
            mSetCharacteristicNotifyStateCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readDescriptor(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            let descriptor = try retrieveDescriptor(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.readValue(for: descriptor)
            mReadDescriptorCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeDescriptor(uuidArgs: String, hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try retrievePeripheral(uuidArgs: uuidArgs)
            let descriptor = try retrieveDescriptor(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            let data = valueArgs.data
            peripheral.writeValue(data, for: descriptor)
            mWriteDescriptorCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func didUpdateState(central: CBCentralManager) {
        let state = central.state
        let stateArgs = state.toArgs()
        mAPI.onStateChanged(stateArgs: stateArgs) { _ in }
    }
    
    func didDiscover(central: CBCentralManager, peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        let rssiArgs = rssi.int64Value
        let advertisementArgs = advertisementData.toAdvertisementArgs()
        if peripheral.delegate == nil {
            peripheral.delegate = peripheralDelegate
        }
        mPeripherals[uuidArgs] = peripheral
        mAPI.onDiscovered(peripheralArgs: peripheralArgs, rssiArgs: rssiArgs, advertisementArgs: advertisementArgs) {_ in }
    }
    
    func didConnect(central: CBCentralManager, peripheral: CBPeripheral) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        let stateArgs = MyConnectionStateArgs.connected
        mAPI.onConnectionStateChanged(peripheralArgs: peripheralArgs, stateArgs: stateArgs) { _ in }
        guard let completion = mConnectCompletions.removeValue(forKey: uuidArgs) else {
            return
        }
        completion(.success(()))
    }
    
    func didFailToConnect(central: CBCentralManager, peripheral: CBPeripheral, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        guard let completion = mConnectCompletions.removeValue(forKey: uuidArgs) else {
            return
        }
        completion(.failure(error ?? MyError.unknown))
    }
    
    func didDisconnectPeripheral(central: CBCentralManager, peripheral: CBPeripheral, error: Error?) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        mServices.removeValue(forKey: uuidArgs)
        mCharacteristics.removeValue(forKey: uuidArgs)
        mDescriptors.removeValue(forKey: uuidArgs)
        let errorNotNil = error ?? MyError.unknown
        let readRssiCompletion = mReadRSSICompletions.removeValue(forKey: uuidArgs)
        readRssiCompletion?(.failure(errorNotNil))
        let discoverServicesCompletion = mDiscoverServicesCompletions.removeValue(forKey: uuidArgs)
        discoverServicesCompletion?(.failure(errorNotNil))
        let discoverIncludedServicesCompletions = self.mDiscoverIncludedServicesCompletions.removeValue(forKey: uuidArgs)
        if discoverIncludedServicesCompletions != nil {
            let completions = discoverIncludedServicesCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let discoverCharacteristicsCompletions = self.mDiscoverCharacteristicsCompletions.removeValue(forKey: uuidArgs)
        if discoverCharacteristicsCompletions != nil {
            let completions = discoverCharacteristicsCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let discoverDescriptorsCompletions = self.mDiscoverDescriptorsCompletions.removeValue(forKey: uuidArgs)
        if discoverDescriptorsCompletions != nil {
            let completions = discoverDescriptorsCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let readCharacteristicCompletions = self.mReadCharacteristicCompletions.removeValue(forKey: uuidArgs)
        if readCharacteristicCompletions != nil {
            let completions = readCharacteristicCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let writeCharacteristicCompletions = self.mWriteCharacteristicCompletions.removeValue(forKey: uuidArgs)
        if writeCharacteristicCompletions != nil {
            let completions = writeCharacteristicCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let notifyCharacteristicCompletions = self.mSetCharacteristicNotifyStateCompletions.removeValue(forKey: uuidArgs)
        if notifyCharacteristicCompletions != nil {
            let completions = notifyCharacteristicCompletions!.values
            for completioin in completions {
                completioin(.failure(errorNotNil))
            }
        }
        let readDescriptorCompletions = self.mReadDescriptorCompletions.removeValue(forKey: uuidArgs)
        if readDescriptorCompletions != nil {
            let completions = readDescriptorCompletions!.values
            for completioin in completions {
                completioin(.failure(errorNotNil))
            }
        }
        let writeDescriptorCompletions = self.mWriteDescriptorCompletions.removeValue(forKey: uuidArgs)
        if writeDescriptorCompletions != nil {
            let completions = writeDescriptorCompletions!.values
            for completion in completions {
                completion(.failure(errorNotNil))
            }
        }
        let stateArgs = MyConnectionStateArgs.disconnected
        mAPI.onConnectionStateChanged(peripheralArgs: peripheralArgs, stateArgs: stateArgs) { _ in }
        guard let completion = mDisconnectCompletions.removeValue(forKey: uuidArgs) else {
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
        guard let completion = mReadRSSICompletions.removeValue(forKey: uuidArgs) else {
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
        guard let completion = mDiscoverServicesCompletions.removeValue(forKey: uuidArgs) else {
            return
        }
        if error == nil {
            let services = peripheral.services ?? []
            var servicesArgs = [MyGATTServiceArgs]()
            for service in services {
                let serviceArgs = service.toArgs()
                self.mServices[uuidArgs, default: [:]][serviceArgs.hashCodeArgs] = service
                servicesArgs.append(serviceArgs)
            }
            completion(.success(servicesArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverIncludedServices(peripheral: CBPeripheral, service: CBService, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = service.hash.toInt64()
        guard let completion = mDiscoverIncludedServicesCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            let includedServices = service.includedServices ?? []
            var includedServicesArgs = [MyGATTServiceArgs]()
            for includedService in includedServices {
                let includedServiceArgs = includedService.toArgs()
                self.mServices[uuidArgs, default: [:]][includedServiceArgs.hashCodeArgs] = includedService
                includedServicesArgs.append(includedServiceArgs)
            }
            completion(.success(includedServicesArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverCharacteristics(peripheral: CBPeripheral, service: CBService, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = service.hash.toInt64()
        guard let completion = mDiscoverCharacteristicsCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            let characteristics = service.characteristics ?? []
            var characteristicsArgs = [MyGATTCharacteristicArgs]()
            for characteristic in characteristics {
                let characteristicArgs = characteristic.toArgs()
                self.mCharacteristics[uuidArgs, default: [:]][characteristicArgs.hashCodeArgs] = characteristic
                characteristicsArgs.append(characteristicArgs)
            }
            completion(.success(characteristicsArgs))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverDescriptors(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = characteristic.hash.toInt64()
        guard let completion = mDiscoverDescriptorsCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            let descriptors = characteristic.descriptors ?? []
            var descriptorsArgs = [MyGATTDescriptorArgs]()
            for descriptor in descriptors {
                let descriptorArgs = descriptor.toArgs()
                self.mDescriptors[uuidArgs, default: [:]][descriptorArgs.hashCodeArgs] = descriptor
                descriptorsArgs.append(descriptorArgs)
            }
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
        guard let completion = mReadCharacteristicCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            mAPI.onCharacteristicNotified(peripheralArgs: peripheralArgs, characteristicArgs: characteristicArgs, valueArgs: valueArgs) { _ in }
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
        guard let completion = mWriteCharacteristicCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
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
        guard let completion = mSetCharacteristicNotifyStateCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
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
        guard let completion = mReadDescriptorCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
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
        guard let completion = mWriteDescriptorCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            return
        }
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
        }
    }
    
    private func retrievePeripheral(uuidArgs: String) throws -> CBPeripheral {
        guard let peripheral = mPeripherals[uuidArgs] else {
            throw MyError.illegalArgument
        }
        return peripheral
    }
    
    private func retrieveService(uuidArgs: String, hashCodeArgs: Int64) throws -> CBService {
        guard let services = self.mServices[uuidArgs] else {
            throw MyError.illegalArgument
        }
        guard let service = services[hashCodeArgs] else {
            throw MyError.illegalArgument
        }
        return service
    }
    
    private func retrieveCharacteristic(uuidArgs: String, hashCodeArgs: Int64) throws -> CBCharacteristic {
        guard let characteristics = self.mCharacteristics[uuidArgs] else {
            throw MyError.illegalArgument
        }
        guard let characteristic = characteristics[hashCodeArgs] else {
            throw MyError.illegalArgument
        }
        return characteristic
    }
    
    private func retrieveDescriptor(uuidArgs: String, hashCodeArgs: Int64) throws -> CBDescriptor {
        guard let descriptors = self.mDescriptors[uuidArgs] else {
            throw MyError.illegalArgument
        }
        guard let descriptor = descriptors[hashCodeArgs] else {
            throw MyError.illegalArgument
        }
        return descriptor
    }
}
