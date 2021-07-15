//
//  NativeGattService.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2021/7/15.
//

import Foundation
import CoreBluetooth

class NativeGattService: NativeValue<CBService> {
    let characteristics: [String: NativeGattCharacteristic]
    
    init(_ value: CBService, _ characteristics: [String: NativeGattCharacteristic]) {
        self.characteristics = characteristics
        super.init(value)
    }
}
