//
//  NativeGattCharacteristic.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2021/7/15.
//

import Foundation
import CoreBluetooth

class NativeGattCharacteristic: NativeValue<CBCharacteristic> {
    let descriptors: [String: NativeGattDescriptor]
    
    init(_ value: CBCharacteristic, _ descriptors: [String: NativeGattDescriptor]) {
        self.descriptors = descriptors
        super.init(value)
    }
}
