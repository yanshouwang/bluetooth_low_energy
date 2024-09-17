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
extension [GATTCharacteristicPropertyArgs] {
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
}

extension [GATTCharacteristicPermissionArgs] {
    func toPermissions() -> CBAttributePermissions {
        var permissions: CBAttributePermissions = []
        for args in self {
            switch args {
            case .read:
                permissions.insert(.readable)
            case .readEncrypted:
                permissions.insert(.readEncryptionRequired)
            case .write:
                permissions.insert(.writeable)
            case .writeEncrypted:
                permissions.insert(.writeEncryptionRequired)
            }
        }
        return permissions
    }
}

extension GATTCharacteristicWriteTypeArgs {
    func toWriteType() -> CBCharacteristicWriteType {
        switch self {
        case .withResponse:
            return .withResponse
        case .withoutResponse:
            return .withoutResponse
        }
    }
}

extension ATTErrorArgs {
    func toError() -> CBATTError.Code {
        switch self {
        case .success:
            return .success
        case .invalidHandle:
            return .invalidHandle
        case .readNotPermitted:
            return .readNotPermitted
        case .writeNotPermitted:
            return .writeNotPermitted
        case .invalidPDU:
            return .invalidPdu
        case .insufficientAuthentication:
            return .insufficientAuthentication
        case .requestNotSupported:
            return .requestNotSupported
        case .invalidOffset:
            return .invalidOffset
        case .insufficientAuthorization:
            return .insufficientAuthorization
        case .prepareQueueFull:
            return .prepareQueueFull
        case .attributeNotFound:
            return .attributeNotFound
        case .attributeNotLong:
            return .attributeNotLong
        case .insufficientEncryptionKeySize:
            return .insufficientEncryptionKeySize
        case .invalidAttributeValueLength:
            return .invalidAttributeValueLength
        case .unlikelyError:
            return .unlikelyError
        case .insufficientEncryption:
            return .insufficientEncryption
        case .unsupportedGroupType:
            return .unsupportedGroupType
        case .insufficientResources:
            return .insufficientResources
        }
    }
}

extension AdvertisementArgs {
    func toAdvertisement() -> [String : Any] {
        // CoreBluetooth only support `CBAdvertisementDataLocalNameKey` and `CBAdvertisementDataServiceUUIDsKey`
        // see https://developer.apple.com/documentation/corebluetooth/cbperipheralmanager/1393252-startadvertising
        var advertisement = [String: Any]()
        if nameArgs != nil {
            let name = nameArgs!
            advertisement[CBAdvertisementDataLocalNameKey] = name
        }
        if !serviceUUIDsArgs.isEmpty {
            let serviceUUIDs = serviceUUIDsArgs.map { serviceUUIDArgs in serviceUUIDArgs!.toCBUUID() }
            advertisement[CBAdvertisementDataServiceUUIDsKey] = serviceUUIDs
        }
        return advertisement
    }
}

extension MutableGATTDescriptorArgs {
    func toDescriptor() -> CBMutableDescriptor {
        let type = uuidArgs.toCBUUID()
        let value = valueArgs?.data
        return CBMutableDescriptor(type: type, value: value)
    }
}

extension MutableGATTCharacteristicArgs {
    func toCharacteristic() -> CBMutableCharacteristic {
        let type = uuidArgs.toCBUUID()
        let propertiesArgs = propertyNumbersArgs.map { propertyNumberArgs in
            let propertyNumber = propertyNumberArgs!.toInt()
            return GATTCharacteristicPropertyArgs(rawValue: propertyNumber)!
        }
        let properties = propertiesArgs.toProperties()
        let value = valueArgs?.data
        let permissionsArgs = permissionNumbersArgs.map { permissionNumberArgs in
            let permissionNumber = permissionNumberArgs!.toInt()
            return GATTCharacteristicPermissionArgs(rawValue: permissionNumber)!
        }
        let permissions = permissionsArgs.toPermissions()
        return CBMutableCharacteristic(type: type, properties: properties, value: value, permissions: permissions)
    }
}

extension MutableGATTServiceArgs {
    func toService() -> CBMutableService {
        let type = uuidArgs.toCBUUID()
        let primary = isPrimaryArgs
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
    func toArgs() -> BluetoothLowEnergyStateArgs {
        switch self {
        case .resetting:
            return .resetting
        case .unsupported:
            return .unsupported
        case .unauthorized:
            return .unauthorized
        case .poweredOff:
            return .poweredOff
        case .poweredOn:
            return .poweredOn
        default:
            return .unknown
        }
    }
}

extension [String: Any] {
    func toAdvertisementArgs() -> AdvertisementArgs {
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
        let manufacturerData = self[CBAdvertisementDataManufacturerDataKey] as? Data
        let manufacturerSpecificDataArgs = manufacturerData == nil ? nil : FlutterStandardTypedData(bytes: manufacturerData!)
        return AdvertisementArgs(nameArgs: nameArgs, serviceUUIDsArgs: serviceUUIDsArgs, serviceDataArgs: serviceDataArgs, manufacturerSpecificDataArgs: manufacturerSpecificDataArgs)
    }
}

extension CBCentral {
    func toArgs() -> CentralArgs {
        let uuidArgs = identifier.toArgs()
        return CentralArgs(uuidArgs: uuidArgs)
    }
}

extension CBPeripheral {
    func toArgs() -> PeripheralArgs {
        let uuidArgs = identifier.toArgs()
        return PeripheralArgs(uuidArgs: uuidArgs)
    }
}

extension CBDescriptor {
    func toArgs() -> GATTDescriptorArgs {
        let hashCodeArgs = hash.toInt64()
        let uuidArgs = uuid.toArgs()
        return GATTDescriptorArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs)
    }
}

extension CBCharacteristic {
    func toArgs() -> GATTCharacteristicArgs {
        let hashCodeArgs = hash.toInt64()
        let uuidArgs = uuid.toArgs()
        let propertyNumbersArgs = properties.toArgs().map { args in args.rawValue.toInt64() }
        let descriptorsArgs = descriptors?.map { descriptor in descriptor.toArgs() } ?? []
        return GATTCharacteristicArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs, propertyNumbersArgs: propertyNumbersArgs, descriptorsArgs: descriptorsArgs)
    }
}

extension CBCharacteristicProperties {
    func toArgs() -> [GATTCharacteristicPropertyArgs] {
        var args = [GATTCharacteristicPropertyArgs]()
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
    func toArgs() -> GATTServiceArgs {
        let hashCodeArgs = hash.toInt64()
        let uuidArgs = uuid.toArgs()
        let isPrimaryArgs = isPrimary
        let includedServicesArgs = includedServices?.map { includedService in includedService.toArgs() } ?? []
        let characteristicsArgs = characteristics?.map { characteristic in characteristic.toArgs() } ?? []
        return GATTServiceArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs, isPrimaryArgs: isPrimaryArgs, includedServicesArgs: includedServicesArgs, characteristicsArgs: characteristicsArgs)
    }
}

extension Int {
    func toInt64() -> Int64 {
        return Int64(self)
    }
}

extension UUID {
    func toArgs() -> String {
        return uuidString.lowercased()
    }
}

extension CBUUID {
    func toArgs() -> String {
        return uuidString.lowercased()
    }
}

extension UInt16 {
    var data: Data {
        var bytes = self
        return Data(bytes: &bytes, count: MemoryLayout<UInt16>.size)
    }
}
