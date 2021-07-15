//
//  NativeGATT.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2021/7/15.
//

import Foundation
import CoreBluetooth

class NativeGATT: NativeValue<CBPeripheral> {
    let services: [String: NativeGattService]
    
    init(_ value: CBPeripheral, _ services: [String: NativeGattService]) {
        self.services = services
        super.init(value)
    }
}
