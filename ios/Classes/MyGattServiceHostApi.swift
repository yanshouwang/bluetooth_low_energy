//
//  MyGattServiceHostApi.swift
//  bluetooth_low_energy
//
//  Created by 闫守旺 on 2022/9/20.
//

import Foundation
import CoreBluetooth

class MyGattServiceHostApi: NSObject, PigeonGattServiceHostApi {
    func allocate(_ id: NSNumber, instanceId: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let instance = instances.removeValue(forKey: instanceId) as! CBService
        instances[id] = instance
        identifiers[instance] = id
    }
    
    func free(_ id: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let instance = instances.removeValue(forKey: id) as! CBService
        identifiers.removeValue(forKey: instance)
    }
    
    func discoverCharacteristics(_ id: NSNumber, completion: @escaping ([FlutterStandardTypedData]?, FlutterError?) -> Void) {
        let service = instances[id] as! CBService
        let peripheral = service.peripheral!
        peripheral.discoverCharacteristics(nil, for: service)
        items["\(service.hash)/\(KEY_DISCOVER_CHARACTERISTICS_COMPLETION)"] = completion
    }
}
