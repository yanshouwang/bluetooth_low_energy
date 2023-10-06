//
//  MyApi.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/9/28.
//

import Foundation
import CoreBluetooth

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

extension CBAttribute {
    var uuidArgs: String { uuid.uuidString }
}

extension CBPeer {
    var uuidArgs: String { identifier.uuidString }
}

extension CBPeripheral {
    func toArgs() -> MyPeripheralArgs {
        let hashCodeArgs = Int64(hash)
        return MyPeripheralArgs(hashCodeArgs: hashCodeArgs, uuidArgs: uuidArgs)
    }
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
