//
//  CentralManagerImpl.swift
//  bluetooth_low_energy_darwin
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

class CentralManagerImpl: CentralManagerHostApi {
    private let mApi: CentralManagerFlutterApi
    
    private lazy var mCentralManager = CBCentralManager()
    private lazy var mCentralManagerDelegate = CBCentralManagerDelegateImpl(self)
    private lazy var mPeripheralDelegate = CBPeripheralDelegateImpl(self)
    
    private var mPeripherals: [String: CBPeripheral]
    private var mServices: [String: [Int64: CBService]]
    private var mCharacteristics: [String: [Int64: CBCharacteristic]]
    private var mDescriptors: [String: [Int64: CBDescriptor]]
    
    private var mConnectCompletions: [String: (Result<Void, Error>) -> Void]
    private var mDisconnectCompletions: [String: (Result<Void, Error>) -> Void]
    private var mReadRSSICompletions: [String: (Result<Int64, Error>) -> Void]
    private var mDiscoverServicesCompletions: [String: (Result<[GATTServiceArgs], Error>) -> Void]
    private var mDiscoverIncludedServicesCompletions: [String: [Int64: (Result<[GATTServiceArgs], Error>) -> Void]]
    private var mDiscoverCharacteristicsCompletions: [String: [Int64: (Result<[GATTCharacteristicArgs], Error>) -> Void]]
    private var mDiscoverDescriptorsCompletions: [String: [Int64: (Result<[GATTDescriptorArgs], Error>) -> Void]]
    private var mReadCharacteristicCompletions: [String: [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]]
    private var mWriteCharacteristicCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    private var mSetCharacteristicNotifyStateCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    private var mReadDescriptorCompletions: [String: [Int64: (Result<FlutterStandardTypedData, Error>) -> Void]]
    private var mWriteDescriptorCompletions: [String: [Int64: (Result<Void, Error>) -> Void]]
    
    init(_ messenger: FlutterBinaryMessenger) {
        self.mApi = CentralManagerFlutterApi(binaryMessenger: messenger)
        
        self.mPeripherals = [:]
        self.mServices = [:]
        self.mCharacteristics = [:]
        self.mDescriptors = [:]
        
        self.mConnectCompletions = [:]
        self.mDisconnectCompletions = [:]
        self.mReadRSSICompletions = [:]
        self.mDiscoverServicesCompletions = [:]
        self.mDiscoverIncludedServicesCompletions = [:]
        self.mDiscoverCharacteristicsCompletions = [:]
        self.mDiscoverDescriptorsCompletions = [:]
        self.mReadCharacteristicCompletions = [:]
        self.mWriteCharacteristicCompletions = [:]
        self.mSetCharacteristicNotifyStateCompletions = [:]
        self.mReadDescriptorCompletions = [:]
        self.mWriteDescriptorCompletions = [:]
    }
    
    func initialize() throws {
        if(self.mCentralManager.isScanning) { self.mCentralManager.stopScan() }
        
        for peripheral in self.mPeripherals.values {
            if peripheral.state != .disconnected { self.mCentralManager.cancelPeripheralConnection(peripheral) }
        }
        
        self.mPeripherals.removeAll()
        self.mServices.removeAll()
        self.mCharacteristics.removeAll()
        self.mDescriptors.removeAll()
        
        self.mConnectCompletions.removeAll()
        self.mDisconnectCompletions.removeAll()
        self.mReadRSSICompletions.removeAll()
        self.mDiscoverServicesCompletions.removeAll()
        self.mDiscoverIncludedServicesCompletions.removeAll()
        self.mDiscoverCharacteristicsCompletions.removeAll()
        self.mDiscoverDescriptorsCompletions.removeAll()
        self.mReadCharacteristicCompletions.removeAll()
        self.mWriteCharacteristicCompletions.removeAll()
        self.mSetCharacteristicNotifyStateCompletions.removeAll()
        self.mReadDescriptorCompletions.removeAll()
        self.mWriteDescriptorCompletions.removeAll()
        
        self.mCentralManager.delegate = self.mCentralManagerDelegate
    }
    
    func getState() throws -> BluetoothLowEnergyStateArgs {
        let state = self.mCentralManager.state
        let stateArgs = state.toArgs()
        return stateArgs
    }
    
    func showAppSettings(completion: @escaping (Result<Void, any Error>) -> Void) {
#if os(iOS)
        do {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { throw BluetoothLowEnergyError.illegalArgument }
            UIApplication.shared.open(url) { success in
                if (success) { completion(.success(())) }
                else { completion(.failure(BluetoothLowEnergyError.unknown)) }
            }
        } catch {
            completion(.failure(error))
        }
#else
        completion(.failure(BluetoothLowEnergyError.unsupported))
#endif
    }
    
    func startDiscovery(serviceUUIDsArgs: [String]) throws {
        let serviceUUIDs = serviceUUIDsArgs.isEmpty ? nil : serviceUUIDsArgs.map { serviceUUIDArgs in serviceUUIDArgs.toCBUUID() }
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        self.mCentralManager.scanForPeripherals(withServices: serviceUUIDs, options: options)
    }
    
    func stopDiscovery() throws {
        self.mCentralManager.stopScan()
    }
    
    func retrieveConnectedPeripherals() throws -> [PeripheralArgs] {
        let peripherals = self.mCentralManager.retrieveConnectedPeripherals(withServices: [])
        let peripheralsArgs = peripherals.map { peripheral in
            let peripheralArgs = peripheral.toArgs()
            let uuidArgs = peripheralArgs.uuidArgs
            if peripheral.delegate == nil { peripheral.delegate = self.mPeripheralDelegate }
            self.mPeripherals[uuidArgs] = peripheral
            return peripheralArgs
        }
        return peripheralsArgs
    }
    
    func connect(uuidArgs: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            self.mCentralManager.connect(peripheral)
            self.mConnectCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func disconnect(uuidArgs: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            self.mCentralManager.cancelPeripheralConnection(peripheral)
            self.mDisconnectCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func getMaximumWriteLength(uuidArgs: String, typeArgs: GATTCharacteristicWriteTypeArgs) throws -> Int64 {
        let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
        let type = typeArgs.toWriteType()
        let maximumWriteLength = peripheral.maximumWriteValueLength(for: type)
        let maximumWriteLengthArgs = maximumWriteLength.toInt64()
        return maximumWriteLengthArgs
    }
    
    func readRSSI(uuidArgs: String, completion: @escaping (Result<Int64, Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            peripheral.readRSSI()
            self.mReadRSSICompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverServices(uuidArgs: String, completion: @escaping (Result<[GATTServiceArgs], Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            peripheral.discoverServices(nil)
            self.mDiscoverServicesCompletions[uuidArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverIncludedServices(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[GATTServiceArgs], Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            let service = try self.retrieveService(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.discoverIncludedServices(nil, for: service)
            self.mDiscoverIncludedServicesCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverCharacteristics(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[GATTCharacteristicArgs], Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            let service = try self.retrieveService(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.discoverCharacteristics(nil, for: service)
            self.mDiscoverCharacteristicsCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func discoverDescriptors(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<[GATTDescriptorArgs], Error>) -> Void){
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            let characteristic = try self.retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.discoverDescriptors(for: characteristic)
            self.mDiscoverDescriptorsCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readCharacteristic(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            let characteristic = try self.retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.readValue(for: characteristic)
            self.mReadCharacteristicCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeCharacteristic(uuidArgs: String, hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, typeArgs: GATTCharacteristicWriteTypeArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            let characteristic = try self.retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            let data = valueArgs.data
            let type = typeArgs.toWriteType()
            peripheral.writeValue(data, for: characteristic, type: type)
            if type == .withResponse { self.mWriteCharacteristicCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion }
            else { completion(.success(())) }
        } catch {
            completion(.failure(error))
        }
    }
    
    func setCharacteristicNotifyState(uuidArgs: String, hashCodeArgs: Int64, stateArgs: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            let characteristic = try self.retrieveCharacteristic(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            let enabled = stateArgs
            peripheral.setNotifyValue(enabled, for: characteristic)
            self.mSetCharacteristicNotifyStateCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func readDescriptor(uuidArgs: String, hashCodeArgs: Int64, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            let descriptor = try self.retrieveDescriptor(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            peripheral.readValue(for: descriptor)
            self.mReadDescriptorCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeDescriptor(uuidArgs: String, hashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let peripheral = try self.retrievePeripheral(uuidArgs: uuidArgs)
            let descriptor = try self.retrieveDescriptor(uuidArgs: uuidArgs, hashCodeArgs: hashCodeArgs)
            let data = valueArgs.data
            peripheral.writeValue(data, for: descriptor)
            self.mWriteDescriptorCompletions[uuidArgs, default: [:]][hashCodeArgs] = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func didUpdateState(central: CBCentralManager) {
        let state = central.state
        let stateArgs = state.toArgs()
        self.mApi.onStateChanged(stateArgs: stateArgs) { _ in }
    }
    
    func didDiscover(central: CBCentralManager, peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        let rssiArgs = rssi.int64Value
        let advertisementArgs = advertisementData.toAdvertisementArgs()
        if peripheral.delegate == nil { peripheral.delegate = self.mPeripheralDelegate }
        self.mPeripherals[uuidArgs] = peripheral
        self.mApi.onDiscovered(peripheralArgs: peripheralArgs, rssiArgs: rssiArgs, advertisementArgs: advertisementArgs) {_ in }
    }
    
    func didConnect(central: CBCentralManager, peripheral: CBPeripheral) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        let stateArgs = ConnectionStateArgs.connected
        self.mApi.onConnectionStateChanged(peripheralArgs: peripheralArgs, stateArgs: stateArgs) { _ in }
        guard let completion = self.mConnectCompletions.removeValue(forKey: uuidArgs) else { return }
        completion(.success(()))
    }
    
    func didFailToConnect(central: CBCentralManager, peripheral: CBPeripheral, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        guard let completion = self.mConnectCompletions.removeValue(forKey: uuidArgs) else { return }
        completion(.failure(error ?? BluetoothLowEnergyError.unknown))
    }
    
    func didDisconnectPeripheral(central: CBCentralManager, peripheral: CBPeripheral, error: Error?) {
        let peripheralArgs = peripheral.toArgs()
        let uuidArgs = peripheralArgs.uuidArgs
        self.mServices.removeValue(forKey: uuidArgs)
        self.mCharacteristics.removeValue(forKey: uuidArgs)
        self.mDescriptors.removeValue(forKey: uuidArgs)
        let errorNotNil = error ?? BluetoothLowEnergyError.unknown
        let readRssiCompletion = self.mReadRSSICompletions.removeValue(forKey: uuidArgs)
        readRssiCompletion?(.failure(errorNotNil))
        let discoverServicesCompletion = self.mDiscoverServicesCompletions.removeValue(forKey: uuidArgs)
        discoverServicesCompletion?(.failure(errorNotNil))
        let discoverIncludedServicesCompletions = self.mDiscoverIncludedServicesCompletions.removeValue(forKey: uuidArgs)
        if discoverIncludedServicesCompletions != nil {
            let completions = discoverIncludedServicesCompletions!.values
            for completion in completions { completion(.failure(errorNotNil)) }
        }
        let discoverCharacteristicsCompletions = self.mDiscoverCharacteristicsCompletions.removeValue(forKey: uuidArgs)
        if discoverCharacteristicsCompletions != nil {
            let completions = discoverCharacteristicsCompletions!.values
            for completion in completions { completion(.failure(errorNotNil)) }
        }
        let discoverDescriptorsCompletions = self.mDiscoverDescriptorsCompletions.removeValue(forKey: uuidArgs)
        if discoverDescriptorsCompletions != nil {
            let completions = discoverDescriptorsCompletions!.values
            for completion in completions { completion(.failure(errorNotNil)) }
        }
        let readCharacteristicCompletions = self.mReadCharacteristicCompletions.removeValue(forKey: uuidArgs)
        if readCharacteristicCompletions != nil {
            let completions = readCharacteristicCompletions!.values
            for completion in completions { completion(.failure(errorNotNil)) }
        }
        let writeCharacteristicCompletions = self.mWriteCharacteristicCompletions.removeValue(forKey: uuidArgs)
        if writeCharacteristicCompletions != nil {
            let completions = writeCharacteristicCompletions!.values
            for completion in completions { completion(.failure(errorNotNil)) }
        }
        let notifyCharacteristicCompletions = self.mSetCharacteristicNotifyStateCompletions.removeValue(forKey: uuidArgs)
        if notifyCharacteristicCompletions != nil {
            let completions = notifyCharacteristicCompletions!.values
            for completioin in completions { completioin(.failure(errorNotNil)) }
        }
        let readDescriptorCompletions = self.mReadDescriptorCompletions.removeValue(forKey: uuidArgs)
        if readDescriptorCompletions != nil {
            let completions = readDescriptorCompletions!.values
            for completioin in completions { completioin(.failure(errorNotNil)) }
        }
        let writeDescriptorCompletions = self.mWriteDescriptorCompletions.removeValue(forKey: uuidArgs)
        if writeDescriptorCompletions != nil {
            let completions = writeDescriptorCompletions!.values
            for completion in completions { completion(.failure(errorNotNil)) }
        }
        let stateArgs = ConnectionStateArgs.disconnected
        self.mApi.onConnectionStateChanged(peripheralArgs: peripheralArgs, stateArgs: stateArgs) { _ in }
        guard let completion = self.mDisconnectCompletions.removeValue(forKey: uuidArgs) else { return }
        if error == nil { completion(.success(())) }
        else { completion(.failure(error!)) }
    }
    
    func didReadRSSI(peripheral: CBPeripheral, rssi: NSNumber, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        guard let completion = self.mReadRSSICompletions.removeValue(forKey: uuidArgs) else { return }
        if error == nil {
            let rssiArgs = rssi.int64Value
            completion(.success((rssiArgs)))
        } else {
            completion(.failure(error!))
        }
    }
    
    func didDiscoverServices(peripheral: CBPeripheral, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        guard let completion = self.mDiscoverServicesCompletions.removeValue(forKey: uuidArgs) else { return }
        if error == nil {
            let services = peripheral.services ?? []
            var servicesArgs = [GATTServiceArgs]()
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
        guard let completion = self.mDiscoverIncludedServicesCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else { return }
        if error == nil {
            let includedServices = service.includedServices ?? []
            var includedServicesArgs = [GATTServiceArgs]()
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
        guard let completion = self.mDiscoverCharacteristicsCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else { return }
        if error == nil {
            let characteristics = service.characteristics ?? []
            var characteristicsArgs = [GATTCharacteristicArgs]()
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
        guard let completion = self.mDiscoverDescriptorsCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else { return }
        if error == nil {
            let descriptors = characteristic.descriptors ?? []
            var descriptorsArgs = [GATTDescriptorArgs]()
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
        guard let completion = self.mReadCharacteristicCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else {
            self.mApi.onCharacteristicNotified(peripheralArgs: peripheralArgs, characteristicArgs: characteristicArgs, valueArgs: valueArgs) { _ in }
            return
        }
        if error == nil { completion(.success(valueArgs)) }
        else { completion(.failure(error!)) }
    }
    
    func didWriteCharacteristicValue(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = characteristic.hash.toInt64()
        guard let completion = self.mWriteCharacteristicCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else { return }
        if error == nil { completion(.success(())) }
        else { completion(.failure(error!)) }
    }
    
    func didUpdateCharacteristicNotificationState(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = characteristic.hash.toInt64()
        guard let completion = self.mSetCharacteristicNotifyStateCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else { return }
        if error == nil { completion(.success(())) }
        else { completion(.failure(error!)) }
    }
    
    func didUpdateDescriptorValue(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?) {
        let uuidArgs = peripheral.identifier.toArgs()
        let hashCodeArgs = descriptor.hash.toInt64()
        guard let completion = self.mReadDescriptorCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else { return }
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
        guard let completion = self.mWriteDescriptorCompletions[uuidArgs]?.removeValue(forKey: hashCodeArgs) else { return }
        if error == nil { completion(.success(())) }
        else { completion(.failure(error!)) }
    }
    
    private func retrievePeripheral(uuidArgs: String) throws -> CBPeripheral {
        guard let peripheral = self.mPeripherals[uuidArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        return peripheral
    }
    
    private func retrieveService(uuidArgs: String, hashCodeArgs: Int64) throws -> CBService {
        guard let services = self.mServices[uuidArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        guard let service = services[hashCodeArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        return service
    }
    
    private func retrieveCharacteristic(uuidArgs: String, hashCodeArgs: Int64) throws -> CBCharacteristic {
        guard let characteristics = self.mCharacteristics[uuidArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        guard let characteristic = characteristics[hashCodeArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        return characteristic
    }
    
    private func retrieveDescriptor(uuidArgs: String, hashCodeArgs: Int64) throws -> CBDescriptor {
        guard let descriptors = self.mDescriptors[uuidArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        guard let descriptor = descriptors[hashCodeArgs] else { throw BluetoothLowEnergyError.illegalArgument }
        return descriptor
    }
}
