//
//  MyGattDescriptorHostApi.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyGattDescriptorHostApi: NSObject, PigeonGattDescriptorHostApi {
    func allocate(_ id: NSNumber, instanceId: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let instance = instances.removeValue(forKey: instanceId) as! CBDescriptor
        instances[id] = instance
        identifiers[instance] = id
    }
    
    func free(_ id: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let instance = instances.removeValue(forKey: id) as! CBDescriptor
        identifiers.removeValue(forKey: instance)
    }
    
    func read(_ id: NSNumber, completion: @escaping (FlutterStandardTypedData?, FlutterError?) -> Void) {
        let descriptor = instances[id] as! CBDescriptor
        let peripheral = descriptor.characteristic!.service!.peripheral!
        peripheral.readValue(for: descriptor)
        items["\(descriptor.hash)/\(KEY_READ_COMPLETION)"] = completion
    }
    
    func write(_ id: NSNumber, value: FlutterStandardTypedData, completion: @escaping (FlutterError?) -> Void) {
        let descriptor = instances[id] as! CBDescriptor
        let peripheral = descriptor.characteristic!.service!.peripheral!
        let data = value.data
        peripheral.writeValue(data, for: descriptor)
        items["\(descriptor.hash)/\(KEY_WRITE_COMPLETION)"] = completion
    }
}
