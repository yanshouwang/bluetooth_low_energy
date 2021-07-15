//
//  NativeValue.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2021/7/15.
//

import Foundation

class NativeValue<T> {
    let key = UUID().uuidString
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}
