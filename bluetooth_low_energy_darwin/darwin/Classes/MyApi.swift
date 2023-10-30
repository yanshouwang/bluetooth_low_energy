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

// This extension of Error is required to do use FlutterError in any Swift code.
extension FlutterError: Error {}

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

extension CBPeer {
    var uuidArgs: String { identifier.uuidString }
}

extension CBCentral {
    func toArgs() -> MyCentralArgs {
        let hashCodeArgs = Int64(hash)
        return MyCentralArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs)
    }
}

extension CBPeripheral {
    func toArgs() -> MyPeripheralArgs {
        let hashCodeArgs = Int64(hash)
        return MyPeripheralArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs)
    }
}

extension CBAttribute {
    var uuidArgs: String { uuid.uuidString }
}

extension CBService {
    func toArgs(_ characteristicsArgs: [MyGattCharacteristicArgs]) -> MyGattServiceArgs {
        let hashCodeArgs = Int64(hash)
        return MyGattServiceArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs, characteristicsArgs: characteristicsArgs)
    }
}

extension CBCharacteristic {
    func toArgs(_ descriptorsArgs: [MyGattDescriptorArgs]) -> MyGattCharacteristicArgs {
        let hashCodeArgs = Int64(hash)
        return MyGattCharacteristicArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs, propertyNumbersArgs: propertyNumbersArgs, descriptorsArgs: descriptorsArgs)
    }
    
    var propertyNumbersArgs: [Int64] {
        var propertiesArgs = [MyGattCharacteristicPropertyArgs]()
        let properties = self.properties
        if properties.contains(.read) {
            propertiesArgs.append(.read)
        }
        if properties.contains(.write) {
            propertiesArgs.append(.write)
        }
        if properties.contains(.writeWithoutResponse) {
            propertiesArgs.append(.writeWithoutResponse)
        }
        if properties.contains(.notify) {
            propertiesArgs.append(.notify)
        }
        if properties.contains(.indicate) {
            propertiesArgs.append(.indicate)
        }
        return propertiesArgs.map { args in Int64(args.rawValue) }
    }
}

extension CBDescriptor {
    func toArgs() -> MyGattDescriptorArgs {
        let hashCodeArgs = Int64(hash)
        return MyGattDescriptorArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs)
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

extension String {
    var data: Data { data(using: String.Encoding.utf8)! }
}

extension NSNumber {
    var data: Data {
        var source = self
        return Data(bytes: &source, count: MemoryLayout<NSNumber>.size)
    }
}

extension UInt16 {
    var data: Data {
        var source = self
        return Data(bytes: &source, count: MemoryLayout<UInt16>.size)
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

extension MyAdvertisementArgs {
    func toAdvertisement() throws -> [String : Any] {
        // CoreBluetooth only support `CBAdvertisementDataLocalNameKey` and `CBAdvertisementDataServiceUUIDsKey`, see https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising
        var advertisement = [String: Any]()
        if nameArgs != nil {
            let name = nameArgs!
            advertisement[CBAdvertisementDataLocalNameKey] = name
        }
        if serviceUUIDsArgs.count > 0 {
            var serviceUUIDs = [CBUUID]()
            for args in serviceUUIDsArgs {
                guard let uuidArgs = args else {
                    throw MyError.illegalArgument
                }
                let uuid = CBUUID(string: uuidArgs)
                serviceUUIDs.append(uuid)
            }
            advertisement[CBAdvertisementDataServiceUUIDsKey] = serviceUUIDs
        }
//        if serviceDataArgs.count > 0 {
//            var serviceData = [CBUUID: Data]()
//            for args in serviceDataArgs {
//                guard let uuidArgs = args.key else {
//                    throw MyError.illegalArgument
//                }
//                guard let dataArgs = args.value else {
//                    throw MyError.illegalArgument
//                }
//                let uuid = CBUUID(string: uuidArgs)
//                let data = dataArgs.data
//                serviceData[uuid] = data
//            }
//            advertisement[CBAdvertisementDataServiceDataKey] = serviceData
//        }
//        if manufacturerSpecificDataArgs != nil {
//            let manufacturerSpecificData = manufacturerSpecificDataArgs!.toManufacturerSpecificData()
//            advertisement[CBAdvertisementDataManufacturerDataKey] = manufacturerSpecificData
//        }
        return advertisement
    }
}

//extension MyManufacturerSpecificDataArgs {
//    func toManufacturerSpecificData() -> Data {
//        let id = UInt16(idArgs).data
//        let data = dataArgs.data
//        return id + data
//    }
//}

extension MyGattServiceArgs {
    func toService() -> CBMutableService {
        let type = CBUUID(string: uuidArgs)
        let primary = true
        return CBMutableService(type: type, primary: primary)
    }
}

extension MyGattCharacteristicArgs {
    func toCharacteristic() -> CBMutableCharacteristic {
        let type = CBUUID(string: uuidArgs)
        return CBMutableCharacteristic(type: type, properties: properties, value: nil, permissions: permissions)
    }
    
    var properties: CBCharacteristicProperties {
        var properties: CBCharacteristicProperties = []
        for args in propertyNumbersArgs {
            guard let rawArgs = args else {
                continue
            }
            let rawValue = Int(rawArgs)
            let property = MyGattCharacteristicPropertyArgs(rawValue: rawValue)
            switch property {
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
            default:
                continue
            }
        }
        return properties
    }
    
    var permissions: CBAttributePermissions {
        var permissions: CBAttributePermissions = []
        for args in propertyNumbersArgs {
            guard let rawArgs = args else {
                continue
            }
            let rawValue = Int(rawArgs)
            let property = MyGattCharacteristicPropertyArgs(rawValue: rawValue)
            switch property {
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

extension MyGattDescriptorArgs {
    func toDescriptor() -> CBMutableDescriptor {
        let type = CBUUID(string: uuidArgs)
        let value = valueArgs?.data
        return CBMutableDescriptor(type: type, value: value)
    }
}

extension Int {
    func coerceIn(_ minimum: Int, _ maximum: Int) throws -> Int {
        if minimum > maximum {
            throw MyError.illegalArgument
        }
        if self < minimum {
            return minimum
        }
        if self > maximum {
            return maximum
        }
        return self
    }
}

extension Dictionary {
    mutating func getOrPut(_ key: Key, _ defaultValue: () -> Value) -> Value {
        guard let value = self[key] else {
            let value1 = defaultValue()
            self[key] = value1
            return value1
        }
        return value
    }
}
