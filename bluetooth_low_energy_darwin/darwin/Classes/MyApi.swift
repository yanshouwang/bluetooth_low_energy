//
//  MyApi.swift
//  bluetooth_low_energy_darwin
//
//  Created by 闫守旺 on 2023/9/28.
//

import Foundation
import CoreBluetooth

extension CBManagerState {
    func toMyArgs() -> MyBluetoothLowEnergyStateArgs {
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
    var myUUID: String { uuid.uuidString }
}

extension CBPeer {
    var myUUID: String { identifier.uuidString }
}

extension CBPeripheral {
    func toMyArgs() -> MyPeripheralArgs {
        let myHashCode = Int64(hash)
        return MyPeripheralArgs(myHashCode: myHashCode, myUUID: myUUID)
    }
}

extension CBService {
    func toMyArgs(_ myCharacteristicArgses: [MyGattCharacteristicArgs]) -> MyGattServiceArgs {
        let myHashCode = Int64(hash)
        return MyGattServiceArgs(myHashCode: myHashCode, myUUID: myUUID, myCharacteristicArgses: myCharacteristicArgses)
    }
}

extension CBCharacteristic {
    func toMyArgs(_ myDescriptorArgses: [MyGattDescriptorArgs]) -> MyGattCharacteristicArgs {
        let myHashCode = Int64(hash)
        return MyGattCharacteristicArgs(myHashCode: myHashCode, myUUID: myUUID, myPropertyNumbers: myPropertyNumbers, myDescriptorArgses: myDescriptorArgses)
    }
    
    var myPropertyNumbers: [Int64] {
        var myPropertyArgses = [MyGattCharacteristicPropertyArgs]()
        let properties = self.properties
        if properties.contains(.read) {
            myPropertyArgses.append(.read)
        }
        if properties.contains(.write) {
            myPropertyArgses.append(.write)
        }
        if properties.contains(.writeWithoutResponse) {
            myPropertyArgses.append(.writeWithoutResponse)
        }
        if properties.contains(.notify) {
            myPropertyArgses.append(.notify)
        }
        if properties.contains(.indicate) {
            myPropertyArgses.append(.indicate)
        }
        return myPropertyArgses.map { args in Int64(args.rawValue) }
    }
}

extension CBDescriptor {
    func toMyArgs() -> MyGattDescriptorArgs {
        let myHashCode = Int64(hash)
        return MyGattDescriptorArgs(myHashCode: myHashCode, myUUID: myUUID)
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
