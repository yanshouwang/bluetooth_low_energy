//
//  MyGattDescriptorHostApi.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyGattDescriptorHostApi: NSObject, PigeonGattDescriptorHostApi {
    func free(_ id: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        unregister(id)
    }
    
    func read(_ id: String, completion: @escaping (FlutterStandardTypedData?, FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let descriptor = items[KEY_DESCRIPTOR] as! CBDescriptor
        let peripheral = descriptor.characteristic!.service!.peripheral!
        peripheral.readValue(for: descriptor)
        instances["\(id)/\(KEY_READ_COMPLETION)"] = completion
    }
    
    func write(_ id: String, value: FlutterStandardTypedData, completion: @escaping (FlutterError?) -> Void) {
        let items = instances[id] as! [String: Any]
        let descriptor = items[KEY_DESCRIPTOR] as! CBDescriptor
        let peripheral = descriptor.characteristic!.service!.peripheral!
        let data = value.data
        peripheral.writeValue(data, for: descriptor)
        instances["\(id)/\(KEY_WRITE_COMPLETION)"] = completion
    }
}
