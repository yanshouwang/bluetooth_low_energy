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

class MyPeripheralManager: MyPeripheralManagerHostApi {
    init(_ binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }
    
    private let binaryMessenger: FlutterBinaryMessenger
    private let peripheralManager = CBPeripheralManager()
    
    private lazy var api = MyPeripheralManagerFlutterApi(binaryMessenger: binaryMessenger)
    private lazy var peripheralManagerDelegate = MyPeripheralManagerDelegate(self)
    
    private var centrals = [Int64: CBCentral]()
    private var services = [Int64: CBMutableService]()
    private var characteristics = [Int64: CBMutableCharacteristic]()
    private var descriptors = [Int64: CBMutableDescriptor]()
    private var requests = [Int64: CBATTRequest]()
    
    private var centralsArgs = [Int: MyCentralArgs]()
    private var servicesArgs = [Int: MyGattServiceArgs]()
    private var characteristicsArgs = [Int: MyGattCharacteristicArgs]()
    private var descriptorsArgs = [Int: MyGattDescriptorArgs]()
    
    private var setUpCompletion: ((Result<MyPeripheralManagerArgs, Error>) -> Void)?
    private var addServiceCompletion: ((Result<Void, Error>) -> Void)?
    private var startAdvertisingCompletion: ((Result<Void, Error>) -> Void)?
    private var notifyCharacteristicValueChangedCallbacks = [() -> Void]()
    
    func setUp(completion: @escaping (Result<MyPeripheralManagerArgs, Error>) -> Void) {
        do {
            if setUpCompletion != nil {
                throw MyError.illegalState
            }
            try tearDown()
            peripheralManager.delegate = peripheralManagerDelegate
            if peripheralManager.state == .unknown {
                setUpCompletion = completion
            } else {
                let stateArgs = peripheralManager.state.toArgs()
                let stateNumberArgs = Int64(stateArgs.rawValue)
                let args = MyPeripheralManagerArgs(stateNumberArgs: stateNumberArgs)
                completion(.success(args))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func tearDown() throws {
        if(peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        centrals.removeAll()
        services.removeAll()
        characteristics.removeAll()
        descriptors.removeAll()
        requests.removeAll()
        centralsArgs.removeAll()
        servicesArgs.removeAll()
        characteristicsArgs.removeAll()
        descriptorsArgs.removeAll()
        setUpCompletion = nil
        addServiceCompletion = nil
        startAdvertisingCompletion = nil
        notifyCharacteristicValueChangedCallbacks.removeAll()
    }
    
    func addService(serviceArgs: MyGattServiceArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if addServiceCompletion != nil {
                throw MyError.illegalState
            }
            let service = serviceArgs.toService()
            var characteristics = [CBMutableCharacteristic]()
            let characteristicsArgs = serviceArgs.characteristicsArgs
            for args in characteristicsArgs {
                guard let characteristicArgs = args else {
                    continue
                }
                let characteristic = characteristicArgs.toCharacteristic()
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
                    self.descriptorsArgs[descriptorHashCode] = descriptorArgs
                    self.descriptors[descriptorHashCodeArgs] = descriptor
                }
                characteristic.descriptors = descriptors
                characteristics.append(characteristic)
                let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
                let characteristicHashCode = characteristic.hash
                self.characteristicsArgs[characteristicHashCode] = characteristicArgs
                self.characteristics[characteristicHashCodeArgs] = characteristic
            }
            service.characteristics = characteristics
            let serviceHashCodeArgs = serviceArgs.hashCodeArgs
            let serviceHashCode = service.hash
            self.servicesArgs[serviceHashCode] = serviceArgs
            self.services[serviceHashCodeArgs] = service
            peripheralManager.add(service)
            addServiceCompletion = completion
        } catch {
            freeService(serviceArgs)
            completion(.failure(error))
        }
    }
    
    func removeService(serviceHashCodeArgs: Int64) throws {
        guard let service = services[serviceHashCodeArgs] else {
            throw MyError.illegalArgument
        }
        let serviceHashCode = service.hash
        guard let serviceArgs = servicesArgs[serviceHashCode] else {
            throw MyError.illegalArgument
        }
        peripheralManager.remove(service)
        freeService(serviceArgs)
    }
    
    func clearServices() throws {
        peripheralManager.removeAllServices()
        let servicesArgs = self.servicesArgs.values
        for serviceArgs in servicesArgs {
            freeService(serviceArgs)
        }
    }
    
    private func freeService(_ serviceArgs: MyGattServiceArgs) {
        let characteristicsArgs = serviceArgs.characteristicsArgs
        for args in characteristicsArgs {
            guard let characteristicArgs = args else {
                continue
            }
            let descriptorsArgs = characteristicArgs.descriptorsArgs
            for args in descriptorsArgs {
                guard let descriptorArgs = args else {
                    continue
                }
                let descriptorHashCodeArgs = descriptorArgs.hashCodeArgs
                guard let descriptor = self.descriptors.removeValue(forKey: descriptorHashCodeArgs) else {
                    continue
                }
                let descriptorHashCode = descriptor.hash
                self.descriptorsArgs.removeValue(forKey: descriptorHashCode)
            }
            let characteristicHashCodeArgs = characteristicArgs.hashCodeArgs
            guard let characteristic = self.characteristics.removeValue(forKey: characteristicHashCodeArgs) else {
                continue
            }
            let characteristicHashCode = characteristic.hash
            self.characteristicsArgs.removeValue(forKey: characteristicHashCode)
        }
        let serviceHashCodeArgs = serviceArgs.hashCodeArgs
        guard let service = self.services.removeValue(forKey: serviceHashCodeArgs) else {
            return
        }
        let serviceHashCode = service.hash
        self.servicesArgs.removeValue(forKey: serviceHashCode)
    }
    
    func startAdvertising(advertisementArgs: MyAdvertisementArgs, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if startAdvertisingCompletion != nil {
                throw MyError.illegalState
            }
            let advertisement = try advertisementArgs.toAdvertisement()
            peripheralManager.startAdvertising(advertisement)
            startAdvertisingCompletion = completion
        } catch {
            completion(.failure(error))
        }
    }
    
    func stopAdvertising() throws {
        peripheralManager.stopAdvertising()
    }
    
    func getMaximumWriteLength(centralHashCodeArgs: Int64) throws -> Int64 {
        guard let central = centrals[centralHashCodeArgs] else {
            throw MyError.illegalArgument
        }
        let maximumWriteLength = try central.maximumUpdateValueLength.coerceIn(20, 512)
        let maximumWriteLengthArgs = Int64(maximumWriteLength)
        return maximumWriteLengthArgs
    }
    
    func sendReadCharacteristicReply(centralHashCodeArgs: Int64, characteristicHashCodeArgs: Int64, idArgs: Int64, offsetArgs: Int64, statusArgs: Bool, valueArgs: FlutterStandardTypedData) throws {
        guard let request = requests.removeValue(forKey: idArgs) else {
            throw MyError.illegalArgument
        }
        request.value = valueArgs.data
        let result = statusArgs ? CBATTError.Code.success : CBATTError.Code.requestNotSupported
        peripheralManager.respond(to: request, withResult: result)
    }
    
    func sendWriteCharacteristicReply(centralHashCodeArgs: Int64, characteristicHashCodeArgs: Int64, idArgs: Int64, offsetArgs: Int64, statusArgs: Bool) throws {
        guard let request = requests.removeValue(forKey: idArgs) else {
            throw MyError.illegalArgument
        }
        let result = statusArgs ? CBATTError.Code.success : CBATTError.Code.requestNotSupported
        peripheralManager.respond(to: request, withResult: result)
    }
    
    func notifyCharacteristicValueChanged(centralHashCodeArgs: Int64, characteristicHashCodeArgs: Int64, valueArgs: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if notifyCharacteristicValueChangedCallbacks.count > 0 {
                throw MyError.illegalState
            }
            let value = valueArgs.data
            guard let characteristic = characteristics[characteristicHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            guard let central = centrals[centralHashCodeArgs] else {
                throw MyError.illegalArgument
            }
            let centrals = [central]
            let updated = peripheralManager.updateValue(value, for: characteristic, onSubscribedCentrals: centrals)
            if updated {
                completion(.success(()))
            } else {
                notifyCharacteristicValueChangedCallbacks.append {
                    let updated = self.peripheralManager.updateValue(value, for: characteristic, onSubscribedCentrals: centrals)
                    if updated {
                        completion(.success(()))
                    } else {
                        completion(.failure(MyError.unknown))
                    }
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func didUpdateState() {
        let state = peripheralManager.state
        let stateArgs = state.toArgs()
        let stateNumberArgs = Int64(stateArgs.rawValue)
        if state != .unknown && setUpCompletion != nil {
            let args = MyPeripheralManagerArgs(stateNumberArgs: stateNumberArgs)
            setUpCompletion!(.success(args))
            setUpCompletion = nil
        }
        api.onStateChanged(stateNumberArgs: stateNumberArgs) {_ in }
    }
    
    func didAdd(_ service: CBService, _ error: Error?) {
        guard let completion = addServiceCompletion else {
            return
        }
        addServiceCompletion = nil
        if error == nil {
            completion(.success(()))
        } else {
            completion(.failure(error!))
            let serviceHashCode = service.hash
            guard let serviceArgs = servicesArgs[serviceHashCode] else {
                return
            }
            freeService(serviceArgs)
        }
    }
    
    func didStartAdvertising(_ error: Error?) {
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
    
    func didReceiveRead(_ request: CBATTRequest) {
        let central = request.central
        let centralHashCode = central.hash
        let centralArgs = centralsArgs.getOrPut(centralHashCode) { central.toArgs() }
        let centralHashCodeArgs = centralArgs.hashCodeArgs
        centrals[centralHashCodeArgs] = central
        let characteristic = request.characteristic
        let characteristicHashCode = characteristic.hash
        guard let characteristicArgs = characteristicsArgs[characteristicHashCode] else {
            peripheralManager.respond(to: request, withResult: .attributeNotFound)
            return
        }
        let idArgs = Int64(request.hash)
        requests[idArgs] = request
        let offsetArgs = Int64(request.offset)
        api.onReadCharacteristicCommandReceived(centralArgs: centralArgs, characteristicArgs: characteristicArgs, idArgs: idArgs, offsetArgs: offsetArgs) {_ in }
    }
    
    func didReceiveWrite(_ requests: [CBATTRequest]) {
        // 根据官方文档，仅响应第一个写入请求
        guard let request = requests.first else {
            return
        }
        if requests.count > 1 {
            // TODO: 支持多写入请求，暂时不清楚此处应如何处理
            let result = CBATTError.requestNotSupported
            peripheralManager.respond(to: request, withResult: result)
        }
        let central = request.central
        let centralHashCode = central.hash
        let centralArgs = centralsArgs.getOrPut(centralHashCode) { central.toArgs() }
        let centralHashCodeArgs = centralArgs.hashCodeArgs
        centrals[centralHashCodeArgs] = central
        let characteristic = request.characteristic
        let characteristicHashCode = characteristic.hash
        guard let characteristicArgs = characteristicsArgs[characteristicHashCode] else {
            peripheralManager.respond(to: request, withResult: .attributeNotFound)
            return
        }
        let idArgs = Int64(request.hash)
        self.requests[idArgs] = request
        let offsetArgs = Int64(request.offset)
        guard let value = request.value else {
            peripheralManager.respond(to: request, withResult: .requestNotSupported)
            return
        }
        let valueArgs = FlutterStandardTypedData(bytes: value)
        api.onWriteCharacteristicCommandReceived(centralArgs: centralArgs, characteristicArgs: characteristicArgs, idArgs: idArgs, offsetArgs: offsetArgs, valueArgs: valueArgs) {_ in }
    }
    
    func didSubscribeTo(_ central: CBCentral, _ characteristic: CBCharacteristic) {
        let centralHashCode = central.hash
        let centralArgs = centralsArgs.getOrPut(centralHashCode) { central.toArgs() }
        let centralHashCodeArgs = centralArgs.hashCodeArgs
        centrals[centralHashCodeArgs] = central
        let characteristicHashCode = characteristic.hash
        guard let characteristicArgs = characteristicsArgs[characteristicHashCode] else {
            return
        }
        let stateArgs = true
        api.onNotifyCharacteristicCommandReceived(centralArgs: centralArgs, characteristicArgs: characteristicArgs, stateArgs: stateArgs) {_ in }
    }
    
    func didUnsubscribeFrom(_ central: CBCentral, _ characteristic: CBCharacteristic) {
        let centralHashCode = central.hash
        let centralArgs = centralsArgs.getOrPut(centralHashCode) { central.toArgs() }
        let centralHashCodeArgs = centralArgs.hashCodeArgs
        centrals[centralHashCodeArgs] = central
        let characteristicHashCode = characteristic.hash
        guard let characteristicArgs = characteristicsArgs[characteristicHashCode] else {
            return
        }
        let stateArgs = false
        api.onNotifyCharacteristicCommandReceived(centralArgs: centralArgs, characteristicArgs: characteristicArgs, stateArgs: stateArgs) {_ in }
    }
    
    func isReadyToUpdateSubscribers() {
        let callbacks = notifyCharacteristicValueChangedCallbacks
        notifyCharacteristicValueChangedCallbacks.removeAll()
        for callback in callbacks {
            callback()
        }
    }
}
