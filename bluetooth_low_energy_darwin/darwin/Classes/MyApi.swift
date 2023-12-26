//
//  MyApi.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/9/28.
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

// ToObj
extension [MyGattCharacteristicPropertyArgs] {
    func toProperties() -> CBCharacteristicProperties {
        var properties: CBCharacteristicProperties = []
        for args in self {
            switch args {
            case .read:
                properties.insert(.read)
            case .write:
                properties.insert(.write)
            case .writeWithoutResponse:
                properties.insert(.writeWithoutResponse)
            case .notify:
                properties.insert(.notify)
            case .indicate:
                properties.insert(.indicate)
            }
        }
        return properties
    }
    
    func toPermissions() -> CBAttributePermissions {
        var permissions: CBAttributePermissions = []
        for args in self {
            switch args {
            case .read:
                permissions.insert(.readable)
            case .write, .writeWithoutResponse:
                permissions.insert(.writeable)
            default:
                continue
            }
        }
        return permissions
    }
}

extension MyGattCharacteristicWriteTypeArgs {
    func toWriteType() -> CBCharacteristicWriteType {
        switch self {
        case .withResponse:
            return .withResponse
        case .withoutResponse:
            return .withoutResponse
        }
    }
}

extension MyAdvertisementArgs {
    func toAdvertisement() -> [String : Any] {
        // CoreBluetooth only support `CBAdvertisementDataLocalNameKey` and `CBAdvertisementDataServiceUUIDsKey`
        // see https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising
        var advertisement = [String: Any]()
        if nameArgs != nil {
            let name = nameArgs!
            advertisement[CBAdvertisementDataLocalNameKey] = name
        }
        if serviceUUIDsArgs.count > 0 {
            var serviceUUIDs = [CBUUID]()
            for args in serviceUUIDsArgs {
                guard let uuidArgs = args else {
                    continue
                }
                let uuid = uuidArgs.toCBUUID()
                serviceUUIDs.append(uuid)
            }
            advertisement[CBAdvertisementDataServiceUUIDsKey] = serviceUUIDs
        }
        return advertisement
    }
}

extension MyGattDescriptorArgs {
    func toDescriptor() -> CBMutableDescriptor {
        let type = uuidArgs.toCBUUID()
        let value = valueArgs?.data
        return CBMutableDescriptor(type: type, value: value)
    }
}

extension MyGattCharacteristicArgs {
    func toCharacteristic() -> CBMutableCharacteristic {
        let type = uuidArgs.toCBUUID()
        var propertiesArgs = [MyGattCharacteristicPropertyArgs]()
        for args in propertyNumbersArgs {
            guard let propertyNumberArgs = args else {
                continue
            }
            let propertyNumber = propertyNumberArgs.toInt()
            guard let propertyArgs = MyGattCharacteristicPropertyArgs(rawValue: propertyNumber) else {
                continue
            }
            propertiesArgs.append(propertyArgs)
        }
        let properties = propertiesArgs.toProperties()
        let permissions = propertiesArgs.toPermissions()
        return CBMutableCharacteristic(type: type, properties: properties, value: nil, permissions: permissions)
    }
}

extension MyGattServiceArgs {
    func toService() -> CBMutableService {
        let type = uuidArgs.toCBUUID()
        let primary = true
        return CBMutableService(type: type, primary: primary)
    }
}

extension Int64 {
    func toInt() -> Int {
        return Int(self)
    }
}

extension String {
    func toCBUUID() -> CBUUID {
        return CBUUID(string: self)
    }
}

// ToArgs
extension CBManagerState {
    func toArgs() -> MyBluetoothLowEnergyStateArgs {
        switch self {
        case .unauthorized:
            return .unauthorized
        case .poweredOff:
            return .poweredOff
        case .poweredOn:
            return .poweredOn
        default:
            return .unsupported
        }
    }
}

extension Data {
    func toManufacturerSpecificDataArgs() -> MyManufacturerSpecificDataArgs? {
        if count > 2 {
            let idArgs = Int64(self[0]) | (Int64(self[1]) << 8)
            let data = self[2...count - 1]
            let dataArgs = FlutterStandardTypedData(bytes: data)
            return MyManufacturerSpecificDataArgs(idArgs: idArgs, dataArgs: dataArgs)
        } else {
            return nil
        }
    }
}

extension [String: Any] {
    func toAdvertisementArgs() -> MyAdvertisementArgs {
        let nameArgs = self[CBAdvertisementDataLocalNameKey] as? String
        let serviceUUIDs = self[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
        let serviceUUIDsArgs = serviceUUIDs.map { uuid in uuid.uuidString }
        let serviceData = self[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] ?? [:]
        let serviceDataArgsKeyWithValues = serviceData.map { (uuid, data) in
            let uuidArgs = uuid.uuidString
            let dataArgs = FlutterStandardTypedData(bytes: data)
            return (uuidArgs, dataArgs)
        }
        let serviceDataArgs = [String?: FlutterStandardTypedData?](uniqueKeysWithValues: serviceDataArgsKeyWithValues)
        let manufacturerSpecificData = self[CBAdvertisementDataManufacturerDataKey] as? Data
        let manufacturerSpecificDataArgs = manufacturerSpecificData?.toManufacturerSpecificDataArgs()
        return MyAdvertisementArgs(nameArgs: nameArgs, serviceUUIDsArgs: serviceUUIDsArgs, serviceDataArgs: serviceDataArgs, manufacturerSpecificDataArgs: manufacturerSpecificDataArgs)
    }
}

extension CBCentral {
    func toArgs() -> MyCentralArgs {
        let uuidArgs = identifier.toArgs()
        return MyCentralArgs(uuidArgs: uuidArgs)
    }
}

extension CBPeripheral {
    func toArgs() -> MyPeripheralArgs {
        let uuidArgs = identifier.toArgs()
        return MyPeripheralArgs(uuidArgs: uuidArgs)
    }
}

extension CBDescriptor {
    func toArgs() -> MyGattDescriptorArgs {
        let hashCodeArgs = hash.toArgs()
        let uuidArgs = uuid.toArgs()
        return MyGattDescriptorArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs)
    }
}

extension CBCharacteristic {
    func toArgs() -> MyGattCharacteristicArgs {
        let hashCodeArgs = hash.toArgs()
        let uuidArgs = uuid.toArgs()
        let propertyNumbersArgs = properties.toArgs().map { args in args.rawValue.toArgs() }
        let descriptorsArgs = descriptors?.map { descriptor in descriptor.toArgs() } ?? []
        return MyGattCharacteristicArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs, propertyNumbersArgs: propertyNumbersArgs, descriptorsArgs: descriptorsArgs)
    }
}

extension CBCharacteristicProperties {
    func toArgs() -> [MyGattCharacteristicPropertyArgs] {
        var args = [MyGattCharacteristicPropertyArgs]()
        if contains(.read) {
            args.append(.read)
        }
        if contains(.write) {
            args.append(.write)
        }
        if contains(.writeWithoutResponse) {
            args.append(.writeWithoutResponse)
        }
        if contains(.notify) {
            args.append(.notify)
        }
        if contains(.indicate) {
            args.append(.indicate)
        }
        return args
    }
}

extension CBService {
    func toArgs() -> MyGattServiceArgs {
        let hashCodeArgs = hash.toArgs()
        let uuidArgs = uuid.toArgs()
        let characteristicsArgs = characteristics?.map { characteristic in characteristic.toArgs() } ?? []
        return MyGattServiceArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs, characteristicsArgs: characteristicsArgs)
    }
}

extension Int {
    func toArgs() -> Int64 {
        return Int64(self)
    }
}

extension UUID {
    func toArgs() -> String {
        return uuidString
    }
}

extension CBUUID {
    func toArgs() -> String {
        return uuidString
    }
}

// This extension of Error is required to do use FlutterError in any Swift code.
extension FlutterError: Error {}

extension String {
    var data: Data { data(using: String.Encoding.utf8)! }
}

extension NSNumber {
    var data: Data {
        var source = self
        // TODO: resolve warning: Forming 'UnsafeRawPointer' to a variable of type 'NSNumber'; this is likely incorrect because 'NSNumber' may contain an object reference.
        return Data(bytes: &source, count: MemoryLayout<NSNumber>.size)
    }
}

extension UInt16 {
    var data: Data {
        var source = self
        return Data(bytes: &source, count: MemoryLayout<UInt16>.size)
    }
}

extension Dictionary {
    mutating func getOrPut(_ key: Key, _ defaultValue: () -> Value) -> Value {
        guard let value = self[key] else {
            let newValue = defaultValue()
            self[key] = newValue
            return newValue
        }
        return value
    }
}
